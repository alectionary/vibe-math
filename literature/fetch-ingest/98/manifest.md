<!-- fetch-manifest: vibe-math-98-worker-20261109 -->

```json
{
  "manifest_version": "0.3",
  "manifest_id": "vibe-math-98-worker-20261109",
  "supersedes": null,
  "recorded_at": "2026-11-09T15:40:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-20261109T1525"
  },
  "campaign_id": "polytomous-person-fit",
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "https://digitalcommons.unl.edu/cehsdiss/425",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 98,
    "url": "https://github.com/alectionary/vibe-math/issues/98"
  },
  "document": {
    "title": "The Examination of Nonparametric Person-Fit Statistics as Appropriate Measures of Response Bias in Ordered Polytomous Items",
    "author": "Mark F. Beck",
    "year": 2023,
    "document_type": "doctoral_dissertation",
    "stable_ids": [
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/cehsdiss/425"
      },
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1436&context=cehsdiss"
      },
      {
        "scheme": "other",
        "value": "proquest:1588285"
      }
    ]
  },
  "discovered_identifiers": [],
  "routes_tried": [
    {
      "id": "openalex-98",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=Nonparametric+Person-Fit+Statistics+Beck+polytomous",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "OpenAlex title search found no matching Beck 2023 UNL dissertation OA PDF location.",
      "attempted_by": null
    },
    {
      "id": "publisher-landing-98",
      "route": "publisher-landing@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/425",
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
      "id": "ir-record-98",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/425",
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
      "id": "ir-viewcontent-98",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1436&context=cehsdiss",
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
      "id": "author-page-98",
      "route": "author-page@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/425",
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
      "id": "wayback-98",
      "route": "wayback-available@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1436&context=cehsdiss",
      "resolved_url": "https://web.archive.org/web/20240907085051id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1436&context=cehsdiss",
      "method": "headless",
      "attempted_at": "2026-11-09T15:32:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "Availability API closest timestamp 20240907085051. Fetched id_ URL; complete PDF.",
      "attempted_by": null
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b",
    "byte_length": 13113996,
    "page_count": 280,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/98/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "DigitalCommons cover and title match: Mark F. Beck, Nonparametric Person-Fit Statistics / Ordered Polytomous Items, 2023.",
      "sha256 86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b matches the issue's previously verified copy; 280 pages.",
      "Page count is 280. Body and references through the final page are present in the extracted text.",
      "Extracted text is 398848 Unicode characters (text_characters), distinct from the PDF byte_length 13113996 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "373351dd57297bb21829ab8f952baf2fc84f35c7f7f410327d5f0e70c6b2b086",
    "text_characters": 398848,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "Complete PDF via wayback-available@1; sha256 matches the issue's previously verified copy. Question count null."
}
```
