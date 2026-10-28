#!/usr/bin/env python3
"""Finite selected-pair cover from fixed-covector X-basis hitting sets.

The cost of a cover is its number of edge cases modulo common translation
and sector exchange. It is monotone under adding source X orbits. Therefore
the invariant-annihilator lemma reduces optimality to255 fixed covectors.
All listed completion cases remain open.
"""
from pathlib import Path
import argparse
import hashlib
import json

ROOT=Path(__file__).resolve().parent


def canonical(e):
    a,b,h=e
    return min(e,(b,a,(-h)%16))


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    paths=[ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt'];X,Z=[[int(s,16) for s in p.read_text().split()] for p in paths]
    assert all((x&z).bit_count()%2==(X[j]&Z[i]).bit_count()%2 for i,x in enumerate(X) for j,z in enumerate(Z))
    edges=[(i,j,h) for i,x in enumerate(X[::16]) for j in range(45) for h in range(16) if (x&Z[16*j+h]).bit_count()%2]
    E=set(edges);assert len(E)==6238 and all((j,i,-h%16) in E for i,j,h in E)
    full=set(map(canonical,E));assert len(full)==3132
    by=[{canonical(e) for e in edges if e[0]==i} for i in range(45)]
    residues=[sum((((x>>(16*b))&65535).bit_count()%2)<<b for b in range(8)) for x in X[::16]]
    costs=[];best=None
    for w in range(1,256):
        H=[i for i,v in enumerate(residues) if (v&w).bit_count()%2]
        covered=set().union(*(by[i] for i in H))
        cost=(len(covered),len(H),w)
        costs.append({'fixed_mask':w,'case_count':len(covered),'anchor_orbits':H,'oriented_pair_count':sum(sum(e[0]==i for e in edges) for i in H)})
        if best is None or cost<best[0]:best=(cost,H,covered)
    (count,_,w),H,covered=best;assert count==1082 and w==140 and len(H)==12
    cases=[{'id':f'X{i:02d}-Z{j:02d}-h{h:02d}','X_index':16*i,'Z_index':16*j+h,'orbit_tuple':[i,j,h],'status':'unresolved'} for i,j,h in sorted(covered)]
    result={'status':'PASS','source_C16_answered':False,
        'theorem':'Every full source frame has a translate and optional sector exchange containing one of these1082 selected pairs. This case count is optimal among covers induced by whole-orbit hitting sets of all source X bases.',
        'common_translation_pair_orbits':6238,'translation_and_sector_exchange_pair_orbits':3132,
        'chosen_fixed_mask':w,'anchor_orbits_before_optional_exchange':H,'optimal_case_count':count,
        'costs_for_all_fixed_covectors':costs,'cases':cases,'whole_pair_cases_excluded':0,
        'scope':'A complete cover, not completed searches. No finishing runtime or global solver speedup follows. The optimality claim is confined to the stated X-basis-cover strategy, not all possible frame-specific decompositions.',
        'source_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS:3132 symmetry pair cases covered by1082 unresolved cases; optimal within the X-basis-cover strategy.',flush=True)


if __name__=='__main__':main()
