FROM registry.cloudogu.com/official/base:3.9.4-1
LABEL maintainer=robert.auer@cloudogu.com

# INSTALL POSTFIX
RUN apk add --update postfix openrc supervisor rsyslog \
	&& rm -rf /var/cache/apk/*

COPY resources /

# POSTFIX PORT
EXPOSE 25/tcp 587/tcp

# FIRE IT UP
CMD ["/bin/bash", "-c", "/startup.sh"]
