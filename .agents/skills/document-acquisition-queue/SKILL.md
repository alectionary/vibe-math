---
name: document-acquisition-queue
description: "Queue a complete source this environment cannot retrieve. File one GitHub issue labeled fetch-request, continue independent work, and later merge the retrieval bot's immutable manifest into the canonical ledgers. Use during open-question-research when full text is still unverified after the documented routes, including bot-mitigation and browser-host failures."
---

# Document acquisition queue

Use this when a research block needs a complete source and this environment
cannot verify the file. File one GitHub issue per source, keep working, and
later merge the retrieval bot's manifest. The research agent is the only writer
of the canonical literature ledgers. The bot posts an immutable result and does
not edit those ledgers, open claim refs, or close the issue.

The manifest contract is
[fetch-manifest.schema.json](schema/fetch-manifest.schema.json). The committed
fixture is
[unl-aai3402936.manifest.json](examples/unl-aai3402936.manifest.json): ProQuest
docview 305217740, 283 pages, the recorded sha256, born-digital, no OCR. It is
a schema example (`producer.role` `example`), not a live posting and not a
question screen. Archive and publisher route mechanics are in
[archive routes](references/archive-routes.md), not in this file.

Check a file with `python3 scripts/validate_fetch_manifest.py`. The same script's
`--self-check` covers the positive control, a front-matter preview, an
unreadable extraction, and secret rejection.

## File a request or keep working

File a `fetch-request` when all of these hold:

- This block needs that complete text for a question screen, a proof reading,
  or a named gap that blocks the requested conclusion.
