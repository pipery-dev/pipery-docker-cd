#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

if [ -z "${INPUT_IMAGE_NAME:-}" ]; then
  echo "No image_name configured, skipping pull."
  exit 0
fi

if [ -n "${INPUT_REGISTRY_PASSWORD:-}" ]; then
  echo "${INPUT_REGISTRY_PASSWORD}" | docker login "${INPUT_REGISTRY:-ghcr.io}" -u "${INPUT_REGISTRY_USERNAME:-}" --password-stdin
fi

docker pull "${INPUT_IMAGE_NAME}:${INPUT_IMAGE_TAG:-latest}"
