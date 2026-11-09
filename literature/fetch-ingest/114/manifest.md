<!-- fetch-manifest: vibe-math-114-worker-20261109 -->

```json
{
  "manifest_version": "0.3",
  "manifest_id": "vibe-math-114-worker-20261109",
  "supersedes": null,
  "recorded_at": "2026-11-09T15:40:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-20261109T1525"
  },
  "campaign_id": "koziol-weighted-multilevel",
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "https://digitalcommons.unl.edu/cehsdiss/229/",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 114,
    "url": "https://github.com/alectionary/vibe-math/issues/114"
  },
  "document": {
    "title": "A comparison of population-averaged and cluster-specific approaches in the context of unequal probabilities of selection",
    "author": "Natalie A. Koziol",
    "year": 2015,
    "document_type": "doctoral_dissertation",
    "stable_ids": [
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/cehsdiss/229/"
      },
      {
        "scheme": "url",
        "value": "https://web.archive.org/web/20240725015242id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1231&context=cehsdiss"
      }
    ]
  },
  "discovered_identifiers": [],
  "routes_tried": [
    {
      "id": "openalex-114",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=population-averaged+cluster-specific+Koziol",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "OpenAlex title search found no matching Koziol 2015 UNL dissertation OA PDF location.",
      "attempted_by": null
    },
    {
      "id": "publisher-landing-114",
      "route": "publisher-landing@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/229/",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "Record HTML 200. Download control points at viewcontent.cgi. No PDF bytes from this route.",
      "attempted_by": null
    },
    {
      "id": "ir-record-114",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/229/",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "Institutional repository record HTML 200. Public Download is viewcontent.cgi. No PDF bytes.",
      "attempted_by": null
    },
    {
      "id": "ir-viewcontent-114",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1231&context=cehsdiss",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:30:00Z",
      "http_status": 403,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "Cloudflare challenge page (Just a moment...). Bot mitigation, not an access restriction. No PDF bytes.",
      "attempted_by": null
    },
    {
      "id": "author-page-114",
      "route": "author-page@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/229/",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:30:00Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "Author search returns the same UNL dissertation record; no separate author-page manuscript.",
      "attempted_by": null
    },
    {
      "id": "wayback-114",
      "route": "wayback-available@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1231&context=cehsdiss",
      "resolved_url": "https://web.archive.org/web/20240725015242id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1231&context=cehsdiss",
      "method": "headless",
      "attempted_at": "2026-11-09T15:32:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "Request alias named snapshot 20240725015242. Fetched id_ URL; complete PDF matches prior sha256.",
      "attempted_by": null
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "b64a3c3fdeb43040875b88560b69d3b9b4f23c1a45b05f0834204e624a56eece",
    "byte_length": 3853291,
    "page_count": 222,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/114/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "DigitalCommons cover and title match: Natalie A. Koziol, population-averaged and cluster-specific approaches, 2015.",
      "sha256 b64a3c3fdeb43040875b88560b69d3b9b4f23c1a45b05f0834204e624a56eece matches the issue's previously verified copy; 222 pages.",
      "Page count is 222. Body and references through the final page are present in the extracted text.",
      "Extracted text is 426384 Unicode characters (text_characters), distinct from the PDF byte_length 3853291 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "a979e16dad02763d3d02ae569e4e9d8acd126cf2fa148a8bda0c9abb4bfcc214",
    "text_characters": 426384,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "Complete PDF via wayback-available@1 using the request's Wayback alias; sha256 matches. Question count null."
}
```
