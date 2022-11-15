---
title: "Local mail dispatch"
---

# Local mail dispatch

To check if the mail dispatch of the Postfix dogu works, [MailHog](https://github.com/mailhog/MailHog)
can be used. MailHog is a tool for testing mail in a local development environment. MailHog sets up a local pseudo-SMTP
server.

## Setting up MailHog

In a nutshell, MailHog runs locally on the host machine as a Docker container and is configured in the local CES as a
Relay host of the postfix dogus entered.

Specifically, the following steps need to be performed:

* Run MailHog on the host machine as a Docker container:
  ```
  docker run -d -p 1025:1025 -p 8025:8025 mailhog/mailhog 
  ```
* Set MailHog in the local CES as the relay host of the Postfix dog:
  ```
  etcdctl set /config/postfix/relayhost 192.168.56.1:1025
  ```
* Remove postfix-dogu via cesapp and create new one
  ```
  cesapp recreate postfix
  ```
* Start postfix-dogu
  ```
  cesapp start postfix 
  ```
* Change to the bash of the Dogu
  ```
  docker exec -it postfix bash 
  ```  
* Send mail
  ```
  sendmail -t testmail@cloudogu.de
  text 1234
  
  <strg>+<d>
  ```
* In web interface of MailHog - ```localhost:8025`` - check mail reception

## Setting up MailHog as part of the CES

With the following script you are able to install MailHog as part of the CES. After the installation you can open the web UI via the Warp menu.

```shell
etcdctl set dogu/mailhog/1.0.0-1 '{"Name": "official/mailhog","Version": "1.0.0-1","DisplayName": "Mailhog","Description": "Mailhog Dogu","Category": "Administration Apps","Tags": ["webapp","warp"],"Logo": "","URL": "https://github.com/cloudogu","Image": "registry.cloudogu.com/official/mailhog","Dependencies": ["nginx"],"OptionalDependencies": null}' && \
etcdctl set dogu/mailhog/current 1.0.0-1 && \
docker run -d -e MH_UI_WEB_PATH=mailhog -p 25:1025 -p 8025:8025 --name mailhog --net cesnet1 mailhog/mailhog && \
MAILHOG_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mailhog) && \
etcdctl set services/mailhog/registrator:mailhog:8025 "{\"name\":\"mailhog\",\"service\":\"${MAILHOG_IP}:8025\",\"port\":\"8025\",\"tags\":[\"webapp\"],\"healthStatus\":\"healthy\",\"attributes\":{}}" && \
etcdctl set /config/postfix/relayhost mailhog:1025 && docker restart postfix
```

## Setting up a proxy in front of MailHog to test authentication workflows.
MailHog does not support authentication, therefore using the tool [E-MailRelay](http://emailrelay.sourceforge.net/index.html)
tool to set up a proxy in front of MailHog.

To do this, E-MailRelay must be [downloaded](http://emailrelay.sourceforge.net/Download.html),
unpacked and installed `sudo ./configure && sudo make && sudo make install`.

For the authentication a password file can be created, which can look like this for example

secret.auth
```
server plain adminuser adminpw
```

E-MailRelay can be created using
```
sudo emailrelay -t --as-server --forward-on-disconnect --log --verbose --log-file mailrelay.log --log-time --port 587 --forward-to localhost:1025 --server-auth ./secret.auth
```
can be started as a proxy before MailHog.

The `-t` parameter starts the proxy in a terminal session. This makes it easier to restart the server.
The relay host must point to the address specified with the `-port`.
```
etcdctl set /config/postfix/relayhost 192.168.56.1:587
```

Afterwards the appropriate password for Postfix can be configured.
SASL authentication is then used when sending mails:
```
etcdctl set /config/postfix/sasl_username adminuser
etcdctl set /config/postfix/sasl_password adminpw
```
