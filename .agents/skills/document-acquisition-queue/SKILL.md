---
name: document-acquisition-queue
description: "Queue a complete public source this environment cannot retrieve. File one GitHub issue labeled fetch-request for any paper, continue independent work, and later merge the retrieval worker's immutable manifest. Use during open-question-research when full text is still unverified after the documented routes."
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
`manifest_version` `0.2`. `0.1` stays valid for manifests already posted.
The committed fixture is
[unl-aai3402936.manifest.json](examples/unl-aai3402936.manifest.json): a verified
positive control, 283 pages, born-digital, no OCR, question count null,
`discovered_identifiers` empty. It is `producer.role` `example`, not a live
posting and not a question screen.

Check a file with `python3 scripts/validate_fetch_manifest.py`. `--self-check`
covers that control, a front-matter preview, an unreadable extraction, a
`not_found` result, catalog route ids, secret rejection, an omitted
`comment_url`, discovered identifiers that do not backfill earlier routes,
and evidence that keeps Unicode `text_characters` distinct from byte counts.

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
`"labels": ["fetch-request"]`. Title: `fetch: 10.1000/example.doi`. The
lifecycle label on a new issue is `fetch-request`.

```markdown
<!-- fetch-request: 10.1000/example.doi -->
<!-- fetch-request-alias: 1234.56789 -->

- Stable source ID: 10.1000/example.doi
- Aliases: arxiv 1234.56789; url https://example.test/paper
- Title: Example paper title
- Author: Author Name
- Year: 2020
- Type: article
- Campaign: (omit when the paper is not in a campaign)
- Priority: normal
- Blocker category: bot_mitigation
- Routes already attempted: curl https://doi.org/10.1000/example.doi returned a bot check; browser did not start
- What failed: this environment cannot verify the complete file
```

Stable ids use the manifest schemes `doi`, `arxiv`, `url`, `archive_record`,
`campaign_record`, and `other`. An archive record looks like
`prefix:value`. Prefixes for a particular archive are defined in that site's
worker reference, not here.

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

The research agent closes the issue after a successful merge. The worker does
not close it. The worker does reopen a closed `not-found` issue when the route
catalog gains an applicable route that the manifests do not contain.

## Manifest

The worker posts one comment and does not edit it. Start the comment with
`<!-- fetch-manifest: MANIFEST_ID -->`, then a `json` fence whose object has the
same `manifest_id`. A correction is a later comment whose `supersedes` names
the replaced id. The committed fixture is a complete example of the object.
Live postings use `manifest_version` `0.2`.

Required content:

- `outcome`: `verified`, `preview_only`, `restricted`, `transport_failure`,
  `needs_human`, or `not_found`.
- Stable ids from the request, on `document.stable_ids`. `campaign_id` is null
  when there is no campaign.
- `discovered_identifiers`: ids learned during the run, each with the catalog
  route that surfaced it. Empty when nothing new appeared. They are not copied
  into `document.stable_ids`, and they do not make earlier routes applicable.
- `routes_tried`: catalog `route` (`openalex-oa@1`), attempt `id`, https URL,
  method, UTC `Z` timestamp, HTTP status, `error_category`, and whether that
  route obtained bytes. The route id must be in the worker
  [route catalog](../document-retrieval-worker/routes.json). Log a route only
  when it was run. After complete bytes are stored, do not log a skipped route.
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

`screen_owner` is `research_agent`. The worker may set `candidates_only` with
`question_count` null. It does not set `completed`. `producer.role` `example`
is the fixture and must not be merged. `consumable()` reports that.
`producer.role` for a live posting is `retrieval_worker`.

Versions `0.1` and `0.2` allow storage kind `worker_local` only. `0.2` requires
`discovered_identifiers` and does not require `issue.comment_url`.

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
   `0.1` manifest that still has `comment_url`, and a `0.2` manifest that
   omits it.
4. Resolve an existing source from the stable ids. If none matches, record a
   lead in the working notes and do not create a canonical source from the
   manifest alone.
5. Merge retrieval evidence only.
   - `verified` and `complete_body`: record the hash, page count, stable ids,
     discovered identifiers, routes, and extraction status. Keep
     `text_characters` as a Unicode character count and `byte_length` as PDF
     bytes.
   - `verified` and `readable` false: keep the file hash and leave
     `question_count` null.
   - `preview_only` or front matter: store the partial hash so it cannot be
     reused as the full text.
   - `restricted`: record a restriction on the checked routes only.
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
8. Comment with the merge result. Close the issue when the manifest is merged
   or explicitly rejected. Leave a `not-found` issue labeled `not-found` so a
   new catalog route can reopen it.

`routes_to_retry` lists active applicable catalog routes absent from a
manifest. Applicability uses `document.stable_ids` only, unless the route
catalog sets `discovered_identifiers_expand_routes`. The committed catalog
leaves that flag false, so a DOI learned mid-run does not reopen earlier
routes. `should_reopen_not_found` is true only when the outcome is
`not_found` and that list is not empty. The worker performs the reopen. The
research agent does not retry those routes itself.

## Question counts

A completed screen with question count zero is allowed only for outcome
`verified`, completeness `complete_body`, and readable extracted text. The
count equals the number of candidates with `counts_as_target` true.

These stay null, with screen status `not_screened` or `blocked`:

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
  .agents/skills/document-acquisition-queue/examples/unl-aai3402936.manifest.json
```

## Remaining for the finishing agent

- [ ] Choose file storage. v0.1 and v0.2 are `worker_local` with `cross_machine` false. A release asset or bucket needs a schema bump.
- [ ] Merge one real manifest into the ledgers under the research skill, then run the campaign validator.
- [ ] Deploy a worker. Starting it on a timer or from a workflow is outside the worker skill.
- [ ] Pilot one previously unresolved UNL dissertation and one paper that is not from UNL. Keep the committed fixture as the schema control.
- [ ] Leave the six lifecycle labels as they are. Do not create or recolor them. The worker skill checks the names.
- [ ] Dry-run `parse_comment`, `locate_manifests`, `routes_to_retry`, and a `not-found` reopen on a real issue thread.
- [ ] Replace this script's schema subset if the schema grows past the keywords in `KNOWN`.
