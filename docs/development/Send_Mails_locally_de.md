---
title: "Lokaler Mailversand"
---

# Lokaler Mailversand

Zur Überprüfung, ob der Mailversand des Postfix-Dogus funktioniert, kann [Mailpit](https://github.com/axllent/mailpit)
verwendet werden. Mailpit ist ein Tool zum Testen von E-Mails in einer lokalen Entwicklungsumgebnung. Mailpit richtet
einen lokalen Pseudo-SMTP-Server ein.

## Einrichtung von Mailpit im Cluster

Kurz zusammengefasst wird Mailpit lokal auf dem Host-Rechner als Docker-Container ausgeführt und im lokalen CES als
Relay-Host des Postfix-Dogus eingetragen.

Konkret müssen folgende Schritte ausgeführt werden:

* Mailpit im Cluster installieren:
  ```bash
  cat <<EOF | kubectl apply -f - 
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: mailpit
    labels:
      app: mailpit
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: mailpit
    template:
      metadata:
        labels:
          app: mailpit
      spec:
        containers:
          - name: mailpit
            image: axllent/mailpit:latest
            ports:
              - containerPort: 8025  # Web UI
              - containerPort: 1025  # SMTP
            env:
              - name: MP_MAX_MESSAGES
                value: "1000"
            resources:
              requests:
                cpu: 50m
                memory: 64Mi
              limits:
                cpu: 200m
                memory: 128Mi
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: mailpit
    labels:
      app: mailpit
  spec:
    selector:
      app: mailpit
    ports:
      - name: http
        port: 8025
        targetPort: 8025
      - name: smtp
        port: 1025
        targetPort: 1025
    type: ClusterIP
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: mailpit
    annotations:
      kubernetes.io/ingress.class: traefik
  spec:
    rules:
      - host: mailpit.example.com
        http:
          paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: mailpit
                  port:
                    number: 8025
  EOF
  ```
* Mailpit als Relay-Host des Postfix-Dogus setzen:
  ```
  `kubectl edit configmap -n ecosystem postfix-config`
  ```
  ````yaml
    data:
      config.yaml: |
        relayhost: "mailpit.ecosystem.svc.cluster.local:1025"
  ````
* In die bash des Dogus wechseln
  ```
  kubectl exec -n ecosystem -it postfix -- bash 
  ```  
* Mail versenden
  ```
  sendmail -t testmail@cloudogu.de
  Text 1234
  
  <strg>+<d>
  ```
* Port-Forward der Mailpit-UI auf localhost
  ```
  kubectl port-forward -n ecosystem service/mailpit 8025:8025
  ```
* In Web-Oberfläche vom Mailpit - ```localhost:8025``` - Mail-Empfang prüfen

## Mit Authentifizierung testen

Mailpit unterstützt die Einrichtung einer Authentifizierung, siehe [Mailpit-Dokumentation](https://mailpit.axllent.org/docs/configuration/http/).
Benutzername und Password können wie folgt eingestellt werden:

`kubectl edit configmap -n ecosystem postfix-config`
````yaml
    data:
      config.yaml: |
        sasl_username adminuser: admin
        sasl_password adminpw: password
````