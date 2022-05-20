{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql.name" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgresql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgresql.labels" -}}
{{ include "postgresql.selectorLabels" . }}
app.kubernetes.io/managed-by: Restrata
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "postgresql.primary.name" -}}
{{- if eq .Values.architecture "standalone" }}
{{- printf "%s" (include "postgresql.name" .) }}
{{- else -}}
{{- printf "%s-%s" (include "postgresql.name" .) "master" }}
{{- end }}
{{- end }}

{{- define "postgresql.secondary.name" -}}
{{- printf "%s-%s" (include "postgresql.name" .) "secondary" }}
{{- end }}

{{- define "postgresql.headlessService" -}}
{{- if eq .Values.architecture "standalone" }}
{{- printf "%s-%s" (include "postgresql.name" .) "headless" }}
{{- else -}}
{{- printf "%s" (include "postgresql.name" .) }}
{{- end }}
{{- end }}

{{/*
Return the name for a custom database to create
*/}}
{{- define "postgresql.database" -}}
{{- if .Values.postgresql.database }}
    {{- .Values.postgresql.database -}}
{{- end -}}
{{- end -}}
