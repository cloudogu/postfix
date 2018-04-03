#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# 1: value
function setValueIfConfigured {
  if doguctl config ${1} > /dev/null; then
    postconf -e ${1}=$(doguctl config ${1})
  fi
}

# 1: config name
# 2: file name
# 3: doguctl params
function writeIntoFileAndSetIfConfigured {
  OPTION_NAME="${1}"
  FILE_NAME="${2}"
  if [[ "$#" -gt 2 ]];then
    PARAM="${3}"
  else
    PARAM=""
  fi
  if doguctl config ${PARAM} ${OPTION_NAME} > /dev/null; then
    echo "$(doguctl config ${PARAM} ${OPTION_NAME})" > ${FILE_NAME}
    postconf -e ${OPTION_NAME}=${FILE_NAME}
  fi
}

MAILRELAY=$(doguctl config relayhost)
NAME=$(hostname)
DOMAIN=$(doguctl config --global domain)
NET=""
OPTIONS=('smtp_tls_security_level' 'smtp_tls_loglevel'
'smtp_tls_exclude_ciphers' 'smtp_tls_mandatory_ciphers'
'smtp_tls_mandatory_protocols')

CERT_FILE=("smtp_tls_cert_file" "/etc/postfix/cert.pem" "-e")
KEY_FILE=("smtp_tls_key_file" "/etc/postfix/key.pem" "-e")
CA_FILE=("smtp_tls_CAfile" "/etc/postfix/CAcert.pem" "")
# array of entries with format: <config name>, <file name>, <doguctl params>
FILE_OPTIONS=(
    "${CERT_FILE[*]}"
    "${KEY_FILE[*]}"
    "${CA_FILE[*]}"
)

# GATHERING NETWORKS FROM INTERFACES FOR MYNETWORKS
for i in $(netstat -nr | grep -v ^0 | grep -v Dest | grep -v Kern| awk '{print $1}' | xargs); do
  MASK=$(netstat -nr | grep ${i} | awk '{print $3}')
  CIDR=$(/mask2cidr.sh ${MASK})
  NET="${NET} ${i}/${CIDR}"
done

# POSTFIX CONFIG
postconf -e mydomain="localhost.local"
postconf -e myhostname="${NAME}.${DOMAIN}"
postconf -e mydestination="${NAME}.${DOMAIN}, localhost.localdomain, localhost"
postconf -e mynetworks="127.0.0.1 ${NET}"
postconf -e smtputf8_enable=no
postconf -e relayhost="${MAILRELAY}"
postconf -e smtpd_recipient_restrictions="permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination"

for option in "${OPTIONS[@]}"; do
  setValueIfConfigured "${option}"
done

for option in "${FILE_OPTIONS[@]}"; do
  writeIntoFileAndSetIfConfigured ${option[@]}
done

# START POSTFIX
exec /usr/bin/supervisord -c /etc/supervisord.conf
