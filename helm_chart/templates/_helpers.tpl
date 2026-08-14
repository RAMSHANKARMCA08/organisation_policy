{{- define "reusable.name" -}}{{- .Values.application.name | trunc 63 | trimSuffix "-" -}}{{- end -}}
{{- define "reusable.fullname" -}}{{- printf "%s-%s" .Values.application.name .Values.environment.name | trunc 63 | trimSuffix "-" -}}{{- end -}}
{{- define "reusable.labels" -}}
app.kubernetes.io/name: {{ .Values.application.name | quote }}
app.kubernetes.io/instance: {{ include "reusable.fullname" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
environment: {{ .Values.environment.name | quote }}
cloud: {{ .Values.cloud.provider | quote }}
{{- end -}}
{{- define "reusable.serviceAccountName" -}}{{- if .Values.serviceAccount.create -}}{{- default (include "reusable.fullname" .) .Values.serviceAccount.name -}}{{- else -}}{{- default "default" .Values.serviceAccount.name -}}{{- end -}}{{- end -}}
