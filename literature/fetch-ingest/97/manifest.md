<!-- fetch-manifest: vibe-math-97-worker-20261109 -->

```json
{
  "manifest_version": "0.3",
  "manifest_id": "vibe-math-97-worker-20261109",
  "supersedes": null,
  "recorded_at": "2026-11-09T15:40:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-20261109T1525"
  },
  "campaign_id": "latent-contrasts",
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "UNL-SEM-D055",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 97,
    "url": "https://github.com/alectionary/vibe-math/issues/97"
  },
  "document": {
    "title": "Navigating Non-Orthogonality: Exploring Latent Mean Differences in Unbalanced Conditions",
    "author": "Jay B. Jeffries",
    "year": 2024,
    "document_type": "doctoral_dissertation",
    "stable_ids": [
      {
        "scheme": "other",
        "value": "UNL-SEM-D055"
      },
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/dissunl/216/"
      },
      {
        "scheme": "url",
        "value": "https://web.archive.org/web/20250511025154id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1215&context=dissunl"
      }
    ]
  },
  "discovered_identifiers": [],
  "routes_tried": [
    {
      "id": "openalex-97",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=Navigating+Non-Orthogonality+Jeffries",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "OpenAlex title search found no matching Jeffries 2024 UNL dissertation OA PDF location.",
      "attempted_by": null
    },
    {
      "id": "publisher-landing-97",
      "route": "publisher-landing@1",
      "url": "https://digitalcommons.unl.edu/dissunl/216/",
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
      "id": "ir-record-97",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/dissunl/216/",
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
      "id": "ir-viewcontent-97",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1215&context=dissunl",
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
      "id": "author-page-97",
      "route": "author-page@1",
      "url": "https://digitalcommons.unl.edu/dissunl/216/",
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
      "id": "wayback-97",
      "route": "wayback-available@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1215&context=dissunl",
      "resolved_url": "https://web.archive.org/web/20250511025154id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1215&context=dissunl",
      "method": "headless",
      "attempted_at": "2026-11-09T15:32:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "Request alias named snapshot 20250511025154. Fetched id_ URL; complete PDF matches prior sha256.",
      "attempted_by": null
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "a21df98c20401491e6b4a1d00a21b6f7cee5551a00c04a89fb414ec6cfd469b3",
    "byte_length": 3083964,
    "page_count": 191,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/97/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "DigitalCommons cover and title match: Jay B. Jeffries, Navigating Non-Orthogonality, 2024.",
      "sha256 a21df98c20401491e6b4a1d00a21b6f7cee5551a00c04a89fb414ec6cfd469b3 matches the issue's previously verified copy; 191 pages.",
      "Page count is 191. Body and references through the final page are present in the extracted text.",
      "Extracted text is 347801 Unicode characters (text_characters), distinct from the PDF byte_length 3083964 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "904351aca4925414c9af87e02b77cb3ee99437f5ed8ea67072b49030573ce833",
    "text_characters": 347801,
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
