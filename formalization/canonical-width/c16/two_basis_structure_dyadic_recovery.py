"""Solver-free small-lattice recovery of an accepted pair allocation.

New allocations only: preserve exact target, source counts, boxes and every
listed rank row. Never overwrite or relabel the parent allocation.
"""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm,gcd
import argparse,gzip,json,time
from two_basis_structure_direct_allocation import ROOT,sha,construct,evaluate,exact_check,expr,plus
from verify_two_sided_full_basis_oracle import physical_source,domains,target

def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def value(e,x):return e[0]+sum(c*x[j] for j,c in e[1].items())
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output-prefix',type=Path,required=True);ap.add_argument('--bits',type=int,nargs='+',default=[50,52,54,56]);a=ap.parse_args();start=time.monotonic();parent=read(a.certificate);receipt=read(a.receipt);assert receipt['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS' and receipt['certificate_sha256']==sha(a.certificate);assert receipt['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_geometry_allocation.py');pf=a.certificate.with_name(a.certificate.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');f=read(pf);assert parent['frozen_sha256']==sha(pf)==receipt['frozen_sha256'];assert f['point_sha256']==sha(a.point);assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());lam=list(map(Q,f['lambda_masses']));xx,zz=f['X_anchors'],f['Z_anchors'];side=f['side'];X,Z,_=physical_source();full=target(a.point,xx,zz);s=int(side=='Z');b=full[11+720*s:731+720*s]+[full[1451+1440*i+720*s+j] for i in range(4) for j in range(720)];dd,E,variables,eq,labels,ineq,meta,face,local=construct(X,Z,side,xx,zz,lam,b);assert variables==f['variables'];Y=[list(map(Q,row)) for row in parent['exact_allocations']];x=[Y[m][j] for j,m in variables];assert evaluate(E,x)==Y and not exact_check(Y,lam,dd,b);rankexpr=[]
 for r in f['rank_rows']:
  e=expr(-lam[r['mask']]*r['contraction_rank'])
  for j in r['indices']:e=plus(e,E[r['mask']][j])
  rankexpr.append(e)
 constraints=ineq+rankexpr;radius=[None]*len(x)
 for e in constraints:
  slack=-value(e,x);assert slack>=0
  for j,c in e[1].items():
   q=slack/abs(c)
   if radius[j] is None or q<radius[j]:radius[j]=q
 piv=[]
 for i,e in enumerate(eq):
  choices=[j for j,c in e[1].items() if abs(c)==1 and all(not r.get(j,0) for k,(cc,r) in enumerate(eq) if k!=i)];assert choices
  piv.append(max(choices,key=lambda j:(radius[j],-j)))
 results=[]
 for bits in a.bits:
  assert bits>=50;D=1<<bits;z=[Q(round(v*D),D) for v in x]
  for (c,r),j in zip(eq,piv):z[j]+=-value((c,r),z)/r[j]
  assert all(value(e,z)==0 for e in eq);assert all((v*D).denominator==1 for v in z);y=evaluate(E,z);bad=exact_check(y,lam,dd,b);rankbad=[[i,str(value(e,z))] for i,e in enumerate(rankexpr) if value(e,z)>0];result=dict(bits=bits,box_failures=bad,rank_failures=rankbad,maximum_parameter_change=str(max(abs(u-v) for u,v in zip(x,z))),maximum_allocation_change=str(max(abs(u-v) for row,new in zip(Y,y) for u,v in zip(row,new))))
  results.append(result);print('DYADIC',bits,'boxfail',len(bad),'rankfail',len(rankbad),flush=True)
  if bad or rankbad:continue
  prefix=Path(str(a.output_prefix)+f'-b{bits}');fp=Path(str(prefix)+'.frozen.json');cp=Path(str(prefix)+'.json.gz');assert not fp.exists() and not cp.exists();frozen=dict(f,status='FROZEN_SOLVER_FREE_DYADIC_PAIR_RECOVERY',parent_certificate=str(a.certificate),parent_certificate_sha256=sha(a.certificate),parent_receipt=str(a.receipt),parent_receipt_sha256=sha(a.receipt),pair_lattice_bits=bits,unit_pivot_columns=piv,pivot_safe_radii=list(map(str,[radius[j] for j in piv])),discovery='Exact nearest dyadic rounding plus unit-column bucket corrections; no LP run');frozen['source_hashes']={**f['source_hashes'],'two_basis_structure_dyadic_recovery.py':sha(__file__),str(a.certificate):sha(a.certificate),str(a.receipt):sha(a.receipt)};fp.write_text(json.dumps(frozen,indent=2)+'\n');accuracy=[]
  for m,l in enumerate(lam):
   if not l:continue
   vals=[y[m][j] for j in dd[m]['zero_free']];den=lcm(l.denominator,*(v.denominator for v in vals));g=gcd(int(l*den),*(int(v*den) for v in vals));gap=Q(g,den);accuracy.append(dict(mask=m,raw_denominator=str(den),primitive_raw_rank_gap=str(gap),normalized_positive_error_threshold=str(gap/l)))
  out=dict(status='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY',frozen_sha256=sha(fp),parent_certificate_sha256=sha(a.certificate),pair_lattice_bits=bits,exact_feature_equations=3600,exact_global_bucket_equations=len(eq),prior_rank_row_count=len(rankexpr),exact_rank_failures=[],exact_box_failures=[],minimum_exact_rank_slack=str(min(-value(e,z) for e in rankexpr)),minimum_box_slack=str(min(min(v,lam[m]-v) for m,row in enumerate(y) for v in row)),sector_target=list(map(str,b)),exact_allocations=[[str(v) for v in row] for row in y],zero_free_lattice_accuracy=accuracy,rounding_result=result,elapsed_seconds=time.monotonic()-start,all_subset_rank_membership_proved=False);cp.write_bytes(gzip.compress((json.dumps(out,indent=2)+'\n').encode(),mtime=0));result.update(candidate=str(cp),candidate_sha256=sha(cp));break
 report=Path(str(a.output_prefix)+'-diagnostic.json');assert not report.exists();report.write_text(json.dumps(dict(status='BOUNDED_SOLVER_FREE_DYADIC_RECOVERY',parent_sha256=sha(a.certificate),producer_sha256=sha(__file__),results=results,elapsed_seconds=time.monotonic()-start),indent=2)+'\n')
if __name__=='__main__':main()
