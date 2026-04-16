# KNOWLEDGE VAULT — INDEX
## {{YOUR_NAME}} | Master Reference Library

**WHAT THIS IS:**
This is the knowledge vault — {{YOUR_NAME}}'s permanent, growing library of
everything that informs her content. It is not a temporary file. It
compounds over time. Every asset added here makes every future content
run more personalized, more specific, and harder to fake.

**HOW CLAUDE USES THIS:**
At the start of every content run, Claude reads this INDEX first.
The INDEX tells Claude what exists in the vault and where to find it.
Claude then pulls the relevant assets for the task at hand — it does
NOT load the entire vault every time, only what's relevant.

**HOW TO ADD ASSETS:**
1. Drop the file into the correct subfolder
2. Add an entry to the correct section of this INDEX
3. Follow the entry format exactly — the annotation is mandatory

---

## VAULT STRUCTURE

```
vault/
├── INDEX.md                    ← this file — read first, always
├── posts/
│   ├── linkedin/               ← high-performing LinkedIn posts (text files)
│   └── instagram/              ← high-performing Instagram posts (text files)
├── references/
│   ├── pdfs/                   ← frameworks, guides, whitepapers (PDFs)
│   └── articles/               ← saved articles, newsletters (text/md files)
├── media/
│   ├── photos/                 ← photos to use in content (jpg/png)
│   └── videos/                 ← reel reference footage or b-roll notes (mp4/txt)
└── research/
    ├── job-analyses/           ← job posting data pulls and analyses
    ├── competitor-snapshots/   ← saved competitor content audits
    └── trend-reports/          ← AI/tech/career trend research
```

---

## SECTION 1 — HIGH-PERFORMING POSTS

### LinkedIn Posts
*Add posts that got above-average engagement — saves, comments,
shares, or reach. These are the voice calibration anchors.*

| Filename | Pillar | Format | Why It Performed | Date Posted |
|----------|--------|--------|-----------------|-------------|
| [empty — add your first post] | | | | |

**How to add:**
- Save post text as: `posts/linkedin/li-[YYYY-MM-DD]-[short-topic].txt`
- Add a row to the table above
- Include engagement signal if known

---

### Instagram Posts
*Add captions + reel scripts that performed well.*

| Filename | Pillar | Format | Why It Performed | Date Posted |
|----------|--------|--------|-----------------|-------------|
| [empty — add your first post] | | | | |

**How to add:**
- Save as: `posts/instagram/ig-[YYYY-MM-DD]-[short-topic].txt`
- For reels: include the script, not just the caption

---

## SECTION 2 — REFERENCE MATERIALS

### PDFs
*Frameworks, whitepapers, guides, research reports you want
Claude to draw from when creating content.*

| Filename | Topic | Use For | Key Takeaways |
|----------|-------|---------|---------------|
| [empty] | | | |

**How to add:**
- Drop PDF into `references/pdfs/`
- Add a row: filename, what it covers, which pillar(s) it feeds, 1–2 key
  takeaways Claude should know about
- Note: Claude Code can read PDFs as text — the more specific your
  key takeaways annotation, the faster Claude finds what it needs

**Suggested PDFs to add first:**
→ Any TPM career frameworks or job leveling guides you've saved
→ Power BI / DAX reference guides you use at work
→ Any immigration/STEM OPT guides relevant to your audience
→ AI adoption research reports (Gartner, McKinsey, etc.)

---

### Articles & Newsletters
*Saved articles, TLDR editions, Substack posts, LinkedIn articles
worth referencing in content.*

| Filename | Source | Topic | Pillar | Date | Key Claim |
|----------|--------|-------|--------|------|-----------|
| [empty] | | | | | |

**How to add:**
- Save as text or markdown: `references/articles/[source]-[YYYY-MM-DD]-[topic].md`
- Add a row with the key claim — the one thing Claude should know from this article

---

## SECTION 3 — MEDIA LIBRARY

