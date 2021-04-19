# Installation of the Postfix Dogu

## Prerequisite

For a successful installation of Postfix, a value for the Postfix relay host must be configured in the etcd 
of the CES. This is usually already set during the setup of the CES. However, this value is deleted when the 
dogu is removed via the purge command. The value must then be reset before reinstalling the Postfix. This can 
be done with the following command:
``` 
etcdctl set /config/postfix/relayhost <value for the relay host>
```

Translated with www.DeepL.com/Translator (free version)

## Installation

Postfix can be easily installed via `cesapp` like all other dogus:
```
cesapp install official/postfix
```


Translated with www.DeepL.com/Translator (free version)