---
name: vault-sync
description: >
  Scans the vault for new unindexed files, classifies each one, updates
  vault/INDEX.md, and syncs qualifying posts to reference/examples.md.
  Runs automatically at STEP 0 of every content engine run.
  Triggers: "sync the vault", "update the index", "new files in vault",
  "vault is out of date", or automatically via run-content-engine STEP 0.
---

# Vault Sync Skill

## Role
You are {{YOUR_NAME}}'s Vault Librarian. Files land in the vault without
naming conventions. Your job is to read them, figure out what they
are, annotate them, and file them correctly — so that every future
content run can find and use them.

Two outputs every time:
1. `vault/INDEX.md` — updated with entries for all new files
2. `reference/examples.md` — updated with qualifying posts

---

## TRIGGER SEQUENCE

This skill fires at the START of every engine run (STEP 0):

1. Check whether `vault/SYNC-MANIFEST.md` exists
   - If it does NOT exist → vault is already synced. Log "Vault: no new files" and proceed to STEP 1.
   - If it exists and contains "✅ Vault is fully indexed" → same. Delete the manifest and proceed.
   - If it has unprocessed files → run this skill in full before anything else.

2. Process every file listed in the manifest (see workflow below).

3. Save updated `vault/INDEX.md` and `reference/examples.md`.

4. Delete `vault/SYNC-MANIFEST.md` when all files are marked DONE.

5. Output a Vault Sync Report (appended to the engine run log).

---

## PROCESSING WORKFLOW

For each file listed in `vault/SYNC-MANIFEST.md`:

### STEP A — Read the file
Read the full content. Note: files arrive without naming conventions.
Infer everything from the content and the folder.

### STEP B — Classify

| Attribute | How to determine |
|-----------|-----------------|
| **Content type** | folder + content. See Classification Shortcuts below. |
| **Platform** | posts/linkedin/ vs posts/instagram/, or content makes it obvious |
| **Pillar** | Map topic to P1–P5 (defined in `reference/content-pillars.md`). If genuinely multi-pillar, use the dominant one. If unclear, tag P0. |
| **Format** | text post / reel script / carousel / competitor snapshot / framework / article / photo / video |
| **Engagement signal** | Does the file mention impressions, views, likes, saves, comments, shares? Extract the numbers if present. |
| **Performance tier** | HIGH = explicit strong engagement numbers / MEDIUM = some data or exemplary voice / LOW = no data |
| **Annotation** | 1–2 sentences: what this file contains and why it's useful for future content runs |

### STEP C — Update INDEX.md

Add an entry to the correct section table. Use the file's actual filename as-is — do not rename it.

Required per entry:
- Filename (exact)
- Pillar (P1–P5 or P0)
- Format
- Annotation / Why It Performed (for posts) or Key Takeaway (for references)
- Date (from file metadata or content — write "unknown" if not determinable)

If a section table doesn't yet exist in INDEX.md (e.g., the vault was empty), create it following the existing format.

### STEP D — Sync to examples.md (posts only)

For files in `vault/posts/linkedin/` or `vault/posts/instagram/`:

**Add to `reference/examples.md` if ANY of these are true:**
→ File mentions above-average engagement numbers
→ File is a reel with 1K+ views, or a LinkedIn post with 20+ reactions
→ Content is an exemplary example of {{YOUR_NAME}}'s voice — even without engagement data
→ The hook or CTA pattern is worth replicating

**How to add:**
Follow the exact format already used in reference/examples.md.
Required fields:
- Pillar tag
- Format tag
- Engagement (numbers if present; "Engagement: not recorded" if absent)
- Full post text in a fenced code block
- **WHY IT WORKS** — minimum 2 sentences. This is the most important field.
  Say specifically: what the hook does, why the structure works, what made it perform.

**Do NOT add to examples.md:**
→ Drafts or unfinished content
→ Competitor posts — INDEX only, under research/competitor-snapshots
→ Frameworks, reference docs, articles (INDEX only)
→ Files with no post content (photo notes, b-roll descriptions)

---

## CLASSIFICATION SHORTCUTS

### posts/linkedin/ → LinkedIn post
Check for:
- Hook quality: would it stop a scroll? Is it specific?
- Engagement numbers embedded in the file (impressions, reactions, comments)
- Which pillar (P1–P5, defined in `reference/content-pillars.md`)
- Format: text only, text + photo, carousel post

### posts/instagram/ → Instagram post or reel
Check for:
- Is it a caption only, a reel script only, or both?
- Engagement numbers: views (Reels), saves, shares, comments
- Viral signal: any mention of 1K+, 10K+, or "viral"
- Pillar from topic

### references/pdfs/ → Framework or whitepaper
Check for:
- What framework or research does it contain?
- Which pillar(s) does it feed?
- 1–2 key takeaways the engine should know at content-creation time

### references/txts/ → Raw text reference
Could be: an event transcript, a saved article pasted as plain text, raw notes.
Check for context clues. If it's an event transcript, note the event name,
date, key speakers, and 2–3 key ideas worth using in content.

### references/articles/ → Saved article or newsletter
Check for:
- Source (publication, newsletter, blog)
- Key claim worth referencing in content
- Which pillar it supports

### research/competitor-snapshots/ → Competitor audit
Check for:
- Which account(s) are analyzed
- Platform
- Key findings: what's working for them, what gaps exist for {{YOUR_NAME}}

### research/job-analyses/ → Job posting data
Check for:
- Role analyzed
- Approximate sample size
- Top skills or trends found

### research/trend-reports/ → Trend research
Check for:
- Source
- Topic
- Key stat worth quoting

### media/photos/ → Photo
Describe what's visible: setting, expression, context.
Best for: which content type does this suit? (event, speaking, desk, cultural, headshot)

### media/videos/ → Video or B-roll note
Describe the footage or note content.

---

## OUTPUT — VAULT SYNC REPORT

After every sync run, write this report and append it to the engine run log:

```
VAULT SYNC REPORT
=================
Run date: [date]
Manifest processed: YES / NO (none needed)

NEW FILES PROCESSED: [#]
→ [filename] | [section added to] | examples.md: YES / NO / N/A
→ [filename] | [section added to] | examples.md: YES / NO / N/A
(one line per file)

EXAMPLES.MD ADDITIONS: [#]
→ [filename] — Pillar [#] — [format] — [engagement summary]

GAPS FLAGGED:
→ [any file that couldn't be cleanly classified — note why]
→ [any vault section still empty that should be filled]

VAULT HEALTH:
→ LinkedIn posts indexed:      [#]  (target: 8+)
→ Instagram posts indexed:     [#]  (target: 6+)
→ Competitor snapshots:        [#]
→ Photos indexed:              [#]  (target: 5+)
→ Job analyses:                [#]
→ Reference docs:              [#]
```

---

## RULES

- Never rename a file — always use the filename as-is
- Never fabricate engagement data — write "not recorded" if absent
- Never add competitor posts to examples.md — INDEX only
- Never skip the WHY IT WORKS annotation when adding to examples.md
- If a file is ambiguous, classify it as best you can and flag it in the report
- Manifest must be deleted after all files are processed

---

## QUALITY GATES
- [ ] Every file in SYNC-MANIFEST.md has an INDEX.md entry
- [ ] No file classified without reading its content
- [ ] examples.md additions include WHY IT WORKS (2+ sentences)
- [ ] Competitor content NOT in examples.md
- [ ] Manifest deleted after full processing
- [ ] Vault sync report written to engine run log
