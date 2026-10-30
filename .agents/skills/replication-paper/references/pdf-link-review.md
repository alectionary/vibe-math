# Final-PDF link acceptance

Inspect actual URI annotations in the rendered main PDF. A correct TeX URL,
passing numerical checks, matching PDF bytes or a nonempty `links` review note
cannot establish that the PDF points to the right destination.

## Generate and review the inventory

Install the pinned extractor with
`python3 -m pip install -r /path/to/skill/scripts/requirements.txt`.
From the study root, run:

```sh
python3 /path/to/skill/scripts/pdf_links.py paper/main.pdf --output provenance/pdf-links.json
```

The inventory records the PDF hash, extractor version, page count, and each URI
annotation's page, rectangle, extracted visible label and same-line prefix,
target and stable ID.
Internal PDF destinations are not URI links. Extraction fails on missing PyMuPDF,
unreadable/encrypted/repaired PDFs and unsupported link actions; do not substitute
source scanning or silently produce an empty inventory. At least one master
artifact navigation link is required in the main paper.

Add these fields to the version-2 delivery record:

```json
{
  "repository": "owner/repository",
  "link_inventory": {"path": "provenance/pdf-links.json", "sha256": "FULL_FILE_HASH"},
  "link_provenance": [],
  "review": {
    "pdf_links": {
      "verdict": "pass",
      "pdf_sha256": "FULL_PDF_HASH",
      "inventory_sha256": "FULL_FILE_HASH",
      "findings": [{"page": 1, "finding": "Name the inspected links, visible filenames and relevant anchors."}]
    }
  }
}
```

Merge these fields with the existing record; do not replace the other review
fields. Commit the inventory at `artifact_revision`. The delivery checker
re-extracts the actual PDF, requires exact inventory equality and review hashes,
and validates every extracted URI against the policy below. Merely changing a
saved inventory or checking a source URL cannot hide the actual target. Rebuild,
regenerate and review the inventory after any PDF change. Page-specific manual
review still checks readable filenames, correct destinations and line anchors.

## One acceptance command

Run the existing orchestrator after generating and reviewing the inventory:

```sh
python3 /path/to/skill/scripts/delivery_check.py delivery.json --root /path/to/study
```

It runs the deterministic hash/schema/stage checks and PDF-link policy in one
command, with no language-model call. Exit status is nonzero on failure. JSON
`errors` contains readable failures; `pdf_link_failures` contains structured
`rule`, `page`, `uri`, and `message` fields. Page/URI are null for a file-level
failure such as unavailable extraction or a missing inventory. Example:

```json
{"rule": "master_navigation", "page": 2,
 "uri": "https://github.com/owner/repository/blob/feature/results.json",
 "message": "artifact navigation must use blob/master or tree/master"}
```

The focused `pdf_links.py` command creates the inventory; delivery acceptance
always re-extracts and validates the PDF rather than trusting that file alone.

## Separate navigation, review delivery, and provenance

- Same-repository file navigation uses canonical
  `https://github.com/owner/repository/blob/master/PATH` and directory navigation
  uses `tree/master/PATH`. Fragments such as `#L12-L20` and `#readme` are allowed.
  Branches, commit-pinned file/directory paths, raw/download/archive links, encoded
  path aliases and query variants cannot substitute for these navigation links.
- The main-PDF/source/evidence URLs in the **delivery record and PR review** remain
  commit-pinned so the reviewed bytes can be verified. This does not authorize
  commit-pinned navigation inside the paper.
- An immutable **same-repository provenance** link may point only to
  `https://github.com/owner/repository/commit/FULL_40_CHARACTER_SHA`, with no fragment
  or query. Its visible clickable label must be exactly `Reproduction revision`
  or `Historical baseline` (case-insensitive). Alternatively, the full target SHA
  may be clickable, optionally followed by a colon, with `reproduction revision`,
  `immutable reproduction revision`, or `historical baseline` immediately before
  it on the same rendered line, matching the declared role. Keep the role and
  hash together so extraction can verify that relationship. Declare the actual annotation ID in `link_provenance` as
  `{"link_id": "EXTRACTED_ID", "kind": "reproduction_revision"}` or
  `{"link_id": "EXTRACTED_ID", "kind": "baseline_revision"}` respectively.
  The target SHA must match the corresponding validated delivery-record revision.
  No other exception kinds or discretionary navigation overrides are accepted.
  A commit-pinned artifact file labeled "Reproduction revision" still fails.
  Use master links for the associated files, with the immutable revision separately
  identifying the reproducible snapshot.
- External scientific/software citations may retain DOI, release or immutable
  commit URLs. Do not rewrite them to this repository's master. Same-repository
  home, issue and PR discussion links are allowed but cannot qualify as provenance
  or replace required artifact navigation.

The checker verifies direct URI syntax and recorded artifact identity, not HTTP
availability, redirects, source support, or whether line anchors identify the
right function. Before merge, a new file may not exist on master yet. Report that
publication limit accurately; never claim that policy compliance proves the link
currently resolves, and never switch its navigation URL to a branch to hide it.
The reviewer must still verify the intended repository and actual link semantics.

Historical `--legacy-audit` behavior is unchanged and cannot establish current
acceptance. Version-2 drafts created before this link audit need a newly generated
inventory and genuine review; do not backfill fictional inspection statements.
