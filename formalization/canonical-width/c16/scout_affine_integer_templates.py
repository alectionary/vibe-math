#!/usr/bin/env python3
"""Bounded event search over a proved finite signed-unit parameter cohort.

Parameter coverage is complete only for the stated arities/equivalences.
Event placements are heuristic. A row cap limits subsequent model integration.
"""
from pathlib import Path
from fractions import Fraction
import argparse, datetime, hashlib, json, math, subprocess, sys, time
from physical_integer_form_rows import coordinate, compile_row
from verify_projected_profile_moment_rows import point_vector

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--prefix', type=Path, required=True)
    ap.add_argument('--binary', type=Path, required=True)
    ap.add_argument('--restarts', type=int, default=100)
    ap.add_argument('--seconds', type=float, default=180)
    ap.add_argument('--maximum-rows', type=int, default=1000)
    a = ap.parse_args()
    assert 0 < a.restarts <= 1000 and 0 < a.seconds <= 180 and 0 < a.maximum_rows <= 1000
    def path(suffix):
        p = Path(str(a.prefix)+suffix)
        assert not p.exists(), p
        return p
    cohort_path = Path('two-basis-results/affine-integer-template-coverage.json')
    cohort = json.loads(cohort_path.read_text())
    templates = cohort['canonical_templates']
    assert len(templates) == 275
    owner = point_vector(a.point)
    inp = path('-input.txt')
    with inp.open('w') as f:
        f.write('90 16\n'+' '.join(format(float(owner[i % 45]), '.17g') for i in range(90))+'\n')
        for h in range(16):
            f.write(' '.join(format(float(owner[coordinate(16*i, 16*j+h)]), '.17g')
                             for i in range(90) for j in range(90))+'\n')
    frozen_path = path('-frozen.json')
    source_paths = [Path(__file__), Path('separate_higher_integer_forms.cpp'),
                    Path('physical_integer_form_rows.py'), Path('verify_projected_profile_moment_rows.py'),
                    Path('accept_physical_integer_forms.py'), Path('verify_physical_integer_forms.py'),
                    Path('audit_affine_integer_templates.py'), cohort_path, a.point, inp]
    hashes = {str(p): sha(p) for p in source_paths}
    frozen = dict(status='FROZEN_BOUNDED_AFFINE_TEMPLATE_SCOUT', source_C16_answered=False,
                  utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  source_hashes=hashes, binary_sha256=sha(a.binary),
                  template_ids=[t['template_id'] for t in templates],
                  restarts_per_template=a.restarts, total_discovery_seconds=a.seconds,
                  seconds_per_template=10, maximum_rows_for_integration=a.maximum_rows,
                  scope='275 signed-unit parameter classes; bounded heuristic event placements, not complete separation.')
    frozen_path.write_text(json.dumps(frozen, indent=2)+'\n')
    started = time.monotonic()
    stages = []
    raw = []
    for k, t in enumerate(templates):
        remaining = a.seconds - (time.monotonic()-started)
        if remaining <= 0:
            break
        output = path(f'-template{k:03d}.json')
        cmd = [str(a.binary), str(inp), str(output), ','.join(map(str,t['weights'])),
               str(a.restarts), str(min(10,remaining)), str(202610301640+k), str(t['constant'])]
        with path(f'-template{k:03d}.log').open('w') as log:
            try:
                r = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT,
                                   timeout=min(10,remaining)+5)
                code = r.returncode
            except subprocess.TimeoutExpired:
                code = None
        if code != 0:
            stages.append(dict(template_id=t['template_id'], returncode=code))
            break
        d = json.loads(output.read_text())
        raw.extend(dict(c, template_id=t['template_id']) for c in d['cuts'])
        stages.append(dict(template_id=t['template_id'], returncode=0,
                           raw_candidates=len(d['cuts']), restarts=d['restarts'],
                           seconds=d['seconds'], artifact_sha256=sha(output)))
        if (k+1) % 25 == 0:
            print('templates',k+1,'raw',len(raw),'seconds',time.monotonic()-started,flush=True)
    candidates_path = path('-all-candidates.json')
    candidates_path.write_text(json.dumps(dict(status='HEURISTIC_AFFINE_TEMPLATE_PROPOSALS',
        source_C16_answered=False, frozen_sha256=sha(frozen_path), cuts=raw),indent=2)+'\n')
    unique = {}
    nonpositive = 0
    for c in raw:
        row, rhs = compile_row(c)
        gap = sum(v*owner[j] for j,v in row.items())-rhs
        if gap <= 0:
            nonpositive += 1
            continue
        g = math.gcd(*[abs(v) for v in [*row.values(),rhs]])
        key = (tuple((j,v//g) for j,v in row.items()),rhs//g)
        size = sum(abs(v) for v in row.values())+abs(rhs)
        score = gap/size
        if key not in unique or score > unique[key][0]:
            unique[key] = (score,c)
    selected = [r[1] for _,r in sorted(unique.items(),key=lambda z:(-z[1][0],z[0]))[:a.maximum_rows]]
    selected_path = path('-selected-candidates.json')
    selected_path.write_text(json.dumps(dict(status='EXACT_POSITIVE_DEDUPLICATED_PROPOSALS',
        source_C16_answered=False, cuts=selected, all_candidates_sha256=sha(candidates_path),
        positive_unique_rows=len(unique), selected_rows=len(selected),
        selection='Largest exact gap/(owner coefficient L1 plus absolute RHS); deterministic tie break.'),indent=2)+'\n')
    bank = path('-bank.json')
    receipt = path('-independent.json')
    commands = [
        [sys.executable,'accept_physical_integer_forms.py','--candidates',str(selected_path),
         '--point',str(a.point),'--output',str(bank)],
        [sys.executable,'verify_physical_integer_forms.py','--bank',str(bank),
         '--point',str(a.point),'--output',str(receipt)]]
    for k,cmd in enumerate(commands):
        with path(f'-accept{k}.log').open('w') as log:
            subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,timeout=120,check=True)
    assert json.loads(receipt.read_text())['status']=='PASS'
    assert all(sha(p)==h for p,h in hashes.items())
    out = dict(status='ACCEPTED_BOUNDED_AFFINE_TEMPLATE_ROWS' if selected else 'BOUNDED_AFFINE_TEMPLATE_NO_CUT',
               source_C16_answered=False, frozen_sha256=sha(frozen_path),
               templates_completed=len(stages), expected_templates=275,
               raw_candidates=len(raw), positive_unique_rows=len(unique),
               nonpositive_candidates=nonpositive, accepted_rows=len(selected),
               integration_row_cap_applied=len(unique)>len(selected),
               bank_sha256=sha(bank), receipt_sha256=sha(receipt), stages=stages,
               seconds=time.monotonic()-started, complete_event_placement_search=False)
    path('-summary.json').write_text(json.dumps(out,indent=2)+'\n')
    print({k:v for k,v in out.items() if k!='stages'},flush=True)


if __name__ == '__main__':
    main()
