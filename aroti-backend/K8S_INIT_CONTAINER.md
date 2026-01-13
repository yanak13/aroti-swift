# Kubernetes Init Container Configuration

To add database migrations as an init container to the backend deployment, update the Kubernetes deployment YAML:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aroti-backend
spec:
  template:
    spec:
      initContainers:
      - name: migration
        image: aroti/backend-api:latest
        command: ["alembic", "upgrade", "head"]
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: aroti-backend-secrets
              key: database-url
        volumeMounts:
        - name: shared-data
          mountPath: /app
      containers:
      - name: api
        image: aroti/backend-api:latest
        # ... rest of container config
```

This ensures migrations run before the API container starts.
