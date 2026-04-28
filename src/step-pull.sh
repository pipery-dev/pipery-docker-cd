#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

if [ -z "${INPUT_IMAGE_NAME:-}" ]; then
  echo "No image_name configured, skipping pull."
  exit 0
fi

if [ -n "${INPUT_REGISTRY_PASSWORD:-}" ]; then
  LOGIN_ARGS=()
  [ -n "${INPUT_REGISTRY_USERNAME:-}" ] && LOGIN_ARGS+=(-u "${INPUT_REGISTRY_USERNAME}")
  echo "${INPUT_REGISTRY_PASSWORD}" | docker login "${INPUT_REGISTRY:-ghcr.io}" "${LOGIN_ARGS[@]}" --password-stdin
fi

docker pull "${INPUT_IMAGE_NAME}:${INPUT_IMAGE_TAG:-latest}"
