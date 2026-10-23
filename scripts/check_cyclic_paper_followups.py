"""Build the paper's local follow-up Lean imports in dependency order.

Run after obtaining the pinned Mathlib cache. This does not rerun experiments.
"""
from pathlib import Path
import os
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / 'formalization/dyadic-rank'
TARGETS = ['CyclicMergedWitnesses', 'CyclicDecoderTubes',
           'CyclicDecoderAudit', 'CyclicDecoderEntryAudit']


def ordered_modules():
    ordered, seen = [], set()

    def visit(module):
        if module in seen:
            return
        seen.add(module)
        source = LEAN / (module.replace('.', '/') + '.lean')
        if not source.is_file():
            raise FileNotFoundError(source)
        for dep in re.findall(r'^(?:public )?import ([A-Za-z0-9_.]+)',
                              source.read_text(), re.M):
            if (LEAN / (dep.replace('.', '/') + '.lean')).is_file():
                visit(dep)
            elif not dep.startswith(('Mathlib', 'Lean', 'Std', 'Init')):
                raise FileNotFoundError('Missing local import: ' + dep)
        ordered.append(module)

    for target in TARGETS:
        visit(target)
    return ordered


if __name__ == '__main__':
    lake = shutil.which('lake') or str(Path.home() / '.elan/bin/lake')
    modules = ordered_modules()
    print(f'Checking {len(modules)} local modules; no new noise or experiments.', flush=True)
    for module in modules:
        rel = module.replace('.', '/')
        output = LEAN / '.lake/build/lib/lean' / (rel + '.olean')
        output.parent.mkdir(parents=True, exist_ok=True)
        print(module, flush=True)
        subprocess.run([lake, '-f', 'lakefile-cyclic.toml', 'env', 'lean',
                        '-o', str(output.relative_to(LEAN)), rel + '.lean'],
                       cwd=LEAN, check=True)
