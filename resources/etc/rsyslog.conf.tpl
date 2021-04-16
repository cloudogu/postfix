$ModLoad immark.so # provides --MARK-- message capability
$ModLoad imuxsock.so # provides support for local system logging (e.g. via logger command)

# default permissions for all log files.
$FileOwner root
$FileGroup adm
$FileCreateMode 0640
$DirCreateMode 0755
$Umask 0022

# configuration for mail (postfix)
mail.{{ .Env.Get "POSTFIX_LOGLEVEL" }} /dev/stdout
