#!/usr/bin/env python3
"""Strengthen rank subsets to their full physical span closures."""
from pathlib import Path
import argparse,hashlib,json,time
from weighted_matroid_separator import insert
from verify_weighted_matroid_cuts import bound as independent_bound
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificates',type=Path,nargs='+',required=True);ap.add_argument('--replays',type=Path,nargs='+',required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();assert len(a.certificates)==len(a.replays);X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];cuts=[];bindings=[];seen={};trivial=0
 for path,replay in zip(a.certificates,a.replays):
  d=json.loads(path.read_text());receipt=json.loads(replay.read_text());assert receipt['status']=='PASS' and receipt['certificate_sha256']==hashlib.sha256(path.read_bytes()).hexdigest()
  for k,c in enumerate(d['cuts']):
   U=X if c['sector']=='S' else Z;anchor=16*c['anchor_orbit'];mandatory=anchor if c['sector']=='S' else None;J=set(c['indices']);aug=J|({anchor} if mandatory is not None else set());piv={}
   for j in sorted(aug):insert(piv,U[j])
   def inside(v):
    while v:
     p=v.bit_length()-1
     if p not in piv:return False
     v^=piv[p]
    return True
   F=[j for j,v in enumerate(U) if inside(v)];r=len(piv);assert J<=set(F) and (mandatory is None or anchor in F);assert independent_bound(U,J,mandatory)==c['bound'];assert independent_bound(U,F,mandatory)==r
   # New minus old LHS-minus-bound is a sum of nonnegative moments;
   # if a was absent, its new moment cancels the one-unit bound increase.
   added=set(F)-J;offset=r-c['bound'];assert offset==int(mandatory is not None and mandatory not in J)
   effective_added=added-({anchor} if offset else set());record={'parent_path':str(path),'parent_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'parent_cut':k,'original_size':len(J),'closure_size':len(F),'rank':r,'extra_nonnegative_terms':len(effective_added),'anchor_diagonal_cancellation':bool(offset)}
   if r==128:
    assert len(F)==720;trivial+=1;record['status']='IMPLIED_BY_TOTAL_CARDINALITY_AND_NONNEGATIVITY'
   else:
    key=(c['sector'],c['anchor_orbit'],tuple(F),r)
    if key not in seen:
     seen[key]=len(cuts);cuts.append({'sector':c['sector'],'anchor_orbit':c['anchor_orbit'],'mandatory_index':mandatory,'indices':F,'bound':r,'augmented_rank':r,'mandatory_in_subset':mandatory is not None,'span_closed':True})
    record.update(status='DOMINATED_BY_CLOSED_RANK_CUT',closed_cut=seen[key])
   bindings.append(record)
 out={'status':'CANDIDATE_RANK_CUTS','source_C16_answered':False,'cuts':cuts,'bindings':bindings,'original_cuts':len(bindings),'unique_nontrivial_closed_cuts':len(cuts),'full_rank_trivial_inputs':trivial,'strictly_enlarged_inputs':sum(b['extra_nonnegative_terms']>0 for b in bindings),'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Every old conditional rank inequality is implied by its span-closed replacement plus nonnegative moments and the anchor diagonal identity, or by total cardinality. Independent rank and closure/dominance replay required; no source exclusion or cover reduction.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['cuts','bindings']},flush=True)
if __name__=='__main__':main()
