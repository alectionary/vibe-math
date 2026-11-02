# PMC Open Access package

Read this when a PMCID is known. The catalog id is `pmc-oa-package@1`. This is
one public route. It does not replace DOI resolution, OpenAlex, Unpaywall, or
the publisher page.

A PMCID on the request is an `archive_record` whose value is `pmcid:PMC` plus
digits, for example `pmcid:PMC4558766`. The prefix pattern is `^PMC\d+$`.

OpenAlex or Unpaywall may name a PMCID during this run. That id was not on the
request, so it does not make an earlier route applicable and it does not reopen
a `not_found` issue by itself. `pmc-oa-package@1` is a later route. Run it
before concluding that no copy exists, and log it because you ran it. After
complete bytes are already stored, do not download another copy and do not log
the skip.

A manifest posted at version 0.2 may have stored this host on
`institutional-repository@1`. Leave that comment as it was posted. A new run
uses `pmc-oa-package@1`.

## Fetch

Use ordinary HTTPS. Do not use a cloud credential, and do not write an
`s3://` URL into the manifest. The public object for the current package is:

```text
https://pmc-oa-opendata.s3.amazonaws.com/PMCID.1/PMCID.1.pdf
```

`PMC4558766` is fetched as
`https://pmc-oa-opendata.s3.amazonaws.com/PMC4558766.1/PMC4558766.1.pdf`.
The `.1` is the package version string on that host, not a catalog route
version.

```sh
curl -fL -o paper.pdf "https://pmc-oa-opendata.s3.amazonaws.com/PMC4558766.1/PMC4558766.1.pdf"
```

Run `pdfinfo` on the bytes. An HTML body is not the paper.

- A complete PDF is `obtained_bytes` true and `error_category` null.
- HTTP 404, or a response that is not a PDF and does not name a wall, is
  `not_found` on this route. Say the PMCID is not in the open-access dataset.
- HTTP 403, or a page that states an embargo date, is `restricted` on this
  route. Quote the date the page showed. `PMC13179297` embargoed until
  2027-05-15 is that case: the wall is the embargo, not a missing route.

The host is a public https host. It is not in `temporary_hosts`. Store that
URL. Do not store a signed query.