- The routes in
  [research access](../open-question-research/references/research-access.md#retrieve-full-text-before-recording-an-access-gap)
  that this environment can actually run have been tried, including the
  supported browser when its connection works.
- The result is still not a verified complete PDF: bot mitigation, a browser
  host that never connects, a preview or front matter file, or a route that
  returned no body.
- Dedup found no open fetch issue and no already merged manifest for the same
  stable id.

Keep working and do not file when:

- The text is already verified here, or the ledger already screens it.
- An open fetch issue already covers the stable id. Comment the new route on
  that issue.
- A `fetched` manifest is already posted. Consume it.
- A public route this environment can still try has not been tried.
- The citation is bibliography-only and this investigation does not need the
  body. Do not queue an unbounded crawl.
- The only new material would be a signed URL, cookie, or credential. Leave
  those out and file the stable id instead.

After filing, do not poll and do not wait inside the block. Record
`acquisition_requested` and the issue URL in the investigation notes, leave
`question_count` null, and continue work that does not need that file. The
canonical ledger does not yet have an `acquisition_requested` field; do not
invent a second ledger and do not patch `literature/` only to store the pointer.
The finishing notes below own that field.

Priority is `high` when the current answer depends on this text, `normal` for
a campaign gap, and `low` for a lead that can wait. One issue per stable
source. This draft has no batch issue.

## Dedup

Search before creating an issue. Match the campaign record, archive id,
publisher id, DOI, or arXiv id, not a transient URL.

```sh
gh issue list --repo alectionary/vibe-math --state all \
  --search "fetch-request: UNL-SEM-D067" --limit 50
gh issue list --repo alectionary/vibe-math --state all \
  --search "fetch: UNL-SEM-D067 in:title" --limit 20
```

Repeat for each alias (`AAI3402936`, `305217740`, and any DOI). When the labels
below exist, also list `--label fetch-request`, `fetch-claimed`, `fetched`,
`restricted`, and `needs-human`. A missing label means the label search fails;
the title and marker searches still work.

Treat an issue as the same request when the title starts with `fetch:` and
contains the id, or the body contains `<!-- fetch-request: ID -->` or
`<!-- fetch-request-alias: ID -->`. A research issue that merely cites the work
is not a duplicate.

An open match blocks a second issue. A closed issue whose manifest was merged
also blocks a new issue. A closed issue that was never merged is unfinished:
comment and reopen it when that authorization already exists; file a successor
only when reopen is unavailable, and point the new body at the predecessor.

## Request template

The GitHub form is
[fetch-request.yml](../../../.github/ISSUE_TEMPLATE/fetch-request.yml). For
`gh issue create`, write the same fields to a body file. Title:
`fetch: UNL-SEM-D067`. Add `--label fetch-request` only when that label exists.

```markdown
<!-- fetch-request: UNL-SEM-D067 -->
<!-- fetch-request-alias: AAI3402936 -->
<!-- fetch-request-alias: 305217740 -->

- Stable source ID: UNL-SEM-D067
- Aliases: unl_aai AAI3402936; unl_bepress cehsdiss/68; proquest_docview 305217740; proquest_publication 3402936
- Title: CONSTRUCTING A CREATIVE SELF-EFFICACY INVENTORY: A MIXED METHODS INQUIRY
- Author: Daniel H. Abbott
- Year: 2010
- Type: doctoral_dissertation
- Campaign: UNL-SEM-2001
- Priority: normal
- Blocker category: bot_mitigation
- Routes already attempted: headless Download controls returned bot-mitigation 403; browser host unavailable before navigation
- What failed: this environment cannot verify the complete PDF
```

Blocker categories use the manifest route vocabulary: `bot_mitigation`,
`browser_host_unavailable`, `preview_or_front_matter`, `no_public_copy_found`,
`extraction_unreadable`, `other`. Put stable ids and durable https URLs in the
routes. Omit signed queries, cookies, and passwords. Read the archive reference
before describing a UNL, ProQuest, CORE, or Cloudflare route.

Coordinate under the parent campaign claim. A fetch issue is not a new
`refs/heads/claims/` reservation and does not split the research target.

## Labels

Lifecycle, exactly one at a time. The bot swaps the previous lifecycle label
for the next and leaves every other label alone. These labels are not created
in this draft. Create them once, then the issue form's `fetch-request` label
can apply:

```sh
gh label create fetch-request --repo alectionary/vibe-math --color fbca04 \
  --description "Complete text queued for the retrieval bot"
gh label create fetch-claimed --repo alectionary/vibe-math --color 0052cc \
  --description "Retrieval bot has claimed this source"
gh label create fetched --repo alectionary/vibe-math --color 0e8a16 \
  --description "Verified complete PDF; manifest is ready to merge"
gh label create restricted --repo alectionary/vibe-math --color d93f0b \
  --description "Checked public routes are access-restricted"
gh label create needs-human --repo alectionary/vibe-math --color 5319e7 \
  --description "Preview, exhausted transport, or a person must choose a route"
```

| From | To | Who | When |
|---|---|---|---|
| `fetch-request` | `fetch-claimed` | bot | Comment the claim, then swap labels. If `fetch-claimed` is already present, stop. |
| `fetch-claimed` | `fetched` | bot | Manifest outcome `verified`. |
| `fetch-claimed` | `restricted` | bot | Manifest outcome `restricted`. |
| `fetch-claimed` | `needs-human` | bot | Outcome `preview_only` or `needs_human`, or `transport_failure` with `retryable` false. |
| `fetch-claimed` | `fetch-claimed` | bot | `transport_failure` with `retryable` true. Post the manifest and stop. |

`scripts/validate_fetch_manifest.py` implements that map as `terminal_label`.
`None` means stay on `fetch-claimed`. The research agent closes the issue after
a successful merge. The bot does not close it.

## Manifest

The bot posts one comment and does not edit it. Start the comment with
`<!-- fetch-manifest: MANIFEST_ID -->`, then a `json` fence whose object has the
same `manifest_id`. A correction is a later comment whose `supersedes` names
the replaced id. The committed fixture is a complete example of the object.

Required content, all defined in the schema:

- `outcome`: `verified`, `preview_only`, `restricted`, `transport_failure`, or `needs_human`.
- Stable ids for the campaign record and every archive or publisher alias actually checked.
- `routes_tried`: https URL, method, UTC `Z` timestamp, HTTP status, `error_category`, and whether that route obtained bytes.
- When bytes were stored: sha256, page count, byte length, and a `bot_local` locator. `committed_to_git` and `cross_machine` stay false. The locator is provenance for the bot's machine. Another checkout reacquires the file from the stable ids and checks the hash.
- Completeness evidence: classification plus a short statement of identity, chapters, references, and final pages. A title hit or a PDF header is not that evidence.
- Extraction and OCR: `born_digital` with `ocr_applied` false, or `ocr` / `mixed` with an engine. `unreadable` requires an OCR attempt and a reason.
- Optional question candidates, each with pdf page numbers and, when known, a printed page and section. `candidate_id` is not a canonical inventory id.

`screen_owner` in this draft is `research_agent`. The bot may set
`candidates_only` with `question_count` null. It does not set `completed`.
`producer.role` `example` is the committed fixture and must not be merged.
`consumable()` reports that.

Version `0.1` allows storage kind `bot_local` only. A release asset or bucket
is a schema bump after the storage decision below.

## Consume and merge

At the start of a research block, before new retrieval, consume manifests for
the active campaign.

1. List issues labeled `fetched`, `restricted`, `needs-human`, and
   `fetch-claimed` (a retryable transport failure stays claimed). Use the dedup
   search when labels are missing.
2. Parse comments with `parse_comment`. Keep manifests from
   `active_manifests`; drop any id named by another manifest's `supersedes`.
   If more than one active manifest remains, stop and report the conflict.
3. Run `consumable`. Reject invalid JSON, secret material, a temporary media
   host, and `producer.role` `example`.
4. Resolve the campaign record from `stable_ids`. If none matches, record a
   lead in the working notes and do not create a canonical source from the
   manifest alone.
5. Merge retrieval evidence only. The research agent writes the ledger.
   - `verified` and `complete_body`: record the hash, page count, stable ids,
     routes, and extraction status. Set a complete-retrieval state only when
     identity matched.
   - `verified` and `readable` false: keep the PDF hash, leave the screen
     unscreened, and keep `question_count` null.
   - `preview_only` or `front_matter_only`: store the partial hash so it cannot
     be reused as the full text. Do not mark retrieval complete.
   - `restricted`: record a restriction on the checked routes. Do not claim the
     work is unavailable everywhere.
   - `transport_failure`: record the error category. A failed route is not a
     paywall.
   - `candidates_only`: keep the locator leads. They are not inventory entries.
6. `ledger_question_count` returns an integer only for a valid `completed`
   screen, and returns `None` otherwise. Copy a number into the ledger only
   after reading those pages. If the text cannot be re-read, write null and
   keep the candidates as leads.
7. After a real ledger edit, run that campaign's bookkeeping validator. This
   draft does not perform the edit.
8. Comment with the merge result. Close the issue when the manifest is merged
   or explicitly rejected. Leave it open when a superseding manifest is still
   required.

## Question counts

A completed screen with question count zero is allowed only for outcome
`verified`, completeness `complete_body`, and readable extracted text. The
count must equal the number of candidates with `counts_as_target` true.
Non-target leads may sit beside a zero.

These stay null, with screen status `not_screened` or `blocked` and no
candidates:

- `preview_only`, including a readable front-matter PDF
- unreadable or partial extraction
- `restricted`, `transport_failure`, and `needs_human`
- a verified PDF that has not been screened

`not_screened` and `blocked` cannot carry candidates. Leads use
`candidates_only`, still with a null count. A target flag requires `completed`.

## Secrets

Manifests and request issues store stable ids and ordinary https URLs. They do
not store signed queries, URL userinfo, cookies, authorization headers, bearer
tokens, or cloud credentials. The validator rejects those strings and the
temporary media hosts named in the archive reference. If a download only
succeeded through a signed URL, record the docview id or publication number and
set `obtained_bytes` from the bytes you hashed, without copying the URL.

## Validate this skill

When editing this skill, validate its frontmatter with the `skill-creator`
skill's `scripts/quick_validate.py`. That validator requires PyYAML. Use a
workspace virtual environment, as in
[open-question-research](../open-question-research/SKILL.md), and run the
validator with that same Python. Then run:

```sh
python3 scripts/validate_fetch_manifest.py --self-check
python3 scripts/validate_fetch_manifest.py \
  .agents/skills/document-acquisition-queue/examples/unl-aai3402936.manifest.json
```

## Remaining for the finishing agent

Tracked from issue #9, with the retrieval background in issue #7.

- [ ] Create the five labels above and confirm the issue form applies `fetch-request`.
- [ ] Choose PDF storage. v0.1 is `bot_local` with `cross_machine` false. A release asset or bucket needs a schema bump and a hash re-check on the consuming machine.
- [ ] Keep one issue per stable source unless a batch format is specified. This draft does not define one.
- [ ] Confirm the research agent owns canonical screens. The bot may attach `candidates_only`. Relax the validator only if the bot is later assigned `completed` screens.
- [ ] Add `acquisition_requested` (issue URL, manifest id, state) to the source records and to `scripts/validate_unl_sem_seed.py` in one change. Do not edit the historical ledgers only to store a queue pointer.
- [ ] Pilot one previously unresolved document: file the issue, post a real manifest from the retrieval VM, merge it, and run the campaign validator. Keep AAI3402936 as the schema control. Include a front-matter comment and an unreadable-extraction comment in that trial, not as ledger rows.
- [ ] The retrieval bot itself is out of this repository. Implement it against this contract on its own VM.
- [ ] Dry-run `parse_comment` and `active_manifests` on a real issue thread.
- [ ] Replace this script's schema subset if the schema grows past the keywords in `KNOWN`.
- [ ] Report how many complete-text gaps the pilot actually closes. The fixture does not close them.
