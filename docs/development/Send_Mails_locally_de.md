---
title: "Lokaler Mailversand"
---

# Lokaler Mailversand

Zur Überprüfung, ob der Mailversand des Postfix-Dogus funktioniert, kann [MailHog](https://github.com/mailhog/MailHog)
verwendet werden. MailHog ist ein Tool zum Testen von E-Mails in einer lokalen Entwicklungsumgebnung. MailHog richtet
einen lokalen Pseudo-SMTP-Server ein.

## Einrichtung von MailHog auf dem Host

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

## Einrichtung von MailHog im CES

Mit dem folgenden Skript wird MailHog im CES installiert. Anschließend kann die Weboberfläche von MailHog über das Warp-Menü aufgerufen werden.

```shell
etcdctl set dogu/mailhog/1.0.0-1 '{"Name": "official/mailhog","Version": "1.0.0-1","DisplayName": "Mailhog","Description": "Mailhog Dogu","Category": "Administration Apps","Tags": ["webapp","warp"],"Logo": "","URL": "https://github.com/cloudogu","Image": "registry.cloudogu.com/official/mailhog","Dependencies": ["nginx"],"OptionalDependencies": null}' && \
etcdctl set dogu/mailhog/current 1.0.0-1 && \
docker run -d -e MH_UI_WEB_PATH=mailhog -p 25:1025 -p 8025:8025 --name mailhog --net cesnet1 mailhog/mailhog && \
MAILHOG_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mailhog) && \
etcdctl set services/mailhog/registrator:mailhog:8025 "{\"name\":\"mailhog\",\"service\":\"${MAILHOG_IP}:8025\",\"port\":\"8025\",\"tags\":[\"webapp\"],\"healthStatus\":\"healthy\",\"attributes\":{}}" && \
etcdctl set /config/postfix/relayhost mailhog:1025 && docker restart postfix
```


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
