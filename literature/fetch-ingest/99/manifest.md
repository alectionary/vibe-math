<!-- fetch-manifest: vibe-math-99-worker-20261109 -->

```json
{
  "manifest_version": "0.3",
  "manifest_id": "vibe-math-99-worker-20261109",
  "supersedes": null,
  "recorded_at": "2026-11-09T15:40:00Z",
  "producer": {
    "role": "retrieval_worker",
    "name": "grokbot-retrieval-20261109T1525"
  },
  "campaign_id": "higgott-quantum-decoding",
  "priority": "normal",
  "retryable": false,
  "requested_source_id": "https://discovery.ucl.ac.uk/id/eprint/10186408/",
  "outcome": "verified",
  "issue": {
    "repository": "alectionary/vibe-math",
    "number": 99,
    "url": "https://github.com/alectionary/vibe-math/issues/99"
  },
  "document": {
    "title": "Practical and Efficient Quantum Error Correction",
    "author": "Oscar Higgott",
    "year": 2024,
    "document_type": "doctoral_dissertation",
    "stable_ids": [
      {
        "scheme": "url",
        "value": "https://discovery.ucl.ac.uk/id/eprint/10186408/"
      },
      {
        "scheme": "url",
        "value": "https://discovery.ucl.ac.uk/id/eprint/10186408/2/higgott_thesis_final_version.pdf"
      },
      {
        "scheme": "arxiv",
        "value": "2308.03750"
      }
    ]
  },
  "discovered_identifiers": [],
  "routes_tried": [
    {
      "id": "arxiv-pdf-99",
      "route": "arxiv-pdf@1",
      "url": "https://arxiv.org/pdf/2308.03750",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "arXiv:2308.03750 is the related article alias, not the thesis; not used as the dissertation bytes. No thesis PDF from this route.",
      "attempted_by": null
    },
    {
      "id": "openalex-99",
      "route": "openalex-oa@1",
      "url": "https://api.openalex.org/works?search=Practical+Efficient+Quantum+Error+Correction+Higgott",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "OpenAlex lists related works; thesis bytes taken from UCL Discovery PDF alias rather than OpenAlex locations.",
      "attempted_by": null
    },
    {
      "id": "publisher-landing-99",
      "route": "publisher-landing@1",
      "url": "https://discovery.ucl.ac.uk/id/eprint/10186408/",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:28:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": false,
      "notes": "UCL Discovery record HTML 200. Public PDF alias is /2/higgott_thesis_final_version.pdf. No bytes from the HTML route.",
      "attempted_by": null
    },
    {
      "id": "ir-pdf-99",
      "route": "institutional-repository@1",
      "url": "https://discovery.ucl.ac.uk/id/eprint/10186408/2/higgott_thesis_final_version.pdf",
      "resolved_url": null,
      "method": "headless",
      "attempted_at": "2026-11-09T15:30:00Z",
      "http_status": 200,
      "error_category": null,
      "obtained_bytes": true,
      "notes": "UCL Discovery public PDF HTTP 200 application/pdf; complete thesis saved.",
      "attempted_by": null
    }
  ],
  "artifact": {
    "media_type": "application/pdf",
    "sha256": "3b5106e86960fc3516727b2eef22107f901dd77654bf709cf2cda3f855b236bb",
    "byte_length": 14555471,
    "page_count": 266,
    "committed_to_git": false,
    "storage": {
      "kind": "worker_local",
      "locator": "worker/99/paper.pdf",
      "cross_machine": false
    }
  },
  "completeness": {
    "classification": "complete_body",
    "identity_matched": true,
    "front_matter_only": false,
    "preview": false,
    "evidence": [
      "Title page matches: Practical and Efficient Quantum Error Correction, Oscar Higgott, Doctor of Philosophy, UCL.",
      "sha256 3b5106e86960fc3516727b2eef22107f901dd77654bf709cf2cda3f855b236bb; 266 pages; no prior sha256 on the issue.",
      "Page count is 266. Body and references through the final page are present in the extracted text.",
      "Extracted text is 610456 Unicode characters (text_characters), distinct from the PDF byte_length 14555471 bytes."
    ]
  },
  "extraction": {
    "status": "extracted",
    "method": "born_digital",
    "ocr_applied": false,
    "ocr_engine": null,
    "readable": true,
    "text_sha256": "254efa33af1c6382ad1c826abb6990f8d57c590f87225f88c4f8495c23dc2a25",
    "text_characters": 610456,
    "unreadable_reason": null
  },
  "question_screen": {
    "status": "not_screened",
    "question_count": null,
    "candidates": [],
    "screen_owner": "research_agent"
  },
  "notes": "Complete PDF from UCL Discovery public file. arXiv alias is a related article and was not used as the thesis. Question count null."
}
```
