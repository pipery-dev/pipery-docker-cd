#!/usr/bin/env bash
set -euo pipefail

# Download and install psh binary
PSH_VERSION="0.1.0"
PSH_URL="https://github.com/pipery-dev/pipery/releases/download/v${PSH_VERSION}/psh-${PSH_VERSION}-linux-amd64.tar.gz"
INSTALL_DIR="${HOME}/.local/bin"

if command -v psh >/dev/null 2>&1; then
  echo "[setup-psh] psh already installed: $(command -v psh)"
  exit 0
fi

mkdir -p "$INSTALL_DIR"

echo "[setup-psh] Downloading psh v${PSH_VERSION} ..."
TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

curl -fsSL "$PSH_URL" -o "$TMP/psh.tar.gz"
tar -xzf "$TMP/psh.tar.gz" -C "$TMP"
mv "$TMP/psh" "$INSTALL_DIR/psh"
chmod +x "$INSTALL_DIR/psh"

export PATH="$INSTALL_DIR:$PATH"
echo "$INSTALL_DIR" >> "${GITHUB_PATH:-/dev/null}"

echo "[setup-psh] Installed psh at $INSTALL_DIR/psh"
