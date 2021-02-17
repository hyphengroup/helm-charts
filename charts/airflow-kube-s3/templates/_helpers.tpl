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

{{/*  Git sync container */}}
{{- define "airflow-kube-s3.git_sync_container"}}
- name: git-sync
  image: {{ .Values.airflow.dags.git.image.repository}}:{{ .Values.airflow.dags.git.image.tag}}
  imagePullPolicy: {{ .Values.airflow.dags.git.image.pullPolicy | quote }}
  volumeMounts:
  - name: airflow-dags
    mountPath: {{ .Values.airflow.dags.git.root }}
  - name: git-sync-ssh-configmap
    mountPath: /etc/git-secret/known_hosts
    subPath: known_hosts
  - name: git-sync-ssh-secrets
    mountPath: /etc/git-secret/ssh
    subPath: ssh
  securityContext:
    runAsUser: 1000
  env:
  - name: GIT_SYNC_REPO
    value: {{ .Values.airflow.dags.git.url }}
  - name: GIT_SYNC_BRANCH
    value: {{ .Values.airflow.dags.git.branch }}
  - name: GIT_SYNC_ROOT
    value: {{ .Values.airflow.dags.git.root }}
  - name: GIT_SYNC_DEST
    value: {{ .Values.airflow.dags.git.dest }}
  - name: GIT_SYNC_DEPTH
    value: {{ .Values.airflow.dags.git.depth | quote }}
  # the number of seconds between syncs
  - name: GIT_SYNC_WAIT
    value: {{ .Values.airflow.dags.git.wait | quote }}
  # using secret and configmap for cloning over SSH
  - name: GIT_SSH_KEY_FILE
    value: /etc/git-secret/ssh
  - name: GIT_SYNC_SSH
    value: "true"
  - name: GIT_SYNC_ADD_USER
    value: "true"
  - name: GIT_KNOWN_HOSTS
    value:  {{ .Values.airflow.dags.git.ssh.strictHostKeyChecking | quote }}
  - name: GIT_SSH_KNOWN_HOSTS_FILE
    value: /etc/git-secret/known_hosts
  {{- if .is_init }}
  - name: GIT_SYNC_ONE_TIME
    value: "true"
  {{- end }}
  resources:
    {{- toYaml .Values.airflow.dags.git.resources | trim | nindent 4 }}
{{- end -}}