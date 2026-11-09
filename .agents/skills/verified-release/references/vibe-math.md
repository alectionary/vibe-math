# vibe-math specifics

## Shared release scripts (`scripts/release/`)

| Script | Purpose |
|---|---|
| `file_manifest.py OUT.json BASE PATTERN...` | Path, bytes, SHA-256 and Git blob id for every release file (PROVENANCE, replay packets). |
| `pdf_link_audit.py PAPER.pdf --repo alectionary/vibe-math --git-dir . --default-ref HEAD` | Checks every repository link in the built PDF: path and type, line anchors, and that a default-branch anchor and its pinned twin show the same line. Run before merging with `--default-ref HEAD`, and after merging with `--default-ref origin/master`. |
| `lean_appendix.py CONFIG.json` | Prints complete Lean declarations into a LaTeX appendix with default-branch and pinned links; fails if a declaration differs from its pin. Example config: `formalization/canonical-width/c16/paper/lean-appendix.json`. |

Replication studies keep using replication-paper's own checks
(`preflight.py`, `delivery_check.py`, `pdf_links.py`, `pr_description.py`); they are
stricter for that workflow. These scripts are for releases that those checks do not cover.

## Lean trust policy

Decided 8 November 2026: compiled evaluation (`native_decide`, `Lean.ofReduceBool`) is
**accepted and disclosed**. Every theorem that uses it is marked in the paper's Lean table and
listed in the release's VERIFICATION record. `sorry` and project-defined axioms are never
accepted. Replacing compiled evaluation with kernel-only proofs is planned; the C16 attempt and
the repository axiom gate are tracked in
[issue #84](https://github.com/alectionary/vibe-math/issues/84)
([brief](../../../../formalization/canonical-width/c16/independent-check/KERNEL-ONLY-SPEC.md)).
Until that gate lands, produce the axiom report by compiling a file that imports the modules
and runs `#print axioms` on each cited theorem, and record its output and exit status.

Lean builds here use the pinned toolchain and Mathlib in each project's `lean-toolchain` and
`lake-manifest.json`. Check the exit status of every build; 137 is out of memory.

## Repository conventions

- Commit as `alectionary <alectionary@users.noreply.github.com>`. Once per clone,
  `git config core.hooksPath .githooks`. Consumer-domain author, committer, and
  message addresses are rejected; noreply addresses are allowed. See
  [CONTRIBUTING.md](../../../../CONTRIBUTING.md).
- Finished work belongs on `master`. `master` requires one approving review; ask the user
  before merging past it. Merge with ordinary merges, never squash, when pinned links exist.
- Built papers are committed under `<project>/paper/output/pdf/` (force-add: `*.pdf` is
  ignored). The README's results index lists each released result.
- Agent coordination uses one issue per agent; examples: #76, #77, #79 (certificate checkers
  and Lean proofs), #84 (kernel-only proofs).
- Use REST (`gh api repos/...`), not GraphQL, from Claude Code sessions.
- Code under `scripts/` and `formalization/`, and skills under `.agents/skills/`, are licensed
  Apache-2.0 ([LICENSING.md](../../../../LICENSING.md)).

## Worked example: C16 symmetric frames

[`formalization/canonical-width/c16/`](../../../../formalization/canonical-width/c16/): search
certificates (`restricted-frames-20261031/certificates/`), the spec-only checker brief
(`independent-check/CERT-SPEC.md`) and the independent C++ checker (`independent-check/chatgpt-certcheck/`),
a Lean certificate checker (`lean/CertGPT*.lean`), the paper with chronology and Lean appendix
(`paper/`), and its release records (`RELEASE.md`). Lessons are in
[RESEARCH-LESSONS.md](../../../../RESEARCH-LESSONS.md#c16-certify-the-search-and-check-it-independently).
