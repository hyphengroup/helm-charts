{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow-kube-s3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "airflow-kube-s3.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "airflow-kube-s3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow-kube-s3.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "airflow-kube-s3.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "airflow-kube-s3.labels" -}}
app.kubernetes.io/name: {{ template "airflow-kube-s3.name" . }}
helm.sh/chart: {{ template "airflow-kube-s3.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.airflow.podLabels }}
{{ toYaml .Values.airflow.podLabels }}
{{- end }}
{{- end -}}

{{/* matchLabels */}}
{{- define "airflow-kube-s3.matchLabels" -}}
app.kubernetes.io/name: {{ template "airflow-kube-s3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a random string if the supplied key does not exist
*/}}
{{- define "airflow-kube-s3.defaultsecret" -}}
{{- if . -}}
{{- . | b64enc | quote -}}
{{- else -}}
{{- randAlphaNum 10 | b64enc | quote -}}
{{- end -}}
{{- end -}}
