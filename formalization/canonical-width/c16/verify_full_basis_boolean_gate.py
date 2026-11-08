#!/usr/bin/env python3
"""Literal completion lower-bound consumer, independent of producer/NumPy/features."""
from pathlib import Path
import gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
BP=ROOT/'coupling-results/full-basis-boolean-gate.json';OUT=ROOT/'coupling-results/full-basis-boolean-gate-independent.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
 assert not OUT.exists();start=time.monotonic();bank=read(BP);frozen=read(BP.with_suffix('.frozen.json'));assert bank['frozen_sha256']==sha(BP.with_suffix('.frozen.json'));assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items())
 X,Z,A=physical();assert dimension(X)==dimension(Z)==128
 from verify_partial_frame import mask,shift
 from audit_pools import exchange
 source=read(ROOT/'physical-pool-source.json');zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];xp=list(map(exchange,zp));lookup=[{v:i for i,v in enumerate(U)} for U in (xp,zp)]
 physical88=[tuple(lookup[s][mask(r[side])] for s,side in enumerate(('X','Z'))) for r in read(ROOT/'partial-frame-88.json')['pairs']]
 profile=next(r for r in read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz')['records'] if r['orbit']==32);bad=[r['mask'] for r in profile['minimal_bad_certificates']];allowed=[p for p in range(65536) if not any(p&b==b for b in bad)]
 cache={};results=[];positive=[]
 for rec in bank['completion_lower_bounds']:
  key=rec['source'],rec['record']
  if key not in cache:
   original=read(ROOT/rec['source']) if rec['source']!='partial-frame-88.json' else None;r=original['records'][rec['record']] if original else None;pairs=r['pairs'] if r else physical88
   sx={x for x,z in pairs};sz={z for x,z in pairs};assert len(sx)==len(sz)==len(pairs)
   assert all(((X[x]&Z[z]).bit_count()%2)==int(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs))
   ax=[i for i in range(720) if i in sx or all(not(X[i]&Z[z]).bit_count()%2 for z in sz)];az=[j for j in range(720) if j in sz or all(not(X[x]&Z[j]).bit_count()%2 for x in sx)]
   must={x-512 for x in sx if 512<=x<528};possible={x-512 for x in ax if 512<=x<528};pmasks=[p for p in allowed if must<={t for t in range(16) if p>>t&1}<=possible]
   cache[key]=(pairs,sx,sz,ax,az,pmasks,r,original)
  pairs,sx,sz,ax,az,pmasks,r,original=cache[key];assert len(pmasks)==rec['possible_P_masks'] and len(az)==rec['possible_Z_count']
  cb=read(ROOT/'coupling-results'/rec['bank']);cut=cb['cuts'][rec['cut']];c=cut['coefficients'];B=cut['upper_bound'];assert B==rec['bound'];anchor=cb.get('anchor',80);minimum=None;branches=[]
  for p in pmasks:
   P=[t for t in range(16) if p>>t&1]
   for state in ([0,1] if len(c)==1512 else [None]):
    fixed=set(sz);eligible=set(az)
    if state==0:
     if anchor in fixed:continue
     eligible.discard(anchor)
    elif state==1:
     if anchor not in eligible:continue
     fixed.add(anchor)
    n=128-len(fixed)
    if n<0 or len(eligible)<128:continue
    weights={j:int(c[10+j//16])+sum(int(c[55+16*(j//16)+(j%16-t)%16]) for t in P)+(int(c[792+j]) if state else 0) for j in eligible}
    chosen=sorted(eligible-fixed,key=lambda j:(weights[j],j))[:n];assert len(chosen)==n
    local=int(c[0])+int(c[1])*len(P)+sum(int(c[1+h])*sum((t+h)%16 in P for t in P) for h in range(1,9))
    if state:local+=int(c[775])+sum(int(c[776+t]) for t in P)
    value=local+sum(weights[j] for j in fixed)+sum(weights[j] for j in chosen);minimum=value if minimum is None else min(minimum,value);branches.append(dict(mask=p,anchor_selected=state,local_score=local,required_Z=sorted(fixed),minimizing_selected_Z=sorted(fixed|set(chosen)),lower_bound=value))
  assert minimum==rec['count_completion_lower_bound'] and (minimum is None)==rec['already_count_or_profile_infeasible'];assert (minimum is not None and minimum>B)==rec['pruned_by_bound']
  row=dict(bank=rec['bank'],cut=rec['cut'],source=rec['source'],record=rec['record'],checked_branches=len(branches),minimum=minimum,bound=B,pruned=rec['pruned_by_bound'])
  if row['pruned']:
   row.update(pairs=pairs,branches=branches,eligible_X_rank=dimension(X[i] for i in ax),eligible_Z_rank=dimension(Z[j] for j in az),selected_X_rank=dimension(X[i] for i in sx),selected_Z_rank=dimension(Z[j] for j in sz),previous_cut_indices=r.get('cut_indices',[]) if r else [],previous_cut_kinds=[original['cuts'][i]['kind'] for i in r.get('cut_indices',[])] if r else []);positive.append(row)
  results.append(row)
 assert len(results)==bank['completion_tests'] and sum(r['pruned'] for r in results)==bank['completion_bound_prunings']
 # Source proof: fullframe containingselectedpairs mayuse onlyeligiblepools,
 # mustcontainmandatoryvertices, and hasexactly128Z. ExhaustiveallowedPmasks,
 # bothqastates and sorted signed cardinality minima lowerbound everycompletion.
 out={'status':'PASS_LITERAL_COMPLETION_LOWER_BOUNDS','source_C16_answered':False,'producer_bank_sha256':sha(BP),'consumer_sha256':sha(__file__),'source_hashes':frozen['source_hashes'],'literal_tests':len(results),'distinct_partial_configurations':len(cache),'positive_row_configuration_tests':len(positive),'distinct_pruned_configurations':len({(r['source'],r['record']) for r in positive}),'positive_witnesses':positive,'results':results,'seconds':time.monotonic()-start,'scope':'Bounded saved-configuration completion lowerbounds only. No CNF/SAT run, actual cover case exclusion, or source closure.'}
 OUT.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['source_hashes','results','positive_witnesses']}))
if __name__=='__main__':main()
