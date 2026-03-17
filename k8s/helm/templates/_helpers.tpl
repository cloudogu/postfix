{{/* Chart basics
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec) starting from
Kubernetes 1.4+.
*/}}
{{- define "postfix.name" }}
{{ default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* All-in-one labels */}}
{{- define "postfix.labels" }}
app: ces
{{ include "postfix.selectorLabels" . }}
helm.sh/chart: {{ printf " %s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "postfix.selectorLabels" }}
app.kubernetes.io/name: {{ include "postfix.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
