---
name: document-retrieval-worker
description: "Retrieve a queued full text for any public source. Claim a fetch-request issue, try the versioned identifier-first routes with curl and a real browser, fall back to the Wayback availability API when an open-access link has moved, hand off when this worker has no browser, verify the PDF, extract or OCR it, and for an equation that matters render the page and attach operators by glyph coordinates. The fetched label is the signal that ingestion can start. Use for the retrieval worker, not for ledger edits, question screening, or the ingestion pull request."
---

# Document retrieval worker

Any agent can run this. The source may be any public paper, not one archive.
GitHub access is an authenticated `gh`, the GitHub REST API, or a connector
that can comment and replace an issue's label set. An unauthenticated `gh` is
not enough. File bytes use `curl`, `pdfinfo`, `pdftotext`, and `tesseract`.
A browser step is a list of outcomes, not a call to one product's browser API.

This worker does not edit canonical literature ledgers, does not open research
claim refs, does not ingest the file, and does not close the issue. After a
verified manifest it sets the lifecycle label to `fetched` and stops. That
label is the signal that ingestion can start. The research agent copies the
manifest, stores the PDF at the conventional local path, writes the question
screen, and opens the pull request. How a worker is started (a person, a timer,
a workflow) is a deployment choice and is not part of this procedure.

The versioned route list is [routes.json](routes.json). Site notes are under
[references/](references/) and are read only when the source matches. The
manifest contract is the queue skill's
[schema](../document-acquisition-queue/schema/fetch-manifest.schema.json).
`python3 scripts/validate_fetch_manifest.py` checks a manifest, including that
every `route` value is in this catalog.

## GitHub transport

Pick one authenticated transport before listing or claiming. A public list
that succeeds without credentials is not a pass: stop, and do not comment.

1. **gh.** The `gh` binary is logged in to `github.com`. Preflight is
   `gh auth status`. It must exit 0 and name an account. If the command is
   missing or exits non-zero, do not use `gh`.
2. **REST.** `https://api.github.com` with an `Authorization` header the
   client holds. Preflight is `GET /repos/alectionary/vibe-math/issues/NUMBER`
   returning 200 from an authenticated client. Treat the call as anonymous,
   and stop, when `X-RateLimit-Limit` is 60 and neither `X-OAuth-Scopes` nor
   `X-Accepted-GitHub-Permissions` is present. `GET /user` is not the
   preflight: a token that can edit issues may receive 403 there.
3. **Label-replace connector.** Any client that can read the issue body,
   comments, and labels, post a comment, and replace the full label set in
   one write. Preflight is an authenticated read of the issue. If the
   connector has no credential, stop.

The `Authorization` header, tokens, and cookies stay in the client. They never
go into the issue, the handoff comment, or the manifest. Use the same
transport for the whole issue. If a later write returns 401 or 403, stop.

## Find and claim

Sweep unlabeled paper requests before the labeled list. Search open issues
whose title starts with `fetch:` (`gh issue list --repo alectionary/vibe-math
--state open --search "fetch: in:title" --limit 50`, or the REST search
`GET /search/issues?q=repo:alectionary/vibe-math+is:issue+is:open+fetch:+in:title`).
`label_sweep_action` is the decision:

- `add-fetch-request`: the title or the `<!-- fetch-request: ID -->` marker
  names a paper, and the issue has no lifecycle label. Add `fetch-request`.
  A marker in the body is not a substitute for the label. The 2026-11-02
  backlog was filed this way.
- `help-issue`: the request is not a paper. Code, a program, a supplement, a
  dataset, or a file offered only by emailing the author uses a help issue.
  Comment that the research agent files the help issue, do not add
  `fetch-request`, and do not claim. `other:mi-2010-sas-iml-qtl` is this case:
  the programs are available only by email, and there is no public URL.
- `claim-pool`: the only lifecycle label is already `fetch-request`.
- `skip`: this is not a fetch request, or another lifecycle label is already set.

Then list open issues labeled `fetch-request` in `alectionary/vibe-math` with
the transport that passed preflight:

```sh
gh issue list --repo alectionary/vibe-math --state open --label fetch-request --limit 50
```

The REST equivalent is
`GET /repos/alectionary/vibe-math/issues?state=open&labels=fetch-request&per_page=50`.

