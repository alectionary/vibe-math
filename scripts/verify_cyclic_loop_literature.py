"""Verify the literature-only revision against the published research snapshot.

The original manifest includes documentation hashes, so preserve it at its
publication commit rather than silently rewriting it after editorial changes.
No scientific simulation or Lean rebuild is needed for this revision.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import re
import runpy
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BASE = '888beebab4153230f65a03970a5a51bcd68da51d'
HERE = ROOT / 'formalization/cyclic-lifts'
MANIFEST = HERE / 'loop-literature-verification.json'
EDITED_BASELINE = {
    'formalization/cyclic-lifts/README.md',
    'formalization/cyclic-lifts/LOOP-HOLDOUT.md',
    'formalization/cyclic-lifts/search/report_loop_holdout.py',
}
REVISION = sorted(EDITED_BASELINE | {
    'formalization/cyclic-lifts/LOOP-LITERATURE.md',
    'formalization/cyclic-lifts/search/loop-literature-review.json',
    'scripts/verify_cyclic_loop_literature.py',
})


def sha(raw):
    return hashlib.sha256(raw).hexdigest()


def at_baseline(rel):
    return subprocess.check_output(['git', 'show', BASE + ':' + rel], cwd=ROOT)


def check():
    baseline_manifest = 'formalization/cyclic-lifts/loop-holdout-verification.json'
    raw = at_baseline(baseline_manifest)
    assert (ROOT / baseline_manifest).read_bytes() == raw
    baseline = json.loads(raw)
    preserved = 0
    for rel, digest in baseline['sha256'].items():
        assert sha(at_baseline(rel)) == digest, ('published snapshot', rel)
        if rel not in EDITED_BASELINE:
            assert sha((ROOT / rel).read_bytes()) == digest, ('scientific artifact changed', rel)
            preserved += 1
    # Reuse the independent numerical, frozen-input and proof-log checks.
    runpy.run_path(str(ROOT / 'scripts/verify_cyclic_loop_artifacts.py'))['verify']()
    ledger = json.loads((HERE / 'search/loop-literature-review.json').read_text())
    assert len(ledger['sources']) == 20
    assert len({s['id'] for s in ledger['sources']}) == 20
    assert ledger['conclusions']['priority'] == 'not_established'
    for s in ledger['sources']:
        assert all(s[k] for k in ['title', 'authors', 'url', 'access', 'locator', 'relationship', 'comparison_limit'])
        if 'local_file' in s:
            assert sha((ROOT / s['local_file']).read_bytes()) == s['local_sha256']
    for rel in REVISION:
        text = (ROOT / rel).read_text()
        assert not re.search(r'/(?:Users|home)/|[A-Za-z0-9._%+-]+@(?:gmail|outlook|icloud)\.com', text, re.I), rel
        if rel.endswith('.py'):
            compile(text, rel, 'exec')
        if rel.endswith('.md'):
            for link in re.findall(r'\]\(([^)]+)\)', text):
                if '://' not in link and not link.startswith('#'):
                    assert ((ROOT / rel).parent / link.split('#')[0]).exists(), (rel, link)
    subprocess.run(['git', 'diff', '--check'], cwd=ROOT, check=True)
    hashes = {rel: sha((ROOT / rel).read_bytes()) for rel in REVISION}
    if '--write-manifest' in sys.argv:
        MANIFEST.write_text(json.dumps(dict(
            checked_at_utc=datetime.now(timezone.utc).isoformat(),
            status='literature_revision_checked_with_scientific_snapshot_unchanged',
            research_baseline_commit=BASE,
            original_manifest_sha256=sha(raw),
            unchanged_baseline_artifacts=preserved,
            deliberately_edited_baseline_documentation=sorted(EDITED_BASELINE),
            source_records=20,
            scope='Attribution and comparisons only; no new proofs, experiments or priority claim.',
            sha256=hashes,
        ), indent=2) + '\n')
    else:
        packet = json.loads(MANIFEST.read_text())
        assert packet['sha256'] == hashes
        assert packet['research_baseline_commit'] == BASE
        assert packet['original_manifest_sha256'] == sha(raw)
        assert packet['unchanged_baseline_artifacts'] == preserved
    print(f'Literature revision PASS: 20 records; {preserved} original artifacts unchanged')


if __name__ == '__main__':
    check()
