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


## Setting up a proxy in front of MailHog to test authentication workflows.
MailHog does not support authentication, therefore using the tool [E-MailRelay](http://emailrelay.sourceforge.net/index.html)
tool to set up a proxy in front of MailHog.

To do this, E-MailRelay must be [downloaded](http://emailrelay.sourceforge.net/Download.html), unpacked and installed (`sudo ./configure && make && make install`).

E-MailRelay can be started using
```
sudo emailrelay -t --as-server --forward-on-disconnect --log --verbose --log-file mailrelay.log --log-time --port 587` as proxy before MailHog.
``` 
The `-t` parameter starts the proxy in a terminal session. This makes it easier to restart the server. 
The relay host must point to the address specified by `-port`.
```
etcdctl set /config/postfix/relayhost 192.168.56.1:587
```

### SASL authentication
SASL authentication can be tested with the `--server-auth <server-auth-file>` parameter.
To do this, a file must be created at the specified path in which server, username and password are stored.
A good tutorial for this can be found [here](https://github.com/aclemons/emailrelay/blob/master/doc/reference.md#authentication).
For SASL authentication this username and password must be stored in etcd.
  ```
  etcdctl set /config/postfix/sasl_username <username>
  etcdctl set /config/postfix/sasl_password <password>
  ```