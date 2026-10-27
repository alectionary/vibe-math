# Site notes: UNL bepress, ProQuest, and CORE

Read this only when a stable id uses one of these `archive_record` prefixes:
`aai`, `bepress`, `proquest-docview`, `proquest-publication`, or `core`.
The route ids are in [routes.json](../routes.json). Generic DOI, arXiv, OpenAlex,
and Unpaywall steps still run first.

These are observations from the 26 October 2026 pilots, not a promise that
every record behaves the same way.

## UNL bepress

Landing records on `digitalcommons.unl.edu` often return HTML with status 200.
The Download control is `/cgi/viewcontent.cgi?article=&context=`.

`unl-bepress-headless@1`: curl of that Download URL returned a Cloudflare
bot-mitigation 403. Record `error_category` `bot_mitigation`. Do not record
`restricted` from that 403, and do not treat the archive's general
institutional-access banner as the dissertation's own access.

`unl-bepress-browser@1`: open the record, pass the bot check if one appears,
and activate Download. A real browser on the retrieval machine passed these
controls with no challenge and no sign-in. Five of six previously blocked
dissertations came back complete: Zimmitti 2023, Volk 2022, Quaisley 2023,
Kuzmanovski 2024, and Kmail 2019. Sainath 2014 (`aai:AAI3632751`, campaign
record D025) showed a campus-access restriction on the checked route. That
outcome is `restricted`, limited to the routes that were checked.

A changed browser procedure is a new catalog id, for example
`unl-bepress-browser@2`. Do not reuse `@1` for a different procedure.

## ProQuest

`proquest-openurl@1` resolves a publication number before guessing a docview id:

```text
https://gateway.proquest.com/openurl?url_ver=Z39.88-2004&res_dat=xri:pqdiss&rft_val_fmt=info:ofi/fmt:kev:mtx:dissertation&rft_dat=xri:pqdiss:PUBLICATION
```

The syntax notes are at
<https://supportcenter.clarivate.com/articledetail?id=kA0400000004JHqCAM>.
An `aai:AAI3402936` value uses publication number `3402936` (the digits after
`AAI`). Store `proquest-docview:` and `proquest-publication:` ids. Docview HTML
is fetchable with curl.

`proquest-browser@1`: open the docview record and activate Download PDF when
the page offers it. Open-access works embed an `openViewPdf` frame whose media
URL is temporary and signed. `media.proquest.com` is listed as a temporary host
in the route catalog; do not put it, or any signed query, in the manifest.

Non-open-access records served watermarked preview PDFs of about 10 to 24
pages. Outcome `preview_only`. A later public copy can still exist.

The positive control is `aai:AAI3402936` / `proquest-docview:305217740`:
open-access Download PDF, 283 pages, sha256
`d39a696d20d6df6d9467a8906e67c40f336c3856ac74637f8db6629ca9fcc9d2`, born-digital
text, no OCR. The committed queue fixture records that result and leaves the
question count null.

## CORE

`core-download@1`: curl of `core.ac.uk/download/*` returned Cloudflare
bot-mitigation 403s. Some indexed links used an obsolete `/download/pdf/` path;
the observed `/download/` path recovered complete files for the same verified
CORE id. A stale URL is not proof that the document is missing. If curl is
challenged, use `browser-download@1` on that same URL.

## Failed browser connection

A browser that fails before any page loads is `browser_host_unavailable` on
`browser-download@1`, outcome `transport_failure`. It is not a statement about
the document. One observed failure, before navigation, was `The browser access
host is unavailable`. Retry that route under the worker's retry bound. Do not
relabel it `restricted` or `not-found`.
