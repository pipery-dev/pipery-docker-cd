# Pipery Docker CD

CD pipeline for Docker: pull image, deploy (ArgoCD/Cloud Run/Helm/Ansible), check status

## Status

- Owner: `pipery-dev`
- Repository: `pipery-docker-cd`
- Marketplace category: `continuous-integration`
- Current version: `0.1.0`

## Usage

```yaml
- uses: pipery-dev/pipery-docker-cd@v0
  with:
    project_path: .
    deploy_target: argocd   # or cloud-run, helm, ansible
```

## Inputs

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree the action should operate on. |
| `config_file` | `.github/pipery/config.yaml` | Path to the pipery config file. |
| `deploy_target` | `argocd` | Deployment target: `argocd`, `cloud-run`, `helm`, or `ansible`. |
| `deploy_strategy` | `rolling` | Deployment strategy: `rolling`, `blue-green`, or `canary`. |
| `skip_pull` | `false` | Skip the image pull step. |
| `skip_deploy` | `false` | Skip the deploy step. |
| `skip_status_check` | `false` | Skip the status check step. |
| `image_name` | `` | Container image name to pull (e.g. `ghcr.io/org/app`). |
| `image_tag` | `latest` | Container image tag to pull. |
| `registry` | `ghcr.io` | Container registry hostname. |
| `registry_username` | `` | Username for registry login. |
| `registry_password` | `` | Password or token for registry login. Store as a GitHub Secret. |
| `argocd_server` | `` | ArgoCD server URL. |
| `argocd_app` | `` | ArgoCD application name. |
| `argocd_token` | `` | ArgoCD authentication token. Store as a GitHub Secret. |
| `cloud_run_service` | `` | Cloud Run service name. |
| `cloud_run_region` | `us-central1` | Cloud Run region. |
| `cloud_run_image` | `` | Container image to deploy to Cloud Run. |
| `helm_release` | `` | Helm release name. |
| `helm_chart` | `` | Helm chart path or reference. |
| `helm_namespace` | `default` | Kubernetes namespace for Helm deployment. |
| `ansible_playbook` | `` | Path to the Ansible playbook file. |
| `ansible_inventory` | `` | Path to the Ansible inventory file. |
| `log_file` | `pipery.jsonl` | Path to write the JSONL log file. |

## Deployment Targets

### ArgoCD

Syncs an existing ArgoCD application and waits for it to become healthy.

Relevant inputs: `argocd_server`, `argocd_app`, `argocd_token` (Secret).

### Cloud Run

Deploys a container image to a Google Cloud Run service.

Relevant inputs: `cloud_run_service`, `cloud_run_region`, `cloud_run_image`.

### Helm

Upgrades a Helm release in a Kubernetes cluster.

Relevant inputs: `helm_release`, `helm_chart`, `helm_namespace`.

### Ansible

Runs an Ansible playbook against the specified inventory.

Relevant inputs: `ansible_playbook`, `ansible_inventory`.

## Steps

| Step | Skip input | Description |
|---|---|---|
| Pull image | `skip_pull` | Logs in to the container registry (if credentials provided) and pulls the Docker image. |
| Deploy | `skip_deploy` | Delegates to `pipery-steps deploy` with the configured target and strategy. |
| Status check | `skip_status_check` | Checks deployment health for the configured target after deploy completes. |

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
