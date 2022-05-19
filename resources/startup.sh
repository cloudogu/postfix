#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# 1: value
function setValueIfConfigured {
  if doguctl config "${1}" > /dev/null; then
    postconf -e "${1}"="$(doguctl config "${1}")"
  fi
}

# 1: config name
# 2: file name
# 3: doguctl params
# This also changes the mod of the file to 600
function writeIntoFileAndSetIfConfigured {
  OPTION_NAME="${1}"
  FILE_NAME="${2}"
  if [[ "$#" -gt 2 ]];then
    PARAM="${3}"
  else
    PARAM=""
  fi
  if doguctl config "${OPTION_NAME}" > /dev/null; then
    # PARAM should not be in double quotes because it can be empty
    doguctl config "${PARAM}" "${OPTION_NAME}" > "${FILE_NAME}"
    chmod 600 "${FILE_NAME}"
    postconf -e "${OPTION_NAME}"="${FILE_NAME}"
  fi
}

MAILRELAY=$(doguctl config relayhost)
NAME=$(hostname)
DOMAIN=$(doguctl config --global domain)
POSTFIX_SASL_USER=$(doguctl config --default "NOT_SET" sasl_username)
POSTFIX_SASL_PASSWORD=$(doguctl config --default "NOT_SET" sasl_password)
NET=""
OPTIONS=('smtp_tls_security_level' 'smtp_tls_loglevel'
'smtp_tls_exclude_ciphers' 'smtp_tls_mandatory_ciphers'
'smtp_tls_mandatory_protocols')

# GATHERING NETWORKS FROM INTERFACES FOR MYNETWORKS
for i in $(netstat -nr | grep -v ^0 | grep -v Dest | grep -v Kern| awk '{print $1}' | xargs); do
  MASK=$(netstat -nr | grep "${i}" | awk '{print $3}')
  CIDR=$(/mask2cidr.sh "${MASK}")
  NET="${NET} ${i}/${CIDR}"
done

echo "start Postfix configuration ..."

# POSTFIX CONFIG
postconf -e relayhost="${MAILRELAY}"
postconf -e mydomain="localhost.local"
postconf -e myhostname="${NAME}.${DOMAIN}"
postconf -e mydestination="${NAME}.${DOMAIN}, localhost.localdomain, localhost"
postconf -e mynetworks="127.0.0.1 ${NET}"
postconf -e smtputf8_enable=no
postconf -e smtpd_recipient_restrictions="permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination"


# check if SASL authentication should be configured
if [ "${POSTFIX_SASL_USER}" != "NOT_SET" ] && [ "${POSTFIX_SASL_PASSWORD}" != "NOT_SET" ]; then
      echo "found SASL pw and user ... configure Postfix to use SASL authentication"

      # SASL security in postfix
      echo "${MAILRELAY} ${POSFIX_SASL_USER}:${POSFIX_SASL_PASSWORD}"> /etc/postfix/sasl_passwd
      postmap /etc/postfix/sasl_passwd

      postconf -e smtp_sasl_auth_enable="yes" # enable SASL authentication in the Postfix SMTP client. By default, the Postfix SMTP client uses no authentication.
      postconf -e smtp_sasl_security_options="noanonymous" # removes the prohibition on plaintext password
      postconf -e smtp_sasl_password_maps="lmdb:/etc/postfix/sasl_passwd" #hash:/ is deprecated using lmdb:/ instead
      # postconf -e smtp_tls_security_level="encrypt"
      # postconf -e smtp_tls_wrappermode="yes" # "wrappermode" protocol, which uses TCP port 465 on the SMTP server (Postfix 3.0 and later), needs minimum security_level=encrypt
else
      echo "configure no SASL authentication"
fi


for option in "${OPTIONS[@]}"; do
  setValueIfConfigured "${option}"
done

# The content of the cert file is encrypted because it can contain the RSA key (http://www.postfix.org/postconf.5.html#smtp_tls_cert_file)
writeIntoFileAndSetIfConfigured "smtp_tls_cert_file" "/etc/postfix/cert.pem" "-e"
writeIntoFileAndSetIfConfigured "smtp_tls_key_file" "/etc/postfix/key.pem" "-e"
writeIntoFileAndSetIfConfigured "smtp_tls_CAfile" "/etc/postfix/CAcert.pem"

# LOGGING CONFIG
./logging.sh

echo "finished configuration, start Postfix ..."
# START POSTFIX
exec /usr/bin/supervisord -c /etc/supervisord.conf
