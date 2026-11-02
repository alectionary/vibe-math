<!-- fetch-manifest: vibe-math-29-worker-20261102 -->

```json
{
  "manifest_version": "0.2",
  "manifest_id": "vibe-math-29-worker-20261102",
  "supersedes": null,
  "recorded_at": "2026-11-02T17:05:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-worker-20261102"
  },
  "campaign_id": null,
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "10.1186/s12864-020-06833-2",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 29,
    "url": "https://github.com/alectionary/vibe-math/issues/29"
  },
  "document": {
    "title": "Multi-trait multi-locus SEM model discriminates SNPs of different effects",
    "author": "Anna A. Igolkina, G. A. Meshcheryakov, and Maria Gretsova",
    "year": 2020,
    "document_type": "article",
    "stable_ids": [
      {
        "scheme": "doi",
        "value": "10.1186/s12864-020-06833-2"
      }
    ]
  },
  "discovered_identifiers": [
    {
      "scheme": "other",
      "value": "pmcid:PMC7385891",
      "route": "openalex-oa@1"
    }
  ],
  "routes_tried": [
    {
      "id": "doi-29",
      "route": "doi-resolution@1",
      "url": "https://doi.org/10.1186/s12864-020-06833-2",
      "resolved_url": "https://link.springer.com/article/10.1186/s12864-020-06833-2",
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "Followed to the publisher landing, which returned a challenge page; no PDF bytes."
    },
    {
      "id": "openalex-29",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works/doi:10.1186/s12864-020-06833-2",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "OpenAlex lists the publisher PDF https://bmcgenomics.biomedcentral.com/track/pdf/10.1186/s12864-020-06833-2 and a PubMed Central location PMC7385891. Metadata only; no PDF bytes."
    },
    {
      "id": "unpaywall-29",
      "route": "unpaywall-oa@1",
      "url": "https://api.unpaywall.org/v2/10.1186/s12864-020-06833-2",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "Unpaywall is_oa true: publisher PDF URL plus PubMed Central repository locations. Metadata only; no PDF bytes."
    },
    {
      "id": "publisher-pdf-29",
      "route": "publisher-landing@1",
      "url": "https://bmcgenomics.biomedcentral.com/track/pdf/10.1186/s12864-020-06833-2",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "HTTP 200 HTML challenge page (3038 bytes), not a PDF. Bot mitigation, not a paywall."
    },
    {
      "id": "pmc-oa-29",
      "route": "institutional-repository@1",
      "url": "https://pmc-oa-opendata.s3.amazonaws.com/PMC7385891.1/PMC7385891.1.pdf",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:00:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "PubMed Central Open Access dataset copy of PMC7385891 (publisher version of record (BMC, Open Access)). Ordinary public https object; complete PDF bytes stored."
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "894f49317639aad6cbeadcd70bf7c69780821714f87c5bee8bc6218d045770f5",
    "byte_length": 2154042,
    "page_count": 11,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/29/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "First page reads Igolkina et al., BMC Genomics 2020, 21(Suppl 8):490, doi 10.1186/s12864-020-06833-2, with the requested title; author list matches the request.",
      "Page count is 11. Abstract, body, and the reference list through the final page are present in the extracted text.",
      "Extracted text is 65553 Unicode characters (text_characters), distinct from the PDF byte_length 2154042 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "b678e2e1ea70f2f246cf1d2ef8bb7a3a4637a51bd5c77de11a5cedb5cdd6dd34",
    "text_characters": 65553,
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
