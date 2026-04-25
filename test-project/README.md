# Test Project — Docker CD

This fixture project is used by `pipery-docker-cd` during `pipery-actions test`.

It contains representative deployment manifests for each supported target:

| File/Directory | Purpose |
| --- | --- |
| `k8s/deployment.yaml` | Kubernetes Deployment manifest referencing the Docker image |
| `argocd-app.yaml` | ArgoCD Application CR pointing at this repo |
| `helm/values.yaml` | Helm values with image repository and tag |
| `ansible/deploy.yml` | Ansible playbook that pulls and runs the container |
| `docker-compose.yml` | Docker Compose service definition for local testing |
