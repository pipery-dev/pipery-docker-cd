#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

# Record git commit SHA for deployment tracking
if git rev-parse HEAD > .git_commit_sha 2>/dev/null; then
  COMMIT_SHA=$(cat .git_commit_sha)
  printf '{"event":"checkout","status":"success","commit":"%s"}\n' "$COMMIT_SHA" >> "${LOG}"
else
  printf '{"event":"checkout","status":"warning","message":"git not available"}\n' >> "${LOG}"
fi
