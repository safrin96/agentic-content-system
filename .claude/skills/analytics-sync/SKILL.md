---
name: analytics-sync
description: >
  Pulls LinkedIn and Instagram performance data from Windsor.ai at the start
  of every content engine run. Identifies top-performing posts from the last
  14 days, saves them to vault/posts/ with metrics embedded, and adds them to
  SYNC-MANIFEST.md so vault-sync classifies and indexes them automatically.
  Replaces the need to manually add high-performing posts to the vault.
  Requires: Windsor.ai MCP connector with LinkedIn and Instagram connected.
  This skill is optional — if Windsor.ai is not configured, the engine skips
  it and continues.
  Triggers: automatically as STEP 0a in run-content-engine, or on demand
  ("sync analytics", "pull post performance", "update vault from analytics").
---

# Analytics Sync Skill

## Role
You are {{YOUR_NAME}}'s performance data librarian. Every two weeks, before
any content is produced, you pull what actually worked — the real engagement
numbers — and make sure the vault reflects it. The vault should never be
more than one run behind.

---

## DEPENDENCY

This skill requires the **Windsor.ai MCP connector** with LinkedIn and
Instagram organic accounts connected. If the connector isn't set up,
this skill exits cleanly without blocking the engine run. The rest of
the system works without it — this is additive, not critical path.

To set up Windsor.ai: https://windsor.ai — connect your LinkedIn page
and Instagram business account, then add the MCP server URL to
`.claude/settings.json`.

---

## WHAT THIS SKILL DOES

1. Queries Windsor.ai for LinkedIn and Instagram posts from the last 14 days
2. Computes engagement rate for each post relative to the account's own average
3. Flags posts that outperformed the batch average
4. Saves top performers to `vault/posts/` with metrics embedded in the file
5. Adds new files to `vault/SYNC-MANIFEST.md` for vault-sync to classify
6. Outputs an Analytics Sync Report for the engine run log

---

## STEP 1 — CONNECT AND VERIFY

Use the Windsor.ai MCP tools in this order:

```
get_connectors()  →  confirm linkedin_organic and instagram are connected
```

If either is not connected:
- Log: "Analytics sync skipped — [platform] not connected to Windsor.ai"
- Proceed to STEP 0b (vault-sync) without blocking the engine run
- Note the gap in the engine-run-report

If both are connected, proceed.

---

## STEP 2 — PULL LINKEDIN DATA

```
get_options(connector="linkedin_organic", accounts=[account_id])
```

Then pull posts from the last 14 days:

```
get_data(
  connector="linkedin_organic",
  accounts=[account_id],
  fields=["date", "post_id", "text", "impressions", "clicks",
          "reactions", "comments", "shares"],
  date_preset="last_14d"
)
```

**Compute engagement rate for each post:**
```
engagement_rate = (reactions + comments + shares) / impressions × 100
```

If `impressions` is 0 for a post, skip it (not yet delivered or data gap).

---

## STEP 3 — PULL INSTAGRAM DATA

```
get_options(connector="instagram", accounts=[account_id])
```

Then pull posts from the last 14 days:

```
get_data(
  connector="instagram",
  accounts=[account_id],
  fields=["date", "media_id", "caption", "media_type",
          "impressions", "reach", "likes", "comments", "saves"],
  date_preset="last_14d"
)
```

**Compute engagement rate for each post:**
```
engagement_rate = (likes + comments + saves) / reach × 100
```

Use `reach` as the denominator (not impressions) for Instagram — reach is
the more meaningful signal for organic content performance.

If `reach` is 0, skip that post.

---

## STEP 4 — IDENTIFY TOP PERFORMERS

**Do not use a hardcoded threshold.** Compute the average engagement rate
across all posts in the 14-day pull for each platform, then flag posts that
are above average.

```
linkedin_avg_er = mean(all linkedin engagement rates in the pull)
instagram_avg_er = mean(all instagram engagement rates in the pull)

linkedin_top = posts where engagement_rate > linkedin_avg_er
instagram_top = posts where engagement_rate > instagram_avg_er
```

**Minimum bar:** a post needs at least 100 impressions (LinkedIn) or
50 reach (Instagram) to qualify — avoids flagging posts with zero reach
that technically have infinite engagement rate.

**Cap:** save a maximum of 3 top performers per platform per run to avoid
flooding the vault with similar content from the same batch.
If more than 3 qualify, take the 3 with the highest absolute engagement
(reactions + comments + shares for LinkedIn; saves + comments for Instagram
— saves are weighted higher on Instagram because they signal genuine value).

---

## STEP 5 — SAVE TO VAULT

For each qualifying post, save a file to the correct vault folder.

