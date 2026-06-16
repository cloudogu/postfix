#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$(realpath "$0")")"

# shellcheck source=/dev/null
source .env

: "${NAMESPACE:?NAMESPACE must be set}"
: "${KUBE_CONTEXT_NAME:?KUBE_CONTEXT_NAME must be set}"

mapfile -t PODS < <(kubectl --context="${KUBE_CONTEXT_NAME}" -n "${NAMESPACE}" get pod -l dogu.name=postfix --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
if [[ ${#PODS[@]} -eq 0 ]]; then
    echo "No running postfix pod found in namespace ${NAMESPACE} using selector dogu.name=postfix" >&2
    exit 1
fi

POD="${PODS[0]}"
MAIL_TO="${MAIL_TO:-test@example.org}"
MAIL_FROM="${MAIL_FROM:-noreply@cloudogu.com}"

kubectl --context="${KUBE_CONTEXT_NAME}" -n "${NAMESPACE}" exec -i "${POD}" -c postfix -- sendmail -f "${MAIL_FROM}" -t << EOF
To: ${MAIL_TO}
From: ${MAIL_FROM}
Subject: Postfix Kubernetes smoke test

Hello from the postfix pod.
EOF

for _ in {1..10}; do
    sleep "1"
    if kubectl --context="${KUBE_CONTEXT_NAME}" -n "${NAMESPACE}" exec "${POD}" -c postfix -- mailq | grep -Fq "${MAIL_TO}"; then
        echo "Success: Postfix accepted the message and it is queued for ${MAIL_TO}." >&2
        exit 0
    fi
    printf "." >&2
done
printf "\n" >&2

echo "Could not verify that Postfix accepted the message." >&2
echo "Current mail queue:" >&2
kubectl --context="${KUBE_CONTEXT_NAME}" -n "${NAMESPACE}" exec "${POD}" -c postfix -- mailq >&2
exit 1
