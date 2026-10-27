---
name: document-retrieval-worker
description: "Retrieve a queued full text for any public source. Claim a fetch-request issue, try the versioned identifier-first routes with curl and a real browser, verify the PDF, extract or OCR it, and post an immutable manifest. Use for the retrieval worker, not for ledger edits or question screening."
---

# Document retrieval worker

Any agent can run this. The source may be any public paper, not one archive.
Tools are ordinary ones: `gh` or the GitHub API, `curl`, `pdfinfo`,
`pdftotext`, and `tesseract`. A browser step is a list of outcomes, not a call
to one product's browser API.

This worker does not edit canonical literature ledgers, does not open research
claim refs, and does not close the issue. The research agent merges the
manifest and closes it. How a worker is started (a person, a timer, a workflow)
is a deployment choice and is not part of this procedure.

The versioned route list is [routes.json](routes.json). Site notes are under
[references/](references/) and are read only when the source matches. The
manifest contract is the queue skill's
[schema](../document-acquisition-queue/schema/fetch-manifest.schema.json).
`python3 scripts/validate_fetch_manifest.py` checks a manifest, including that
every `route` value is in this catalog.

## Find and claim

List open issues labeled `fetch-request` in `alectionary/vibe-math`:

```sh
gh issue list --repo alectionary/vibe-math --state open --label fetch-request --limit 50
```

Before touching an issue, read it again. Skip it when `fetch-claimed`,
`fetched`, `restricted`, `needs-human`, or `not-found` is already present.
Search the title and body for the same stable id (`<!-- fetch-request: ID -->`
and each `<!-- fetch-request-alias: ID -->`). A second open issue for that id
is a duplicate: comment with the canonical issue number and stop.

