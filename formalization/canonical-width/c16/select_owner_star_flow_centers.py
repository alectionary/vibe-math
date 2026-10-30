"""Deterministic bounded selection of a physical K2,2 owner-star interface."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,os
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
 assert os.getpriority(os.PRIO_PROCESS,0)==19
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
 b,r=read(a.bank),read(a.receipt);assert r['status']=='PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS' and r['bank_sha256']==sha(a.bank)
 assert b['source_hashes']==r['source_hashes'] and all(sha(ROOT/p)==h for p,h in b['source_hashes'].items())
 X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];dot=lambda x,z:(X[x]&Z[z]).bit_count()%2
 xx,zz=b['X_anchors'],b['Z_anchors'];assert xx==[80,512] and zz==[186,433]
 mx={i:1<<k for k,i in enumerate(xx)};mz={i:1<<(k+2) for k,i in enumerate(zz)}
 ax=[sum(dot(i,j)<<k for k,i in enumerate(xx)) for j in range(720)]
 az=[sum(dot(i,j)<<(k+2) for k,j in enumerate(zz)) for i in range(720)]
 def zeros(x,z):
  required_one=mx.get(x,0)|mz.get(z,0);required_zero=(ax[z]&~mx.get(x,0))|(az[x]&~mz.get(z,0))
  return 16 if required_one&required_zero else 16-(1<<(4-(required_one|required_zero).bit_count()))
 nx=[[]for _ in range(720)];nz=[[]for _ in range(720)];wx=[0]*720;wz=[0]*720
 for x in range(720):
  for z in range(720):
   if dot(x,z):nx[x].append(z);nz[z].append(x);v=zeros(x,z);wx[x]+=v;wz[z]+=v
 gaps={(row['side'],row['probe']):Q(row['exact_violation']) for row in b['cuts']}
 assert dot(614,51);best=None;unconstrained=None;total=feasible=0
 for x in nz[51]:
  if x in xx+[614]:continue
  for z in nx[614]:
   if z in zz+[51] or not dot(x,z):continue
   total+=1;score=gaps.get(('X',x),Q(0))+gaps.get(('Z',z),Q(0));key=(score,-x,-z)
   E=len(nx[614])+len(nx[x])+len(nz[51])+len(nz[z])-4
   zero=wx[614]+wx[x]+wz[51]+wz[z]-sum(zeros(u,v) for u in (614,x) for v in (51,z))
   predicted_ub=57335+64*E+zero;predicted_vars=13393+16*E
   row=(key,x,z,E,zero,predicted_ub,predicted_vars)
   if unconstrained is None or key>unconstrained[0]:unconstrained=row
   if predicted_ub>100000 or predicted_vars>30000:continue
   feasible+=1
   if best is None or key>best[0]:best=row
 assert best is not None
 _,x,z,E,zero,ub,n=best;probes=[['X',614],['X',x],['Z',51],['Z',z]]
 out=dict(status='FROZEN_PHYSICAL_K22_OWNER_STAR_CENTER_SELECTION',probes=probes,fixed_centers=[['X',614],['Z',51]],cohort=str(a.bank),cohort_sha256=sha(a.bank),cohort_receipt=str(a.receipt),cohort_receipt_sha256=sha(a.receipt),point_sha256=b['point_sha256'],producer_sha256=sha(__file__),selection='Maximize sum of exact gaps of the two extra centers among physical K2,2 completions satisfying conservative30000-variable/100000-inequality limits; ties favor lowerX then lowerZ.',candidate_K22_completions=total,budget_feasible_candidates=feasible,unconstrained_best_extra_centers=[unconstrained[1],unconstrained[2]],degrees=[len(nx[614]),len(nx[x]),len(nz[51]),len(nz[z])],physical_edges=E,structural_zero_cells=zero,predicted_max_base_inequalities=57335,predicted_max_total_inequalities=ub,predicted_total_variables=n,selected_gaps={s+str(i):str(gaps.get((s,i),Q(0)))for s,i in probes},K22_edges=[[u,v]for u in (614,x)for v in (51,z)],solver_run=False)
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
if __name__=='__main__':main()
