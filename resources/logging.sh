#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

SCRIPT_LOG_PREFIX="Log level mapping:"

function exitOnInvalidDoguLogLevel() {
  echo "${SCRIPT_LOG_PREFIX} Validate root log level"

  validateExitCode=0
  doguctl validate "${DEFAULT_LOGGING_KEY}" || validateExitCode=$?

  if [[ ${validateExitCode} -ne 0 ]]; then
      echo "${SCRIPT_LOG_PREFIX} ERROR: The loglevel configured in ${DEFAULT_LOGGING_KEY} is invalid."
      echo "${SCRIPT_LOG_PREFIX} ERROR: Fix the loglevel. Exiting now"
      exit 1
  fi

  return
}

# logging behaviour can be configured in logging/root with the following options <ERROR,WARN,INFO,DEBUG>
DEFAULT_LOGGING_KEY="logging/root"
DEFAULT_LOG_LEVEL="INFO"

# check if loglevel is valid or exit, so that customers see that they need to fix the log level
exitOnInvalidDoguLogLevel

POSTFIX_LOGLEVEL=$(doguctl config --default "${DEFAULT_LOG_LEVEL}" "${DEFAULT_LOGGING_KEY}")
export POSTFIX_LOGLEVEL

# logging configuration used to configure the rsyslog logging mechanism
RSYSLOG_LOGGING_TEMPLATE="/etc/rsyslog.conf.tpl"
RSYSLOG_LOGGING="/etc/rsyslog.conf"

# config file for supervisor which contains a loglevel configuration
SUPERVISOR_CONF_TEMPLATE="/etc/supervisord.conf.tpl"
SUPERVISOR_CONF="/etc/supervisord.conf"

echo "Rendering logging configuration..."
doguctl template ${RSYSLOG_LOGGING_TEMPLATE} ${RSYSLOG_LOGGING}
doguctl template ${SUPERVISOR_CONF_TEMPLATE} ${SUPERVISOR_CONF}

