<!-- fetch-manifest: vibe-math-63-worker-20261102 -->

```json
{
  "manifest_version": "0.2",
  "manifest_id": "vibe-math-63-worker-20261102",
  "supersedes": null,
  "recorded_at": "2026-11-02T17:25:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-worker-20261102"
  },
  "campaign_id": null,
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "openalex:W2080656989",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 63,
    "url": "https://github.com/alectionary/vibe-math/issues/63"
  },
  "document": {
    "title": "Testing membership in matroid polyhedra",
    "author": "William H. Cunningham",
    "year": 1984,
    "document_type": "article",
    "stable_ids": [
      {
        "scheme": "doi",
        "value": "10.1016/0095-8956(84)90023-6"
      },
      {
        "scheme": "other",
        "value": "openalex:W2080656989"
      }
    ]
  },
  "discovered_identifiers": [],
  "routes_tried": [
    {
      "id": "doi-resolution-63-0",
      "route": "doi-resolution@1",
      "url": "https://doi.org/10.1016/0095-8956(84)90023-6",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T16:40:00Z",
      "http_status": 200,
      "error_category": "not_found",
      "obtained_bytes": false,
      "notes": "HTTP 200 on the Elsevier linkinghub redirect page (no PDF). No PDF bytes."
    },
    {
      "id": "openalex-oa-63-1",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works/doi:10.1016/0095-8956(84)90023-6",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T16:40:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "HTTP 200, bronze OA, pdf_url is the ScienceDirect PDF; only other location is OpenGrey handle 10068/181960 (not OA). No PDF bytes."
    },
    {
      "id": "unpaywall-63",
      "route": "unpaywall-oa@1",
      "url": "https://api.unpaywall.org/v2/10.1016/0095-8956(84)90023-6?email=unpaywall_01@example.com",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T17:15:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "is_oa true, oa_status bronze; only OA location is the publisher PDF https://www.sciencedirect.com/science/article/pii/0095895684900236/pdf. Rerun at this time; the earlier lookup in this session failed on the email parameter and returned no locations. Metadata only; no PDF bytes."
    },
    {
      "id": "publisher-landing-63-3",
      "route": "publisher-landing@1",
      "url": "https://www.sciencedirect.com/science/article/pii/0095895684900236/pdf",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-02T16:40:00Z",
      "http_status": 403,
      "error_category": "bot_mitigation",
      "obtained_bytes": false,
      "notes": "HTTP 403 challenge page. No PDF bytes."
    },
    {
      "id": "browser-63",
      "route": "browser-download@1",
      "url": "https://www.sciencedirect.com/science/article/pii/0095895684900236/pdf",
      "resolved_url": null,
      "method": "browser",
      "attempted_at": "2026-11-02T17:10:00Z",
      "http_status": null,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "Real browser: passed the site's Cloudflare bot check, Download PDF saved the complete 28-page PDF."
    }
  ],
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "outcome": "verified",
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "d7ad1675aa9882a226ab0b9349beac0ab51f467deb57b900d4274b26e6360715",
    "byte_length": 1759454,
    "page_count": 28,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/63/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "First page reads Journal of Combinatorial Theory, Series B 36, 161-188 (1984), 'Testing Membership in Matroid Polyhedra', William H. Cunningham; matches the request title, author, and year.",
      "Page count is 28. Body and the reference list through the final page are present in the extracted text.",
      "Extracted text is 77611 Unicode characters (text_characters), distinct from the PDF byte_length 1759454 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "ce43ee18ca64d86f33a6c7233290eac5dceb97ffa495d66ed0402ee58501169a",
    "text_characters": 77611,
    "unreadable_reason": null
  },
  "notes": "Complete PDF saved by the browser pass to worker/63/paper.pdf; headless routes had hit bot mitigation. pdftotext -layout gave readable text; OCR not run. The PDF is a scan with the publisher's embedded text layer; minor OCR glyph errors in names (e.g. 'Universitiit') but the text is readable. Question count stays null. Request campaign is not a valid campaign_id under the schema pattern, so campaign_id is null. requested_source_id uses the issue's listed alias OpenAlex W2080656989 because the schema pattern for requested_source_id rejects the parentheses in DOI 10.1016/0095-8956(84)90023-6; the DOI is kept in document.stable_ids."
}
```
