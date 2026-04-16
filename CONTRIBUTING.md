# Contributing

Contributions are welcome. Here's what's most useful:

## What to contribute

**New skills** — additional SKILL.md files for content types not
yet covered (Twitter/X threads, YouTube descriptions, newsletter
editions, TikTok scripts, podcast show notes).

**Platform adaptations** — skills tuned for different platforms
or content formats.

**Alternative scheduling** — GitHub Actions workflow, macOS
launchd plist, or Windows Task Scheduler instructions as
alternatives to cron.

**Integrations** — MCP connector examples for Notion, Airtable,
Slack, or other tools that fit content workflows.

**Bug fixes** — especially in the shell scripts across different
OS environments (macOS Intel vs Apple Silicon, Ubuntu, WSL).

## How to contribute

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-skill-name`
3. Make your changes
4. Test with `bash scripts/test-run.sh --dry-run`
5. Open a PR with a clear description of what you added and why

## Skill file standards

New SKILL.md files should follow the existing format:
- YAML frontmatter with `name`, `description`, trigger phrases
- Role definition (not a task executor — a named role)
- Trigger conditions table
- Workflow steps
- Output format template
- Quality gates checklist

## What not to contribute

- Personal brand configurations (these belong in your own fork)
- Vault contents or example posts
- Output files
- API keys or credentials of any kind
