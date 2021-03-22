FROM registry.cloudogu.com/official/base:3.12.4-1
LABEL name="official/postfix" \
      version="3.3.2-1" \
      maintainer=hello@cloudogu.com

# INSTALL POSTFIX
RUN apk add --update postfix openrc supervisor rsyslog \
	&& rm -rf /var/cache/apk/*

COPY resources /

# POSTFIX PORT
EXPOSE 25/tcp 587/tcp

HEALTHCHECK CMD doguctl healthy postfix || exit 1

# FIRE IT UP
CMD ["/bin/bash", "-c", "/startup.sh"]
