# Code license and scope

Original VibeMath code in the scope below is licensed under the **Apache License,
Version 2.0** ([LICENSE](LICENSE)). This grant covers only rights the repository's
licensors are entitled to grant. It does not relicense third-party material or
assert ownership of mathematical ideas, source papers, or dependencies.

## Included code

The grant applies to original `.py`, `.cpp`, and `.lean` files under `scripts/`
and `formalization/`, subject to all the exclusions below. This includes original
proof implementations, computational checks and code comments; a citation to a
mathematical result does not claim authorship of that result. Third-party code,
quotations and source excerpts embedded in an otherwise included file retain
their own terms and are outside this grant.

## Exclusions take precedence

- **All of `formalization/higgott-quantum-decoding/`** is excluded from this new
  grant pending a finer separation of original wrappers, adapted circuits,
  generator outputs and source evidence. The existing Apache-2.0 grants on the
  imported generator and inputs remain in effect; see [THIRD_PARTY.md](THIRD_PARTY.md).
- **All `.R` files** are excluded pending review of imported OSF scripts,
  package-derived implementations, dissertation translations and their callers.
  This is a conservative review boundary, not a conclusion that using R or a
  GPL package makes every script a derivative work.
- Files in any directory component named `vendor`, `inputs`, `osf`,
  `source-evidence`, `artifact`, `paper` or `papers` are excluded, including code
  in those directories. Historical archives (`.zip`, `.gz`) are also excluded;
  their contents and prior terms are not changed by adding the root license.
- Everything outside the included code scope is excluded: papers and TeX,
  prose documentation and reviews, figures and dissertation crops, datasets,
  result tables, circuits (`.stim`), logs, certificates stored as data, source
  extracts, metadata, HTML, configuration, and `.agents/` skill material.
  No Creative Commons or other new content license is granted here.

Exclusion from this new grant does not revoke an existing license, prohibit
uses permitted by law, or establish that an item has no existing license.
Keep applicable upstream licenses, copyright and attribution notices when
redistributing upstream material. The root license never overrides them.

## Review and maintenance

The [rights inventory](THIRD_PARTY.md) records the evidence, known imports and
unresolved cases. New copies, adaptations and dependencies should be checked
before inclusion; the file extension alone does not establish ownership.
Do not treat Git author labels as proof of copyright ownership or contributor
consent. If independently owned contributions are identified without authority
to license them, they remain outside this grant pending authorization.

A repository citation file is deferred: public manuscripts have blank author
fields, and Git identities do not establish the intended scholarly author list.
The maintainer should supply the repository citation title and credited authors
before `CITATION.cff` is added. Cite individual papers and upstream projects
using their own bibliographic records; repository citation cannot replace them.
