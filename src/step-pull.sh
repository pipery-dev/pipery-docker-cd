#!/usr/bin/env bash
set -euo pipefail

# Pipery Docker CD - Pull step
# Logs in to the container registry (if credentials provided) and pulls the image.

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

if [ -z "${INPUT_IMAGE_NAME:-}" ]; then
  echo "No image_name configured, skipping pull."
  exit 0
fi

if [ -n "${INPUT_REGISTRY_PASSWORD:-}" ]; then
  echo "${INPUT_REGISTRY_PASSWORD}" | psh -log-file "$LOG" -c "docker login ${INPUT_REGISTRY:-ghcr.io} -u ${INPUT_REGISTRY_USERNAME} --password-stdin"
fi

psh -log-file "$LOG" -c "docker pull ${INPUT_IMAGE_NAME}:${INPUT_IMAGE_TAG:-latest}"
