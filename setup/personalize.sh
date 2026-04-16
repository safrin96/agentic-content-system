#!/bin/bash

# ============================================================
# personalize.sh
# One-time setup: configures the content system for your brand
# Usage: bash setup/personalize.sh
# ============================================================

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo ""
echo "=============================================="
echo " Agentic Content System — Brand Setup"
echo "=============================================="
echo ""
echo "This script personalizes every file in the system"
echo "for your brand. It takes about 5 minutes."
echo ""
echo "You can re-run it any time to update your settings."
echo "Press Ctrl+C to cancel."
echo ""

# ── COLLECT INPUT ──────────────────────────────────────────

read -p "Your full name: " YOUR_NAME
read -p "Your job title (e.g. Senior Data Analyst & IT Program Manager): " YOUR_TITLE
read -p "Your company/org (or 'omit' to keep private): " YOUR_COMPANY
read -p "Your LinkedIn handle (without @): " LI_HANDLE
read -p "Your Instagram handle (without @): " IG_HANDLE
read -p "Your niche in one line (e.g. enterprise AI, data analytics, career growth): " YOUR_NICHE
read -p "Your target audience on LinkedIn (e.g. data practitioners, PMs, tech leaders): " LI_AUDIENCE
read -p "Your target audience on Instagram (e.g. aspiring analysts, early-career tech): " IG_AUDIENCE
read -p "Your timezone (e.g. {{YOUR_TZ}}, America/New_York, America/Los_Angeles): " YOUR_TZ
read -p "Primary production tool for carousels (e.g. {{DESIGN_TOOL}}, Canva): " DESIGN_TOOL

echo ""
echo "Now let's set up your 5 content pillars."
echo "Format: one short phrase each (e.g. 'Technical Deep Dives')"
echo ""
read -p "Pillar 1 — your core expertise topic: " P1
read -p "Pillar 2 — your industry/career insights angle: " P2
read -p "Pillar 3 — your personal story angle: " P3
read -p "Pillar 4 — your tools/practical angle: " P4
read -p "Pillar 5 — your career/authority-building angle: " P5

echo ""
echo "Voice preferences (press Enter to use defaults):"
read -p "One phrase you NEVER want to use (e.g. 'leverage'): " AVOID_WORD
read -p "One thing that defines your writing voice (e.g. 'direct and specific'): " VOICE_TRAIT

# ── CONFIRM ────────────────────────────────────────────────

echo ""
echo "=============================================="
echo " Review your settings:"
echo "=============================================="
echo "Name:         $YOUR_NAME"
echo "Title:        $YOUR_TITLE"
echo "Company:      $YOUR_COMPANY"
echo "LinkedIn:     @$LI_HANDLE"
echo "Instagram:    @$IG_HANDLE"
echo "Niche:        $YOUR_NICHE"
echo "Timezone:     $YOUR_TZ"
echo "Design tool:  $DESIGN_TOOL"
echo ""
echo "Pillars:"
echo "  P1: $P1"
echo "  P2: $P2"
echo "  P3: $P3"
echo "  P4: $P4"
echo "  P5: $P5"
echo ""
read -p "Apply these settings? (y/n): " CONFIRM
[ "$CONFIRM" != "y" ] && echo "Aborted — no changes made." && exit 0

# ── APPLY TO ALL FILES ─────────────────────────────────────

echo ""
echo "Applying to all files..."

# Function to do safe multi-replacement across a file
replace_in_file() {
  local file="$1"
  [ ! -f "$file" ] && return

  python3 - "$file" << PYEOF
import sys

filepath = sys.argv[1]
with open(filepath, 'r') as f:
    content = f.read()

replacements = {
    '{{YOUR_NAME}}':      '${YOUR_NAME}',
    '{{YOUR_TITLE}}':     '${YOUR_TITLE}',
    '{{YOUR_COMPANY}}':   '${YOUR_COMPANY}',
    '{{LI_HANDLE}}':      '@${LI_HANDLE}',
    '{{IG_HANDLE}}':      '@${IG_HANDLE}',
    '{{YOUR_NICHE}}':     '${YOUR_NICHE}',
    '{{LI_AUDIENCE}}':    '${LI_AUDIENCE}',
    '{{IG_AUDIENCE}}':    '${IG_AUDIENCE}',
    '{{YOUR_TZ}}':        '${YOUR_TZ}',
    '{{DESIGN_TOOL}}':    '${DESIGN_TOOL}',
    '{{P1}}':             '${P1}',
    '{{P2}}':             '${P2}',
    '{{P3}}':             '${P3}',
    '{{P4}}':             '${P4}',
    '{{P5}}':             '${P5}',
    '{{AVOID_WORD}}':     '${AVOID_WORD}',
    '{{VOICE_TRAIT}}':    '${VOICE_TRAIT}',
}

for placeholder, value in replacements.items():
    content = content.replace(placeholder, value)

with open(filepath, 'w') as f:
    f.write(content)
PYEOF
}

# Apply to all markdown and shell files
find "$PROJECT_DIR" \
  -not -path "*/output/*" \
  -not -path "*/.git/*" \
  -not -path "*/vault/posts/*" \
  -not -path "*/vault/media/*" \
  \( -name "*.md" -o -name "*.sh" \) | while read -r file; do
    replace_in_file "$file"
    echo "  ✓ $file"
done

# ── UPDATE CRON TIMEZONE ────────────────────────────────────

# Calculate UTC hour for 9 AM in given timezone using Python
UTC_HOUR=$(python3 -c "
from datetime import datetime
import pytz, sys
try:
    tz = pytz.timezone('${YOUR_TZ}')
    # Use a summer date to get standard offset behavior
    local = tz.localize(datetime(2026, 6, 1, 9, 0, 0))
    utc = local.utctimetuple()
    print(utc.tm_hour)
except Exception:
    print(15)  # fallback to {{TZ_ABBR}} if pytz unavailable
" 2>/dev/null || echo "15")

# Update the cron time in run-biweekly.sh
sed -i.bak "s|TZ={{YOUR_TZ}}|TZ=${YOUR_TZ}|g" "$PROJECT_DIR/scripts/run-biweekly.sh"
sed -i.bak "s|TZ={{YOUR_TZ}}|TZ=${YOUR_TZ}|g" "$PROJECT_DIR/scripts/setup-scheduler.sh"

echo ""
echo "  ✓ Timezone set to ${YOUR_TZ} (cron will fire at ${UTC_HOUR}:00 UTC = 9:00 AM local)"

# ── MAKE SCRIPTS EXECUTABLE ─────────────────────────────────

chmod +x "$PROJECT_DIR/scripts/"*.sh
echo "  ✓ Scripts made executable"

# ── DONE ───────────────────────────────────────────────────

echo ""
echo "=============================================="
echo " Setup complete!"
echo "=============================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Add your voice examples:"
echo "   open $PROJECT_DIR/reference/examples.md"
echo "   (Paste 3-5 of your best past posts — most important step)"
echo ""
echo "2. Test the system:"
echo "   bash scripts/test-run.sh --dry-run   # preview only"
echo "   bash scripts/test-run.sh             # full run"
echo ""
echo "3. Set up the biweekly scheduler:"
echo "   bash scripts/setup-scheduler.sh"
echo ""
echo "See SETUP.md for detailed instructions and troubleshooting."
echo ""
