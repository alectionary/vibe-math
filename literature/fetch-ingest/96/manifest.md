<!-- fetch-manifest: vibe-math-96-worker-20261109 -->

```json
{
  "manifest_version": "0.3",
  "manifest_id": "vibe-math-96-worker-20261109",
  "supersedes": null,
  "recorded_at": "2026-11-09T15:40:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-20261109T1525"
  },
  "campaign_id": "kupzyk-power-assumptions",
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "https://digitalcommons.unl.edu/cehsdiss/106/",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 96,
    "url": "https://github.com/alectionary/vibe-math/issues/96"
  },
  "document": {
    "title": "The Effects of Simplifying Assumptions in Power Analysis",
    "author": "Kevin A. Kupzyk",
    "year": 2011,
    "document_type": "doctoral_dissertation",
    "stable_ids": [
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/cehsdiss/106/"
      }
    ]
  },
  "discovered_identifiers": [],
  "routes_tried": [
    {
      "id": "openalex-96",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=Effects+of+Simplifying+Assumptions+in+Power+Analysis+Kupzyk",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "OpenAlex title search found no matching Kupzyk 2011 UNL dissertation OA PDF location.",
      "attempted_by": null
    },
    {
      "id": "publisher-landing-96",
      "route": "publisher-landing@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/106/",
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
      "id": "ir-record-96",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/106/",
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
      "id": "ir-viewcontent-96",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1107&context=cehsdiss",
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
      "id": "author-page-96",
      "route": "author-page@1",
      "url": "https://digitalcommons.unl.edu/cehsdiss/106/",
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
      "id": "wayback-96",
      "route": "wayback-available@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1107&context=cehsdiss",
      "resolved_url": "https://web.archive.org/web/20240725011918id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1107&context=cehsdiss",
      "method": "headless",
      "attempted_at": "2026-11-09T15:32:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "Availability API closest timestamp 20240725011918. Fetched id_ URL; complete PDF.",
      "attempted_by": null
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "368dc575d9f744bf5ca5516873a633691d999fbdd5d19516994c64e10674896a",
    "byte_length": 713123,
    "page_count": 143,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/96/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "DigitalCommons cover (cehsdiss/106, 4-2011) and title match: Kevin A. Kupzyk, The Effects of Simplifying Assumptions in Power Analysis.",
      "sha256 368dc575d9f744bf5ca5516873a633691d999fbdd5d19516994c64e10674896a; 143 pages (issue previously recorded sha256 c3b7af14...); same work identity.",
      "Page count is 143. Body and references through the final page are present in the extracted text.",
      "Extracted text is 273684 Unicode characters (text_characters), distinct from the PDF byte_length 713123 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "df198189c4cd5050e8cbe65f3fa40c7ef385fc43c77daac43f69b77cd35cde6e",
    "text_characters": 273684,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "Complete PDF via wayback-available@1 after UNL viewcontent Cloudflare 403. Question count null. sha256 differs from the issue's previously verified copy c3b7af14877156cf6506e1c3c4ea57b23bcba6ce2139cf82bdce8417c451a1d1; this run's copy still matches title/author/identity and is the Wayback or live OA file obtained this session."
}
```
