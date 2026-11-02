---
name: document-acquisition-queue
description: "Queue a complete public source this environment cannot retrieve. File one GitHub issue labeled fetch-request for any paper, keep a dated code and supplementary-material ledger, file a help issue when that form does not fit, continue independent work, and later ingest a fetched manifest. Ingestion commits the manifest and question screen and opens a pull request that references the fetch issue. Use during open-question-research when full text is still unverified after the documented routes."
---

# Document acquisition queue

Use this when a research block needs a complete source and this environment
cannot verify the file. The source may be any public paper. File one GitHub
issue per source, keep working, and later merge the retrieval worker's
manifest. The research agent is the only writer of the canonical literature
ledgers. The worker posts an immutable result and does not edit those ledgers,
open claim refs, or close the issue. Any agent may be the worker. Its procedure
is [document retrieval](../document-retrieval-worker/SKILL.md).

Identify a source by DOI, arXiv id, canonical URL, archive record id, and
title, author, and year. A campaign id is optional. Site procedures, including
UNL bepress and ProQuest, stay in the worker's
[site notes](../document-retrieval-worker/references/unl-proquest.md) and are
read only when the source matches.

The manifest contract is
[fetch-manifest.schema.json](schema/fetch-manifest.schema.json). Workers post
`manifest_version` `0.3`. `0.1` and `0.2` stay valid for manifests already
posted. Do not edit a posted comment to bump its version. The committed
fixture is
[unl-aai3402936.manifest.json](examples/unl-aai3402936.manifest.json): a verified
positive control, 283 pages, born-digital, no OCR, question count null,
`discovered_identifiers` empty. It is `producer.role` `example`, not a live
posting and not a question screen. The other files in `examples/` are validator
fixtures for a DOI with parentheses, the campaign ids `unl-sem`,
`L-F91-c16-unrestricted-width`, and `L-F102-correlated-residuals`, a bare
`other` id, and a route attributed to another worker session. They are not
live postings.

Check a file with `python3 scripts/validate_fetch_manifest.py`. `--self-check`
covers that control, the other committed fixtures, a front-matter preview,
an unreadable extraction, a `not_found` result, catalog route ids, secret
rejection, an omitted `comment_url`, discovered identifiers that do not
backfill earlier routes, evidence that keeps Unicode `text_characters`
distinct from byte counts, campaign ids, a bare other id, route attribution,
and the fetched-to-ingestion markers.

## Code and supplementary-material ledger

Start this ledger the day the first place is checked. "Not available" is a
row in the ledger, not a recollection at wrap-up. Keep it in the
investigation notes, next to the source ledger. One row per place:

| Place checked | UTC date | Result |
|---|---|---|

Check these places before writing "not available":

- The paper itself, including any sentence that names a supplement or a program.
- The publisher's article page and its supplementary-material tab.
- The author manuscript or repository copy, when that file is not the publisher's version.
- A public code host named in the paper or the supplement.
- The software the paper says it used, recorded as the product name on the page that names it.

The result is one of: obtained, with a hash or a stable URL; absent on that
page; paywalled or campus-only, with the route and the wall that was shown;
or not checked yet. "Not available" is allowed only when every place above
has a dated row and none of them obtained the file. A route that was not
opened does not support that sentence.

