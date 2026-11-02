# Unpaywall

Read this when running `unpaywall-oa@1`. The route applies when the request
has a DOI. The catalog id stays `unpaywall-oa@1`.

Unpaywall requires a contact address on the request. That address is how they
reach the caller. It is not a license key and not a secret credential. It is
still an operator mailbox: do not invent one, and do not paste it into the
issue or the manifest.

## Configure the address

Set `UNPAYWALL_EMAIL` in the environment before the call. The value is a
mailbox the operator can read. It contains `@` and a dotted domain. These
values are not configured and must not be sent:

- an empty value, or the variable unset
- `example.com`, `example.org`, `example.net`, or `localhost`
- a placeholder such as `unpaywall_01@example.com`

Any agent can read the variable. Do not hard-code an address in this skill,
and do not name a person or a product as the mailbox.

## Call

Percent-encode the DOI. Send the address only as the query parameter.

```sh
curl -fsSL "https://api.unpaywall.org/v2/ENCODED_DOI?email=$UNPAYWALL_EMAIL"
```

The manifest `url` is `https://api.unpaywall.org/v2/<DOI>` with no query. The
notes say that the configured contact address was sent, and they record
`is_oa` and whether any location was a PDF. A 200 with no open-access location
is `not_found` on this route. Metadata without a file is `obtained_bytes`
false.

## When the variable is unset

Do not call the API. Log `unpaywall-oa@1` once:

- `url`: `https://api.unpaywall.org/v2/<DOI>` with no query
- `error_category`: `other`
- `obtained_bytes`: false
- notes: `UNPAYWALL_EMAIL is unset, so the API was not called.`

That row is not `not_found`. A manifest outcome `not_found` cannot include it,
because `not_found` requires every logged route to be `not_found`. Configure
the address and run the route before calling the paper missing.

A call that fails because the address was a placeholder is the same category.
Say the contact address was rejected. Do not record that as no open-access copy.
