---
title: "Local mail dispatch"
---

# Local mail dispatch

To check whether the mail dispatch of the Postfix dogu works, [Mailpit](https://github.com/axllent/mailpit)
can be used. Mailpit is a tool for testing emails in a local development environment. Mailpit sets up a local pseudo-SMTP
server.

## Setting up Mailpit in the cluster

In a nutshell, Mailpit is run in the cluster and configured in the local CES as the relay host of the Postfix dogu.

Specifically, the following steps need to be performed:

* Install Mailpit in the cluster:
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
* Set Mailpit as the relay host of the Postfix dogu:
  ```
  kubectl edit configmap -n ecosystem postfix-config
  ```
  ````yaml
    data:
      config.yaml: |
        relayhost: "mailpit.ecosystem.svc.cluster.local:1025"
  ````
* Change to the Dogu's bash:
  ```
  kubectl exec -n ecosystem -it postfix -- bash
  ```
* Send mail:
  ```
  sendmail -t testmail@cloudogu.de
  Text 1234

  <ctrl>+<d>
  ```
* Port-forward the Mailpit UI to localhost:
  ```
  kubectl port-forward -n ecosystem service/mailpit 8025:8025
  ```
* Check mail reception in the Mailpit web interface at `localhost:8025`

## Test with authentication

Mailpit supports setting up authentication, see the [Mailpit documentation](https://mailpit.axllent.org/docs/configuration/http/).
The username and password can be set as follows:

`kubectl edit configmap -n ecosystem postfix-config`
````yaml
    data:
      config.yaml: |
        sasl_username adminuser: admin
        sasl_password adminpw: password
````
