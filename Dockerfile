FROM registry.cloudogu.com/official/base:3.22.0-4
LABEL NAME="official/postfix" \
      VERSION="3.10.4-0" \
      maintainer=hello@cloudogu.com

ENV POSTFIX_ALPINE_VERSION=3.10.4-r0

# INSTALL POSTFIX
RUN set -o errexit \
  && set -o nounset \
  && set -o pipefail \
  && apk update \
  && apk upgrade \
  && apk add --update postfix=${POSTFIX_ALPINE_VERSION} openrc supervisor rsyslog \
  && rm -rf /var/cache/apk/*

COPY resources /

# POSTFIX PORT
EXPOSE 25/tcp 587/tcp

HEALTHCHECK CMD doguctl healthy postfix || exit 1

# FIRE IT UP
CMD ["/bin/bash", "-c", "/startup.sh"]
