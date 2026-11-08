<!-- fetch-manifest: fetch-11-bepress-dissunl-339-verified -->

```json
{
  "manifest_version": "0.1",
  "manifest_id": "fetch-11-bepress-dissunl-339-verified",
  "supersedes": null,
  "recorded_at": "2026-10-27T07:33:30Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grok-bot-e2e-20261027T0728Z"
  },
  "campaign_id": null,
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "bepress:dissunl/339",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 11,
    "url": "https://github.com/alectionary/vibe-math/issues/11",
    "comment_url": "https://github.com/alectionary/vibe-math/issues/11#issuecomment-6436223299"
  },
  "document": {
    "title": "Analysis of Graph-based Decoders for Quantum Low Density Parity Check Codes",
    "author": "Morris, Kirsten",
    "year": 2025,
    "document_type": "doctoral_dissertation",
    "stable_ids": [
      {
        "scheme": "archive_record",
        "value": "bepress:dissunl/339"
      },
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/dissunl/339"
      },
      {
        "scheme": "url",
        "value": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl"
      }
    ]
  },
  "routes_tried": [
    {
      "id": "openalex-oa-morris-2025",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=Analysis%20of%20Graph-based%20Decoders%20for%20Quantum%20Low%20Density%20Parity%20Check%20Codes%20Morris",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-10-27T07:28:15Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "OpenAlex title search returned unrelated QLDPC works; no record matching Morris 2025 UNL dissertation."
    },
    {
      "id": "ir-dissunl-339",
      "route": "institutional-repository@1",
      "url": "https://digitalcommons.unl.edu/dissunl/339/",
      "resolved_url": "https://digitalcommons.unl.edu/dissunl/339/",
      "method": "headless",
      "attempted_at": "2026-10-27T07:28:20Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "Record HTML 200. Download control points at viewcontent.cgi?article=1405&context=dissunl. No PDF bytes from this route."
    },
    {
      "id": "unl-viewcontent-dissunl-1405-headless",
      "route": "unl-bepress-headless@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-10-27T07:27:50Z",
      "http_status": 403,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "Cloudflare challenge page (Just a moment...). Bot mitigation, not an access restriction."
    },
    {
      "id": "author-page-morris-qldpc",
      "route": "author-page@1",
      "url": "https://export.arxiv.org/api/query?search_query=au:Morris+AND+ti:Quantum+AND+ti:Parity&max_results=5",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-10-27T07:28:35Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "No arXiv deposit of this dissertation; no separate author-page manuscript URL found."
    },
    {
      "id": "browser-download-deferred-to-site",
      "route": "browser-download@1",
      "url": "https://digitalcommons.unl.edu/dissunl/339/",
      "resolved_url": null,
      "method": "browser",
      "attempted_at": "2026-10-27T07:30:00Z",
      "http_status": null,
      "error_category": "browser_host_unavailable",
      "obtained_bytes": false,
      "notes": "First worker session had no browser. Deferred to unl-bepress-browser@1 once a browser was available."
    },
    {
      "id": "unl-viewcontent-dissunl-1405-browser",
      "route": "unl-bepress-browser@1",
      "url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl",
      "resolved_url": "https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl",
      "method": "browser",
      "attempted_at": "2026-10-27T07:32:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "Opened record dissunl/339, activated Download. No bot check, no sign-in. Saved 5422038-byte PDF under worker_local."
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "73578ca2735961d7f37539dfa92377691eda47746e5f554c2e1005f000bd2517",
    "byte_length": 5422038,
    "page_count": 92,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/11/morris_2025_qldpc.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "bepress coversheet (dissunl/339, 8-2025) and title page match: Kirsten Morris, adviser Christine A. Kelley, August 2025, Mathematics Ph.D.",
      "92 pages; Bibliography starts at printed p75; references continue through printed p79+; no PREVIEW watermark.",
      "pdfinfo Title/Author match the fetch-request; sha256 73578ca2735961d7f37539dfa92377691eda47746e5f554c2e1005f000bd2517."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "d131f53e72d3be975362d424900fc46cca5346c2799d45e55c87c03e7b3cd9be",
    "text_characters": 159895,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "E2e pilot UNL dissertation. Headless viewcontent returned Cloudflare 403; unl-bepress-browser@1 recovered the complete PDF with no challenge. Question count left null for the research agent."
}
```