Before touching an issue, read it again. Skip it when `fetched`, `restricted`,
`needs-human`, or `not-found` is already present. Skip `fetch-claimed` unless
the thread has a [browser handoff](#browser-handoff) and this worker can open
a browser. Search the title and body for the same stable id
(`<!-- fetch-request: ID -->` and each `<!-- fetch-request-alias: ID -->`).
A second open issue for that id is a duplicate: comment with the canonical
issue number and stop.

Also search closed `not-found` issues when [a catalog route is new](#reopen-not-found).
Do not download a source whose active manifest is already `verified`.

Claim by commenting, then setting the lifecycle label to `fetch-claimed` with
the [label write](#lifecycle-labels). Read the labels first. `claim_blocked`
in `scripts/validate_fetch_manifest.py` is that check: a new claim proceeds
only when the only lifecycle label is `fetch-request`. If `fetch-claimed` is
already present and this is not a browser-handoff resume, stop without writing.

```sh
gh issue comment NUMBER --body-file claim.md
```

REST posts the same body:
`POST /repos/alectionary/vibe-math/issues/NUMBER/comments` with `{"body": "..."}`.
A connector creates a comment with that body.

`claim.md` names the stable id and this worker's session id. It contains no
cookies, tokens, or signed URLs.

## Lifecycle labels

The end state after every label write is exactly one lifecycle label, and it
is the label for this step. Other labels on the issue stay.
`label_end_state_ok` is that check. `replace_label_set` is the set a
replace-set client writes. `terminal_label` is the outcome map.

| Step | End state |
|---|---|
| claim | `fetch-claimed` |
| `verified` | `fetched` |
| `restricted` | `restricted` |
| `preview_only`, `needs_human`, or a spent transport failure | `needs-human` |
| `not_found` | `not-found` |
| `transport_failure` with `retryable` true | `fetch-claimed` |
| reopen for a new route, before the new claim | `fetch-request` |
| browser handoff | `fetch-claimed` |

Read, then write, then read again:

1. Read the label names.
2. A new claim stops without writing when `claim_blocked` is true. A browser
   resume stops unless the only lifecycle label is `fetch-claimed`. A final
   relabel writes only from the lifecycle label this worker already holds.
3. Write with one variant below.
4. Read again. Confirm exactly one lifecycle label, and that it is the name
   you wrote. If the read shows two lifecycle labels, none, or a different
   one, stop. Do not download, and do not post a manifest, on a claim that
   did not stick.

**gh** adds and removes by name:

```sh
gh issue edit NUMBER --repo alectionary/vibe-math --remove-label OLD --add-label NEW
```

**REST** adds the new name, then deletes the previous name:

```text
POST /repos/alectionary/vibe-math/issues/NUMBER/labels
{"labels": ["NEW"]}

DELETE /repos/alectionary/vibe-math/issues/NUMBER/labels/OLD
```

**Replace-set** writes the full set once. Read the names, drop every lifecycle
label, keep every other label, and append the new lifecycle label. `PUT` on
the labels collection, or `PATCH` on the issue with a `labels` array, both
replace the whole set. Do not send only the new lifecycle label through a
replace-set client; that removes unrelated labels.

```text
PUT /repos/alectionary/vibe-math/issues/NUMBER/labels
{"labels": ["NEW", "any-non-lifecycle-label"]}
```

## Choose routes

Sort [routes.json](routes.json) by `order`. A route applies when:

- `scope` is `generic` and `requires` is empty, or the document has a stable id
  of one of those schemes.
- `scope` is `site` and an `archive_record` value starts with one of
  `requires_prefixes`.

The id set is `document.stable_ids` only. `applicability` in the catalog says
the same thing: `identifier_source` is `document.stable_ids`,
`discovered_identifiers_expand_routes` is false, and
`backfill_earlier_routes` is false. `routes_to_retry` uses that rule.

`requires_match` says how to read `requires`. `any` means at least one listed
scheme: `["doi", "url"]` is a DOI or a URL, not both. `all` means every listed
scheme. `always` means the route is not gated on a scheme, and `requires` is
empty. `prefixes` means an `archive_record` value starts with one of
`requires_prefixes`. A site route uses `prefixes`. Empty `requires` with
`always` is filled in; it is not a missing field.

Skip a route that does not apply. Skip a route id already present on the
issue's active manifest; copy those entries forward and do not fetch them again.
Record every route you do run. The manifest field `route` is the catalog id,
such as `openalex-oa@1`. The field `id` is a unique attempt slug. Two attempts
may share a catalog id when they hit two URLs. A changed procedure gets a new
version (`unl-bepress-browser@2`); do not rewrite the meaning of `@1`.

`status` `active` is what you try. `retired` stays in the file so old manifests
still validate, and it is not tried and does not reopen an issue.

Identifier-first order:

1. `doi-resolution@1` when a DOI is present on the request. `curl -L` on `https://doi.org/<DOI>`.
2. `arxiv-pdf@1` when an arXiv id is present on the request. `curl` the arXiv PDF for that id.
3. `openalex-oa@1`. Read OpenAlex open-access locations for the DOI, arXiv id, or title.
4. `unpaywall-oa@1` when a DOI is present on the request. Read
   [Unpaywall](references/unpaywall.md). The contact address is
   `UNPAYWALL_EMAIL`. The manifest URL has no `email` query. If the variable
   is unset, log this route with `error_category` `other` and do not call the
   API. That row is not `not_found`.
5. `pmc-oa-package@1` when the request has `archive_record` `pmcid:PMC` plus
   digits, or when `openalex-oa@1` or `unpaywall-oa@1` in this run named a
   PMCID. Read [the PMC Open Access package](references/pmc-oa.md). This is a
   later route, not a backfill. Log it when you run it. A 0.2 manifest that
   stored this host on `institutional-repository@1` stays as posted.
6. `publisher-landing@1` when a DOI or a canonical URL is on the request.
   `curl` the publisher landing page and its public download control.
7. Site routes whose `order` falls here. Read the matching file in
   [references/](references/) before using them. Today that is
   [UNL bepress, ProQuest, and CORE](references/unl-proquest.md).
8. `institutional-repository@1` when a repository URL or an `archive_record`
   is on the request. `curl` that record and its public file. A PMC Open
   Access package is `pmc-oa-package@1`, not this route.
9. `author-page@1`. The author string is on every request, so `requires_match`
   is `always`. Log it as [Author page](#author-page) describes. If complete
   bytes are already stored, skip it and do not log it.
10. `wayback-available@1` when the request has a DOI or a URL. `requires_match`
    is `any`: either scheme is enough, and both are not required. Call the
    API only when an earlier curl route followed an open-access link onto a
    redirect, an empty platform, or a page with no file. The procedure is
    [Wayback fallback](#wayback-fallback). If no such link appeared, log this
    route once with `error_category` `not_found` and say that the availability
    API was not called. Do not invent a URL. If complete bytes are already
    stored, skip this route and do not log it.
11. `browser-download@1`, and any site browser route, only when a page you
   opened answered with a bot check, a cookie wall, or a challenge, and no
   route has obtained complete bytes. If no complete bytes were obtained and
   no such page remains, record the browser route once with `error_category`
   `not_found` and say that no challenge page was left. Do not pretend a
   browser was opened. If complete bytes were already stored, skip this route
   and do not log a synthetic `not_found`. `log_skipped_routes_after_complete_bytes`
   is false.

Headless work uses `curl`. Follow redirects. A 403 challenge page is
`bot_mitigation`, not `restricted` and not `not_found`. A connection timeout or
a browser that never loads a page is a transport error. A 404 or an API result
with no open-access location is `not_found` on that route. A login, purchase,
or campus-only wall on a page you actually opened is `restricted` on that route.
Name that route, the URL, the HTTP status, and the wall the page showed. A
restriction with no route is not a record. See
[Restricted sources](#restricted-sources).

Store ordinary https URLs and stable ids. Drop signed query strings, URL
userinfo, cookies, and authorization headers. Hosts in the catalog's
`temporary_hosts` list never go in the manifest. If the bytes came from a
signed URL, hash the bytes and record the stable id instead of the URL.

## Identifiers discovered mid-run

A route may surface a DOI, arXiv id, or other stable id the request did not
carry. Append it to `discovered_identifiers` with `scheme`, `value`, and the
catalog `route` that surfaced it. That route must also be a row in
`routes_tried`, because you ran it. On `manifest_version` `0.2` and `0.3` the
array is required; use `[]` when nothing new appeared.

Do not copy a discovered id into `document.stable_ids`. Do not run earlier
routes that would have applied only if the request had carried that id. A DOI
learned from `openalex-oa@1` after `arxiv-pdf@1` succeeded does not add
`doi-resolution@1` or `unpaywall-oa@1`.

After a route obtains complete bytes (`obtained_bytes` true and
`error_category` null), do not download another copy. Log a later route only
when you actually ran it, such as an identifier lookup that discovered a DOI.
Do not log a route you skipped.

## Author page

`author-page@1` looks for a manuscript on a page the author or the department
controls. It is not a second log of the publisher or repository route.

Log one row when you run it:

- `url` is the author page, lab page, or departmental page you opened. If no
  such page exists, `url` is the search URL you actually requested.
- `http_status` is the status of that page.
- `obtained_bytes` is true only when the file from that page is the complete
  work. `error_category` is then null.
- `not_found` when the page has no manuscript of this work: citation only,
  data or code only, a different work, or no page. The notes name which of
  those you saw.
- `restricted` when a manuscript link on that page is a login, a purchase, or
  a campus-only wall. Name the wall.

Do not point this row at a URL another route already logged unless that URL is
the author or departmental page. Do not log the route after complete bytes are
stored.

## Browser outcomes

Use a real browser only for `tool` `browser` routes. The outcomes, in order,
are the whole interface:

1. Open the record URL.
2. If a cookie banner blocks the download, dismiss it.
3. If the site presents a bot check, complete that check.
4. Activate the page's Download or Download PDF control. If the control opens
   the PDF inline in the viewer, save the bytes from that viewer.
5. Save the PDF bytes that the control or the viewer returns.

A worker with any browser may perform those outcomes. Do not bind the step to
a vendor API, an extension id, or a browser product. If a browser was supposed
to start and fails before any page loads, record `browser_host_unavailable`
and stop that route. A worker that has no browser does not use that category;
it follows [browser handoff](#browser-handoff).

## Browser handoff

This is a documented state, not a final manifest. Use it when this worker has
no browser and a browser route is still required: a page you opened returned
`bot_mitigation`, a cookie wall, or a challenge, or a site route's tool is
`browser` and headless did not obtain the bytes. Do not use it after another
route already obtained complete bytes.

Post a progress comment, not a manifest. Start it with
`<!-- fetch-browser-handoff -->`. Include:

- the stable id
- this worker's session id
- each route already run: catalog id, https URL, HTTP status, `error_category`, and whether it obtained bytes
- the record URL
- the download URL
- the relative `worker_local` target locator the resume should fill

An absolute path may be added when the resume is expected on the same
filesystem. The manifest locator stays the relative path. The comment holds
no cookies, tokens, or signed URLs.

Leave the lifecycle label `fetch-claimed`. Do not post `transport_failure`
because this worker never had a browser.

A worker that can open a browser, including the same agent once a browser is
available, resumes that issue instead of skipping `fetch-claimed`. Read the
latest handoff. If the download URL or the target locator is missing, stop
and leave the label. Do not guess a path.

Resume race, the same read-then-write shape:

1. Post `<!-- fetch-browser-resume: SESSION -->` naming the download URL and the target locator.
2. Read the comments again. If more than one resume marker is present, the earliest comment continues and the others stop without a manifest. If the timestamps tie, the lower comment id continues.
3. Perform the browser outcomes and write the bytes to the target locator.
4. Post one manifest. Copy the handoff's route rows, then append the browser attempt. `supersedes` is null when no manifest was posted yet.
5. Relabel from the manifest outcome.

If this worker also has no browser, leave the handoff comment and
`fetch-claimed`. Do not post a second handoff that drops the URLs.

A handoff comment is immutable, so it stays on the issue after the file is
fetched. The resume that finishes it posts a new comment. Start that comment
with `<!-- fetch-browser-handoff-resolved: SESSION -->`, then the manifest
marker. `SESSION` is the worker session named in the handoff. Do not edit the
handoff comment.

`open_handoff_sessions` is the list still waiting. A session leaves that list
when a later comment has the resolved marker for that session, or when a later
comment contains a fetch-manifest marker. A manifest posted on 2026-11-02
after a handoff already resolves that handoff; do not edit those issues and
do not add a marker after the fact. Resume only an open handoff on an issue
whose only lifecycle label is `fetch-claimed`. A terminal label means the
handoff is stale. Leave it.

```markdown
<!-- fetch-browser-handoff -->

- Stable id: `10.1000/example.doi`
- Worker session: `SESSION`
- Record URL: https://example.test/record
- Download URL: https://example.test/download
- Target locator: `worker/ISSUE/paper.pdf`
- Routes already run:
  - `publisher-landing@1` https://example.test/download HTTP 403, `bot_mitigation`, no bytes
```

## Verify identity and completeness

Run `pdfinfo` for the page count and `sha256sum` for the hash. Then check the
file against the request:

- The title, author, and year on the first pages match the request. A different
  work with a similar title is `identity_mismatch`, not a success.
- The file includes the body, references, and final pages. A title page, a
  front-matter booklet, or a publisher preview that you saved is `preview_only`
  with classification `front_matter_only` or `preview`. Keep that file's hash
  so it is not later treated as the full text.
- A preview you saw and did not save is not `preview_only`. There is no hash.
  ProQuest's watermarked Document Preview is this case when the bytes were not
  downloaded. Log that route with `error_category` `preview_only`,
  `obtained_bytes` false, and notes that name what was shown and say the
  preview was not saved (not saved, not downloaded, not stored, or no preview
  hash). `artifact` is null. `completeness.classification` is `not_obtained`.
  `completeness.preview` stays false: that flag means a stored preview file.
  Outcome is `needs_human`.
- A PDF header by itself is not completeness evidence. Write what you checked
  into `completeness.evidence`.

`artifact.byte_length` is the PDF size in bytes. `extraction.text_characters`
is the number of Unicode code points in the extracted string. It is not the
PDF size and not the UTF-8 byte length of a `.txt` file. Evidence that cites
either number names the unit: `Unicode characters` or `bytes`. On
`manifest_version` `0.2` or `0.3`, a number next to the wrong unit fails
validation. A `0.1` manifest is not rejected for older wording.

`verified` requires one route with `obtained_bytes` true, `error_category`
null, classification `complete_body`, and `identity_matched` true.

## Extract text

Run `pdftotext -layout` on the PDF. If the text is empty, tiny relative to the
page count, or visibly the wrong glyphs, run `tesseract` on the pages.
`text_characters` is the length of that Unicode string.

- Readable native text: `method` `born_digital`, `ocr_applied` false, `status`
  `extracted`, and the text sha256.
- Readable OCR text: `method` `ocr` or `mixed`, `ocr_applied` true, the engine
  name, `status` `extracted`.
- OCR still unreadable: `status` `unreadable`, `readable` false, a reason, and
  question count null. Do not use `unreadable` when OCR was not tried; use
  `needs_human`.

Question screening stays with the research agent. `screen_owner` is
`research_agent`. Do not set `completed`.

`not_screened` means the file can be screened and has not been. Use it only
when the outcome is `verified` and the extraction is readable. Question count
null, candidates empty. Locator leads on that file are `candidates_only`,
still with question count null.

`blocked` means a screen cannot be done from what this run obtained. Use it
for `preview_only`, `restricted`, `transport_failure`, `needs_human`, and
`not_found`, and for a verified file that is unreadable or partial. Question
count null, candidates empty. A missing file is blocked. A verified readable
file is not blocked.

An equation the investigation will cite is not finished at `pdftotext`. Follow
[Equations in the text layer](#equations-in-the-text-layer).

## Equations in the text layer

A PDF written with Word Equation Editor or MathType often stores Symbol-font
operators in the Private Use Area. On the page, the glyph is a minus, a plus,
an equals, or a piece of a bracket. In the text layer the same glyph is a
private-use code:

| Code | What the page shows |
|---|---|
| U+F02D | minus, Symbol slot `0x2D` |
| U+F02B | plus, Symbol slot `0x2B` |
| U+F03D | equals, Symbol slot `0x3D` |
| U+F0E6–U+F0FB | parenthesis and bracket pieces, Symbol slots `0xE6`–`0xFB` |

Those operators are not in reading order with the digits. A matrix row can
come out of `pdftotext` with no signs, while the minus and plus codes are
emitted on other lines. An extractor that then invents one leading minus, or
that drops every sign, is reading the text layer. It is not reading the page.

For any equation that matters, render the page and attach each operator by
its glyph coordinates. `pdftotext` is not the evidence for a sign.

```sh
pdftoppm -png -r 600 -f PAGE -l PAGE SOURCE.pdf page
```

The worked checks are
[measure_glyphs.py](../../../formalization/correlated-residuals/simulation/measure_glyphs.py),
which compares stored character boxes with the PDF, and
[crop_equation7.py](../../../formalization/correlated-residuals/paper/figures/crop_equation7.py),
which runs `pdftoppm -png -r 600` and crops the equation. The replication
skill says how those crops enter the note.

## Wayback fallback

`wayback-available@1` is the fallback for a moved open-access link. Use it
after a curl route followed that link onto a redirect, an empty new journal
platform, or a page that is not the file. Skip it when complete bytes are
already stored, and do not log the skip.

1. Take the ordinary https URL that moved. Drop signed query strings.
2. Ask the availability API. Percent-encode the URL.

```sh
curl -fsSL "https://archive.org/wayback/available?url=ENCODED_URL"
```

3. Read `archived_snapshots.closest`. If `available` is not true, this
   attempt is `not_found`. Say that the API returned no snapshot.
4. Download the raw file, not the replay wrapper. `closest.url` is the
   replay page. The `id_` form has no slash between the timestamp and `id_`:

```text
https://web.archive.org/web/TIMESTAMPid_/ORIGINAL_URL
```

5. Run `pdfinfo` on the bytes. An archived HTML landing page is not the
   paper. Record the original URL, the timestamp, the `id_` URL, the HTTP
   status, and whether the bytes were a complete PDF.

The 2008 New Prairie Press paper, DOI `10.4148/2475-7772.1095`, is the case
this fallback is for: its open-access URL redirected to an empty new journal
platform. Query the availability API with the URL that moved, then fetch the
snapshot with the `id_` form.

## Restricted sources

When the outcome is `restricted`, name every route that failed and how it
failed. Each such `routes_tried` row has the catalog id, the https URL, the
HTTP status, `error_category` `restricted`, and a note that names the wall
actually shown: a login page, a purchase page, or a campus-only notice. A
manifest note that says only "restricted" is not enough. A route that failed
for another reason keeps its own `error_category`. A restriction on one route
does not cover a route that was not opened.

## Post the manifest and relabel

Validate the JSON, then comment. `manifest_version` is `0.3`. Versions `0.1`
and `0.2` stay valid for comments already posted. Do not edit a comment to
bump its version. The marker id equals `manifest_id`. A correction is a new
comment whose `supersedes` names the previous id and which repeats earlier
route rows unchanged, then appends new attempts.

On `0.3`, every route has `attempted_by`. Use null when `producer` ran that
attempt. When another worker session ran it, set `{"role": "retrieval_worker",
"session": "SESSION"}`. `SESSION` is the opaque id from that run, not a product
name. A browser resume copies the handoff rows and sets `attempted_by` on the
rows the handoff session ran. The resume's own rows use null when the resume
session is `producer.name`. Do not set `attempted_by.session` equal to
`producer.name`.

`campaign_id` is the investigation's spelling: two or more hyphen-separated
segments of letters and digits. `unl-sem`, `L-F102-correlated-residuals`,
`L-F91-c16-unrestricted-width`, and `UNL-SEM-2001` are all valid. Null when
the request names no campaign. A `0.1` or `0.2` comment that stored null
because the old all-caps pattern rejected the issue's campaign is not
rewritten. `migrate_campaign_id(posted, issue_campaign)` is the id a new
manifest stores.

`requested_source_id` may be a DOI that contains parentheses, such as
`10.1016/0095-8956(84)90023-6`. Scheme `other` is either `prefix:value` or a
bare token with no colon, such as `UNL-SEM-D013`. A bare token does not need
an invented prefix.

When this comment finishes a browser handoff, the resolved marker comes first.
When the outcome is `verified`, the ready marker comes before the manifest
marker. The ready marker does not ingest the file. It tells the next reader
why the label is `fetched`.

```markdown
<!-- fetch-browser-handoff-resolved: HANDOFF_SESSION -->
<!-- fetch-ready-for-ingestion -->
<!-- fetch-manifest: MANIFEST_ID -->
```

Omit the handoff marker when this run did not finish a handoff. Omit the
ready marker unless the outcome is `verified`.

`issue` names the repository, the issue number, and the issue URL. Omit
`comment_url`. The comment URL does not exist until this comment is posted,
and the body is immutable, so the consumer takes `html_url` from the comment
API via `locate_manifests`. Do not patch the comment to insert that URL.

`discovered_identifiers` is present. Use `[]` when the run learned no new id.

```sh
gh issue comment NUMBER --body-file manifest.md
```

REST is `POST /repos/alectionary/vibe-math/issues/NUMBER/comments`. Then set
the lifecycle label with the [label write](#lifecycle-labels). The end state
comes from `terminal_label`:

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
bytes, and none hit a transport error, a restriction, or a preview. Applicable
uses `document.stable_ids`, not `discovered_identifiers`. The validator rejects
a `not_found` manifest that omits an applicable active route. Question count
stays null.

`producer.role` is `retrieval_worker`, and `issue` names the repository,
number, and issue URL.

## After fetched, stop

`fetched` is the ingestion signal. There is no seventh lifecycle label. The
worker does not copy the PDF into `local-extraction/`, does not write the
question screen, does not open a pull request, and does not close the issue.

The research agent lists open issues labeled `fetched`.
`ingestion_ready` is true when that label is the only lifecycle label and the
thread has no `<!-- fetch-ingestion-started: SESSION -->` marker and no
`<!-- fetch-ingestion-merged: PR_URL -->` marker. The procedure from there is
the queue skill's [Ingest a fetched paper](../document-acquisition-queue/SKILL.md#ingest-a-fetched-paper).
A person or a timer may start that research block. Starting it is a deployment
choice, the same way starting this worker is.

## Bounded retries

Retry only `transport_failure`, and only the catalog route ids that failed
transport. Three attempts of the same route id is the bound. Count attempts
across manifests on this issue; a copied route row counts. After the third,
post `transport_failure` with `retryable` false and move to `needs-human`.

A browser handoff is not a transport attempt and does not spend this bound.
`browser_host_unavailable` spends it only when a browser failed to start.

Do not retry `not_found`, `restricted`, `preview_only`, or `verified` on the
same route ids. A new catalog version is a different id and starts at zero
attempts.

## Reopen not-found

When `routes.json` gains an active route, list issues labeled `not-found`
(open and closed). For each, load every manifest on the thread. If
`applicable_missing` reports ids, and those ids apply to that source from its
`document.stable_ids`:

1. Reopen the issue if it is closed.
2. Remove `not-found` and add `fetch-request`, then claim it as above. The
   end state of that swap is `fetch-request`, then the claim ends on
   `fetch-claimed`. Use the same read-then-write and the same three label
   variants.
3. Try only the missing route ids. Copy the previous route rows into the new
   manifest, append the new attempts, set `supersedes` to the previous
   `manifest_id`, and relabel from the new outcome.

If nothing is missing, leave the issue on `not-found`. Do not reopen `fetched`,
`restricted`, or `needs-human` just because the catalog grew. A preview or a
restriction is not a missing route. A discovered identifier does not by itself
make an earlier route missing.

`routes_to_retry(manifest)` in the validator is this missing-id list.
`should_reopen_not_found(manifest)` is true only for outcome `not_found` with a
non-empty list.

## Labels

These six lifecycle names are the contract: `fetch-request`, `fetch-claimed`,
`fetched`, `restricted`, `needs-human`, `not-found`. Exactly one is on the
issue. `fetched` means the manifest is verified and ingestion is not yet
merged. Do not add an ingestion label. Colors and descriptions are repository
metadata. They already differ from any palette this skill used to suggest. Do
not create labels, and do not change a color or a description.

Check the names with the same authenticated transport:

```sh
gh label list --repo alectionary/vibe-math --limit 100
```

REST is `GET /repos/alectionary/vibe-math/labels?per_page=100`. A successful
public label list is not the [auth preflight](#github-transport). If any of
the six names is missing, stop and report the missing name.

## Validate this skill

When editing this skill, run the `skill-creator` `scripts/quick_validate.py`
against this directory, with PyYAML available. Then run:

```sh
python3 scripts/validate_fetch_manifest.py --self-check
```
