#!/usr/bin/env bash
set -euo pipefail

# Pipery Docker CD - Deploy step
# Delegates to pipery-steps deploy with the configured target and strategy.

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

export ARGOCD_SERVER="${INPUT_ARGOCD_SERVER:-}"
export ARGOCD_APP="${INPUT_ARGOCD_APP:-}"
export ARGOCD_AUTH_TOKEN="${INPUT_ARGOCD_TOKEN:-}"

export CLOUD_RUN_SERVICE="${INPUT_CLOUD_RUN_SERVICE:-}"
export CLOUD_RUN_REGION="${INPUT_CLOUD_RUN_REGION:-us-central1}"
export CLOUD_RUN_IMAGE="${INPUT_CLOUD_RUN_IMAGE:-}"

export HELM_RELEASE="${INPUT_HELM_RELEASE:-}"
export HELM_CHART="${INPUT_HELM_CHART:-}"
export HELM_NAMESPACE="${INPUT_HELM_NAMESPACE:-default}"

export ANSIBLE_PLAYBOOK="${INPUT_ANSIBLE_PLAYBOOK:-}"
export ANSIBLE_INVENTORY="${INPUT_ANSIBLE_INVENTORY:-}"

TARGET="${INPUT_DEPLOY_TARGET:-argocd}"
STRATEGY="${INPUT_DEPLOY_STRATEGY:-rolling}"

echo "[step-deploy] Deploying via target=${TARGET} strategy=${STRATEGY}"

psh -log-file "$LOG" -fail-on-error -c "pipery-steps deploy --target ${TARGET} --strategy ${STRATEGY} --log-file ${LOG}"
