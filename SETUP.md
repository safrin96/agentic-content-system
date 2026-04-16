# SETUP GUIDE — Content Engine
## How to fire up the full system in Claude Code

---

## PREREQUISITES

Before anything runs, you need:

1. **Claude Code installed**
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
   Docs: https://docs.claude.com/en/docs/claude-code

2. **Authenticated with Anthropic**
   ```bash
   claude auth login
   ```

3. **Your folder structure confirmed:**
   ```
   ~/claude/          ← or wherever your Claude folder lives
   ├── CLAUDE.md
   ├── reference/
   │   ├── examples.md
   │   ├── content-pillars.md
   │   ├── voice-rules.md
   │   ├── platform-rules.md
   │   └── brand-guidelines.md
   ├── .claude/
   │   ├── skills/       ← all 13 SKILL.md files
   │   └── commands/
   │       └── run-content-engine.md
   ├── scripts/
   │   ├── run-bibiweekly.sh
   │   ├── setup-scheduler.sh
   │   ├── remove-scheduler.sh
   │   └── test-run.sh
   ├── output/           ← auto-created on first run
   └── logs/             ← auto-created on first run
   ```

---

## STEP 1 — MAKE SCRIPTS EXECUTABLE

Run this once after downloading:

```bash
cd ~/claude
chmod +x scripts/run-bibiweekly.sh
chmod +x scripts/setup-scheduler.sh
chmod +x scripts/remove-scheduler.sh
chmod +x scripts/test-run.sh
```

---

## STEP 2 — TEST IT MANUALLY FIRST

**Dry run (shows the resolved prompt, no Claude call):**
```bash
bash scripts/test-run.sh --dry-run
```
→ This prints the full prompt with all dates substituted.
→ Verify the dates look right before running for real.

**Full test run (runs Claude Code right now):**
```bash
bash scripts/test-run.sh
```
→ This is identical to the Saturday run — same script, same prompt.
→ Do this at least once before setting up the scheduler.
→ Outputs will appear in `output/week-1/` and `output/week-2/`

---

## STEP 3 — REVIEW THE FIRST OUTPUT

After the test run completes, check:

```bash
ls output/week-1/
ls output/week-2/
cat output/week-1/linkedin.YYYY-MM-DD.md   # replace with actual date
```

**What to look for:**
- [ ] Files are named `[platform].[date].md`
- [ ] Each file has all sections (caption, pinned comment, visual brief, etc.)
- [ ] Status shows `READY TO PUBLISH`
- [ ] Content sounds like you, not like AI filler
- [ ] No em dashes anywhere
- [ ] Voice matches examples.md samples

If something looks off, add more examples to `reference/examples.md` and run again.
The more examples you give it, the sharper the output gets.

---

## STEP 4 — SET UP THE SATURDAY SCHEDULER

Once you're happy with the output quality:

```bash
bash scripts/setup-scheduler.sh
```

This installs a cron job that runs every **Saturday at 9:00 AM (your timezone)**.

**Confirm it's installed:**
```bash
crontab -l
```

You should see something like:
```
0 15 * * 6 TZ={{YOUR_TZ}} /Users/yourname/claude/scripts/run-bibiweekly.sh >> /Users/yourname/claude/logs/cron.log 2>&1
```

Note: `15:00 UTC = 9:00 AM (your timezone)` ({{TIMEZONE_FULL}} is UTC−6)
When {{TZ_ABBR}} ends (November), update this to `16:00 UTC` for MST (UTC−7).

---

## STEP 5 — OPEN THE PROJECT IN CLAUDE CODE

For interactive use (writing one-off posts, editing content, running
individual skills manually):

```bash
cd ~/claude
claude
```

Then use slash commands:
```
/run-content-engine     ← runs the full 2-week engine manually
```

Or talk to it naturally:
```
Research trending AI topics for a Pillar 2 post this week
Write a LinkedIn caption about DAX calculated columns vs measures
Run a voice audit on this draft: [paste]
Is this post ready to publish?
```

---

## ONGOING MAINTENANCE

### After each Saturday run:
1. Open `output/week-1/` and `output/week-2/`
2. Review all files — make any edits directly in the markdown
3. When ready to publish, copy the caption from the file, post it,
   then immediately paste the pinned comment

### Once a month:
- Add your best-performing posts to `reference/examples.md`
- Add approved Claude outputs to Section 8 of examples.md
- The system gets better every time you add to examples.md

### When {{TZ_ABBR}} → MST (first Sunday in November):
- Update the cron job: change `15` to `16` for UTC
- Or just re-run `bash scripts/setup-scheduler.sh` — it will ask to replace

---

## OUTPUT FOLDER STRUCTURE AFTER A RUN

```
output/
├── content-plan.2026-04-12.md       ← full 2-week schedule
├── research/
│   └── research-brief.2026-04-12.md ← research brief used
├── engine-run-report.2026-04-12.md  ← summary of the run
├── week-1/
│   ├── linkedin.2026-04-14.md       ← Monday LinkedIn post
│   ├── instagram.2026-04-15.md      ← Tuesday Instagram Reel
│   ├── linkedin.2026-04-16.md       ← Wednesday LinkedIn Carousel
│   ├── instagram.2026-04-17.md      ← Thursday Instagram Carousel
│   ├── linkedin.2026-04-18.md       ← Friday LinkedIn Story
│   └── instagram.2026-04-19.md      ← Saturday Instagram Reel
└── week-2/
    ├── linkedin.2026-04-21.md
    ├── instagram.2026-04-22.md
    ├── linkedin.2026-04-23.md
    ├── instagram.2026-04-24.md
    ├── linkedin.2026-04-25.md
    └── instagram.2026-04-26.md
```

---

## TROUBLESHOOTING

**"claude: command not found" in cron**
The cron environment doesn't inherit your PATH. Fix:
```bash
# Open crontab
crontab -e

# Replace the cron line with the full path to claude:
0 15 * * 6 TZ={{YOUR_TZ}} /full/path/to/claude --print --no-confirm -p "..." >> ~/claude/logs/cron.log 2>&1

# Find the full path:
which claude
```

**Output files are empty or missing**
- Check `logs/cron.log` for errors
- Run `bash scripts/test-run.sh` manually to see the full output
- Make sure `claude auth login` is still active (tokens expire)

**Content doesn't sound like me**
- Add more examples to `reference/examples.md` → Section 1 and 8
- The breakout February post especially — add that one first

**Cron runs but nothing happens on macOS**
macOS requires granting cron Full Disk Access:
System Settings → Privacy & Security → Full Disk Access → add `/usr/sbin/cron`

**On Windows (WSL)**
Cron works the same inside WSL. Make sure WSL is running when
Saturday 9 AM hits, or use Windows Task Scheduler instead:
- Action: `wsl bash /home/yourname/claude/scripts/run-bibiweekly.sh`
- Trigger: Weekly, Saturday, 9:00 AM
