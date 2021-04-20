---
title: "Entwickler-Guide"
---

# Entwickler-Guide

Dieser Artikel ist für all jene geeignet, welche an dem Postfix-Dogu entwickeln möchten.

## Voraussetzungen

* Es ist notwendig, die folgenden Programme zu installieren:
    * [git](https://git-scm.com/) - siehe Link
    * vagrant
    * docker

## Aufsetzten der Entwicklungsumgebung

1. Klone das Repository:
   ```
   git clone https://github.com/cloudogu/postfix.git
   ```

## Entwicklung am Postfix-Dogu

### Voraussetzungen

- Eine laufende Vagrant-Maschine für das CES

### Postfix-Dogu Bauen

Der Buildprozess des Dogus wird immer in der Vagrant-Maschine ausgeführt.

1. Wechsel in das Root-Verzeichnis des Postfix-Dogus (in vagrant)
2. Baue das Dogu

```
   cesapp build .
```

Jetzt sollte das Dogu automatisch gebaut, aktualisiert, und gestartet werden.
