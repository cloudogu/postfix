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