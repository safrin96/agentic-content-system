#!/bin/bash

# ============================================================
# remove-scheduler.sh
# Removes the content engine cron job
# Usage: bash scripts/remove-scheduler.sh
# ============================================================

EXISTING=$(crontab -l 2>/dev/null | grep "run-biweekly.sh" || true)

if [ -z "$EXISTING" ]; then
  echo "No content engine cron job found. Nothing to remove."
  exit 0
fi

echo "Found cron job:"
echo "$EXISTING"
echo ""
read -p "Remove it? (y/n): " CONFIRM

if [ "$CONFIRM" = "y" ]; then
  crontab -l 2>/dev/null | grep -v "run-biweekly.sh" | crontab -
  echo "✓ Cron job removed."
else
  echo "Aborted."
fi