### LinkedIn posts → `vault/posts/linkedin/`

Filename: `auto-[YYYY-MM-DD]-li.txt`
(Use the post date. If two posts on same date, append `-2`, `-3`.)

File format:
```
PLATFORM: LinkedIn
DATE: [YYYY-MM-DD]
SOURCE: Windsor.ai auto-sync
METRICS:
  Impressions: [#]
  Reactions: [#]
  Comments: [#]
  Shares: [#]
  Engagement Rate: [X.X]%
  Avg engagement rate this batch: [X.X]%
  Performance: [X]% above batch average

---

[full post text as returned by Windsor.ai]
```

### Instagram posts → `vault/posts/instagram/`

Filename: `auto-[YYYY-MM-DD]-ig.txt`

File format:
```
PLATFORM: Instagram
DATE: [YYYY-MM-DD]
FORMAT: [Reel / Carousel / Image — from media_type field]
SOURCE: Windsor.ai auto-sync
METRICS:
  Reach: [#]
  Impressions: [#]
  Likes: [#]
  Comments: [#]
  Saves: [#]
  Engagement Rate: [X.X]%
  Avg engagement rate this batch: [X.X]%
  Performance: [X]% above batch average

---

[full caption as returned by Windsor.ai]
```

---

## STEP 6 — UPDATE SYNC-MANIFEST

After saving all files, update `vault/SYNC-MANIFEST.md`:

If a manifest already exists:
→ Append the new files to the appropriate section under "FILES REQUIRING INDEX ENTRY"

If no manifest exists:
→ Create it using the standard manifest format (see vault-sync skill)

For each new file added to the manifest, include:
- Full path
- Type hint: `LinkedIn post (auto-synced)` or `Instagram post (auto-synced)`
- Size and date
- Metrics summary: `Engagement rate: X.X% — X% above batch average`

The metrics summary in the manifest helps vault-sync write the "Why It Performed"
annotation without re-reading the metrics from the file.

---

## STEP 7 — OUTPUT THE ANALYTICS SYNC REPORT

Save this inline to the engine run log (appended to the log file for this run).
Also include a summary in the engine-run-report at the end of the full run.

```
ANALYTICS SYNC REPORT
=====================
Run date: [date]
Period covered: last 14 days ([start date] → [end date])

LINKEDIN
--------
Posts pulled: [#]
Avg engagement rate: [X.X]%
Top performers saved to vault: [#]
  → [filename] — [date] — ER: [X.X]% ([X]% above avg)
  → [filename] — [date] — ER: [X.X]% ([X]% above avg)

INSTAGRAM
---------
Posts pulled: [#]
Avg engagement rate: [X.X]%
Top performers saved to vault: [#]
  → [filename] — [date] — ER: [X.X]% ([X]% above avg) — [Reel/Carousel/Image]
  → [filename] — [date] — ER: [X.X]% ([X]% above avg) — [Reel/Carousel/Image]

VAULT UPDATE
------------
New files written: [#] total ([#] LinkedIn + [#] Instagram)
Added to SYNC-MANIFEST: YES
Vault-sync will classify and index these in STEP 0b.

GAPS / WARNINGS:
→ [Any platform not connected, any posts with missing data, etc.]
```

---

## DEDUPLICATION GUARD

Before saving any file to the vault, check whether a file for the same
post date already exists in `vault/posts/linkedin/` or `vault/posts/instagram/`.

If a file for that date already exists (from a previous run):
→ Compare the engagement rate. If the new pull shows higher engagement
  (post continued accumulating over time), overwrite the file with updated metrics.
→ If engagement is the same or lower, skip — don't create duplicates.

---

## WHAT THIS SKILL NEVER DOES

- Never adds competitor posts to the vault — only {{YOUR_NAME}}'s own posts
- Never saves a post with fewer than 100 impressions (LinkedIn) or 50 reach (Instagram)
- Never blocks the engine run — if Windsor.ai is unavailable or a connector
  is down, log the error and proceed. Analytics sync is additive, not critical path.
- Never saves posts where `text` or `caption` is empty or null — no content
  to learn from
- Never fabricates engagement metrics — if data is missing, note the gap,
  do not estimate

---

## QUALITY GATES
- [ ] Both connectors verified as connected before pulling data
- [ ] Engagement rate computed from real numbers, not hardcoded threshold
- [ ] Minimum impression/reach bar applied
- [ ] Max 3 posts per platform per run saved to vault
- [ ] Files written with metrics header + full post text
- [ ] SYNC-MANIFEST updated
- [ ] Analytics Sync Report written to engine log
- [ ] Deduplication check run before saving
