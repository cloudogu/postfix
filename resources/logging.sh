#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# logging behaviour can be configured in logging/root with the following options <ERROR,WARN,INFO,DEBUG>
DEFAULT_LOGGING_KEY="logging/root"
DEFAULT_LOG_LEVEL="WARN"

POSTFIX_LOGLEVEL=$(doguctl config --default "${DEFAULT_LOG_LEVEL}" "${DEFAULT_LOGGING_KEY}")
export POSTFIX

# logging configuration used to configure the rsyslog logging mechanism
POSTFIX_LOGGING_TEMPLATE="/etc/rsyslog.conf.tpl"
POSTFIX_LOGGING="/etc/rsyslog.conf"

SCRIPT_LOG_PREFIX="Log level mapping:"
function validateDoguLogLevel() {
  echo "${SCRIPT_LOG_PREFIX} Validate root log level"

  validateExitCode=0
  doguctl validate "${DEFAULT_LOGGING_KEY}" || validateExitCode=$?

  if [[ ${validateExitCode} -ne 0 ]]; then
      echo "${SCRIPT_LOG_PREFIX} WARNING: The loglevel configured in ${DEFAULT_LOGGING_KEY} is invalid."
      echo "${SCRIPT_LOG_PREFIX} WARNING: Removing misconfigured value."
      doguctl config --rm "${DEFAULT_LOGGING_KEY}"
  fi

  return
}

validateDoguLogLevel

echo "Rendering logging configuration..."
doguctl template ${POSTFIX_LOGGING_TEMPLATE} ${POSTFIX_LOGGING}

