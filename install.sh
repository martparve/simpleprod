#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing simpleprod..."
echo ""

# Add as local marketplace and install
claude plugins marketplace add "$SCRIPT_DIR" --scope user 2>/dev/null || true
claude plugins install simpleprod@simpleprod --scope user

echo ""
echo "simpleprod installed. Restart Claude Code to activate."
