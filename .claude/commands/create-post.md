# /create-post

You are creating a single piece of content from an impromptu idea.
This is outside the scheduled biweekly run. The full quality pipeline
still applies — no shortcuts because it's one post.

---

## WHAT YOU'LL DO

1. Read the idea brief below
2. Ask ONE clarifying question if the brief is too thin to produce
   great content (skip if the brief is specific enough)
3. Run the full production pipeline for the platform(s) specified
4. Save to `output/impromptu/[platform].[date].[slug].md`

---

## THE IDEA BRIEF

$ARGUMENTS

---

## STEP 1 — ASSESS THE BRIEF

Before drafting, check:
- Is there a specific angle or just a topic?
- Is there a personal detail, moment, or specific example to anchor it?
- Is there a clear platform target?

If any of these are missing AND the brief is under 2 sentences:
ask one focused question to get what you need.

If the brief is specific enough: skip straight to Step 2.

---

## STEP 2 — LOAD CONTEXT

Load in this order:
1. `vault/INDEX.md` — check for relevant photos, past posts, research
2. `reference/examples.md` — calibrate voice
3. `reference/content-pillars.md` — identify which pillar this fits
   (or flag if it's outside the 5 pillars — that's fine for impromptu)
4. `reference/voice-rules.md` — forbidden phrases and patterns

---

## STEP 3 — IDENTIFY PILLAR + PLATFORM

**Pillar assignment:**
Map the idea to the closest pillar. If it genuinely doesn't fit
any of the 5 pillars (e.g. event post, announcement, niche
cultural moment), tag it as **P0 — Timely/Impromptu** and note why.

**Platform decision:**
- Professional insight / career / technical → LinkedIn first
- Personal story / visual / cultural moment → Instagram first
- High-value announcement (project launch, speaking event) → Both
- If not specified in the brief: recommend based on content type

---

## STEP 4 — RUN THE PRODUCTION PIPELINE

### hook-cta-writer
Generate 3 hook options. Pick the strongest. Explain why.

### [drafting skill — pick the right one]
- LinkedIn text post → `caption-writer`
- Instagram Reel → `instagram-reel-script`
- Carousel (either platform) → `presentation-content` + `caption-writer`
- LinkedIn article → `linkedin-article-writer`
- Both platforms → run `caption-writer` twice, separately

### content-deduplicator
Quick scan: has this exact angle or event been posted before?
For timely/event posts: waive the recency check (by definition it's new).
Still check for hook formula overlap.

### brand-voice-manager
Voice audit. Fix anything that sounds generic or AI-written.

### Refinement Protocol (all 6 passes)
Run all 6. No skipping because it's a quick post.

### reference-verifier
Verify any claims, stats, or attributions.
For personal experience posts: verify only external claims.

### thumbnail-brief
Required for: Reels, carousels, and any post where a visual
is part of the content (e.g. event photo, product screenshot).

### pinned-comment-writer
Write the pinned comment. Always.

### content-reviewer
GO / NO-GO. Fix any NO-GO issues before saving.

---

## STEP 5 — SAVE OUTPUT

Save to: `output/impromptu/[platform].[YYYY-MM-DD].[short-slug].md`

Examples:
- `output/impromptu/linkedin.2026-04-13.project-launch.md`
- `output/impromptu/instagram.2026-04-13.conference-recap.md`
- `output/impromptu/both.2026-04-13.career-milestone.md`

Use the same file format as the biweekly engine:
Caption → Pinned Comment → Visual Brief → Reel Script (if applicable)
→ Vault Assets Used → Production Notes

---

## TIMELY CONTENT GUIDELINES

For event posts, announcements, or cultural moments — special rules:

**Speed vs. quality tradeoff:**
Timely posts have a shelf life. If the event is TODAY:
- Prioritize hook strength and voice accuracy over perfect polish
- The Refinement Protocol still runs — but moves faster
- Flag in Production Notes: "Time-sensitive — publish within [X hours]"

**Event posts specifically:**
- Lead with what YOU noticed / felt / learned — not the event summary
- One specific moment beats a full recap every time
- Photo of you at the event > stock photo every time
- Check vault/media/photos/ for any usable shots

**Announcement posts:**
- Don't just announce — teach something from the process of building it
- "I published X" is weak. "Here's what I learned building X" earns the read
- Link goes in the pinned comment (LinkedIn), bio (Instagram)

---

## WHAT YOU NEVER DO FOR IMPROMPTU POSTS

- Never skip the Refinement Protocol
- Never publish without a pinned comment ready
- Never let "it's just a quick post" lower the quality bar
- Never post a generic event recap — find the specific angle
- Never skip the voice audit — impromptu briefs are highest risk
  for AI-sounding first drafts
