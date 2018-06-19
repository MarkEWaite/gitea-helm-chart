{{/*
Create helm partial for gitea server
*/}}
{{- define "gitea" }}
- name: gitea
  image: {{ .Values.images.gitea }}
  imagePullPolicy: {{ .Values.images.pullPolicy }}
  env:
  - name: POSTGRES_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "postgresql.fullname" . }}
        key: postgres-password
  ports:
  - name: ssh
    containerPort: 22
  - name: http
    containerPort: 3000
  livenessProbe:
    tcpSocket:
      port: http
    initialDelaySeconds: 200
    timeoutSeconds: 1
    periodSeconds: 10
    successThreshold: 1
    failureThreshold: 10
  readinessProbe:
    tcpSocket:
      port: http
    initialDelaySeconds: 5
    periodSeconds: 10
    successThreshold: 1
    failureThreshold: 3
  volumeMounts:
  - name: gitea-data
    mountPath: /data
  - name: gitea-config
    mountPath: /etc/gitea
{{- end }}