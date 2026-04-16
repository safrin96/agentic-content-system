# /run-content-engine

You are running {{YOUR_NAME}}'s automated content engine for the next 2 weeks.

Today's date is $TODAY.
Week 1 starts: $WEEK1_START (the coming Sunday or Monday)
Week 2 starts: $WEEK2_START

---

## WHAT YOU WILL DO

You will produce a full 2-week content batch by executing these steps
in sequence. Do not skip steps. Do not ask for confirmation between
steps — run the full pipeline and save all outputs.

---

## STEP 1 — RESEARCH BRIEF

Load: `vault/INDEX.md`, `reference/examples.md`, `reference/content-pillars.md`

Run the `content-research` skill:
- Perform a Trending Topic Scan for the next 2 weeks
- Check watched accounts for recent content gaps
- Pull AI/tech news from Tier 1 sources
- Output: one Research Brief per pillar (P1–P4)
  - Save as: `output/research/research-brief.$TODAY.md`

---

## STEP 2 — BUILD THE 2-WEEK PLAN

Using the research brief and the weekly cadence from
`reference/content-pillars.md`, generate a content plan:

### Week 1 Schedule ($WEEK1_START to $WEEK1_END):

| Date | Platform | Format | Pillar | Topic (from research) |
|------|----------|--------|--------|-----------------------|
| $W1_MON | LinkedIn | Text post | P2 | [assign from research] |
| $W1_TUE | Instagram | Reel | P4 | [assign from research] |
| $W1_WED | LinkedIn | Carousel | P1 | [assign from research] |
| $W1_THU | Instagram | Carousel | P3 | [assign from research] |
| $W1_FRI | LinkedIn | Personal story | P3 | [assign from research] |
| $W1_SAT | Instagram | Reel | P4 | [assign from research] |

### Week 2 Schedule ($WEEK2_START to $WEEK2_END):

| Date | Platform | Format | Pillar | Topic (from research) |
|------|----------|--------|--------|-----------------------|
| $W2_MON | LinkedIn | Text post | P2 | [assign from research] |
| $W2_TUE | Instagram | Reel | P1 | [assign from research] |
| $W2_WED | LinkedIn | Carousel | P2 | [assign from research] |
| $W2_THU | Instagram | Carousel | P4 | [assign from research] |
| $W2_FRI | LinkedIn | Personal story | P3 | [assign from research] |
| $W2_SAT | Instagram | Reel | P5 | [assign from research] |

Save plan as: `output/content-plan.$TODAY.md`

---

## STEP 3 — PRODUCE ALL CONTENT

For each row in the plan, run the full production pipeline:

### Per-piece pipeline:

1. **hook-cta-writer** → generate 3 hook options, pick the strongest
2. **[drafting skill]** → run the appropriate skill:
   - LinkedIn text post → `caption-writer`
   - LinkedIn carousel → `presentation-content` (brief) + `caption-writer` (post copy)
   - Instagram Reel → `instagram-reel-script`
   - Instagram Carousel → `presentation-content` (brief) + `caption-writer` (caption)
3. **brand-voice-manager** → voice audit, fix any issues
4. **reference-verifier** → verify all claims
5. **thumbnail-brief** → visual brief for all reels and carousels
6. **pinned-comment-writer** → write the pinned first comment
7. **content-reviewer** → GO / NO-GO gate

If NO-GO: fix the flagged issues and re-run the reviewer before saving.

### Save each piece using this exact format:

```
output/
├── week-1/
│   ├── linkedin.$W1_MON.md
│   ├── instagram.$W1_TUE.md
│   ├── linkedin.$W1_WED.md
│   ├── instagram.$W1_THU.md
│   ├── linkedin.$W1_FRI.md
│   └── instagram.$W1_SAT.md
└── week-2/
    ├── linkedin.$W2_MON.md
    ├── instagram.$W2_TUE.md
    ├── linkedin.$W2_WED.md
    ├── instagram.$W2_THU.md
    ├── linkedin.$W2_FRI.md
    └── instagram.$W2_SAT.md
```

---

## STEP 3b — DEDUPLICATION CHECK

After all 12 pieces are drafted and before any file is saved,
run the `content-deduplicator` skill across the full batch:

1. Scan all existing files in `output/` and `vault/posts/`
2. Check every new piece for hook, angle, example, and recency overlap
3. Fix all 🔄 REWORK items immediately — reassign angle from research brief
4. Note all ⚠️ SOFT FLAGs in the engine-run-report
5. No ❌ HARD BLOCK item may proceed to Step 4

Save dedup report as: `output/dedup-report.$TODAY.md`

---

## STEP 4 — CONTENT FILE FORMAT

Every output file must follow this exact structure:

```markdown
# [Platform] — [Date] — [Topic]

**Pillar:** P[#]
**Format:** [Text / Carousel / Reel / Article]
**Status:** READY TO PUBLISH
**Reviewer:** PASS

---

## CAPTION / POST COPY

[Full post text exactly as it will be published]

---

## PINNED COMMENT

[Full pinned comment text, ready to paste]

---

## VISUAL BRIEF

[Thumbnail or cover card brief from thumbnail-brief skill]

---

## CAROUSEL BRIEF (if applicable)

[Full slide-by-slide content brief for {{DESIGN_TOOL}}]

---

## REEL SCRIPT (if applicable)

[Full 60-second script with delivery notes]

---

## STOCK PHOTO NOTE (if applicable)

[Recommended search query and source from stock-photo-finder skill]

---

## VERIFICATION LOG

[Summary from reference-verifier — claims checked, sources]

---

## VAULT ASSETS USED

[List any vault assets referenced in this piece:]
→ Voice calibrated against: [filename from vault/posts/ or examples.md]
→ Photo suggested: [filename from vault/media/photos/ — or "none available"]
→ Research sourced from: [filename from vault/research/ if applicable]
→ Reference used: [filename from vault/references/ if applicable]

---

## PRODUCTION NOTES

[Any notes for {{YOUR_NAME}}: things to record, personal photos needed,
tool demos to capture, timing considerations. If a photo is suggested
above, note the iCloud path or vault filename here.]
```

---

## STEP 5 — SUMMARY REPORT

After all content is produced, save a summary:
`output/engine-run-report.$TODAY.md`

Include:
- Run date and 2-week window covered
- Total pieces produced: [#]
- Pillar distribution (count per pillar)
- Platform distribution (LinkedIn vs Instagram)
- Any pieces that needed extra revision (NO-GO → GO)
- Dedup summary: hard blocks, soft flags, rework count
- Hook formula frequency warnings
- Research sources used
- Recommended content to prioritize if time is short
- Topics deferred to the following week (if any)

---

## WHAT YOU NEVER DO IN THIS RUN

- Never skip the brand-voice-manager pass
- Never skip the reference-verifier pass
- Never save a file that has a NO-GO from content-reviewer without fixing it first
- Never produce generic topics — every piece must trace back to the research brief
- Never use em dashes in any output
- Never start a LinkedIn post with "I"
- Never save incomplete files — if a step fails, note it in the report and move on
  to the next piece, but flag it clearly
