# Agentic Content System for Claude Code

A complete, production-ready content strategy and creation system
built on Claude Code. Drop it into any project, personalize in
5 minutes, and run a fully automated biweekly content engine
for LinkedIn and Instagram.

---

## What This Is

This is not a prompt. It is a **system** — a set of roles, skills,
reference files, and automation scripts that turns Claude Code into
an in-house Senior Content Strategist and Editor for your brand.

**What it does:**
- Runs every other Saturday at 9 AM (your timezone) via cron
- Researches trending topics in your niche from your chosen sources
- Produces 12 ready-to-publish pieces (6 per week, 2 weeks ahead)
- Runs every piece through a 6-pass adversarial Refinement Protocol
- Checks every claim against a fact-verifier before saving
- Scans your full content history to block topic and hook repetition
- Outputs files named `[platform].[date].md` into organized week folders
- Builds from a growing Knowledge Vault that compounds over time

**What you get out of the box:**
- 1 master `CLAUDE.md` with a Senior Content Strategist role definition
- 16 specialized skills (research, writing, hooks, thumbnails, fact-check, and more)
- 5 reference files (pillars, voice rules, platform specs, brand guidelines, examples)
- A Knowledge Vault folder structure for posts, photos, PDFs, research
- A content deduplicator that reads your full archive before writing anything new
- 4 shell scripts (biweekly runner, scheduler setup, test run, remove)
- A `personalize.sh` setup script that configures everything for your brand

---

## The 6-Pass Refinement Protocol

Every piece of content runs through six adversarial passes before
it can be saved:

| Pass | Role | What It Checks |
|------|------|----------------|
| 1 | The Skeptic | Generic content, missing specifics, weak hook |
| 2 | The Expert | Technical accuracy, oversimplification |
| 3 | The Scroller | Hook strength, text density, mobile readability |
| 4 | The Competitor | Differentiation, unique angle, personal layer |
| 5 | The Editor | Forbidden phrases, formatting, CTA quality |
| 6 | Thumbnail | Visual brief, 6-word max text, hook test |

---

## Content Pillars (Template Defaults)

The system ships with 5 placeholder pillars. You replace them
with your own during `personalize.sh`.

The architecture is designed around:
- 2 expertise/technical pillars (builds credibility)
- 1 personal story pillar (builds reach)
- 1 tools/practical pillar (builds utility)
- 1 career/industry pillar (builds authority + recruiter visibility)

---

## Folder Structure

```
your-content-system/
├── CLAUDE.md                         ← Master role + Refinement Protocol
├── README.md                         ← This file
├── SETUP.md                          ← Detailed setup guide
├── .gitignore                        ← Protects your personal vault contents
├── setup/
│   └── personalize.sh                ← Run once to configure for your brand
├── vault/
│   ├── INDEX.md                      ← Knowledge vault navigator
│   ├── posts/linkedin/               ← Your best LinkedIn posts
│   ├── posts/instagram/              ← Your best Instagram posts
│   ├── references/pdfs/              ← Frameworks, guides, whitepapers
│   ├── references/articles/          ← Saved articles and newsletters
│   ├── media/photos/                 ← Photos for content use
│   ├── media/videos/                 ← B-roll notes
│   └── research/                     ← Job analyses, trends, competitor snapshots
├── reference/
│   ├── examples.md                   ← Voice calibration (fill with your posts)
│   ├── content-pillars.md            ← Your 5 content pillars
│   ├── voice-rules.md                ← Your voice, avoid-list, CTA patterns
│   ├── platform-rules.md             ← LinkedIn + Instagram format specs
│   └── brand-guidelines.md           ← Visual identity, audience personas
├── .claude/
│   ├── commands/
│   │   └── run-content-engine.md     ← Biweekly engine orchestrator
│   └── skills/                       ← 16 specialized skill files
│       ├── content-research/
│       ├── content-deduplicator/
│       ├── instagram-competitot-research/
│       ├── presentation-content/
│       ├── linkedin-article-writer/
│       ├── instagram-reel-script/
│       ├── caption-writer/
│       ├── reference-verifier/
│       ├── pinned-comment-writer/
│       ├── hook-cta-writer/
│       ├── thumbnail-brief/
│       ├── stock-photo-finder/
│       ├── content-project-manager/
│       ├── brand-voice-manager/
│       └── content-reviewer/
│       └── visual-competitor-analysis/
├── scripts/
│   ├── run-biweekly.sh               ← The engine (biweekly gate built in)
│   ├── setup-scheduler.sh            ← Installs the cron job
│   ├── remove-scheduler.sh           ← Removes the cron job
│   └── test-run.sh                   ← Manual test run (--dry-run supported)
└── output/                           ← Auto-created. Never committed to git.
```

---

## Quick Start

### 1. Prerequisites
```bash
# Claude Code
npm install -g @anthropic-ai/claude-code
claude auth login
```

### 2. Clone and personalize
```bash
git clone https://github.com/[YOUR-USERNAME]/agentic-content-system
cd agentic-content-system
bash setup/personalize.sh
```

`personalize.sh` asks you 10 questions about your brand, role,
audience, voice rules, and content pillars — then rewrites every
file in the system for you. Takes about 5 minutes.

### 3. Fill in your voice examples
Open `reference/examples.md` and paste in 3–5 of your best
past posts. This is the single highest-leverage thing you can
do before the first run. The more examples you add, the more
the system sounds like you.

### 4. Test run
```bash
chmod +x scripts/*.sh
bash scripts/test-run.sh --dry-run   # preview dates only
bash scripts/test-run.sh             # full real run
```

### 5. Set up the biweekly scheduler
```bash
bash scripts/setup-scheduler.sh
```

---

## The Knowledge Vault

The vault is a living library that compounds over time.

Every run, Claude reads `vault/INDEX.md` first to understand what
assets exist. As you add to it, outputs get more personalized:

- **Add a post that performed well** → future posts calibrate to that voice
- **Add a photo** → Claude starts suggesting specific photos in visual briefs
- **Add a job posting analysis** → data-driven career posts get real numbers
- **Add a PDF or article** → content draws from your reference materials

The vault is excluded from git (see `.gitignore`). It stays local.

---

## Connecting External Sources

The system supports MCP connectors for richer research. Add them
to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "gmail": {
      "type": "url",
      "url": "https://gmail.mcp.claude.com/mcp"
    }
  }
}
```

Supported: Gmail (for newsletters like TLDR), any MCP-compatible
connector your Claude account has access to.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

Issues and PRs welcome — especially:
- Additional skill files for other content types
- Platform-specific adaptations (Twitter/X, TikTok, YouTube)
- Alternative scheduling approaches (GitHub Actions, launchd)
- Notion / Airtable integration improvements

---

## License

MIT — use it, fork it, build on it.

---

## Built By

Originally built for a Senior IT Program Manager and BI Analyst
building a personal brand in enterprise AI adoption, data analytics,
and immigrant-in-tech storytelling.

Generalized into this template so anyone can run the same system
for their own niche and voice.
