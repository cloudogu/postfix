FROM registry.cloudogu.com/official/base:3.18.3-1
LABEL NAME="official/postfix" \
      VERSION="3.8.4-1" \
      maintainer=hello@cloudogu.com

# INSTALL POSTFIX
RUN set -o errexit \
  && set -o nounset \
  && set -o pipefail \
  && apk update \
  && apk upgrade \
  && apk add --update postfix openrc supervisor rsyslog \
  && rm -rf /var/cache/apk/*

COPY resources /

# POSTFIX PORT
EXPOSE 25/tcp 587/tcp

HEALTHCHECK CMD doguctl healthy postfix || exit 1

# FIRE IT UP
CMD ["/bin/bash", "-c", "/startup.sh"]