Also search closed `not-found` issues when [a catalog route is new](#reopen-not-found).
Do not download a source whose active manifest is already `verified`.

Claim by commenting, then swapping labels. If the swap loses a race because
`fetch-claimed` appeared, stop.

```sh
gh issue comment NUMBER --body-file claim.md
gh issue edit NUMBER --remove-label fetch-request --add-label fetch-claimed
```

`claim.md` names the stable id and this worker's session id. It contains no
cookies, tokens, or signed URLs. The same two steps exist as GitHub API calls
(`POST /repos/alectionary/vibe-math/issues/NUMBER/comments` and
`POST /repos/alectionary/vibe-math/issues/NUMBER/labels` plus deleting
`fetch-request`) when `gh issue` is unavailable.

## Choose routes

Sort [routes.json](routes.json) by `order`. A route applies when:

- `scope` is `generic` and `requires` is empty, or the document has a stable id
  of one of those schemes.
- `scope` is `site` and an `archive_record` value starts with one of
  `requires_prefixes`.

Skip a route that does not apply. Skip a route id already present on the
issue's active manifest; copy those entries forward and do not fetch them again.
Record every route you do run. The manifest field `route` is the catalog id,
such as `openalex-oa@1`. The field `id` is a unique attempt slug. Two attempts
may share a catalog id when they hit two URLs. A changed procedure gets a new
version (`unl-bepress-browser@2`); do not rewrite the meaning of `@1`.

`status` `active` is what you try. `retired` stays in the file so old manifests
still validate, and it is not tried and does not reopen an issue.

Identifier-first order:

1. `doi-resolution@1` when a DOI is present. `curl -L` on `https://doi.org/<DOI>`.
2. `arxiv-pdf@1` when an arXiv id is present. `curl` the arXiv PDF for that id.
3. `openalex-oa@1`. Read OpenAlex open-access locations for the DOI, arXiv id, or title.
4. `unpaywall-oa@1` when a DOI is present. Read Unpaywall open-access locations.
5. `publisher-landing@1`. `curl` the publisher landing page and its public download control.
6. Site routes whose `order` falls here. Read the matching file in
   [references/](references/) before using them. Today that is
   [UNL bepress, ProQuest, and CORE](references/unl-proquest.md).
7. `institutional-repository@1`. `curl` a repository record and its public file.
8. `author-page@1`. `curl` an author or departmental manuscript page.
9. `browser-download@1`, and any site browser route, for pages that answered
   with a bot check, a cookie wall, or a challenge. If no such page remains,
   record the browser route once with `error_category` `not_found` and say that
   no challenge page was left. Do not pretend a browser was opened.

Headless work uses `curl`. Follow redirects. A 403 challenge page is
`bot_mitigation`, not `restricted` and not `not_found`. A connection timeout or
a browser that never loads a page is a transport error. A 404 or an API result
with no open-access location is `not_found` on that route. A login, purchase,
or campus-only wall on a page you actually opened is `restricted` on that route.

Store ordinary https URLs and stable ids. Drop signed query strings, URL
userinfo, cookies, and authorization headers. Hosts in the catalog's
`temporary_hosts` list never go in the manifest. If the bytes came from a
signed URL, hash the bytes and record the stable id instead of the URL.

## Browser outcomes

Use a real browser only for `tool` `browser` routes. The outcomes, in order,
are the whole interface:

1. Open the record URL.
2. If a cookie banner blocks the download, dismiss it.
3. If the site presents a bot check, complete that check.
4. Activate the page's Download or Download PDF control.
5. Save the PDF bytes that the control returns.

A worker with any browser may perform those outcomes. Do not bind the step to
a vendor API, an extension id, or a browser product. If the browser cannot
start, record `browser_host_unavailable` and stop that route.

## Verify identity and completeness

Run `pdfinfo` for the page count and `sha256sum` for the hash. Then check the
file against the request:

- The title, author, and year on the first pages match the request. A different
  work with a similar title is `identity_mismatch`, not a success.
- The file includes the body, references, and final pages. A title page, a
  front-matter booklet, or a publisher preview is `preview_only` with
  classification `front_matter_only` or `preview`. Keep that file's hash so it
  is not later treated as the full text.
- A PDF header by itself is not completeness evidence. Write what you checked
  into `completeness.evidence`.

`verified` requires one route with `obtained_bytes` true, `error_category`
null, classification `complete_body`, and `identity_matched` true.

## Extract text

Run `pdftotext -layout` on the PDF. If the text is empty, tiny relative to the
page count, or visibly the wrong glyphs, run `tesseract` on the pages.

- Readable native text: `method` `born_digital`, `ocr_applied` false, `status`
  `extracted`, and the text sha256.
- Readable OCR text: `method` `ocr` or `mixed`, `ocr_applied` true, the engine
  name, `status` `extracted`.
- OCR still unreadable: `status` `unreadable`, `readable` false, a reason, and
  question count null. Do not use `unreadable` when OCR was not tried; use
  `needs_human`.

Question screening stays with the research agent. Leave `question_screen.status`
at `not_screened` or, when you only attach locator leads, `candidates_only`
with `question_count` null. `screen_owner` is `research_agent`. Do not set
`completed`.

## Post the manifest and relabel

Validate the JSON, then comment. The marker id equals `manifest_id`. Do not
edit the comment later. A correction is a new comment whose `supersedes` names
the previous id and which repeats earlier route rows unchanged, then appends
new attempts.

```sh
gh issue comment NUMBER --body-file manifest.md
gh issue edit NUMBER --remove-label fetch-claimed --add-label LABEL
```

`terminal_label` in `scripts/validate_fetch_manifest.py` is the label map:

| Outcome | Label | `retryable` |
|---|---|---|
| `verified` | `fetched` | false |
| `restricted` | `restricted` | false |
| `preview_only` | `needs-human` | false |
| `needs_human` | `needs-human` | false |
| `not_found` | `not-found` | false |
| `transport_failure` | stay on `fetch-claimed` | true, until the bound below |
| `transport_failure` | `needs-human` | false, once the bound is spent |

`not_found` means every applicable active route was attempted, none obtained
bytes, and none hit a transport error, a restriction, or a preview. The
validator rejects a `not_found` manifest that omits an applicable active route.
Question count stays null.

`producer.role` is `retrieval_worker`, and `issue` names the repository,
number, issue URL, and comment URL. `campaign_id` is null when the request has
no campaign.

## Bounded retries

Retry only `transport_failure`, and only the catalog route ids that failed
transport. Three attempts of the same route id is the bound. Count attempts
across manifests on this issue; a copied route row counts. After the third,
post `transport_failure` with `retryable` false and move to `needs-human`.

Do not retry `not_found`, `restricted`, `preview_only`, or `verified` on the
same route ids. A new catalog version is a different id and starts at zero
attempts.

## Reopen not-found

When `routes.json` gains an active route, list issues labeled `not-found`
(open and closed). For each, load every manifest on the thread. If
`applicable_missing` reports ids, and those ids apply to that source:

1. Reopen the issue if it is closed.
2. Remove `not-found` and add `fetch-request`, then claim it as above.
3. Try only the missing route ids. Copy the previous route rows into the new
   manifest, append the new attempts, set `supersedes` to the previous
   `manifest_id`, and relabel from the new outcome.

If nothing is missing, leave the issue on `not-found`. Do not reopen `fetched`,
`restricted`, or `needs-human` just because the catalog grew. A preview or a
restriction is not a missing route.

`routes_to_retry(manifest)` in the validator is this missing-id list.
`should_reopen_not_found(manifest)` is true only for outcome `not_found` with a
non-empty list.

## Labels

These six labels were requested for `alectionary/vibe-math`. Creating them from
this environment returned HTTP 403, so run:

```sh
gh label create fetch-request --repo alectionary/vibe-math --color fbca04 \
  --description "Complete text queued for a retrieval worker"
gh label create fetch-claimed --repo alectionary/vibe-math --color 0052cc \
  --description "A retrieval worker has claimed this source"
gh label create fetched --repo alectionary/vibe-math --color 0e8a16 \
  --description "Verified complete file; manifest is ready to merge"
gh label create restricted --repo alectionary/vibe-math --color d93f0b \
  --description "Checked public routes are access-restricted"
gh label create needs-human --repo alectionary/vibe-math --color 5319e7 \
  --description "Preview, exhausted transport, or a person must choose a route"
gh label create not-found --repo alectionary/vibe-math --color 6e7781 \
  --description "Applicable public routes found no copy; reopen when a new route is added"
```

Exactly one lifecycle label is on the issue. Remove the previous one when
adding the next.

## Validate this skill

When editing this skill, run the `skill-creator` `scripts/quick_validate.py`
against this directory, with PyYAML available. Then run:

```sh
python3 scripts/validate_fetch_manifest.py --self-check
```
