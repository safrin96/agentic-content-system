#!/bin/bash

# ============================================================
# setup-scheduler.sh
# Installs the biweekly Saturday 9 AM {{TZ_ABBR}} cron job
# Usage: bash scripts/setup-scheduler.sh
# ============================================================

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$PROJECT_DIR/scripts/run-biweekly.sh"

chmod +x "$SCRIPT"

echo ""
echo "Setting up biweekly content engine scheduler..."
echo "Script: $SCRIPT"
echo ""

if ! command -v claude &> /dev/null; then
  echo "ERROR: 'claude' command not found."
  echo "Install Claude Code: https://docs.claude.com/en/docs/claude-code"
  exit 1
fi
echo "✓ Claude Code: $(which claude)"

# Check for existing entry
EXISTING=$(crontab -l 2>/dev/null | grep "run-biweekly.sh" || true)
if [ -n "$EXISTING" ]; then
  echo ""
  echo "Existing cron job found:"
  echo "$EXISTING"
  echo ""
  read -p "Replace it? (y/n): " CONFIRM
  [ "$CONFIRM" != "y" ] && echo "Aborted." && exit 0
fi

# Cron fires every Saturday at 15:00 UTC (9:00 AM (your timezone)).
# The script itself gates on even/odd week number — only runs on even weeks.
CRON_ENTRY="0 15 * * 6 TZ={{YOUR_TZ}} $SCRIPT >> $PROJECT_DIR/logs/cron.log 2>&1"

(crontab -l 2>/dev/null | grep -v "run-biweekly.sh"; echo "$CRON_ENTRY") | crontab -

echo ""
echo "✓ Cron job installed (fires every Saturday, runs every other Saturday):"
echo "  $CRON_ENTRY"
echo ""
echo "How the biweekly logic works:"
echo "  Cron fires every Saturday at 9 AM {{TZ_ABBR}}."
echo "  run-biweekly.sh checks the ISO week number."
echo "  Even week → runs. Odd week → skips and logs 'skipping'."
echo "  Net effect: runs every 14 days."
echo ""

# Tell the user which Saturday it will first run on
WEEK_NOW=$(TZ="{{YOUR_TZ}}" date +"%V" | sed 's/^0//')
if [ $(( WEEK_NOW % 2 )) -eq 0 ]; then
  NEXT_RUN="this Saturday (week $WEEK_NOW is even → RUN)"
else
  NEXT_RUN="the Saturday after next (week $WEEK_NOW is odd → SKIP, then week $(( WEEK_NOW + 1 )) → RUN)"
fi
echo "First scheduled run: $NEXT_RUN"
echo ""
echo "To flip which Saturdays it runs on, edit run-biweekly.sh:"
echo "  Change:  [ \$(( WEEK_NUMBER % 2 )) -ne 0 ]"
echo "  To:      [ \$(( WEEK_NUMBER % 2 )) -eq 0 ]"
echo ""
echo "To test right now: bash scripts/test-run.sh"
echo "To remove:         bash scripts/remove-scheduler.sh"
