# Phase choice and loss protection: Denys (2024)

Bounded replication of Figure 3.2 in Aurélie Denys's doctoral dissertation, *Quantum key distribution and quantum error correction with bosonic systems* (Sorbonne Université, defended 5 April 2024; adviser Anthony Leverrier).

The selected performance comparisons partly replicate: seed-phase improvement has the same sign at all four amplitudes, and group enlargement worsens three points but improves the fourth in both source and replication. Ten of twelve values fall inside the declared figure-extraction envelopes; two extended-group values remain outside. No original point precision or solver uncertainty is available, so rounding agreement and statistical source rankings are withheld. This is not a replication of the whole thesis or a search for optimal amplitude.

Main paper: [phase_choice_and_loss_protection__a_replication_of_denys_pauli_codes.pdf](paper/phase_choice_and_loss_protection__a_replication_of_denys_pauli_codes.pdf). Editable source and bibliography are in [paper/](paper/). Main-paper master links are navigation aids that become available only after merge. The draft PR supplies current-commit review links.

## Reproduction revision

The paper records an immutable computational commit containing the scripts, saved outputs and extracted inputs below. The earlier master baseline in provenance/workflow.json is historical context, not a runnable reproduction target. Start at the paper's computational commit for calculations; use the PR's artifact commit to rebuild that exact paper. No source thesis or original author's code is bundled. No random seeds are used: the computations are deterministic optimizations (floating-point solver differences remain possible).

## Environment and installation

Run every command below **from the repository root** on Linux with Python 3.12, a C/C++ runtime, pdflatex and Poppler pdftoppm. The recorded environment used Python3.12.14, pdfTeX3.141592653-2.6-1.40.26 (TeX Live2025/dev/Debian), Poppler26.05.0. Exact Python versions are in requirements.txt. The pilot budget was 4CPU/16GiB, one BLAS thread per run; primary pilot projected under15seconds and all12 independent cases took about15seconds. Allow several minutes for installation, plots, 600dpi crops and PDF compilation. No checkpoints are resumed: each numerical command rewrites its named output, with per-condition saves in the primary/diagnostic scripts. Preserve committed results and write alternative reruns to /tmp when comparing.

```sh
python3 -m venv formalization/denys-bosonic-pauli/.venv
formalization/denys-bosonic-pauli/.venv/bin/pip install -r formalization/denys-bosonic-pauli/requirements.txt
export PATH="$PWD/formalization/denys-bosonic-pauli/.venv/bin:$PATH"
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1
export MPLCONFIGDIR=/tmp/denys-matplotlib XDG_CACHE_HOME=/tmp/denys-cache
python .agents/skills/replication-paper/scripts/preflight.py --fallback formalization/denys-bosonic-pauli/provenance/engine_departure.json
```

The preflight fallback is deliberate: SEM engines do not express a complex quantum recovery SDP. Its final acceptance was recorded after independent validation; the initial generic pre-compute preflight failed because SEM engines were absent. This timing departure is disclosed, not a prospective approval claim.

## Rerun numerical calculations

```sh
python formalization/denys-bosonic-pauli/replicate.py --pilot --output /tmp/denys-primary-pilot.json
python formalization/denys-bosonic-pauli/replicate.py --output /tmp/denys-primary.json
python formalization/denys-bosonic-pauli/independent_check.py --pilot --output /tmp/denys-independent-pilot.json
python formalization/denys-bosonic-pauli/independent_check.py --output /tmp/denys-independent.json
python formalization/denys-bosonic-pauli/independent_check.py --pilot --cutoff 40 --max-lost 10 --output /tmp/denys-convergence.json
python formalization/denys-bosonic-pauli/diagnostics.py
```

The committed outputs/primary.json remains the baseline; diagnostics.py rewrites outputs/solver_sensitivity.json and normalization.json only. The independent check has a distinct Fock channel and SCS optimizer, but shares the thesis definitions, scientific objective and CVXPY frontend. Its larger-cutoff check uses the largest selected alpha, all3 codes. Expected: maximum primary-independent gap about1.1e-8; identity fidelity1, full-loss fidelity.25; no point-direction reversals. Do not treat runtime-dependent seconds fields or PDF metadata as mathematical discrepancies.

## Rebuild the report from saved outputs

No thesis download or numerical optimization is needed here.

```sh
python formalization/denys-bosonic-pauli/analyze.py
cd formalization/denys-bosonic-pauli/paper
pdflatex -interaction=nonstopmode -halt-on-error phase_choice_and_loss_protection__a_replication_of_denys_pauli_codes.tex
pdflatex -interaction=nonstopmode -halt-on-error phase_choice_and_loss_protection__a_replication_of_denys_pauli_codes.tex
cd ../../..
python .agents/skills/replication-paper/scripts/check_citations.py formalization/denys-bosonic-pauli/paper/phase_choice_and_loss_protection__a_replication_of_denys_pauli_codes.tex --references formalization/denys-bosonic-pauli/paper/references.tex --log formalization/denys-bosonic-pauli/paper/phase_choice_and_loss_protection__a_replication_of_denys_pauli_codes.log
```

analyze.py consumes saved primary.json and source_values.json, writes comparison.json, contrasts.json, coverage.json, two table fragments and selected_performance.pdf. Expected coverage20 signed comparisons (8headline/12supporting), 10/12 extraction-envelope inclusions. The generated connecting lines only guide the eye; no intermediate-alpha computation is claimed. Availability/compliance table fragments are copied records of the two provenance JSON ledgers, reviewed manually rather than inferred from a helper pass.

## Re-extract the external source

Only this step needs the external full thesis. Obtain the exact publicly readable author-hosted file, keep it outside git, and verify its hash before any page-index extraction. If access fails, stop extraction rather than substituting a different edition.

```sh
curl --fail --location https://raw.githubusercontent.com/aurelie-denys/aurelie-denys.github.io/5aefd7b6caca97df7bf49ece36c6c91ba955d0fc/PhDThesisAurelieDenys.pdf --output /tmp/PhDThesisAurelieDenys.pdf
printf '%s\n' '4cadbf1bbacdc7b21bb36479dbbadc0da5013c8c67f794bff0206d345e0b4156  /tmp/PhDThesisAurelieDenys.pdf' | sha256sum --check
python formalization/denys-bosonic-pauli/extract_source.py /tmp/PhDThesisAurelieDenys.pdf /tmp/denys-source
python formalization/denys-bosonic-pauli/crop_source.py /tmp/PhDThesisAurelieDenys.pdf /tmp/denys-source
```

Compare /tmp/denys-source/source_values.json and five PNG hashes against committed source-evidence files. crop_manifest.json includes historical absolute command paths; newly generated paths legitimately differ. No original data or Figure3.2 solver implementation was obtained; the linked GitLab code concerned chapter2 and denied access. See [availability.json](provenance/availability.json) and [RIGHTS.md](source-evidence/RIGHTS.md).

## Review and boundaries

[analysis_plan.json](provenance/analysis_plan.json) declares the subset after pilot, before full-results review; it is not preregistration. [source_review.md](provenance/source_review.md) verifies source identity and equations. The independent numerical review and rendered-main-PDF review are recorded separately. Delivery is complete only with remote-byte hashes and a draft PR, not this README alone. No source is relicensed and no author contact or external announcement was made.
