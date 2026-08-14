---
title: "Installation of the Postfix dogu"
---

# Installation of the Postfix dogu

## Prerequisite

For a successful installation of Postfix, a value for the Postfix relay host must be configured in the CES.
This is usually already set during the setup of the CES. The relayhost can be set with the following command:

`kubectl edit configmap -n ecosystem postfix-config`
````yaml
    data:
      config.yaml: |
        relayhost: "192.168.1.1"
````

Translated with www.DeepL.com/Translator (free version)

## Installation

Postfix can be easily installed via `kubectl` like all other dogus:

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