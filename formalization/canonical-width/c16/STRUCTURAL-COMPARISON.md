# C16 structural-method comparison

- Canonical target: `L-F91-c16-unrestricted-width`; follow-up to issue8 and the six-hour handoff.
- Source: Lee, arXiv:2610.06820v1, Proposition9, equation50. Determine unrestricted width16 or18 by a physically checked128-pair minimum-weight frame or a complete justified obstruction.
- Session: `codex-c16-structural-20261027T173245Z`.
- User authorization: “Thanks, proceed with your recommendation. If this works, we may update our lessons learned accordingly.”
- Start:2026-10-27T17:32:45Z.
- Branch: `research/c16-structural-20261027T173245`; isolated worktree `/private/tmp/c16-structural-20261027T173245`.
- Prior checkpoint: `baad1cd6811c78fd13da2c7e76bc14625b6db451`.
- Issue: https://github.com/alectionary/vibe-math/issues/8 . No Project requested. No external message authorized.

## Answer contract and bounded deliverable

The canonical width remains16 or18; the checked physical partial frame remains88 pairs. This block changes the research method, not the question. Its first deliverable is a controlled comparison of stronger necessary conditions: local Hall/private-owner allocation, a symmetry-reduced low-degree semidefinite relaxation, and cyclic-filtration identities. A failed or feasible relaxation is not a proof that a full frame exists. Numerical infeasibility must be converted into an exact certificate before answering the source question.

Each new condition must retain explicit positive controls and pass an independent implementation check. A method earns a lessons-learned update only if a frozen comparison establishes an actual gain or a definite failure of a proposed shortcut; installation, theorem names and increased node counts are not successes.

The first comparison has a90-minute review endpoint,19:02:45Z, with experiments cut off by18:45Z and time reserved for verification/preservation. Individual solver limits are explicit and no more than six CPU workers are allocated. No request to stop a process should be needed: use child-process wall limits and stop sentinels from the outset. Continuing a productive route is considered only after the first comparison's evidence is reviewed, within the user's authorization.

## OpenAI-library applicability

The prior read-only audit pins `openai/math` at `7ef5c0cc5ca4b0e072b7a050fca09ab24bc6fa3a`. `OAI.Algorithms.SubexponentialSAT` has an asymptotic fixed-clause-width machine theorem, with unspecified constants and thresholds; no executable practical speedup has been established. Its displayed scale n(log(log(n+16)))²/sqrt(log(n+16)) is about1.39n at720 variables and1.81n at273951 variables before its exponent constant. This does not provide a finite-size performance advantage for our encodings. `OAI.CommonBasesFPRAS` counts common matroid bases, while our identity cross-pairing condition is additional. `OAI.PerfectMatchingPSD` is a lower-bound result. None is imported as an assumed solution to C16.

The immediate practical work uses exact finite arithmetic and available optimization tools. Lean formalization remains a separate bridge, with no completion claimed from a numerical solver status.

## Claim protocol

Prepare and push this ownership commit, acquire the canonical claim create-only, and verify the server SHA before substantial implementation. Keep the claim fixed while work commits advance. Release only this ownership SHA after preserving the block's outcome.
