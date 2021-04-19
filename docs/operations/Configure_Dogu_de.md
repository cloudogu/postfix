# Konfiguration des Postfix-Dogu

## Voraussetzung

* Das Postfix-Dogu ist erfolgreich [installiert](Install_Dogu_de.md)

## Konfigurationsmöglichkeiten

Das Postfix-Dogu wird über die etcd-Registry konfiguriert. Es gibt mehrere Möglichkeiten, um Werte in der etcd-Registry
zu konfigurieren. Kurzgefasst kann man:

1. Das Postfix-Dogu mit `cesapp edit-config postfix` konfigurieren (empfohlen)
2. Die Konfigurations-Werte mithilfe eines Blueprint aktualisieren
3. Die Schlüssel mit `etcdctl` manuell anpassen

## Konfiguration

Alle Konfigurationsschlüssel für die Einstellungen des Postfix haben das Schlüsselpräfix `config/postfix/`. Das
Postfix-Dogu bietet die folgenden Einstellungen:

### Relay-Host

* Pfad des Konfigurationsschlüssels: `relayhost`
* Das Next-Hop-Ziel von nicht-lokalen Mails
* Wird in der Regel bereits bei der Einrichtung des CES gesetzt.
* Der Wert muss dann vor der Installation von Postfix gesetzt werden. Dies kann mit folgendem Befehl geschehen:
  ```
  etcdctl set /config/postfix/relayhost <Wert für den Relayhost>
  ```

### SMTP TLS Sicherheitsstufe

* Pfad des Konfigurationsschlüssels: `smtp_tls_security_level`
* Die Standard-SMTP-TLS-Sicherheitsstufe für den Postfix-SMTP-Client.
* Optional

### SMTP-Client RSA-Zertifikat

* Pfad des Konfigurationsschlüssels: `smtp_tls_cert_file`
* Postfix SMTP-Client RSA-Zertifikat im PEM-Format
* Optional
* Verschlüsselt

### Postfix SMTP-Client RSA-Privatschlüssel

* Pfad des Konfigurationsschlüssels: `smtp_tls_key_file`
* Postfix SMTP-Client RSA-Privatschlüssel im PEM-Format
* Optional
* Verschlüsselt

### CA-Zertifikate

* Pfad des Konfigurationsschlüssels: `smtp_tls_CAfile`
* CA-Zertifikate von Root-CAs, denen vertraut wird, um entweder entfernte SMTP-Server-Zertifikate oder
  Zwischen-CA-Zertifikate zu signieren
* Optional

### Zusätzliche Postfix SMTP-Client-Protokollierung

* Pfad des Konfigurationsschlüssels: `smtp_tls_loglevel`
* Aktiviert zusätzliche Postfix-SMTP-Client-Protokollierung der TLS-Aktivität
* Optional

### Ausgeschlossen Verschlüsselungen

* Pfad des Konfigurationsschlüssels: `smtp_tls_exclude_ciphers`
* Liste der Verschlüsselungen oder Verschlüsselung-Typen, die von der Verschlüsselung-Liste des Postfix-SMTP-Clients auf
  allen TLS-Sicherheitsstufen ausgeschlossen werden sollen
* Optional

### Erforderliche Verschlüsselung

* Pfad des Konfigurationsschlüssels: `smtp_tls_mandatory_ciphers`
* Der minimale TLS-Verschlüsselung-Grad, den der Postfix SMTP-Client bei der erforderlichen TLS-Verschlüsselung
  verwenden soll
* Optional

### SSL/TLS-Protokolle

* Pfad des Konfigurationsschlüssels: `smtp_tls_mandatory_protocols`
* Liste der SSL/TLS-Protokolle, die der Postfix-SMTP-Client mit zwingender TLS-Verschlüsselung verwenden wird
* Optional

### Log Level

* Pfad des Konfigurationsschlüssels: `logging/root`
* Inhalt: Setzt das Log-Level des Postfix-Dogu.
* Datentyp: string
* Valide Werte: `ERROR, WARN, INFO, DEBUG`
* Default-Wert: `INFO`

#### Physisches Speicherlimit

* Pfad des Konfigurationsschlüssels `container_config/memory_limit`
* Inhalt: Beschränkt den Speicher (RAM) des Docker-Containers für das Postfix-Dogu
* Datentyp: Binäre Speicherangabe
* Valide Werte: Ganzzahl gefolgt von [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte)
* Beispiel: `1750m` = 1750 MebiByte

#### Physisches Swaplimit

* Konfigurations-Schlüssel-Pfad: `container_config/swap_limit`
* Inhalt: Beschränkt den Swap des Docker-Containers für das Postfix-Dogu
* Datentyp: Binäre Speicherangabe
* Valide Werte: Ganzzahl gefolgt von [b,k,m,g] (byte, kibibyte, mebibyte, gibibyte)
* Beispiel: `1750m` = 1750 MebiByte