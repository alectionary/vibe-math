<!-- fetch-manifest: vibe-math-28-worker-20261102 -->

```json
{
  "manifest_version": "0.2",
  "manifest_id": "vibe-math-28-worker-20261102",
  "supersedes": null,
  "recorded_at": "2026-11-02T17:05:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-worker-20261102"
  },
  "campaign_id": null,
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "10.1186/s12918-015-0200-0",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 28,
    "url": "https://github.com/alectionary/vibe-math/issues/28"
  },
  "document": {
    "title": "The wright stuff: reimagining path analysis reveals novel components of the sex determination hierarchy in Drosophila melanogaster",
    "author": "Justin M. Fear, Michelle N. Arbeitman, and Matthew P. Salomon",
    "year": 2015,
    "document_type": "article",
    "stable_ids": [
      {
        "scheme": "doi",
        "value": "10.1186/s12918-015-0200-0"
      }
    ]
  },
  "discovered_identifiers": [
    {
      "scheme": "other",
      "value": "pmcid:PMC4558766",
      "route": "openalex-oa@1"
    }
  ],
  "routes_tried": [
    {
      "id": "doi-28",
      "route": "doi-resolution@1",
      "url": "https://doi.org/10.1186/s12918-015-0200-0",
      "resolved_url": "https://link.springer.com/article/10.1186/s12918-015-0200-0",
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "Followed to the publisher landing, which returned a challenge page; no PDF bytes."
    },
    {
      "id": "openalex-28",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works/doi:10.1186/s12918-015-0200-0",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "OpenAlex lists the publisher PDF https://link.springer.com/content/pdf/10.1186/s12918-015-0200-0.pdf and a PubMed Central location PMC4558766. Metadata only; no PDF bytes."
    },
    {
      "id": "unpaywall-28",
      "route": "unpaywall-oa@1",
      "url": "https://api.unpaywall.org/v2/10.1186/s12918-015-0200-0",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "Unpaywall is_oa true: publisher PDF URL plus PubMed Central repository locations. Metadata only; no PDF bytes."
    },
    {
      "id": "publisher-pdf-28",
      "route": "publisher-landing@1",
      "url": "https://link.springer.com/content/pdf/10.1186/s12918-015-0200-0.pdf",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "HTTP 200 HTML challenge page (3038 bytes), not a PDF. Bot mitigation, not a paywall."
    },
    {
      "id": "pmc-oa-28",
      "route": "institutional-repository@1",
      "url": "https://pmc-oa-opendata.s3.amazonaws.com/PMC4558766.1/PMC4558766.1.pdf",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "PubMed Central Open Access dataset copy of PMC4558766 (publisher version of record (BMC, Open Access)). Ordinary public https object; complete PDF bytes stored."
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "a48a816f33c0fd03c29644d7bc8b318300641a99a3f42524a9b7aabbdfa9c3c8",
    "byte_length": 2317490,
    "page_count": 17,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/28/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "First page reads Fear et al., BMC Systems Biology (2015) 9:53, DOI 10.1186/s12918-015-0200-0, with the requested title; authors Fear, Arbeitman, Salomon present.",
      "Page count is 17. Abstract, body, and the reference list through the final page are present in the extracted text.",
      "Extracted text is 113183 Unicode characters (text_characters), distinct from the PDF byte_length 2317490 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "5e5ea99c793703e018c3b0cb3192f048f5245e99ae29bcfcf5c79e3f10ebbe02",
    "text_characters": 113183,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "Retrieved headless from the PubMed Central Open Access dataset (publisher version of record (BMC, Open Access)). Publisher PDF routes returned challenge pages. pdftotext -layout gave readable text; OCR not needed. Wayback and browser routes were not run because complete bytes were already stored. Question count stays null. Request campaign L-F102-correlated-residuals is not a valid campaign_id under the schema pattern, so campaign_id is null."
}
```
