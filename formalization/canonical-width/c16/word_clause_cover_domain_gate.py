#!/usr/bin/env python3
"""Static owner-domain eligibility on the unchanged405-case cover; no solver."""
from pathlib import Path
from collections import Counter
import argparse,hashlib,json,time
from verify_algebraic_model import physical
from verify_partial_frame import mask,shift
from audit_pools import exchange
from signature_cover import logical_data
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();assert not args.output.exists();start=time.monotonic()
 bp=ROOT/'coupling-results/word-subspace-minimized-new-cuts.json';cp=ROOT/'transfer-results/cover-405.json';cuts=json.loads(bp.read_text())['cuts'];cover=json.loads(cp.read_text());X,Z,A=physical();AA,C,E=logical_data();assert AA==A;retained={tuple(r['orbit_tuple']) for r in cover['cases']};assert len(retained)==405;removed=set(C)-retained
 patterns=[(k,h,sorted(16*(j//16)+(j%16+h)%16 for j in c['indices'])) for k,c in enumerate(cuts) for h in range(16)];base=[e for e in E if C[e[3]] in removed];byclass={c:[] for c in retained}
 for e in E:
  if C[e[3]] in retained:byclass[C[e[3]]].append(e)
 records=[]
 for r in cover['cases']:
  target=tuple(r['orbit_tuple']);anchor=r['X_index'],r['Z_index'];edges=[e for e in [*base,*byclass[target]] if e[0]!=anchor[0] and e[1]!=anchor[1] and not A[e[0]]>>anchor[1]&1 and not A[anchor[0]]>>e[1]&1];owner_sets=[{e[s] for e in edges} for s in (0,1)]
  eligible=[]
  for k,h,J in patterns:
   for side in (0,1):
    rest=sorted(set(J)-{anchor[side]})
    if set(rest)<=owner_sets[side]:eligible.append(dict(cut=k,phase=h,sector=side,remaining_indices=rest))
  records.append(dict(case=list(target),anchor=list(anchor),free_edges=len(edges),eligible_source_clauses=eligible))
 pp=ROOT/'partial-frame-88.json';partial=json.loads(pp.read_text());source=json.loads((ROOT/'physical-pool-source.json').read_text());zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];xp=list(map(exchange,zp));lookup=[{v:i for i,v in enumerate(pool)} for pool in (xp,zp)];pairs=[(lookup[0][mask(p['X'])],lookup[1][mask(p['Z'])]) for p in partial['pairs']];assert len(pairs)==partial['n_pairs']==88
 for i,(x,z) in enumerate(pairs):
  for j,(xx,zz) in enumerate(pairs):assert (A[x]>>zz&1)==int(i==j)
 selected=[{p[s] for p in pairs} for s in (0,1)];partial_hits=[dict(cut=k,phase=h,sector=s) for k,h,J in patterns for s in (0,1) if set(J)<=selected[s]]
 gp=ROOT/'transfer-results/global-trial.json';global_data=json.loads(gp.read_text());hits=[]
 for number,r in enumerate(global_data['records']):
  selected=[{p[s] for p in r['pairs']} for s in (0,1)];matches=[dict(cut=k,phase=h,sector=s) for k,h,J in patterns for s in (0,1) if set(J)<=selected[s]]
  if matches:hits.append(dict(record=number,matches=matches,already_rejected_by_cut_indices=r.get('cut_indices',[]),old_cut_kinds=[global_data['cuts'][i]['kind'] for i in r.get('cut_indices',[])]))
 paths=[bp,cp,pp,gp,ROOT/'physical-pool-source.json',ROOT/'verify_algebraic_model.py',ROOT/'signature_cover.py',ROOT/'verify_partial_frame.py',ROOT/'audit_pools.py',Path(__file__)]
 out=dict(status='PASS_STATIC_APPLICATION_GATE',source_C16_answered=False,cover_before=405,cover_after=405,solver_calls=0,input_hashes={str(p.relative_to(ROOT)):sha(p) for p in paths},records=records,cases_admitting_at_least_one_clause=sum(bool(r['eligible_source_clauses']) for r in records),eligible_clause_occurrences=sum(len(r['eligible_source_clauses']) for r in records),eligible_clauses_per_case_histogram=dict(Counter(len(r['eligible_source_clauses']) for r in records)),partial88_physical_replayed=True,partial88_clause_hits=partial_hits,old_global_hard_case_hits=hits,elapsed_seconds=time.monotonic()-start,
          scope='Exact static owner-domain eligibility for extra negative clauses in every current405-cover extension domain. Eligibility does not assert CNF nonredundancy or improve a proof. No SAT or full-anchor exclusion. Partial88 is checked only for containment of these clauses.')
 args.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['records','input_hashes']})
if __name__=='__main__':main()
