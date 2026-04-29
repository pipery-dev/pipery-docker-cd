#!/usr/bin/env psh
set -euo pipefail

# shellcheck disable=SC2034
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
TARGET="${INPUT_DEPLOY_TARGET:-argocd}"

echo "[step-status] Checking deployment status for target=${TARGET}"

case "$TARGET" in
  argocd)
    if ! command -v argocd >/dev/null 2>&1; then
      echo "[step-status] argocd CLI not installed; skipping status check."
      exit 0
    fi
    APP="${INPUT_ARGOCD_APP:-}"
    if [ -z "$APP" ]; then
      echo "[step-status] argocd_app not configured; skipping status check."
      exit 0
    fi
    SERVER_ARGS=()
    [ -n "${INPUT_ARGOCD_SERVER:-}" ] && SERVER_ARGS=(--server "${INPUT_ARGOCD_SERVER}")
    ARGOCD_AUTH_TOKEN="${INPUT_ARGOCD_TOKEN:-}" argocd app get "${APP}" "${SERVER_ARGS[@]}"
    ;;
  helm)
    if ! command -v helm >/dev/null 2>&1; then
      echo "[step-status] helm not installed; skipping status check."
      exit 0
    fi
    RELEASE="${INPUT_HELM_RELEASE:-}"
    NS="${INPUT_HELM_NAMESPACE:-default}"
    if [ -z "$RELEASE" ]; then
      echo "[step-status] helm_release not configured; skipping status check."
      exit 0
    fi
    helm status "${RELEASE}" --namespace "${NS}"
    ;;
  cloud-run)
    if ! command -v gcloud >/dev/null 2>&1; then
      echo "[step-status] gcloud CLI not installed; skipping status check."
      exit 0
    fi
    SERVICE="${INPUT_CLOUD_RUN_SERVICE:-}"
    REGION="${INPUT_CLOUD_RUN_REGION:-us-central1}"
    if [ -z "$SERVICE" ]; then
      echo "[step-status] cloud_run_service not configured; skipping status check."
      exit 0
    fi
    gcloud run services describe "${SERVICE}" --region "${REGION}" --format=yaml
    ;;
  ansible)
    echo "[step-status] Ansible deployments do not expose a post-deploy status endpoint; skipping."
    ;;
  *)
    echo "[step-status] Unknown deploy target: ${TARGET}; skipping status check."
    ;;
esac
