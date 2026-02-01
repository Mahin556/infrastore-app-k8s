{{- define "labels" -}}
app.kubernetes.io/environment: {{ .Values.environment }}
app.kubernetes.io/release: {{ .Release.Name }}
app.kubernetes.io/name: {{ .Values.app_name }}
{{- end }}

{{- define "infrastore.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.app_name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return ServiceAccount name in format:
<release>-<app_name>-sa

Supports custom override and external SA.
*/}}
{{- define "infrastore.serviceAccountName" -}}

{{- if .Values.serviceAccount.create }}

    {{- if .Values.serviceAccount.name }}
        {{- .Values.serviceAccount.name | trunc 63 | trimSuffix "-" }}
    {{- else }}
        {{- printf "%s-%s-sa" .Release.Name .Values.app_name | trunc 63 | trimSuffix "-" }}
    {{- end }}

{{- else }}
    {{- required "serviceAccount.name must be set when serviceAccount.create=false" .Values.serviceAccount.name }}
{{- end }}

{{- end }}

