---
title: "Installation des Postfix-Dogu"
---

# Installation des Postfix-Dogu

## Voraussetzung

Für eine erfolgreiche Installation von Postfix muss im etcd vom CES ein Wert für den Relay-Host von Postfix 
konfiguriert sein. Dieser wird in der Regel bereits beim Setup des CES gesetzt. Allerdings wird dieser Wert
beim Entfernen des Dogus über den Purge Befehl gelöscht. Der Wert muss dann vor der erneuten Installation vom
Postfix neu gesetzt werden. Dies kann über folgenden Befehl erfolgen:
``` 
etcdctl set /config/postfix/relayhost <Wert für den Relay-Host>
```

## Installation

Postfix can be easily installed via `cesapp` like all other dogus:
```
cesapp install official/postfix
```
