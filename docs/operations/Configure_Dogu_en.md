---
title: "Configuration of the Postfix dogu"
---

# Configuration of the Postfix dogu

## Prerequisite

* The Postfix dogu is successfully [installed](Install_Postfix_en.md)

## Configuration options

The Postfix dogu is configured via the etcd registry. There are several ways to configure values in the registry. In
short you can:

1. configure Postfix dogu with `cesapp edit-config postfix` (recommended)
2. update the configuration values using a blueprint
3. manually adjust the keys with `etcdctl`

## Configuration

All configuration keys for the Postfix dogu settings have the key prefix `config/postfix/`. The Postfix dogu provides
the following settings:

### Relay host

* Configuration key path: `relayhost`
* The next-hop destination of non-local mail
* Is usually already set during the setup of the CES
* The value must then be set before installing the Postfix. This can be done with the following command:
  ```
  etcdctl set /config/postfix/relayhost <value for the relay host>
  ```

### SMTP TLS security level

* Configuration key path: `smtp_tls_security_level`
* The default SMTP TLS security level for the Postfix SMTP client
* Optional

### SMTP client RSA certificate

* Configuration key path: `smtp_tls_cert_file`
* Postfix SMTP client RSA certificate in PEM format
* Optional
* Encrypted

### Postfix SMTP client RSA private key

* Configuration key path: `smtp_tls_key_file`
* Postfix SMTP client RSA private key in PEM format
* Optional
* Encrypted

### CA certificates

* Configuration key path: `smtp_tls_CAfile`
* CA certificates of root CAs trusted to sign either remote SMTP server certificates or intermediate CA certificates
* Optional

### Additional Postfix SMTP client logging

* Configuration key path: `smtp_tls_loglevel`
* Enable additional Postfix SMTP client logging of TLS activity
* Optional

### Excluding ciphers

* Configuration key path: `smtp_tls_exclude_ciphers`
* List of ciphers or cipher types to exclude from the Postfix SMTP client cipher list at all TLS security levels
* Optional

### Mandatory ciphers

* Configuration key path: `smtp_tls_mandatory_ciphers`
* The minimum TLS cipher grade that the Postfix SMTP client will use with mandatory TLS encryption
* Optional

### SSL/TLS protocols

* Configuration key path: `smtp_tls_mandatory_protocols`
* List of SSL/TLS protocols that the Postfix SMTP client will use with mandatory TLS encryption
* Optional

### Log Level

* Configuration key path: `logging/root`
* Content: Set the root log level for the Postfix dogu.
* Data type: string
* Valid values: `ERROR, WARN, INFO, DEBUG`
* Default value: `INFO`

### Physical memory limit

* Configuration key path: `container_config/memory_limit`
* Content: limits the memory (RAM) of the Docker container for the Postfix dogu.
* Data type: Binary memory specification.
* Valid values: integer followed by [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte).
* Example: `1750m` = 1750 MebiByte

### Physical swap limit

* Configuration key path: `container_config/swap_limit`
* Content: limits Docker container swap for the Postfix dogu.
* Data type: Binary memory specification.
* Valid values: integer followed by [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte).
* Example: `1750m` = 1750 MebiByte