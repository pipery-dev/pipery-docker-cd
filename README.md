# Pipery Docker CD

CD pipeline for Docker: pull image, deploy (ArgoCD/Cloud Run/Helm/Ansible), check status

## Status

- Owner: `pipery-dev`
- Repository: `pipery-docker-cd`
- Marketplace category: `continuous-integration`
- Current version: `1.0.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-docker-cd@v1
        with:
          project_path: .
          config_file: .github/pipery/config.yaml
          deploy_target: argocd
          deploy_strategy: rolling
          skip_pull: false
          skip_deploy: false
          skip_status_check: false
          image_name: 
          image_tag: latest
          registry: ghcr.io
          registry_username: 
          registry_password: 
          argocd_server: 
          argocd_app: 
          argocd_token: 
          cloud_run_service: 
          cloud_run_region: us-central1
          cloud_run_image: 
          helm_release: 
          helm_chart: 
          helm_namespace: default
          ansible_playbook: 
          ansible_inventory: 
          log_file: pipery.jsonl
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree the action should operate on. |
| `config_file` | no | `.github/pipery/config.yaml` | Path to the pipery config file. |
| `deploy_target` | no | `argocd` | Deployment target: argocd, cloud-run, helm, or ansible. |
| `deploy_strategy` | no | `rolling` | Deployment strategy: rolling, blue-green, or canary. |
| `skip_pull` | no | `false` | Skip the image pull step. |
| `skip_deploy` | no | `false` | Skip the deploy step. |
| `skip_status_check` | no | `false` | Skip the status check step. |
| `image_name` | no | `` | Container image name to pull (e.g. ghcr.io/org/app). |
| `image_tag` | no | `latest` | Container image tag to pull. |
| `registry` | no | `ghcr.io` | Container registry hostname. |
| `registry_username` | no | `` | Username for registry login. |
| `registry_password` | no | `` | Password or token for registry login. |
| `argocd_server` | no | `` | ArgoCD server URL. |
| `argocd_app` | no | `` | ArgoCD application name. |
| `argocd_token` | no | `` | ArgoCD authentication token. |
| `cloud_run_service` | no | `` | Cloud Run service name. |
| `cloud_run_region` | no | `us-central1` | Cloud Run region. |
| `cloud_run_image` | no | `` | Container image to deploy to Cloud Run. |
| `helm_release` | no | `` | Helm release name. |
| `helm_chart` | no | `` | Helm chart path or reference. |
| `helm_namespace` | no | `default` | Kubernetes namespace for Helm deployment. |
| `ansible_playbook` | no | `` | Path to the Ansible playbook file. |
| `ansible_inventory` | no | `` | Path to the Ansible inventory file. |
| `log_file` | no | `pipery.jsonl` | Path to write the JSONL log file. |

## Outputs

No outputs.

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
