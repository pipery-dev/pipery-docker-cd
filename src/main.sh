#!/usr/bin/env bash
set -euo pipefail

# Pipery Docker CD - Main orchestrator
# When run directly (e.g. via pipery-actions test), this script runs all CD steps
# in sequence and writes the final success log entry.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
LOG="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"

# Validate project path
if [ ! -d "$PROJECT_PATH" ]; then
  echo "[pipery-docker-cd] ERROR: project path does not exist: $PROJECT_PATH" >&2
  exit 1
fi

mkdir -p "$(dirname "$LOG")"

# Step: setup psh (always)
  # In test mode use a bash wrapper for psh; the real psh binary has a Go runtime
  # incompatibility (newosproc) with the GitHub Actions runner seccomp profile.
  mkdir -p /tmp/pipery-test-bin
  printf '#!/bin/bash\nexec bash "$@"\n' > /tmp/pipery-test-bin/psh
  chmod +x /tmp/pipery-test-bin/psh
  export PATH="/tmp/pipery-test-bin:$PATH"

# Step: pull image
if [ "${INPUT_SKIP_PULL:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-pull.sh"
else
  echo "[pipery-docker-cd] Skipping pull step."
fi

# Step: deploy
if [ "${INPUT_SKIP_DEPLOY:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-deploy.sh"
else
  echo "[pipery-docker-cd] Skipping deploy step."
fi

# Step: status check
if [ "${INPUT_SKIP_STATUS_CHECK:-false}" != "true" ]; then
  "$SCRIPT_DIR/step-status.sh"
else
  echo "[pipery-docker-cd] Skipping status check step."
fi

# Final success log entry (always written)
printf '{"event":"build","status":"success","project":"docker","mode":"cd"}\n' >> "${INPUT_LOG_FILE:-pipery.jsonl}"

echo "[pipery-docker-cd] CD pipeline completed for: ${PROJECT_PATH}"
