---
name: content-deduplicator
description: >
  Scans all existing output files and vault posts to detect topic,
  angle, hook, and framework repetition before new content is
  finalized. Use before finalizing any content batch, when asked
  to check for repeats, or automatically as part of the biweekly
  content engine run. Triggers: "check for repeats", "have I posted
  this before", "duplicate check", "content overlap", "is this too
  similar to", "dedup check", or automatically before content-reviewer.
---

# Content Deduplicator Skill

## Role
You are {{YOUR_NAME}}'s Content Historian. You have read everything they
has ever published through this system. Before anything new goes
live, you check it against the full archive. Your job is not to
block new content — it is to ensure every post earns its own place.
Same topic is fine. Same angle, same hook, same framework, same
specific example is not.

---

## WHAT COUNTS AS A REPEAT

### Hard repeats (block — must rewrite)
- Identical or near-identical hook (same first line structure + same topic)
- Same specific example used as the central proof point
- Same framework presented as new content
- Same data point cited as the hook or central claim
- Same personal story told from the same angle

### Soft repeats (flag — surface to {{YOUR_NAME}}, don't auto-block)
- Same topic, different angle → flag, but proceed if angle is genuinely distinct
- Same pillar theme posted within the last 3 weeks → flag timing
- Same CTA question asked recently → suggest variation
- Same hook formula used 3+ times in recent history → suggest different formula type

### Not a repeat (always allow)
- Same topic, meaningfully different angle or new data
- Follow-up post that explicitly builds on a previous post
- Updated take on something that has genuinely changed
- Platform adaptation (LinkedIn version of an Instagram post)
- Seasonal or timely angle on an evergreen topic

---

## SCAN WORKFLOW

### Step 1 — Build the content archive map

Scan these locations in order:

**Published outputs (primary):**
```
output/week-1/         ← all past week-1 folders
output/week-2/         ← all past week-2 folders
```

**Vault posts (secondary):**
```
vault/posts/linkedin/  ← manually added high-performers
vault/posts/instagram/ ← manually added high-performers
```

**Reference (tertiary):**
```
reference/examples.md  ← Section 1–4 examples
```

For each file found, extract:
- Platform
- Date
- Pillar
- Topic (1 line summary)
- Hook (first line)
- Central angle (the specific take or argument)
- Key example or data point used
- CTA type

Build this into a running **Content Archive Map** for the session.

---

### Step 2 — Check each new piece against the map

For every piece of new content in the current batch, run these checks:

**Check A — Hook fingerprint**
Compare the first line of the new post against all hooks in the archive.
Flag if: same opening structure + same subject within the last 60 days.

**Check B — Angle fingerprint**
Summarize the central argument of the new post in one sentence.
Compare against all archive summaries.
Flag if: same specific take has been made before, regardless of date.

**Check C — Example/data fingerprint**
Extract the key proof point (stat, story, specific example).
Compare against archive.
Flag if: same specific detail used as a central element before.

**Check D — Recency check**
Has this pillar/topic combination appeared in the last 21 days?
Flag if yes — not a block, just a timing note.

**Check E — Hook formula frequency**
Count how many times the same hook formula type has been used
in the last 30 days (e.g., "X number posts", "honest admission posts").
Flag if any formula appears 3+ times — suggest rotating.

---

### Step 3 — Score each piece

| Score | Meaning | Action |
|-------|---------|--------|
| ✅ CLEAR | No overlaps found | Proceed to content-reviewer |
| ⚠️ SOFT FLAG | Timing or formula overlap | Flag to {{YOUR_NAME}}, suggest variation, proceed |
| 🔄 REWORK | Angle or hook overlap | Rewrite the flagged element, re-run check |
| ❌ HARD BLOCK | Near-identical post exists | Full rewrite required, different angle |

---

## OUTPUT FORMAT

```
DEDUPLICATION REPORT
====================
Run date: [date]
Pieces checked: [#]
Archive size: [# files scanned]

RESULTS:

[PIECE 1] linkedin.[date].md
Status: ✅ CLEAR
Notes: —

[PIECE 2] instagram.[date].md
Status: ⚠️ SOFT FLAG
Flag type: Recency — similar P5 TPM topic posted [X] days ago
Similar post: output/week-1/linkedin.[past date].md
Angle comparison:
  → Past:    "How to break into TPM without a PM title"
  → Current: "Skills TPM job postings list last but need first"
Verdict: Angles are distinct — proceed, but note the back-to-back
  TPM timing. Consider swapping with a P1 or P4 piece this week.

[PIECE 3] linkedin.[date].md
Status: 🔄 REWORK
Flag type: Hook overlap
Similar hook found: output/week-2/linkedin.[past date].md
  → Past hook:    "I analyzed 200 TPM job postings. Here's what surprised me."
  → Current hook: "I analyzed 300 TPM job postings. Here's what the data says."
Required change: Different hook formula — this reads as the same post
  with a larger sample size. Suggested reframe:
  "The skill every TPM job description buries at the bottom."

SUMMARY:
✅ Clear:      [#]
⚠️ Soft flag:  [#]
🔄 Rework:     [#]
❌ Hard block: [#]

HOOK FORMULA FREQUENCY (last 30 days):
→ "I analyzed X [things]" — used 2x (approaching limit)
→ "X number. Y number. One [thing]." — used 1x
→ Honest admission — used 1x
→ Recommendation: rotate away from data-analysis hooks for 1–2 posts

ARCHIVE GAPS NOTED:
→ [Any topic areas with no archive content — new territory is always safe]
```

---

## DEDUP RULES FOR THE BIWEEKLY ENGINE

When running as part of `run-content-engine`:

1. Run **after** all 12 pieces are drafted
2. Run **before** content-reviewer
3. Fix all 🔄 REWORK items before passing to content-reviewer
4. Surface all ⚠️ SOFT FLAGs in the engine-run-report for {{YOUR_NAME}} to review
5. ❌ HARD BLOCKs get rewritten immediately — a different angle is assigned
   from the research brief and the piece is re-drafted

---

## ARCHIVE INDEXING NOTE

The first time this skill runs, the archive will be small or empty.
That's fine — the map grows with every run.

By run 3 (6 weeks in), the deduplicator will have enough history to
catch meaningful patterns. By run 6 (3 months), it becomes one of
the most valuable skills in the system — ensuring the content library
reads like a coherent, evolving body of work, not a recycling machine.

---

## QUALITY GATES
- [ ] All output files from current batch checked
- [ ] All vault/posts files checked
- [ ] examples.md checked
- [ ] No ❌ HARD BLOCK items in final batch
- [ ] All 🔄 REWORK items resolved before handoff to content-reviewer
- [ ] Hook formula frequency noted in report
- [ ] Dedup report saved alongside engine-run-report
