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

Dazu muss E-MailRelay [heruntergeladen](http://emailrelay.sourceforge.net/Download.html), 
entpackt und installiert `sudo ./configure && sudo make && sudo make install` werden. 

Für die Authentifizierung kann eine Password-Datei angelegt werden, die z.B. so aussehen kann:

secret.auth
```
server plain adminuser adminpw
```

E-MailRelay kann mittels 
```
sudo emailrelay -t --as-server --forward-on-disconnect --log --verbose --log-file mailrelay.log --log-time --port 587 --forward-to localhost:1025 --server-auth ./secret.auth
```
als Proxy vor MailHog gestartet werden.

Der Parameter `-t` startet den Proxy in einer Terminal-Sitzung. Das macht es einfacher, den Server neu zu starten.
Der Relay-Host muss auf die mit dem `-port` spezifizierte Adresse zeigen. 
```
etcdctl set /config/postfix/relayhost 192.168.56.1:587
```

Anschließend kann das entsprechende Passwort für Postfix konfiguriert werden.
Beim Verschicken von Mails wird dann die SASL-Authentifizierung verwendet:
```
etcdctl set /config/postfix/sasl_username adminuser
etcdctl set /config/postfix/sasl_password adminpw
```
