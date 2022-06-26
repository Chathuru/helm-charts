{{- define "cassandra.name" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cassandra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cassandra.labels" -}}
helm.sh/chart: {{ include "cassandra.chart" . }}
{{ include "cassandra.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "cassandra.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cassandra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "cassandra.seeds" -}}
{{- $seeds := list }}
{{- $fullname := include "cassandra.name" .  }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $seedCount := .Values.cluster.seedCount | int }}
{{- range $e, $i := until $seedCount }}
{{- $seeds = append $seeds (printf "%s-%d.%s-headless.%s.svc.%s" $fullname $i $fullname $releaseNamespace $clusterDomain) }}
{{- end }}
{{- join "," $seeds }}
{{- end -}}
