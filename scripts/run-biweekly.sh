#!/bin/bash

# ============================================================
# run-biweekly.sh
# {{YOUR_NAME}}'s Content Engine — Biweekly Automation Script
# Runs every OTHER Saturday at 9:00 AM (your timezone) via cron
# Produces content for the next 2 weeks on each run
# ============================================================

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs"
OUTPUT_DIR="$PROJECT_DIR/output"
COMMAND_FILE="$PROJECT_DIR/.claude/commands/run-content-engine.md"

mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# --- BIWEEKLY GATE ---
# Cron fires every Saturday but we only want to run every other one.
# We use ISO week number: run on even weeks, skip odd weeks.
# To flip which Saturday it runs on, change -eq 0 to -eq 1.
WEEK_NUMBER=$(TZ="{{YOUR_TZ}}" date +"%V")  # ISO week number (01–53)
if [ $(( WEEK_NUMBER % 2 )) -ne 0 ]; then
  echo "$(TZ="{{YOUR_TZ}}" date): Odd week ($WEEK_NUMBER) — skipping. Next run in 7 days." >> "$LOG_DIR/cron.log"
  exit 0
fi

# --- DATE CALCULATIONS ---
TODAY=$(TZ="{{YOUR_TZ}}" date +"%Y-%m-%d")
DAY_OF_WEEK=$(TZ="{{YOUR_TZ}}" date +"%u")  # 1=Mon … 6=Sat, 7=Sun

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

# --- OUTPUT FOLDERS ---
mkdir -p "$OUTPUT_DIR/week-1" "$OUTPUT_DIR/week-2" "$OUTPUT_DIR/research"

# --- LOG ---
LOG_FILE="$LOG_DIR/run-$TODAY.log"
echo "======================================" | tee -a "$LOG_FILE"
echo "Content Engine Run — $TODAY (Week $WEEK_NUMBER)" | tee -a "$LOG_FILE"
echo "Week 1: $WEEK1_START → $WEEK1_END" | tee -a "$LOG_FILE"
echo "Week 2: $WEEK2_START → $WEEK2_END" | tee -a "$LOG_FILE"
echo "Next run: in 14 days" | tee -a "$LOG_FILE"
echo "======================================" | tee -a "$LOG_FILE"

# --- BUILD PROMPT ---
PROMPT=$(cat "$COMMAND_FILE" | \
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
  sed "s/\$W2_SAT/$W2_SAT/g")

echo "Prompt built. Starting Claude Code..." | tee -a "$LOG_FILE"

# --- RUN ---
cd "$PROJECT_DIR"
claude --print --no-confirm -p "$PROMPT" 2>&1 | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "======================================" | tee -a "$LOG_FILE"
echo "Run complete: $(TZ="{{YOUR_TZ}}" date)" | tee -a "$LOG_FILE"
echo "Output: $OUTPUT_DIR" | tee -a "$LOG_FILE"
echo "======================================" | tee -a "$LOG_FILE"
