#!/usr/bin/env python3
"""
vault-scan.py
-------------
Scans the Claude vault for files not yet indexed in INDEX.md.
Writes vault/SYNC-MANIFEST.md listing every unindexed file so that
the vault-sync Claude skill can process them intelligently.

Run:   python3 scripts/vault-scan.py
Output: vault/SYNC-MANIFEST.md (overwritten each run)

No third-party dependencies — stdlib only.
"""

import os
import re
import sys
from pathlib import Path
from datetime import datetime

# ── Paths ────────────────────────────────────────────────────────────────────
PROJECT_DIR  = Path(__file__).resolve().parent.parent
VAULT_DIR    = PROJECT_DIR / "vault"
INDEX_FILE   = VAULT_DIR / "INDEX.md"
MANIFEST_FILE = VAULT_DIR / "SYNC-MANIFEST.md"

# ── Folder → human-readable type ─────────────────────────────────────────────
SCAN_FOLDERS = {
    "posts/linkedin":               "LinkedIn post",
    "posts/instagram":              "Instagram post / reel script",
    "references/pdfs":              "PDF reference / framework",
    "references/txts":              "Text reference / raw transcript",
    "references/articles":          "Article / newsletter",
    "media/photos":                 "Photo",
    "media/videos":                 "Video / B-roll note",
    "research/job-analyses":        "Job posting analysis",
    "research/competitor-snapshots":"Competitor snapshot",
    "research/trend-reports":       "Trend report",
    "research":                     "Research file (unclassified subfolder)",
}

# Files and extensions to always ignore
SKIP_NAMES = {
    ".DS_Store", "INDEX.md", "SYNC-MANIFEST.md",
    ".gitkeep", "Thumbs.db", ".gitignore",
}
SKIP_SUFFIXES = {".DS_Store", ".db", ".localized"}


# ── Helpers ───────────────────────────────────────────────────────────────────

def get_indexed_filenames(index_path: Path) -> set[str]:
    """
    Parse INDEX.md and collect every filename that already has an entry.
    Looks for filenames in:
      - Markdown table first-column cells  (| filename.txt | … )
      - Backtick spans                     (`filename.txt`)
    """
    if not index_path.exists():
        return set()

    content = index_path.read_text(encoding="utf-8", errors="replace")
    found: set[str] = set()

    for line in content.splitlines():
        # Table rows: | filename | rest…
        if "|" in line:
            parts = [p.strip() for p in line.split("|")]
            for cell in parts[1:3]:            # check cols 1 and 2 for safety
                if cell and not cell.startswith("-") and cell not in (
                    "Filename", "[empty]", "[empty — add your first post]"
                ) and "." in cell:
                    found.add(cell)

    # Backtick filenames anywhere in the doc
    for match in re.finditer(r"`([^`]+\.[A-Za-z0-9]+)`", content):
        found.add(match.group(1))

    return found


def best_folder_type(rel_folder: str) -> str:
    """Return the most specific type label for a given relative folder path."""
    # Try longest-match first
    for folder_key in sorted(SCAN_FOLDERS, key=len, reverse=True):
        if rel_folder.startswith(folder_key):
            return SCAN_FOLDERS[folder_key]
    return "Unknown"


def scan_vault(indexed: set[str]) -> list[dict]:
    """Walk vault, return list of unindexed file metadata dicts."""
    unindexed: list[dict] = []

    for root, dirs, files in os.walk(VAULT_DIR):
        # Skip hidden dirs
        dirs[:] = [d for d in dirs if not d.startswith(".")]

        root_path = Path(root)
        rel_folder = str(root_path.relative_to(VAULT_DIR))

        for filename in sorted(files):
            if filename in SKIP_NAMES:
                continue
            if Path(filename).suffix.lower() in SKIP_SUFFIXES:
                continue
            if filename.startswith("."):
                continue
            if filename in indexed:
                continue

            file_path = root_path / filename
            try:
                stat = file_path.stat()
                size_kb = round(stat.st_size / 1024, 1)
                modified = datetime.fromtimestamp(stat.st_mtime).strftime("%Y-%m-%d")
            except OSError:
                size_kb, modified = 0.0, "unknown"

            unindexed.append({
                "filename":  filename,
                "rel_path":  str(file_path.relative_to(VAULT_DIR)),
                "rel_folder": rel_folder,
                "type":      best_folder_type(rel_folder),
                "suffix":    Path(filename).suffix.lower(),
                "size_kb":   size_kb,
                "modified":  modified,
            })

    return unindexed


def write_manifest(unindexed: list[dict]) -> None:
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    lines: list[str] = [
        "# VAULT SYNC MANIFEST",
        f"Generated: {now}",
        f"Unindexed files found: {len(unindexed)}",
        "",
        "---",
        "",
    ]

    if not unindexed:
        lines += [
            "## ✅ Vault is fully indexed",
            "",
            "No new files found. Proceed directly to content engine STEP 1.",
        ]
    else:
        lines += [
            "## FILES REQUIRING INDEX ENTRY",
            "",
            "Claude: process each file below using the **vault-sync** skill.",
            "Read → Classify → Update INDEX.md → Sync to examples.md if applicable.",
            "",
        ]

        # Group by folder
        by_folder: dict[str, list[dict]] = {}
        for f in unindexed:
            key = f["rel_folder"]
            by_folder.setdefault(key, []).append(f)

        for folder in sorted(by_folder):
            files = by_folder[folder]
            plural = "s" if len(files) != 1 else ""
            lines.append(
                f"### `vault/{folder}/`  —  {len(files)} new file{plural}"
            )
            lines.append("")
            for f in files:
                lines += [
                    f"**`{f['filename']}`**",
                    f"→ Full path: `vault/{f['rel_path']}`",
                    f"→ Type hint: {f['type']}",
                    f"→ Size: {f['size_kb']} KB  |  Modified: {f['modified']}",
                    "",
                ]

        lines += [
            "---",
            "",
            "## PROCESSING INSTRUCTIONS FOR CLAUDE",
            "",
            "For each file listed above (vault-sync skill):",
            "1. Read the full file content",
            "2. Classify: type / pillar / format / engagement signal",
            "3. Write the annotation (1–2 sentences — WHY IT'S USEFUL)",
            "4. Add to the correct INDEX.md section",
            "5. If it's a post with engagement data or strong voice → add to reference/examples.md",
            "6. Mark each processed file ✅ DONE inline in this manifest",
            "",
            "When ALL files are marked DONE: delete this manifest file.",
        ]

    MANIFEST_FILE.write_text("\n".join(lines), encoding="utf-8")


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> int:
    print("vault-scan: scanning for unindexed files…")

    indexed   = get_indexed_filenames(INDEX_FILE)
    unindexed = scan_vault(indexed)

    if not unindexed:
        print("vault-scan: ✅  Vault is fully indexed — no new files.")
        # Remove a stale manifest if one exists from a previous run
        if MANIFEST_FILE.exists():
            MANIFEST_FILE.unlink()
            print("vault-scan: removed stale SYNC-MANIFEST.md")
        return 0

    write_manifest(unindexed)
    print(
        f"vault-scan: 📋  {len(unindexed)} unindexed file(s) → "
        f"vault/SYNC-MANIFEST.md written."
    )
    return 0          # non-blocking — engine always continues


if __name__ == "__main__":
    sys.exit(main())
