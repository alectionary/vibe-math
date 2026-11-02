<!-- fetch-manifest: fetch-12-arxiv-2502-15166-verified -->

```json
{
  "manifest_version": "0.1",
  "manifest_id": "fetch-12-arxiv-2502-15166-verified",
  "supersedes": null,
  "recorded_at": "2026-10-27T07:30:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grok-bot-e2e-20261027T0728Z"
  },
  "campaign_id": null,
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "2502.15166",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 12,
    "url": "https://github.com/alectionary/vibe-math/issues/12",
    "comment_url": "https://github.com/alectionary/vibe-math/issues/12#issuecomment-6436223665"
  },
  "document": {
    "title": "Constructions of Macaulay Posets and Macaulay Rings",
    "author": "Penelope Beall; Erenay Boyali; Nancy Chen; Ellen Chlachidze; Trong Toan Dao; Frederic Garvey; Mitchell Johnson; Yu Olivier Li; Nikola Kuzmanovski; Kelvin Ma; Treanungkur Mal; Rukshan Marasinghe Mudiyanselage; Quinlan Mayo; Nava Minsky-Primus; Alexandra Seceleanu; Sriram Veerapaneni",
    "year": 2025,
    "document_type": "preprint",
    "stable_ids": [
      {
        "scheme": "arxiv",
        "value": "2502.15166"
      },
      {
        "scheme": "doi",
        "value": "10.37236/14245"
      },
      {
        "scheme": "url",
        "value": "https://arxiv.org/abs/2502.15166"
      },
      {
        "scheme": "url",
        "value": "https://arxiv.org/pdf/2502.15166"
      }
    ]
  },
  "routes_tried": [
    {
      "id": "arxiv-pdf-2502-15166",
      "route": "arxiv-pdf@1",
      "url": "https://arxiv.org/pdf/2502.15166",
      "resolved_url": "https://arxiv.org/pdf/2502.15166",
      "method": "headless",
      "attempted_at": "2026-10-27T07:27:45Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "curl downloaded application/pdf 653082 bytes. Identity matches arXiv abs metadata and PDF info Title/Author."
    },
    {
      "id": "openalex-oa-2502-15166",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=Constructions%20of%20Macaulay%20Posets%20and%20Macaulay%20Rings",
      "resolved_url": "https://openalex.org/W7163670167",
      "method": "headless",
      "attempted_at": "2026-10-27T07:28:10Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "OpenAlex W7163670167; DOI 10.37236/14245; OA PDF at Electronic Journal of Combinatorics. Bytes already obtained via arxiv-pdf@1; EJOC URL not re-fetched."
    },
    {
      "id": "publisher-landing-arxiv-abs",
      "route": "publisher-landing@1",
      "url": "https://arxiv.org/abs/2502.15166",
      "resolved_url": "https://arxiv.org/abs/2502.15166",
      "method": "headless",
      "attempted_at": "2026-10-27T07:28:40Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "arXiv abs HTML 200. PDF already obtained via arxiv-pdf@1; no additional download."
    },
    {
      "id": "browser-download-none-needed",
      "route": "browser-download@1",
      "url": "https://arxiv.org/pdf/2502.15166",
      "resolved_url": null,
      "method": "browser",
      "attempted_at": "2026-10-27T07:29:00Z",
      "http_status": null,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "No bot-check or challenge page remained after headless arxiv-pdf@1 success. Browser not opened."
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "6373eea0021a7aa835f3d562a431756c4f941669623e457f5d139d4dc0f2c134",
    "byte_length": 653082,
    "page_count": 32,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/12/2502.15166.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "pdfinfo Title and Author match the fetch-request and arXiv abs record for 2502.15166.",
      "32 pages: abstract, sections 1-7, References on pdf p30-31, author addresses on p32.",
      "pdftotext -layout yields readable born-digital text (129072 characters); no PREVIEW watermark."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "22d32bedc717d4340a9bd9378c9020b8745bcb241ed61b15de914dde608de7dc",
    "text_characters": 125806,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "First e2e pilot non-UNL paper. arxiv-pdf@1 obtained complete PDF. OpenAlex also lists published EJOC version DOI 10.37236/14245; that OA URL was not re-downloaded. DOI discovered via OpenAlex after arXiv fetch; doi-resolution@1 was not run because the request originally had no DOI. Question count left null."
}
```
