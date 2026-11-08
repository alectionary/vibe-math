#!/usr/bin/env python3
"""Source-specific paired-basis covers from a dual expansion identity.

If beta(u,v)=1 and (x_i,z_i) is a full dual frame, then
  1 = sum_i beta(x_i,v) beta(u,z_i) in F2.
Consequently some selected pair passes both tests. With v fixed by cyclic
translation the test's orbit support is simple to calculate, without assuming
that the selected frame is invariant. No minimum over arbitrary u is claimed.
"""
from pathlib import Path
import argparse
import hashlib
import json
import time

ROOT = Path(__file__).resolve().parent


def canonical(e):
    a,b,h = e
    return min(e, (b,a,-h%16))


def residue(v):
    return sum((((v >> (16*b)) & 65535).bit_count()%2) << b for b in range(8))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--two-source-sums',action='store_true')
    a = ap.parse_args()
    start = time.monotonic()
    paths = [ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']
    X,Z = [[int(s,16) for s in p.read_text().split()] for p in paths]
    rows = [sum(((x&z).bit_count()%2) << j for j,z in enumerate(Z)) for x in X]
    oriented = [(i,j,h) for i in range(45) for j in range(45) for h in range(16) if rows[16*i] >> (16*j+h) & 1]
    allcases = sorted(set(map(canonical,oriented)))
    pos = {e:k for k,e in enumerate(allcases)}
    incidence = [[0]*45 for _ in range(45)]
    for i,j,h in oriented:
        incidence[i][j] |= 1 << pos[canonical((i,j,h))]
    residues = list(map(residue,X[::16]))
    H = {w:[i for i,r in enumerate(residues) if (r&w).bit_count()%2] for w in range(1,256)}
    byZ = {}
    for w in range(1,256):
        byZ[w] = []
        for j in range(45):
            mask = 0
            for i in H[w]:
                mask |= incidence[i][j]
            byZ[w].append(mask)
    candidates = [(1 << (16*b), {'kind':'coordinate','coordinate':16*b}) for b in range(8)]
    candidates += [(X[16*i], {'kind':'source_X','indices':[16*i]}) for i in range(45)]
    if a.two_source_sums:
        candidates += [(X[16*i]^X[j], {'kind':'source_X_sum','indices':[16*i,j]}) for i in range(45) for j in range(16*i+1,720)]
    # Derive active Z orbits by literal scalar products, accelerated for sums
    # using already independently constructed source pairing rows.
    best = None
    improvements = []
    seen = set()
    examined = 0
    costs = 0
    for u,description in candidates:
        ur = residue(u)
        if not ur:
            continue
        if description['kind'].startswith('source_X'):
            pairing = 0
            for index in description['indices']:
                pairing ^= rows[index]
        else:
            pairing = sum(((u&z).bit_count()%2) << j for j,z in enumerate(Z))
        B = [j for j in range(45) if pairing >> (16*j) & 65535]
        key = (ur,tuple(B))
        examined += 1
        if key in seen:
            continue
        seen.add(key)
        for w in range(1,256):
            if not (ur&w).bit_count()%2:
                continue
            cover = 0
            for j in B:
                cover |= byZ[w][j]
            cost = cover.bit_count()
            costs += 1
            if best is None or cost < best[0]:
                best = (cost,w,u,description,B,cover)
                improvements.append({'case_count':cost,'fixed_mask':w,'u':description,'X_orbits':H[w],'Z_orbits':B})
                print(f'Improved to {cost} cases; mask {w}, u={description}; {time.monotonic()-start:.2f}s',flush=True)
    cost,w,u,description,B,cover = best
    v = sum(65535 << (16*b) for b in range(8) if w >> b & 1)
    assert (u&v).bit_count()%2 == 1
    cases = []
    for k,(i,j,h) in enumerate(allcases):
        if cover >> k & 1:
            cases.append({'id':f'X{i:02d}-Z{j:02d}-h{h:02d}','X_index':16*i,'Z_index':16*j+h,'orbit_tuple':[i,j,h],'status':'unresolved'})
    result = {'status':'PASS','source_C16_answered':False,
              'theorem':'Every full source frame has a translate and optional sector exchange containing one listed pair, by 1=sum beta(x_i,v) beta(u,z_i).',
              'proof_conditions':{'beta_u_v':1,'v_fixed_mask':w,'u_logical_hex':hex(u),'v_logical_hex':hex(v),'u_construction':description},
              'X_orbits_before_optional_exchange':H[w],'Z_orbits_before_optional_exchange':B,
              'case_count':cost,'cases':cases,'whole_pair_cases_excluded':0,
              'discovery':{'candidate_family':'8 phase-zero coordinate vectors and45 phase-zero source X vectors'+(' plus every two-source sum with first summand phase zero' if a.two_source_sums else ''),
                           'candidate_count':len(candidates),'nonzero_residue_candidates':examined,'distinct_residue_active_orbit_signatures':len(seen),'fixed_mask_costs_evaluated':costs,'improvements':improvements},
              'scope':'Exact sufficient cover; no optimum over arbitrary witnesses or covers, no completed conditional case, no demonstrated runtime gain.',
              'source_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
              'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f'Saved proved-cover candidate with {cost} unresolved cases; independent replay required.',flush=True)


if __name__ == '__main__':
    main()
