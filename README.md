# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-docker-cd/main/assets/icon.png" width="28" align="center" /> Pipery Docker CD

Reusable GitHub Action for Docker CD — pull image, deploy, and verify — with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Docker%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-docker-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CD
on:
  push:
    branches: [main]

jobs:
  cd:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-docker-cd@v1
        with:
          image_name: ghcr.io/${{ github.repository }}
          image_tag: ${{ github.sha }}
          deploy_target: argocd
          argocd_server: ${{ vars.ARGOCD_SERVER }}
          argocd_app: my-app
          argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

## GitLab CI

This repository also includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as the reference implementation when you want to run the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps the action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and keeps the same skip controls where the GitHub Action exposes them. Store credentials such as deploy tokens, registry passwords, and cloud provider keys as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-docker-cd/v1/.gitlab-ci.yml
```

## Pipeline steps

| Step | Description | Skip input |
|---|---|---|
| Download | Pull Docker image from registry | `skip_download` |
| Deploy | Deploy via ArgoCD, Cloud Run, Helm, or Ansible | `skip_deploy` |
| Status check | Verify deployment health | `skip_status_check` |

## Inputs

| Name | Default | Description |
|---|---|---|
| `image_name` | `` | Docker image to pull (e.g. `ghcr.io/org/app`). |
| `image_tag` | `latest` | Image tag to pull. |
| `registry` | `ghcr.io` | Container registry host. |
| `registry_username` | `` | Registry login username. |
| `registry_password` | `` | Registry login password or token. |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `deploy_target` | `argocd` | Deployment target: `argocd`, `cloud-run`, `helm`, or `ansible`. |
| `deploy_strategy` | `rolling` | Deployment strategy: `rolling`, `blue-green`, or `canary`. |
| `argocd_server` | `` | ArgoCD server URL. |
| `argocd_app` | `` | ArgoCD application name. |
| `argocd_token` | `` | ArgoCD authentication token. |
| `cloud_run_service` | `` | Cloud Run service name. |
| `cloud_run_region` | `us-central1` | Cloud Run region. |
| `cloud_run_image` | `` | Container image to deploy to Cloud Run. |
| `helm_release` | `` | Helm release name. |
| `helm_chart` | `` | Helm chart path or reference. |
| `helm_namespace` | `default` | Kubernetes namespace. |
| `ansible_playbook` | `` | Path to Ansible playbook. |
| `ansible_inventory` | `` | Path to Ansible inventory. |
| `log_file` | `pipery.jsonl` | Path to the JSONL structured log file. |
| `skip_download` | `false` | Skip the download step. |
| `skip_deploy` | `false` | Skip the deploy step. |
| `skip_status_check` | `false` | Skip the post-deploy status check. |

## Bitbucket Pipelines

Bitbucket Cloud pipelines support this deployment workflow. The equivalent configuration is in `bitbucket-pipelines.yml`.

### Quick Start

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure deployment targets and credentials in Repository Variables:
   - `ARGOCD_TOKEN` - ArgoCD authentication token
   - `ARGOCD_SERVER` - ArgoCD server URL
   - `GCLOUD_SERVICE_KEY_BASE64` - GCP service account key (for Cloud Run)
3. Set DEPLOY_TARGET variable (e.g., "argocd", "cloud-run", "helm")
4. Commit to trigger deployment

### Pipeline Stages

- checkout → setup → download → deploy → status_check → logs

### Deployment Targets

See `bitbucket-pipelines.yml` for supported deployment targets:
- **argocd**: ArgoCD-based Kubernetes deployment
- **cloud-run**: Google Cloud Run serverless
- **helm**: Kubernetes Helm charts
- **ansible**: Infrastructure automation

### Features

- Multi-target Docker image deployment
- Container registry authentication
- Deployment strategies: rolling, blue-green, canary
- Health checks and rollback support
- 90-day log retention

### Documentation

- See `bitbucket-pipelines.yml` for complete customization options
- Refer to [Bitbucket Pipelines Documentation](https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/) for detailed reference

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
