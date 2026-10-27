# Archive routes for the fetch bot

Route observations for the retrieval bot. They are not a guarantee that every
mirror or every record behaves the same way. The research agent's own checks
before it files a request stay in
[research access](../../open-question-research/references/research-access.md).

Dates below are the 26 October 2026 pilots. Headless means an ordinary HTTP
client. The browser is a real browser on the retrieval VM, which is a different
machine from the Edge host failure recorded in issue #7.

## UNL bepress

Landing records on `digitalcommons.unl.edu` often return HTML with status 200.
The Download control is a `/cgi/viewcontent.cgi?article=&context=` URL.

Headless requests to those Download URLs returned Cloudflare bot-mitigation
403 responses. Record `error_category` `bot_mitigation`. Do not record
`restricted` from that 403, and do not treat the archive's general
institutional-access banner as the dissertation's own access.

A real browser on the retrieval VM passed the UNL Download controls with no
challenge and no sign-in. Five of six previously blocked dissertations came
back complete: Zimmitti 2023, Volk 2022, Quaisley 2023, Kuzmanovski 2024, and
Kmail 2019. Sainath 2014 (campaign record D025, AAI3632751) showed a genuine
campus-access restriction on the checked route. That outcome is `restricted`,
limited to the routes that were checked.

## ProQuest

Docview HTML is fetchable headless. Open-access works embed an `openViewPdf`
iframe whose media URL is temporary and signed. Store the docview id and the
publication number only. `media.proquest.com` is a temporary media host; the
manifest validator rejects it. A query string with a signature, expiry, or
credential is rejected even on another host.

Non-open-access records served watermarked preview PDFs of about 10 to 24
pages. Outcome `preview_only`, route `error_category` `preview_only`, and a
null question count. A later public copy can still exist; the preview does not
prove the dissertation is unpublished elsewhere.

Resolve a publication number with the publisher's documented OpenURL syntax
before guessing a docview id:

```text
https://gateway.proquest.com/openurl?url_ver=Z39.88-2004&res_dat=xri:pqdiss&rft_val_fmt=info:ofi/fmt:kev:mtx:dissertation&rft_dat=xri:pqdiss:PUBLICATION
```

The syntax notes are at
<https://supportcenter.clarivate.com/articledetail?id=kA0400000004JHqCAM>.
The positive control is UNL AAI3402936, publication 3402936, docview 305217740:
open-access Download PDF, 283 pages, sha256
`d39a696d20d6df6d9467a8906e67c40f336c3856ac74637f8db6629ca9fcc9d2`, born-digital
extraction, no OCR. The committed fixture records that result and leaves the
question count null.

## CORE and other mirrors

Headless `core.ac.uk/download/*` URLs also returned Cloudflare bot-mitigation
403s. Some indexed CORE links used an obsolete `/download/pdf/.pdf` path; the
observed `/download/.pdf` path recovered complete files for the same verified
CORE id. Treat that as an identifier-based route, not a promise that every
mirror works. A stale URL is not document unavailability.

## Browser host failures

Issue #7's Edge session failed before navigation with `The browser access host
is unavailable`. That is `browser_host_unavailable` under `transport_failure`,
not a statement about the document. Do not keep retrying it from the research
agent. The bot runs on the VM whose browser already completed the UNL
downloads. If that VM's browser host is down, post a retryable transport
manifest when the bot will try again, or `retryable` false and label
`needs-human` when a person has to fix the host.

## Completeness and extraction

A PDF header or a matching title page is not a complete dissertation. Check the
contents, main chapters, references, and final pages. Front matter alone, including
a short readable PDF, is `front_matter_only` and stays out of `fetched`.

Native extraction can return a long string with a broken glyph mapping. One
recovered file, `UNL-SEM-D084` in `literature/unl-sem/seed-source-manifest.json`,
used `tesseract_ocr_all_188_pages` because the native text was unreadable. For
that shape of result set `method` to `ocr`, `ocr_applied` true, and `readable`
true only after the text is actually readable. If OCR still fails, status
`unreadable` and question count null. Skipping OCR is `needs_human`, not
`unreadable`.

## Order the bot tries

1. Public headless routes already named on the issue, skipping signed URLs and temporary media hosts.
2. OpenURL from a publication number, then the docview page.
3. The real browser on the archive Download control and the publisher Download PDF control.
4. Reject previews and front matter. Hash only the bytes that were stored.
5. Extract. OCR when the mapping is broken or the pages are scans.
6. Post one immutable manifest comment and swap the lifecycle label. Do not edit a canonical ledger.
