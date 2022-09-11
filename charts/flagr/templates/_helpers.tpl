{{/*
Expand the name of the chart.
*/}}
{{- define "flagr.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "flagr.fullname" -}}
{{- printf "%s-%s" .Release.Name "server" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "flagr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Generate datadog labels */}}
{{- define "flagr.datadogLabels" }}
tags.datadoghq.com/env: {{ default "prod" .Values.datadog.env }}
tags.datadoghq.com/service: {{ default "flagr" .Values.datadog.serviceName }}
tags.datadoghq.com/version: {{ default "unset" .Values.datadog.flagrVersion }}
tags.datadoghq.com/namespace: {{ .Release.Namespace }}
tags.datadoghq.com/port: "8126"
{{- end }}

{{/*
Common labels
*/}}
{{- define "flagr.labels" -}}
helm.sh/chart: {{ include "flagr.chart" . }}
{{ include "flagr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- include "flagr.datadogLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "flagr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flagr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "flagr.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "flagr.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* Generate env vars for datadog */}}
{{- define "flagr.datadogEnv" -}}
- name: DD_AGENT_HOST
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
- name: DD_ENTITY_ID
  valueFrom:
    fieldRef:
      fieldPath: metadata.uid
- name: DD_ENV
  valueFrom:
    fieldRef:
      fieldPath: metadata.labels['tags.datadoghq.com/env']
- name: DD_TRACE_AGENT_PORT
  valueFrom:
    fieldRef:
      fieldPath: metadata.labels['tags.datadoghq.com/port']
- name: DD_SERVICE
  valueFrom:
    fieldRef:
      fieldPath: metadata.labels['tags.datadoghq.com/service']
- name: DD_SERVICE_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.labels['tags.datadoghq.com/service']
- name: DD_TRACE_AGENT_HOSTNAME
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
- name: DD_VERSION
  valueFrom:
    fieldRef:
      fieldPath: metadata.labels['tags.datadoghq.com/version']
- name: DD_RUNTIME_METRICS_ENABLED
  value: "true"
- name: DD_TRACE_ANALYTICS_ENABLED
  value: "true"
- name: DD_LOGS_INJECTION
  value: "true"
- name: DD_PROFILING_ENABLED
  value: "true"
- name: DD_APPSEC_ENABLED
  value: "true"
{{- end -}}
