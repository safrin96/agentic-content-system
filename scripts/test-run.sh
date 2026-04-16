#!/bin/bash

# ============================================================
# test-run.sh
# Run the content engine manually right now (no cron needed)
# Usage: bash scripts/test-run.sh
# Optional: bash scripts/test-run.sh --dry-run  (shows prompt only)
# ============================================================

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMAND_FILE="$PROJECT_DIR/.claude/commands/run-content-engine.md"

DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
fi

# --- DATE CALCULATIONS (same logic as run-biweekly.sh) ---
TODAY=$(TZ="{{YOUR_TZ}}" date +"%Y-%m-%d")
DAY_OF_WEEK=$(TZ="{{YOUR_TZ}}" date +"%u")

DAYS_UNTIL_MON=$(( (8 - DAY_OF_WEEK) % 7 ))
[ "$DAYS_UNTIL_MON" -eq 0 ] && DAYS_UNTIL_MON=7

WEEK1_START=$(TZ="{{YOUR_TZ}}" date -d "+${DAYS_UNTIL_MON} days" +"%Y-%m-%d")
W1_MON=$WEEK1_START
W1_TUE=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 1 )) days" +"%Y-%m-%d")
W1_WED=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 2 )) days" +"%Y-%m-%d")
W1_THU=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 3 )) days" +"%Y-%m-%d")
W1_FRI=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 4 )) days" +"%Y-%m-%d")
W1_SAT=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 5 )) days" +"%Y-%m-%d")
WEEK1_END=$W1_SAT

WEEK2_START=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 7 )) days" +"%Y-%m-%d")
W2_MON=$WEEK2_START
W2_TUE=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 8 )) days" +"%Y-%m-%d")
W2_WED=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 9 )) days" +"%Y-%m-%d")
W2_THU=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 10 )) days" +"%Y-%m-%d")
W2_FRI=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 11 )) days" +"%Y-%m-%d")
W2_SAT=$(TZ="{{YOUR_TZ}}" date -d "+$(( DAYS_UNTIL_MON + 12 )) days" +"%Y-%m-%d")
WEEK2_END=$W2_SAT

echo ""
echo "======================================="
echo "Content Engine — Test Run"
echo "======================================="
echo "Today:  $TODAY"
echo "Week 1: $WEEK1_START → $WEEK1_END"
echo "        Mon $W1_MON | Tue $W1_TUE | Wed $W1_WED"
echo "        Thu $W1_THU | Fri $W1_FRI | Sat $W1_SAT"
echo "Week 2: $WEEK2_START → $WEEK2_END"
echo "        Mon $W2_MON | Tue $W2_TUE | Wed $W2_WED"
echo "        Thu $W2_THU | Fri $W2_FRI | Sat $W2_SAT"
echo "======================================="
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "--- DRY RUN MODE: Showing resolved prompt only ---"
  echo ""
  cat "$COMMAND_FILE" | \
    sed "s/\$TODAY/$TODAY/g" | \
    sed "s/\$WEEK1_START/$WEEK1_START/g" | \
    sed "s/\$WEEK1_END/$WEEK1_END/g" | \
    sed "s/\$WEEK2_START/$WEEK2_START/g" | \
    sed "s/\$WEEK2_END/$WEEK2_END/g" | \
    sed "s/\$W1_MON/$W1_MON/g" | \
    sed "s/\$W1_TUE/$W1_TUE/g" | \
    sed "s/\$W1_WED/$W1_WED/g" | \
    sed "s/\$W1_THU/$W1_THU/g" | \
    sed "s/\$W1_FRI/$W1_FRI/g" | \
    sed "s/\$W1_SAT/$W1_SAT/g" | \
    sed "s/\$W2_MON/$W2_MON/g" | \
    sed "s/\$W2_TUE/$W2_TUE/g" | \
    sed "s/\$W2_WED/$W2_WED/g" | \
    sed "s/\$W2_THU/$W2_THU/g" | \
    sed "s/\$W2_FRI/$W2_FRI/g" | \
    sed "s/\$W2_SAT/$W2_SAT/g"
  echo ""
  echo "--- End of dry run ---"
  exit 0
fi

echo "Starting Claude Code now..."
echo ""

# Run the actual engine
bash "$(dirname "${BASH_SOURCE[0]}")/run-biweekly.sh"