When the paper says the programs exist and names where they were deposited,
record that sentence and whether this block obtained the file. A missing
paper uses a `fetch-request`. A missing program, supplement, dataset, or other
gap that the fetch form does not fit uses a [help issue](#help-issue). A file
offered only by emailing the author is a help issue, not a fetch request.

## File a request the day the source is blocked

The steps under [File a request or keep working](#file-a-request-or-keep-working)
run in the same step that records the block. Index the source that day, with
the issue URL. Do not collect blocked sources for closeout.

## File a request or keep working

File a `fetch-request` when all of these hold:

- This block needs that complete text for a question screen, a proof reading,
  or a named gap that blocks the requested conclusion.
- The routes in
  [research access](../open-question-research/references/research-access.md#retrieve-full-text-before-recording-an-access-gap)
  that this environment can actually run have been tried, including a real
  browser when its connection works.
- The result is still not a verified complete file: bot mitigation, a browser
  that never connects, a preview or front matter file, or a route that returned
  no body.
- Dedup found no open fetch issue for the same stable id.

Keep working and do not file when:

- The text is already verified here, or the ledger already screens it.
- An open fetch issue already covers the stable id. Comment the new route on
  that issue.
- A `fetched` manifest is already posted. Consume it.
- A `not-found` issue already covers the id. Leave it; the worker reopens it
  only when the route catalog gains an applicable route.
- A public route this environment can still try has not been tried.
- The citation is bibliography-only and this investigation does not need the
  body. Do not queue an unbounded crawl.
- The only new material would be a signed URL, cookie, or credential. Leave
  those out and file the stable id instead.

After filing, do not poll and do not wait inside the block. Continue work that
does not need that file, and leave `question_count` null.

When the source is already a ledger record and this block is updating that
record, set `retrieval_status` to `acquisition_requested`. On a dissertation
row also set `access.retrieval_status` to the same value. Leave
`question_count` null and do not change other fields. `acquisition_requested`
is an allowed state in `scripts/validate_unl_sem_seed.py`; existing rows were
not rewritten to it. A source that has no ledger row yet is recorded, with the
issue URL, in the investigation notes until the research skill creates the row.

Priority is `high` when the current answer depends on this text, `normal` for
a campaign gap, and `low` for a lead that can wait. One issue per stable
source. This draft has no batch issue.

## Dedup

Search before creating an issue, with the same authenticated transport. Match
the DOI, arXiv id, canonical URL, or archive record id, not a transient signed
URL. The `gh` search below is one variant; REST search is
`GET /search/issues?q=repo:alectionary/vibe-math+FETCH_ID`.

```sh
gh issue list --repo alectionary/vibe-math --state all \
  --search "fetch-request: 10.1000/example.doi" --limit 50
gh issue list --repo alectionary/vibe-math --state all \
  --search "fetch: 10.1000/example.doi in:title" --limit 20
```

Substitute the real id, and repeat for each alias. Also list `--label
fetch-request`, `fetch-claimed`, `fetched`, `restricted`, `needs-human`, and
`not-found` when those labels exist.

Treat an issue as the same request when the title starts with `fetch:` and
contains the id, or the body contains `<!-- fetch-request: ID -->` or
`<!-- fetch-request-alias: ID -->`. A research issue that merely cites the work
is not a duplicate.

An open match blocks a second issue. A closed issue whose manifest was merged
also blocks a new issue. A `not-found` issue blocks a new issue even when
closed; the worker reopens it for new catalog routes. A closed issue that was
never merged and is not `not-found` is unfinished: comment and reopen it when
that authorization already exists.

## Request template

The GitHub form is
[fetch-request.yml](../../../.github/ISSUE_TEMPLATE/fetch-request.yml). Filing
uses the authenticated transports and preflight in the
[worker skill](../document-retrieval-worker/SKILL.md#github-transport). For
`gh issue create`, write the same fields to a body file. REST is
`POST /repos/alectionary/vibe-math/issues` with the same title, body, and
`"labels": ["fetch-request"]`. For `gh issue create`, pass
`--label fetch-request`. Title: `fetch: 10.1000/example.doi`. The lifecycle
label on a new issue is `fetch-request`.

```sh
gh issue create --repo alectionary/vibe-math --title "fetch: 10.1000/example.doi" \
  --body-file request.md --label fetch-request
```

Read the issue back before the step ends. Confirm the only lifecycle label is
`fetch-request`. If the create call omitted it, add it. A
`<!-- fetch-request: ID -->` marker without that label is not filed. The
2026-11-02 backlog was filed as bodies without the label; the worker now
sweeps those, and new requests do not rely on that sweep.

```markdown
<!-- fetch-request: 10.1000/example.doi -->
<!-- fetch-request-alias: 1234.56789 -->

- Stable source ID: 10.1000/example.doi
- Aliases: arxiv 1234.56789; url https://example.test/paper
- Title: Example paper title
- Author: Author Name
- Year: 2020
- Type: article
- Campaign: unl-sem (omit when the paper is not in a campaign)
- Priority: normal
- Blocker category: bot_mitigation
- Routes already attempted: curl https://doi.org/10.1000/example.doi returned a bot check; browser did not start
- What failed: this environment cannot verify the complete file
```

Stable ids use the manifest schemes `doi`, `arxiv`, `url`, `archive_record`,
`campaign_record`, and `other`. An archive record looks like
`prefix:value`. Prefixes for a particular archive are defined in that site's
worker reference, not here. A PMCID on the request is `archive_record`
`pmcid:PMC` plus digits. Scheme `other` is either `prefix:value`
(`openalex:W2080656989`) or a bare token with no colon (`UNL-SEM-D013`). Do
not invent a prefix so the value will match the old pattern. A DOI may
contain parentheses (`10.1016/0095-8956(84)90023-6`); that string can be
`requested_source_id`.

The campaign field is the investigation's spelling: two or more
hyphen-separated segments of letters and digits. `unl-sem`,
`L-F102-correlated-residuals`, `L-F91-c16-unrestricted-width`, and
`UNL-SEM-2001` are valid. Omit the field when the paper is not in a campaign.
It is not a document id. A posted `0.1` or `0.2` manifest that stored
`campaign_id` null because the old all-caps pattern rejected one of these ids
stays as posted. `migrate_campaign_id(posted, issue_campaign)` returns the id
a new manifest stores. It does not edit the old comment.

Blocker categories are the manifest `error_category` names:
`bot_mitigation`, `http_error`, `browser_host_unavailable`, `timeout`,
`network`, `preview_only`, `restricted`, `identity_mismatch`,
`incomplete_document`, `extraction_unreadable`, `not_found`, and `other`.
A browser that cannot start is `browser_host_unavailable`, not `other`. A
preview or front-matter file is `preview_only`. No public copy is `not_found`.
Put durable https URLs in the routes. Omit signed queries, cookies, and
passwords.

Coordinate under the parent campaign claim when there is one. A fetch issue is
not a new `refs/heads/claims/` reservation.

## Help issue

Use a help issue when the gap is not a missing paper: code, a program, a
supplement, a dataset, or another file the `fetch-request` form does not fit.
Also use it when the only stated way to obtain the file is to email an author.
The SAS programs named in a 2010 manuscript and offered only by email, with no
public URL, are this case. Do not open `fetch: other:...` for them. If a fetch
issue was already opened for that kind of gap, comment on it and file the help
issue. The worker's `label_sweep_action` returns `help-issue` and does not
claim it. Search open issues for the same missing item before filing. Title:
`help: <what is missing>`. The GitHub form is
[help-request.yml](../../../.github/ISSUE_TEMPLATE/help-request.yml).
Filing uses the same authenticated transport as a fetch request. Paste this
body when the form is not what the client sends:

```markdown
## What is missing

The file or supplement, named precisely, and the source it belongs to.

## Why it matters

The claim or comparison that stays open without it.

## Routes already tried

One line per place: the place, the UTC date, and the result. Copy the
availability ledger. Do not write "not available" without those rows.

## What would unblock it

The document, dataset, or permission that would let the check run.
```

A help issue does not use the fetch lifecycle labels and does not reserve a
claim ref. Link it from the investigation notes the day it is filed.

## Labels

Lifecycle, exactly one at a time. The worker swaps the previous lifecycle label
for the next. `not_found` uses `not-found`. A retryable transport failure stays
on `fetch-claimed`. A browser handoff also stays on `fetch-claimed`.
`terminal_label` in `scripts/validate_fetch_manifest.py` is the outcome map.
`label_end_state_ok` checks the end state, and `replace_label_set` is the
full set a replace-set client writes. The read-then-write, and the `gh`,
REST, and replace-set variants, are in the
[worker skill](../document-retrieval-worker/SKILL.md#lifecycle-labels).

| Outcome | Label |
|---|---|
| `verified` | `fetched` |
| `restricted` | `restricted` |
| `preview_only`, `needs_human`, or a spent transport failure | `needs-human` |
| `not_found` | `not-found` |
| `transport_failure` with `retryable` true | `fetch-claimed` |

The six names already exist. Check that they exist. Do not create them, and
do not change their colors or descriptions. Filing uses the same authenticated
transports and preflight as the worker. Do not assume `gh` is logged in. The
issue form names `fetch-request` so that label applies when the form is used.

The worker does not close the issue. A `fetched` issue stays open until
ingestion is on the default branch. The research agent closes it after the
ingestion pull request has merged and the merged marker is posted. See
[Ingest a fetched paper](#ingest-a-fetched-paper). `restricted` and
`needs-human` close when that gap is recorded in the ledger and no PDF
ingestion is required. A `not-found` issue stays labeled `not-found`. The
worker reopens a closed `not-found` issue when the route catalog gains an
applicable route that the manifests do not contain.

## Manifest

The worker posts one comment and does not edit it. Start the comment with
`<!-- fetch-manifest: MANIFEST_ID -->`, then a `json` fence whose object has the
same `manifest_id`. A verified comment also has `<!-- fetch-ready-for-ingestion -->`
before that marker. A comment that finishes a browser handoff has
`<!-- fetch-browser-handoff-resolved: SESSION -->` first. A correction is a
later comment whose `supersedes` names the replaced id. The committed fixture
is a complete example of the object. Live postings use `manifest_version` `0.3`.

Required content:

- `outcome`: `verified`, `preview_only`, `restricted`, `transport_failure`,
  `needs_human`, or `not_found`.
- Stable ids from the request, on `document.stable_ids`. `campaign_id` uses
  the convention above, or null when there is no campaign.
- `discovered_identifiers`: ids learned during the run, each with the catalog
  route that surfaced it. Empty when nothing new appeared. They are not copied
  into `document.stable_ids`, and they do not make earlier routes applicable.
- `routes_tried`: catalog `route` (`openalex-oa@1`), attempt `id`, https URL,
  method, UTC `Z` timestamp, HTTP status, `error_category`, and whether that
  route obtained bytes. On `0.3`, each row has `attempted_by`: null when
  `producer` ran it, or `role` `retrieval_worker` and `session` when another
  worker session ran it. The route id must be in the worker
  [route catalog](../document-retrieval-worker/routes.json). `requires_match`
  is `any`, `all`, `always`, or `prefixes`. Log a route only when it was run.
  After complete bytes are stored, do not log a skipped route. A preview that
  was seen and not saved is `needs_human`, with that route's `error_category`
  `preview_only`, `obtained_bytes` false, and notes that say the preview was
  not saved. `preview_only` is only a preview whose bytes were stored.
- When bytes were stored: sha256, page count, byte length, and a `worker_local`
  locator. `committed_to_git` and `cross_machine` stay false. The locator is
  provenance for that machine. Another checkout reacquires the file from the
  stable ids and checks the hash. `byte_length` is PDF bytes.
- Completeness evidence. A title hit or a file header is not that evidence.
  On version `0.2`, a `characters` count in that evidence equals
  `text_characters` (Unicode code points). Do not call that number bytes.
  `byte_length` is the PDF size in bytes.
- Extraction and OCR status. `text_characters` is Unicode code points, not
  bytes.
- `issue.repository`, `issue.number`, and `issue.url` on a live posting. Omit
  `issue.comment_url`. The consumer takes the comment URL from the API.
- Optional question candidates with pdf page locators. `candidate_id` is not a
  canonical inventory id.

`screen_owner` is `research_agent`. The worker sets `not_screened` only for a
verified readable file, and `blocked` when the screen cannot run (`restricted`,
`preview_only`, `needs_human`, `not_found`, `transport_failure`, or an
unreadable or partial extraction). It may set `candidates_only` with
`question_count` null on a verified readable file. It does not set
`completed`. `producer.role` `example` is a fixture and must not be merged.
`consumable()` reports that. `producer.role` for a live posting is
`retrieval_worker`.

Versions `0.1`, `0.2`, and `0.3` allow storage kind `worker_local` only.
`committed_to_git` stays false: the manifest describes the worker's copy, and
the PDF bytes are not a git blob. `0.2` and `0.3` require
`discovered_identifiers` and do not require `issue.comment_url`. `0.3`
requires `attempted_by` on every route. A `0.2` row that stored a PMC Open
Access host on `institutional-repository@1` stays as posted. A new run uses
`pmc-oa-package@1`.

## Consume and merge

At the start of a research block, before new retrieval, consume manifests for
the sources this block cares about.

1. List issues labeled `fetched`, `restricted`, `needs-human`, `not-found`, and
   `fetch-claimed` (a retryable transport failure, and a browser handoff, stay
   claimed). Use the same authenticated transport preflight as the worker.
2. Parse comments with `parse_comment`. Take each comment URL from
   `locate_manifests`, which reads the API object's `html_url` and matches
   `manifest_id`. Do not require `issue.comment_url` inside the body. Keep
   `active_manifests`. If more than one active manifest remains, stop and
   report the conflict.
3. Run `consumable`. Reject invalid JSON, an unknown catalog route, secret
   material, a temporary media host, and `producer.role` `example`. Accept a
   `0.1` manifest that still has `comment_url`, and a `0.2` or `0.3` manifest
   that omits it.
4. Resolve an existing source from the stable ids. If none matches, record a
   lead in the working notes and do not create a canonical source from the
   manifest alone.
5. Merge retrieval evidence only.
   - `verified` and `complete_body`: record the hash, page count, stable ids,
     discovered identifiers, routes, and extraction status while ingesting
     the file. Keep `text_characters` as a Unicode character count and
     `byte_length` as PDF bytes. Do not close the issue in this bullet.
   - `verified` and `readable` false: keep the file hash and leave
     `question_count` null.
   - `preview_only` or front matter: store the partial hash so it cannot be
     reused as the full text.
   - `restricted`: record a restriction on the checked routes only. Copy each
     route id, the URL, the HTTP status, and how that route failed. A line
     that says only "restricted" is not a merge.
   - `transport_failure`: record the error category. A failed route is not an
     access wall.
   - `not_found`: record that the applicable routes found no copy. Leave the
     issue closed or labeled `not-found`. Do not file another request for the
     same id.
   - `candidates_only`: keep the locator leads. They are not inventory entries.
6. `ledger_question_count` returns an integer only for a valid `completed`
   screen, otherwise `None`. Copy a number into the ledger only after reading
   those pages.
7. After a real ledger edit, run that campaign's bookkeeping validator.
8. For outcome `verified`, ingestion is the merge. Follow
   [Ingest a fetched paper](#ingest-a-fetched-paper). Do not close the issue
   in this step.
9. For every other outcome, comment with the merge result. Close `restricted`
   or `needs-human` when the gap is recorded. Leave a `not-found` issue
   labeled `not-found` so a new catalog route can reopen it. Close an issue
   whose manifest is explicitly rejected.

`routes_to_retry` lists active applicable catalog routes absent from a
manifest. Applicability uses `document.stable_ids` only, unless the route
catalog sets `discovered_identifiers_expand_routes`. The committed catalog
leaves that flag false, so a DOI learned mid-run does not reopen earlier
routes. `should_reopen_not_found` is true only when the outcome is
`not_found` and that list is not empty. The worker performs the reopen. The
research agent does not retry those routes itself.

## Ingest a fetched paper

`fetched` means the worker verified a complete file and stopped. Nothing else
runs until an agent following this skill, or the open-question-research skill,
takes the issue. Any agent may do that. The worker does not.

The signal is the lifecycle label `fetched` on an open issue.
`ingestion_ready(labels, comments)` is that check: the only lifecycle label is
`fetched`, and the thread has neither
`<!-- fetch-ingestion-started: SESSION -->` nor
`<!-- fetch-ingestion-merged: PR_URL -->`. A `<!-- fetch-ready-for-ingestion -->`
marker on a new manifest comment says the same thing. A `fetched` issue from
before that marker still counts. Do not add a seventh label.

At the start of a research block, list open issues labeled `fetched` with the
same authenticated transport as the worker. Ingest the ones this block's
campaign or question needs. Leave the others labeled `fetched`.

Claim, then do the work, then open the pull request. Do not close the issue
when the pull request opens.

1. Post `<!-- fetch-ingestion-started: SESSION -->` with the issue number, the
   manifest id, and the PDF path from `ingest_paths`. `SESSION` is this run's
   id. It is not a product name.
2. Read the comments again. If more than one started marker is present, the
   earliest comment continues and the others stop. If the timestamps tie, the
   lower comment id continues.
3. Load the active manifest with `locate_manifests` and `consumable`. It must
   be outcome `verified` with `complete_body`.
4. Put the PDF at `ingest_paths(issue, requested_source_id)["pdf"]`, which is
   `local-extraction/literature/fetch/<issue>/<source-id>.pdf`. Copy the
   worker's `worker_local` file when this machine has it. Otherwise reacquire
   the file from the stable ids. `sha256sum` must match `artifact.sha256`, and
   `pdfinfo` must match `page_count`. Write the extracted text beside it at
   the `text` path. This is the same convention as every other source PDF:
   `local-extraction/` is gitignored, and `*.pdf` is gitignored, because
   copyrighted full texts are not git blobs. Do not `git add -f` the PDF.
   `committed_to_git` on the manifest stays false.
5. Write the manifest JSON, unchanged, to
   `literature/fetch-ingest/<issue>/manifest.json`. If the source already has
   a campaign ledger, add a row there with the hash, page count, local path,
   manifest id, and fetch issue URL. Do not edit the issue comment.
6. Screen the text under
   [open-question-research](../open-question-research/SKILL.md#harvest-questions-from-every-encountered-paper).
   Write `literature/fetch-ingest/<issue>/SCREEN.md` with the fetch issue URL,
   the manifest id, the SHA-256, the page count, a short summary of what the
   paper establishes, and either each open question with a locator or an
   explicit statement that the readable passages named no additional target.
   The manifest's `question_screen.status` stays `not_screened`. The count
   lives in the screen note and the inventory, not in an edited manifest.
7. Open a pull request that references the fetch issue. The body contains
   `Refs #<issue>` and the issue URL. Do not write `Closes`, `Fixes`, or
   `Resolves`: those would close the issue before the screen is on the
   default branch. The pull request commits the manifest copy, `SCREEN.md`,
   and any ledger row. It does not commit the PDF.

After that pull request has merged to the default branch, post
`<!-- fetch-ingestion-merged: PR_URL -->` and close the issue. A closed
`fetched` issue means the screen and the manifest copy are on the default
branch. The PDF remains at the local path; another checkout reacquires it
from the stable ids and checks the hash.

If this agent cannot open the pull request, do not post the started marker.
Leave the issue `fetched`.

## Question counts

A completed screen with question count zero is allowed only for outcome
`verified`, completeness `complete_body`, and readable extracted text. The
count equals the number of candidates with `counts_as_target` true.

These stay null. `not_screened` is only a verified readable file the research
agent has not screened. `blocked` is the status when the screen cannot run:

- `preview_only`, including a readable front-matter file
- unreadable or partial extraction
- `restricted`, `transport_failure`, `needs_human`, and `not_found`
- a verified file that has not been screened

## Secrets

Manifests and request issues store stable ids and ordinary https URLs. They do
not store signed queries, URL userinfo, cookies, authorization headers, or
cloud credentials. The validator rejects those strings and any host listed in
the route catalog's `temporary_hosts`. If a download only succeeded through a
signed URL, record the stable id and set `obtained_bytes` from the bytes you
hashed, without copying the URL.

## Validate this skill

When editing this skill, validate its frontmatter with the `skill-creator`
skill's `scripts/quick_validate.py`, using a Python that has PyYAML. Then run:

```sh
python3 scripts/validate_fetch_manifest.py --self-check
python3 scripts/validate_fetch_manifest.py \
  .agents/skills/document-acquisition-queue/examples/*.manifest.json
```

## Remaining for the finishing agent

- [ ] Choose file storage beyond the local PDF. v0.1, v0.2, and v0.3 keep `worker_local` and `committed_to_git` false. Ingestion copies the PDF to gitignored `local-extraction/literature/fetch/<issue>/` and commits the manifest and screen under `literature/fetch-ingest/<issue>/`. A release asset or bucket needs a schema bump.
- [ ] Merge one real manifest into the ledgers under the research skill, then run the campaign validator.
- [ ] Deploy a worker. Starting it on a timer or from a workflow is outside the worker skill.
- [ ] Pilot one previously unresolved UNL dissertation and one paper that is not from UNL. Keep the committed fixture as the schema control.
- [ ] Leave the six lifecycle labels as they are. Do not create or recolor them. The worker skill checks the names.
- [ ] Dry-run `parse_comment`, `locate_manifests`, `routes_to_retry`, and a `not-found` reopen on a real issue thread.
- [ ] Replace this script's schema subset if the schema grows past the keywords in `KNOWN`.
