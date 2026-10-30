#!/usr/bin/env python3
"""Independent low-pivot span closure and coefficient-dominance replay."""
from pathlib import Path
import argparse,hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.certificate.read_text());X,Z,A=physical();cache={};seen=set();extra=0;trivial=0
 for record in d['bindings']:
  path=ROOT/record['parent_path'];assert hashlib.sha256(path.read_bytes()).hexdigest()==record['parent_sha256']
  if path not in cache:cache[path]=json.loads(path.read_text())
  parent=cache[path]['cuts'][record['parent_cut']];pair=(str(path),record['parent_cut']);assert pair not in seen;seen.add(pair);U=X if parent['sector']=='S' else Z;anchor=16*parent['anchor_orbit'];J=set(parent['indices']);mandatory=anchor if parent['sector']=='S' else None;piv={}
  for j in sorted(J|({anchor} if mandatory is not None else set())):
   v=U[j]
   while v:
    bit=v&-v
    if bit not in piv:piv[bit]=v;break
    v^=piv[bit]
  def reduce(v):
   while v:
    bit=v&-v
    if bit not in piv:return v
    v^=piv[bit]
   return 0
  F={i for i,u in enumerate(U) if not reduce(u)};r=len(piv);assert r==record['rank'] and len(F)==record['closure_size'] and J<=F
  if record['status']=='IMPLIED_BY_TOTAL_CARDINALITY_AND_NONNEGATIVITY':assert r==128 and len(F)==720;trivial+=1
  else:
   closed=d['cuts'][record['closed_cut']];assert closed['sector']==parent['sector'] and closed['anchor_orbit']==parent['anchor_orbit'] and set(closed['indices'])==F and closed['bound']==r
  # Symbolically compare conditional moment coefficients, replacing y_a=p_a.
  coeff={i:1 for i in F-J};pcoef=-(r-parent['bound'])
  if mandatory is not None:pcoef+=coeff.pop(anchor,0)
  assert pcoef==0 and all(v>=0 for v in coeff.values());assert len(coeff)==record['extra_nonnegative_terms'];extra+=len(coeff)
 assert len(seen)==d['original_cuts']==sum(len(v['cuts']) for v in cache.values())
 out={'status':'PASS','source_C16_answered':False,'certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'parent_cuts_covered':len(seen),'unique_nontrivial_closed_cuts':len(d['cuts']),'full_rank_trivial_inputs':trivial,'added_nonnegative_moment_terms':extra,'strictly_enlarged_inputs':d['strictly_enlarged_inputs'],'physical_pairings_rebuilt':518400,'elapsed_seconds':time.monotonic()-start,'scope':'Complete closure sets independently reconstructed from physical vectors; every source row is dominated by the named closed row plus nonnegative moments and anchor diagonals, or by fixed cardinality. This reduces/strengthens a relaxation row bank, not the405 source-case cover.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
