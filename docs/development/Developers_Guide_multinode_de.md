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

- ein laufendes Multi-Node-Cluster
- gesetzter kubectx des Clusters

### Postfix-Dogu Bauen


1. Baue das Dogu

```
   make build
```

Jetzt sollte das Dogu automatisch gebaut, aktualisiert, und gestartet werden.
