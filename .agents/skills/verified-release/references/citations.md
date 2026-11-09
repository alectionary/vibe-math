# Citation coverage for research manuscripts

Before handing off the manuscript, reconcile the sources used in the research,
methods and software records with an explicit citation inventory. Include the
source question and results, theorems and methods relied on, and every external
software tool discussed because it was used. Start from the study's source
ledger, code, and tool versions, then compare with the earlier bibliography if
this is a revision or re-replication. Establish relevance to this paper before
retaining a prior citation. Record a specific reason for each omission.

Use a scholarly in-text citation and matching References entry for each item.
For software, use the recommended citation where available. Otherwise give an
official project or release reference with the version used. Cite the method
paper where the method is explained and credit its implementation where used.
Keep the project or registry link and exact version next to the software
citation. A tool can share a bibliography entry across sections or versions
when the same source supports each occurrence. Keep hyperlinks to our scripts,
inputs, and outputs in the reproducibility record.

Verify each source against the primary publication, official release, or
recommended citation metadata. Check that the passage supports the attributed
statement and record exact source locators. For access-limited sources, record
what was actually verified. Have an independent reviewer compare the inventory
with the analysis and tool records, then check the rendered in-text citations
and References. Reviewing only the entries that made it into the manuscript
can miss omissions.

## LaTeX gate

Save `citation-inventory.json` beside the study's evidence. Paths inside it are
relative to the study root. Use the section title as written in the TeX source.

```json
{
  "repository": "alectionary/vibe-math",
  "software_sections": ["Reproducibility"],
  "items": [
    {
      "subject": "The original method",
      "evidence": "notes/source-audit.md",
      "key": "originalMethod",
      "section": "Methods"
    },
    {
      "subject": "R runtime",
      "evidence": "notes/runtime.txt",
      "key": "rcore2026",
      "section": "Reproducibility",
      "software": {"version": "4.5.3", "url": "https://www.r-project.org/"}
    }
  ],
  "previous": {
    "references": "paper/earlier-references.tex",
    "retained": {"olderRKey": "rcore2026"},
    "dropped": {"oldOptimizer": "Only the earlier implementation used this optimizer."}
  }
}
```

Use `previous` when there is an earlier bibliography. It checks that every old
key is accounted for. Use `references` at the top level to list separate BibTeX
files, if any. Local TeX inputs within the study are read from the manuscript.
For an external nonsoftware link in a software section or an ambiguous versioned
link, use `other_links` to map its exact URL to the reason it is not a software
citation. Links to artifacts in the declared repository need no software row.

Run the shared gate from the repository root:

```sh
python3 scripts/release/citation_coverage.py --root STUDY_ROOT --paper paper/main.tex
```

The gate checks citation keys, the expected sections, versioned software links
and prior-reference dispositions. It flags unaccounted external links in
declared software sections, plus package registry links and links with
version-like labels elsewhere. Use ordinary LaTeX citation commands and a
bibliography with standard keys. For other source formats, record equivalent
inventory, cross-reference and rendered checks. The gate enforces the reviewed
inventory. Independent comparison with the research records establishes that
the inventory is complete and that each source supports its attribution.