### Photos
*Photos available for use in LinkedIn posts, Instagram carousels,
reel thumbnails. Claude reads this index to suggest specific photos
by filename when building visual briefs.*

| Filename | Description | Best For | Platform | Date Taken |
|----------|-------------|----------|----------|------------|
| [empty] | | | | |

**How to add:**
- Drop photo into `media/photos/`
- Naming convention: `[YYYY-MM-DD]-[description].jpg`
  Examples: `2026-03-15-conference-speaking.jpg`
            `2026-04-01-desk-setup-dark.jpg`
            `2026-01-20-eid-celebration.jpg`
- Add a row: what it shows, which content types it suits, which platform

**Photo categories to prioritize:**
→ Speaking / presenting (highest authority signal)
→ Working at desk / with data (practitioner credibility)
→ Cultural moments — Eid, cultural celebrations (Pillar 3)
→ Candid professional moments (conferences, events, meetings)
→ Clean headshots with good lighting (reel thumbnails)

**iCloud path (for Claude Code to scan):**
`~/Library/Mobile Documents/com~apple~Photos/`
Or: `~/Pictures/Photos Library.photoslibrary/originals/`

---

### Videos / B-Roll Notes
*MP4 files or text notes about video footage available for reels.*

| Filename | Description | Best For | Duration | Date |
|----------|-------------|----------|----------|------|
| [empty] | | | | |

**How to add:**
- MP4: drop into `media/videos/`
- If the file is large or on iCloud: create a `.txt` note file instead
  with the filename, description, and iCloud path
- Naming: `[YYYY-MM-DD]-[description].mp4` or `.txt`

---

## SECTION 4 — RESEARCH ARCHIVE

### Job Posting Analyses
*Saved analyses of job postings — used for Pillar 2 and Pillar 5 content.*

| Filename | Role Analyzed | # Postings | Key Findings | Date |
|----------|--------------|------------|--------------|------|
| [empty] | | | | |

**How to add:**
- Save as: `research/job-analyses/[YYYY-MM-DD]-[role]-analysis.md`
- Include: methodology, sample size, top 10 skills found, surprising findings

---

### Competitor Snapshots
*Saved content audits of competitor/inspiration accounts.*

| Filename | Account | Platform | Findings | Date |
|----------|---------|----------|---------|------|
| [empty] | | | | |

---

### Trend Reports
*AI/tech/career trend research saved for reference.*

| Filename | Source | Topic | Key Stats | Date |
|----------|--------|-------|-----------|------|
| [empty] | | | | |

---

## CALIBRATION INSTRUCTIONS FOR CLAUDE

When loading this vault during a content run:

**Step 1 — Read the INDEX** (this file) to understand what exists.

**Step 2 — Pull relevant assets** based on the task:
- Writing a P1 technical post? → Check references/pdfs/ for relevant guides
- Writing a P3 personal story? → Check media/photos/ for relevant photos
- Writing a P5 TPM post? → Check research/job-analyses/ for data
- Any post? → Check posts/ for voice calibration anchors

**Step 3 — Reference specifically:**
When using a vault asset, name it in the output:
→ "Voice calibrated against: `li-2026-02-28-breakout-post.txt`"
→ "Photo suggested: `2026-03-15-conference-speaking.jpg`"
→ "Data sourced from: `2026-04-01-tpm-300-postings-analysis.md`"

**Step 4 — Never fabricate vault contents.**
If a relevant asset doesn't exist in the INDEX, don't invent one.
Note the gap: "No job analysis found for this topic — recommend adding one."

---

## VAULT HEALTH CHECKLIST
*Run this mentally once a month:*

- [ ] At least 5 LinkedIn posts in posts/linkedin/
- [ ] At least 3 Instagram posts in posts/instagram/
- [ ] At least 1 job analysis in research/job-analyses/ (for P2/P5)
- [ ] At least 5 photos indexed in media/photos/
- [ ] INDEX table updated for every file added
- [ ] examples.md in reference/ still in sync with top posts here
