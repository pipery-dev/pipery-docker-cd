# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-docker-cd/main/assets/icon.png" alt="Pipery Docker CD" width="28" align="center" /> Pipery Docker CD

Reusable GitHub Action for Docker CD — pull image, deploy, and verify — with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Docker%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-docker-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Deployment Targets](#deployment-targets)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

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

## Pipeline Overview

| Step | Description | Skip Input |
| --- | --- | --- |
| Download | Pull Docker image from registry | `skip_download` |
| Deploy | Deploy via ArgoCD, Cloud Run, Helm, or Ansible | `skip_deploy` |
| Status check | Verify deployment health | `skip_status_check` |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `image_name` | `` | Docker image to pull (e.g., `ghcr.io/org/app`). |
| `image_tag` | `latest` | Image tag to pull. |
| `registry` | `ghcr.io` | Container registry hostname. |
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

## Deployment Targets

### ArgoCD

Deploy to Kubernetes via ArgoCD. Automatically syncs and monitors the application.

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    image_tag: ${{ github.sha }}
    deploy_target: argocd
    argocd_server: argocd.example.com
    argocd_app: my-app
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Cloud Run

Deploy serverless containers to Google Cloud Run.

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    image_tag: ${{ github.sha }}
    deploy_target: cloud-run
    cloud_run_service: my-service
    cloud_run_region: us-central1
    cloud_run_image: gcr.io/project/service
```

### Helm

Deploy using Helm charts on Kubernetes clusters.

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    image_tag: ${{ github.sha }}
    deploy_target: helm
    helm_release: my-release
    helm_chart: ./helm/my-chart
    helm_namespace: production
```

### Ansible

Deploy to VMs or bare metal servers using Ansible playbooks.

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    deploy_target: ansible
    ansible_playbook: deploy.yml
    ansible_inventory: inventory/production
```

## Usage Examples

### Example 1: ArgoCD deployment

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

### Example 2: Cloud Run with custom region

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: gcr.io/my-project/my-service
    image_tag: ${{ github.sha }}
    deploy_target: cloud-run
    cloud_run_service: my-service
    cloud_run_region: europe-west1
```

### Example 3: Blue-green deployment strategy

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    image_tag: ${{ github.sha }}
    deploy_target: argocd
    deploy_strategy: blue-green
    argocd_server: argocd.example.com
    argocd_app: my-app
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

### Example 4: Helm with custom values

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    image_tag: ${{ github.sha }}
    deploy_target: helm
    helm_release: my-release
    helm_chart: bitnami/my-chart
    helm_namespace: production
```

### Example 5: Ansible deployment with custom inventory

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    deploy_target: ansible
    ansible_playbook: playbooks/deploy.yml
    ansible_inventory: inventories/production/hosts.yml
```

### Example 6: Skip status checks for faster deployment

```yaml
- uses: pipery-dev/pipery-docker-cd@v1
  with:
    image_name: ghcr.io/${{ github.repository }}
    image_tag: ${{ github.sha }}
    deploy_target: argocd
    argocd_server: argocd.example.com
    argocd_app: my-app
    skip_status_check: true
    argocd_token: ${{ secrets.ARGOCD_TOKEN }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-docker-cd/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `REGISTRY_PASSWORD` - Container registry authentication
- `ARGOCD_TOKEN` - ArgoCD authentication (if using ArgoCD)
- `GCLOUD_SERVICE_KEY_BASE64` - GCP service account key (if using Cloud Run)

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `REGISTRY_PASSWORD` - Container registry password
   - `ARGOCD_TOKEN` - ArgoCD token (if using ArgoCD)
   - `GCLOUD_SERVICE_KEY_BASE64` - GCP service account key (if using Cloud Run)
3. Set `DEPLOY_TARGET` variable (e.g., "argocd", "cloud-run", "helm", "ansible")
4. Commit to trigger deployment

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → download → deploy → status_check → logs

### Additional Deployment Targets

Support for:
- **ArgoCD**: Kubernetes GitOps deployments
- **Cloud Run**: Google Cloud Run serverless
- **Helm**: Kubernetes Helm charts
- **Ansible**: VMs and bare metal

### Features

- Multi-target Docker image deployment
- Container registry authentication
- Deployment strategies: rolling, blue-green, canary
- Health checks and rollback support
- JSONL-based pipeline logging
- 90-day log retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

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
