# Release record templates

Keep these files in the released result's folder. Use them in proportion to the
result: a short note may combine them in one README with these headings.

## README

```markdown
# <Result title>

**Answer:** <the exact claim, with every hypothesis>.
**Scope:** <what is and is not established; restricted cases; what remains open>.
**Evidence:** <evidence label(s)>; see VERIFICATION.md.
**Source question:** <author, title, version, date, locator, arXiv/DOI>.
**Paper:** <default-branch PDF link> (<pinned link>).
```

## PROVENANCE

```markdown
# Provenance

Scientific revision: <commit> (tree <tree>), the revision the reviews accept.
Delivery commits after it change only: <prose / packaging / links>.

| Path | Git blob | SHA-256 | Role |
|---|---|---|---|

Generated files: <generator, its inputs and their hashes>.
External code: <repository, pinned commit, license>.
```

## IMPORTS

```markdown
# External results used but not checked here

| Result | Source and locator | Used in | Checked here? |
|---|---|---|---|
```

## VERIFICATION

```markdown
# Verification status

| Layer | What was checked | How, where, when | Result |
|---|---|---|---|
| Source identity | input hashes, manifests | | |
| Finite execution | searches, certificates, numerical runs | | |
| Independent check | spec-only implementation / review / rerun | | |
| Kernel-checked proof | Lean build, axiom report | | |

Not done: <anything a reader might assume was done but was not>.
Axiom report: <link>; compiled-evaluation axioms used by: <theorems>.
```

## Review record

```markdown
# Review: <component or composition>

Reviewer: <agent and model version, or person>. Not an author of: <files>.
Verdict: **ACCEPT | ACCEPT WITH CHANGES | REJECT** at scientific revision
<commit>, tree <tree>.

Exact claim reviewed: <statement>.
Files and SHA-256 reviewed: <table>.
Prerequisite reviews relied on: <links and their bound revisions>.
Checks performed: <what was read, rerun, rebuilt>.
Findings: <each with location and severity; or "none unresolved">.
Limits: <what this review is not, e.g. not external referee acceptance>.
```

## Replay packet

```markdown
# Replay

Requirements: <interpreters, compilers, Lean toolchain and versions known to work>.
Known not to work: <versions and symptom>.

    python3 replay.py            # quick checks, expected: PASS_<RESULT>_QUICK
    python3 replay.py --full     # adds long steps (<time>), expected: PASS_<RESULT>

| Step | What it checks | Time |
|---|---|---|
```
