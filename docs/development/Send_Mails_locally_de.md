---
title: "Lokaler Mailversand"
---

# Lokaler Mailversand

Zur Überprüfung, ob der Mailversand des Postfix-Dogus funktioniert, kann [MailHog](https://github.com/mailhog/MailHog)
verwendet werden. MailHog ist ein Tool zum Testen von E-Mails in einer lokalen Entwicklungsumgebnung. MailHog richtet
einen lokalen Pseudo-SMTP-Server ein.

## Einrichtung von MailHog

Kurz zusammengefasst wird MailHog lokal auf dem Host-Rechner als Docker-Container ausgeführt und im lokalen CES als
Relay-Host des Postfix-Dogus eingetragen.

Konkret müssen folgende Schritte ausgeführt werden:

* MailHog auf dem Host-Rechner als Docker-Container ausführen:
  ```
  docker run -d -p 1025:1025 -p 8025:8025 mailhog/mailhog 
  ```
* MailHog im lokalen CES als Relay-Host des Postfix-Dogus setzen:
  ```
  etcdctl set /config/postfix/relayhost 192.168.56.1:1025
  ```
* Postfix-Dogu über die cesapp entfernen und neu erzeugen
  ```
  cesapp recreate postfix
  ```
* Postfix-Dogu starten
  ```
  cesapp start postfix 
  ```
* In die bash des Dogus wechseln
  ```
  docker exec -it postfix bash 
  ```  
* Mail versenden
  ```
  sendmail -t testmail@cloudogu.de
  Text 1234
  
  <strg>+<d>
  ```
* In Web-Oberfläche vom MailHog - ```localhost:8025``` - Mail-Empfang prüfen


## Einrichtung eines Proxy vor MailHog zum testen von Authentifizerungsworkflows
MailHog unterstützt keine Authentifizerung, aus diesem Grund kann mithilfe des Tools [E-MailRelay](http://emailrelay.sourceforge.net/index.html) 
ein Proxy vor dem MailHog aufgebaut werden.

Dazu muss E-MailRelay [heruntergeladen](http://emailrelay.sourceforge.net/Download.html), entpackt und installiert `sudo ./configure && make && make install` werden. 

E-MailRelay kann mittels 
```
sudo emailrelay -t --as-server --forward-on-disconnect --log --verbose --log-file mailrelay.log --log-time --port 587` als Proxy vor MailHog gestartet werden.
``` 
Der Parameter `-t` startet den Proxy in einer Terminal-Sitzung. Das macht es einfacher, den Server neu zu starten.
Der Relay-Host muss auf die mit dem `-port` spezifizierte Adresse zeigen. 
```
etcdctl set /config/postfix/relayhost 192.168.56.1:587
```

### SASL Authentifizierung
SASL Authentifizierung kann mit dem Parameter `--server-auth <server-auth-file>` getestet werden. 
Dazu muss am spezifizierten Pfad eine Datei angelegt werden in der Server, username und password hinterlegt werden.
Eine gute Anleitung hierzu kann [hier](https://github.com/aclemons/emailrelay/blob/master/doc/reference.md#authentication) eingesehen werden. 
Für SASL Authentifizierung muss der in der Datei hinterlegten Username und Passwort im etcd hinterlegt werden.
  ```
  etcdctl set /config/postfix/sasl_username <username>
  etcdctl set /config/postfix/sasl_password <password>
  ```