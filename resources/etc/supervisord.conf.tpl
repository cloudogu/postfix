[supervisord]
user             = root
nodaemon         = true
logfile          = /dev/null
logfile_maxbytes = 0
loglevel         = {{ .Env.Get "POSTFIX_LOGLEVEL" }}

[program:rsyslog]
command                 = rsyslogd -n
autostart               = true
autorestart             = true
startsecs               = 2
stopwaitsecs            = 2
stdout_logfile          = /dev/stdout
stderr_logfile          = /dev/stderr
stdout_logfile_maxbytes = 0
stderr_logfile_maxbytes = 0

[program:postfix]
process_name    = master
autostart       = true
autorestart     = false
directory       = /etc/postfix
command         = /usr/sbin/postfix -c /etc/postfix start
startsecs       = 0
