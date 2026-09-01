---
title: "Installation des Postfix-Dogu"
---

# Installation des Postfix-Dogu

## Voraussetzung

Für eine erfolgreiche Installation von Postfix muss vom CES ein Wert für den Relay-Host von Postfix konfiguriert
sein. Dieser wird in der Regel bereits beim Setup des CES gesetzt. Das Setzen des Wertes kann über folgenden Befehl erfolgen:

`kubectl edit configmap -n ecosystem postfix-config`
````yaml
    data:
      config.yaml: |
        relayhost: "192.168.1.1"
````

## Installation

Postfix kann mit `kubectl` installiert werden:

````bash
kubectl apply -n ecosystem -f - <<EOF
apiVersion: k8s.cloudogu.com/v2
kind: Dogu 
  metadata: 
    name: postfix
labels:
  app: ces
spec:
  name: official/postfix
  version: 3.11.4-1
EOF
````