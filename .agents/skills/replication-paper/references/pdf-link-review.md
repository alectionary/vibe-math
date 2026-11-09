# Final-PDF link acceptance

- [Generate and review the inventory](#generate-and-review-the-inventory)
- [One acceptance command](#one-acceptance-command)
- [Navigation, delivery, and provenance](#separate-navigation-review-delivery-and-provenance)

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
- The paper never links to a commit of this repository (`/commit/<sha>`) and names
  no commit or working branch in its text: commit pins belong in the delivery record
  and the pull request. `link_provenance` in the delivery record must be empty; the
  checker refuses same-repository commit links (`commit_reference`) and any
  provenance declaration (`provenance_declared`).
- External scientific/software citations may retain DOI, release or immutable
  commit URLs. Do not rewrite them to this repository's master. Same-repository
  home, issue and PR discussion links are allowed but cannot replace required
  artifact navigation.

The checker verifies direct URI syntax and recorded artifact identity, not HTTP
availability, redirects, source support, or whether line anchors identify the
right function. Before merge, a new file may not exist on master yet. Report that
publication limit accurately; never claim that policy compliance proves the link
currently resolves, and never switch its navigation URL to a branch to hide it.
The reviewer must still verify the intended repository and actual link semantics.

## Two gates: branch tree, then live master

These are separate checks. A pre-merge 404 on a new `blob/master` or `tree/master`
path is expected and must not block. The pre-merge gate does not fetch GitHub.

Before merge, `preflight.py done` checks every same-repository
`blob/master/<path>` and `tree/master/<path>` target in the paper against the
branch tree at `HEAD` (`git cat-file -e HEAD:<path>`, and `git cat-file -t` so a
file link is a blob and a directory link is a tree). Each `#L<n>` or `#L<n>-L<m>`
anchor must fall inside that file's line count. If the link inventory records a
`symbol` for that URI, the anchored line must contain it. Paths on another
repository are not part of this gate.

```sh
python3 /path/to/skill/scripts/pdf_links.py --branch-targets \
  --root /path/to/study --paper paper/manuscript.tex
```

After the paper is on master, run the post-merge gate. It requests the live
master URL and, for a line anchor, the raw master file. A failure here is a
publication defect. It is not a reason to retarget the paper at a branch.

```sh
python3 /path/to/skill/scripts/pdf_links.py --post-merge \
  --root /path/to/study --paper paper/manuscript.tex
```

Historical `--legacy-audit` behavior is unchanged and cannot establish current
acceptance. Version-2 drafts created before this link audit need a newly generated
inventory and genuine review; do not backfill fictional inspection statements.
