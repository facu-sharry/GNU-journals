#!/bin/bash

set -euo pipefail

# --------------------------
# Configuration
# --------------------------
ENV_FILE="${ENV_FILE:-.env}"

# Export everything loaded from ENV_FILE so variables are available in this script.
if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
else
  echo "❌  Error: Env file not found (${ENV_FILE})."
  exit 1
fi

# Prefer specific keys from .env, fallback to already-exported generic names.
DEPLOY_PATH="${DEPLOY_PATH:-"/mnt/pc2/HDDBLUE/Backup"}"
ORIGIN_PATH="${ORIGIN_PATH:-"/mnt/HDD-GREEN-1TB"}"
RSYNC_INCLUDES="${RSYNC_INCLUDES:-""}"
RUN_ID="$(date '+%Y%m%d_%H%M%S')_$$"
LOG_DIR="${DEPLOY_PATH%/}/logs"
LOG_FILE="${LOG_DIR}/backup_${RUN_ID}.log"
STANDARD_OUTPUT_LOG_FILE="${LOG_DIR}/backup_stdout_${RUN_ID}.log"

# Convert to absolute paths
CURRENT_DIR=$(pwd)
ABS_ORIGIN_PATH=$(realpath "${ORIGIN_PATH}")

# --------------------------
# Validation
# --------------------------
if [ -z "$DEPLOY_PATH" ] || [ -z "$ORIGIN_PATH" ]; then
  echo "❌ Error: Missing required configuration!"
  exit 1
fi

if [ ! -d "$ABS_ORIGIN_PATH" ]; then
  echo "❌ Error: Origin path not found: ${ABS_ORIGIN_PATH}"
  exit 1
fi

mkdir -p "$LOG_DIR"

# --------------------------
# 0. Preview Changes (Dry Run)
# --------------------------
echo "🔍 Previewing changes (dry run)..."
rsync -avzt --inplace --delete-before --stats --progress --dry-run --log-file="$LOG_FILE" --exclude='/logs/***' "${RSYNC_INCLUDES[@]}" "$ABS_ORIGIN_PATH/" "$DEPLOY_PATH/"

echo ""
echo "⚠️  These are the files that WILL be modified/deleted."
echo ""

read -p "❓ Do you want to continue with deployment? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "❌ Deployment cancelled."
  exit 0
fi

# --------------------------
# 1. File Transfer
# --------------------------
echo "📤 Transferring files from ${ABS_ORIGIN_PATH} to ${DEPLOY_PATH}..."

rsync -avzt --inplace --delete-before --stats --progress --log-file="$LOG_FILE" --exclude='/logs/***' "${RSYNC_INCLUDES[@]}" "$ABS_ORIGIN_PATH/" "$DEPLOY_PATH/" > "$STANDARD_OUTPUT_LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
  echo "❌ File transfer failed!"
  exit 1
fi

echo "✅ Deployment completed successfully!"
exit 0