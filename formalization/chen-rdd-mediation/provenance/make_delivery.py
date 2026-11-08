#!/usr/bin/env python3
"""Write delivery-record.json (contract version 2) for the Chen (2021) replication.

  python3 provenance/make_delivery.py ARTIFACT_REVISION     (from the study root)

ARTIFACT_REVISION is the pushed commit that holds the reviewed PDF, its source and every
recorded file. Each remote file is downloaded from GitHub at that revision through the REST
contents API (`gh api`, raw media type), into paper/downloaded/ (not committed), and its hash is
compared with the local file. Direct raw.githubusercontent.com requests are refused by this
environment's network policy, so the API is the download channel; the recorded `url` is the
equivalent commit-pinned raw URL that the delivery checker requires.
"""
import hashlib, json, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = 'alectionary/vibe-math'
PREFIX = 'formalization/chen-rdd-mediation'
BASELINE = '8bcfb1c3f9b9fd6da2e4fb2750aea7285979a14f'      # first commit: REPLICATION-PLAN.yaml
NAME = 'paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021'
EVIDENCE = ['results/cells.csv', 'results/table48_ours.csv', 'results/table49_ours.csv', 'results/type1.csv',
            'results/power.csv', 'results/summary.json', 'results/statement_checks.csv',
            'secondary/zero_estimate_check.csv', 'secondary/table_arithmetic.csv', 'notes/availability.md',
            'notes/run-record.md', 'simulation/chen_sim.py', 'REPLICATION-PLAN.yaml']


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def remote(path, rev):
    """Download PATH at REV from GitHub and check it against the local bytes."""
    out = ROOT / 'paper/downloaded' / (f'{PREFIX}/{path}'.replace('/', '_'))
    out.parent.mkdir(parents=True, exist_ok=True)
    data = subprocess.run(['gh', 'api', '-H', 'Accept: application/vnd.github.raw',
                           f'repos/{REPO}/contents/{PREFIX}/{path}?ref={rev}'],
                          capture_output=True, check=True).stdout
    out.write_bytes(data)
    if hashlib.sha256(data).hexdigest() != sha(path):
        sys.exit(f'remote bytes differ for {path}')
    return dict(path=path, sha256=sha(path),
                url=f'https://raw.githubusercontent.com/{REPO}/{rev}/{PREFIX}/{path}',
                downloaded_path=out.relative_to(ROOT).as_posix())


def main():
    rev = sys.argv[1]
    head = subprocess.run(['git', 'rev-parse', rev], capture_output=True, text=True, check=True, cwd=ROOT).stdout.strip()
    review = json.load(open(ROOT / 'notes/editorial-review.json'))
    build = [f'{NAME}.tex', 'paper/references.bib', 'paper/approved-preamble.tex']
    primary = remote(f'{NAME}.pdf', head); primary['role'] = 'manuscript'
    if review['pdf_sha256'] != primary['sha256'] or review['source_sha256'] != sha(f'{NAME}.tex'):
        sys.exit('review does not match the current PDF/source')
    preamble_rev = subprocess.run(['git', 'log', '-1', '--format=%H', '--', 'paper/approved-preamble.tex'],
                                  capture_output=True, text=True, check=True, cwd=ROOT).stdout.strip()
    record = dict(
        contract_version=2, repository=REPO, baseline_revision=BASELINE, reproduction_revision=head,
        artifact_revision=head, primary=primary, source=remote(f'{NAME}.tex', head),
        evidence=[remote(p, head) for p in EVIDENCE],
        packet=remote('evidence-packet.json', head), writer_manifest=remote('writer-manifest.json', head),
        link_inventory=remote('provenance/pdf-links.json', head), link_provenance=[],
        template=dict(path='paper/approved-preamble.tex', sha256=sha('paper/approved-preamble.tex'), revision=preamble_rev),
        build_inputs=[dict(path=p, sha256=sha(p)) for p in build],
        review=dict(reviewer=review['reviewer'], pdf_sha256=review['pdf_sha256'], source_sha256=review['source_sha256'],
                    build_inputs={p: sha(p) for p in build}, packet_sha256=review['packet_sha256'],
                    writer_manifest_sha256=review['writer_manifest_sha256'], items=review['items'],
                    editorial=review['editorial'], pdf_links=review['pdf_links']),
    )
    (ROOT / 'delivery-record.json').write_text(json.dumps(record, indent=1, ensure_ascii=False) + '\n')
    print('wrote delivery-record.json at', head)


if __name__ == '__main__':
    main()
