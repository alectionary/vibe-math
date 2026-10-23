"""Refresh the manuscript's source archive without changing scientific inputs."""
from pathlib import Path
import hashlib
import json
import shutil
import zipfile
from check_cyclic_paper_followups import ordered_modules

ROOT = Path(__file__).resolve().parents[1]
PAPER = ROOT / 'formalization/cyclic-lifts/paper'
ARTIFACT = PAPER / 'artifact'
HERE = ROOT / 'formalization/cyclic-lifts'
REVISION = 'c5561734e1b91c55911703ef4930f6e718624453'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def copy(rel):
    source = ROOT / rel
    target = ARTIFACT / rel
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, target)


def refresh():
    for module in ordered_modules():
        copy('formalization/dyadic-rank/' + module.replace('.', '/') + '.lean')
    copy('formalization/dyadic-rank/CyclicLogicalSix.lean')
    copy('scripts/check_cyclic_paper_followups.py')
    reports = ['DISTANCE-MATCHED', 'MILLION-PAIRED', 'DEGREE-PRESERVING',
               'MERGED-MILLION', 'MERGED-MECHANISM', 'LOOP-HOLDOUT',
               'LOOP-HOLDOUT-PROTOCOL', 'LOOP-LITERATURE', 'ENTRY-DYNAMICS',
               'ENTRY-CONFIRM-PROTOCOL', 'EXACT-GIRTH-PRIORITY-AUDIT-2026-10-23']
    for name in reports:
        copy('formalization/cyclic-lifts/' + name + '.md')
    # Include compact outcomes, exact calculations and historical build records.
    names = ['million-paired-results', 'merged-million-results',
             'loop-holdout-results', 'entry-confirm-results', 'entry-bit-bias',
             'entry-bernstein', 'entry-soft-controls', 'loop-literature-review',
             'entry-lean-build-results', 'loop-lean-build-results',
             'loop-reach-lean-build-results']
    for name in names:
        rel = 'formalization/cyclic-lifts/search/' + name + '.json'
        if (ROOT / rel).is_file():
            copy(rel)
    for pattern in ['entry*-lean*.log', 'entry-final-axioms.log',
                    'loop*-check.log', 'loop-reach-*.log']:
        for source in HERE.glob(pattern):
            copy(source.relative_to(ROOT).as_posix())
    snapshot = {
        'date': '2026-10-23', 'followup_source_revision': REVISION,
        'local_lean_dependency_closure': ordered_modules(),
        'scope': 'Original manuscript artifact plus complete later local Lean imports, reports and compact results. Large packed Monte Carlo streams and full implementation audits remain in the linked repository at the frozen revision. No new scientific results or noise were generated.',
        'repository': 'https://github.com/alectionary/vibe-math/tree/' + REVISION,
    }
    (ARTIFACT / 'FOLLOWUP-SNAPSHOT.json').write_text(json.dumps(snapshot, indent=2) + '\n')
    readme = ARTIFACT / 'README.txt'
    original = readme.read_text().split('\nLATER TRAJECTORY CHRONOLOGY SUPPLEMENT\n')[0]
    readme.write_text(original + '\nLATER TRAJECTORY CHRONOLOGY SUPPLEMENT\n'
        'The complete local follow-up Lean imports and generated proof data are now included.\n'
        'After obtaining the pinned Mathlib cache, run from this artifact root:\n'
        '  python3 scripts/check_cyclic_paper_followups.py\n'
        'This builds imports in dependency order; concrete trajectory checks can take minutes.\n'
        'FOLLOWUP-SNAPSHOT.json records the frozen revision and scientific scope.\n'
        'Compact results and reports are bundled; large packed experimental streams remain\n'
        'at the linked repository revision. Historical manifests and counts retain their scope.\n')
    contents = {p.relative_to(ARTIFACT).as_posix(): sha(p)
                for p in sorted(ARTIFACT.rglob('*'))
                if p.is_file() and p.name != 'MANIFEST_SHA256.json'
                and '__pycache__' not in p.parts and '.lake' not in p.parts}
    (ARTIFACT / 'MANIFEST_SHA256.json').write_text(json.dumps(contents, indent=2) + '\n')
    paths = [PAPER / 'main.tex', PAPER / 'LEAN-PROOF-GUIDE.md', PAPER / 'CLAIM-AUDIT.md']
    paths += [p for folder in [ARTIFACT, PAPER / 'listings']
              for p in folder.rglob('*') if p.is_file() and '__pycache__' not in p.parts and '.lake' not in p.parts]
    manifest = {p.relative_to(PAPER).as_posix(): sha(p) for p in sorted(paths)}
    (PAPER / 'source-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    archive = PAPER / 'cyclic-lift-girth-eight-source.zip'
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for name in sorted(list(manifest) + ['source-manifest.json']):
            info = zipfile.ZipInfo(name, (2026, 10, 23, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            z.writestr(info, (PAPER / name).read_bytes())
    print(f'Packaged {len(manifest) + 1} files, {archive.stat().st_size} bytes; '
          f'{len(ordered_modules())} follow-up Lean modules.')


if __name__ == '__main__':
    refresh()
