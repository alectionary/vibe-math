#!/usr/bin/env python3
"""Exact replay of all listed degree-two row families at a rational point."""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,math,time
import numpy as np
from certify_profile_moment_point import layout,verify
from verify_algebraic_model import physical
from physical_owner_moment_matrix import matrix as owner_matrix
from physical_circuit_moment_matrix import matrix as circuit_matrix
from physical_legacy_linear_moments import build as legacy_matrix
from conditional_matroid_moment_matrix import matrix as matroid_matrix
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--old-replay',type=Path,required=True);ap.add_argument('--matroid-cuts',type=Path,nargs='+',required=True);ap.add_argument('--matroid-replays',type=Path,nargs='+',required=True);ap.add_argument('--separating-cuts',type=Path);ap.add_argument('--separating-replay',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();data=read(a.certificate);prior=read(a.old_replay);assert prior['status']=='PASS' and prior['certificate_sha256']==sha(a.certificate)
 hulls=read(ROOT/'algebraic-results/hulls-16-rank.json.gz');caps=read(ROOT/'algebraic-results/orbit-rank-profiles-independent.json');cond=read(ROOT/'algebraic-results/conditional-capacity/independent.json');cross=read(ROOT/'algebraic-results/conditional-cross-capacity/independent.json');weighted=[read(ROOT/p) for p in ['algebraic-results/conditional-facets-round1-independent.json','moment-resumption-results/all-pair-moment-faces.json']];base=verify(data,hulls,caps,cond,cross,weighted);names,index,m=layout(hulls);v=list(map(Fraction,data['values']));patterns=0
 for path in ['relevant-results/seed-cuts.json','moment-resumption-results/all-pair-word-cuts.json']:
  for cut in read(ROOT/path)['cuts']:
   J=cut['indices']
   for anchor in J:assert sum(v[m('S',(j-anchor)%16,anchor//16,j//16)] for j in J if j!=anchor)<=(len(J)-2)*v[index['p',anchor//16]];patterns+=1
 flat=[v[index['p',i]] for i in range(45)]+[v[m(side,h,i,j)] for side in 'ST' for h in range(9) for i in range(45) for j in range(45)];D=math.lcm(*(x.denominator for x in flat));ints=[x.numerator*(D//x.denominator) for x in flat];X,Z,A=physical();O,_,_=owner_matrix(A);bank=read(ROOT/'moment-resumption-results/physical-rank-moment-bank.json');C,_,_=circuit_matrix(bank['physical_circuits']);L,rhs,_,_,_=legacy_matrix(bank['mapping']);M,_=matroid_matrix(a.matroid_cuts,a.matroid_replays)
 def evaluate(matrix,rhs):
  residual=[]
  for row in range(matrix.shape[0]):residual.append(sum(int(coef)*ints[int(col)] for col,coef in zip(matrix.indices[matrix.indptr[row]:matrix.indptr[row+1]],matrix.data[matrix.indptr[row]:matrix.indptr[row+1]]))-int(rhs[row] if not isinstance(rhs,int) else rhs)*D)
  return residual
 checks={}
 for key,matrix,rhs in [('ownership',O,0),('circuit',C,0),('legacy',L,rhs),('conditional_matroid',M,0)]:
  residual=evaluate(matrix,rhs);bad=[i for i,r in enumerate(residual) if r>0];checks[key]={'rows':len(residual),'violations':len(bad),'maximum_exact_violation':str(Fraction(max(residual),D)),'first_violated_rows':bad[:12]};assert not bad,(key,checks[key]);print('EXACT PASS',key,len(residual),flush=True)
 separation=None
 if a.separating_cuts:
  Q,_=matroid_matrix([a.separating_cuts],[a.separating_replay]);residual=evaluate(Q,0);bad=[i for i,r in enumerate(residual) if r>0];separation={'rows':len(residual),'strictly_violated_rows':len(bad),'violated_indices':bad,'maximum_exact_violation':str(Fraction(max(residual),D)),'maximum_violation_approximation':float(Fraction(max(residual),D)),'bank_sha256':sha(a.separating_cuts),'replay_sha256':sha(a.separating_replay)}
 out={'status':'PASS','source_C16_answered':False,'certificate_sha256':sha(a.certificate),'old_replay_sha256':sha(a.old_replay),'all_old_equalities_and_interval_PSD_replayed':True,'old_profile_replay':base,'conditioned_pattern_rows_checked':patterns,'exact_added_family_checks':checks,'new_rank_family_separation':separation,'moment_common_denominator':str(D),'source_hashes':{p:sha(ROOT/p) for p in ['verify_unified_moment_point.py','physical_owner_moment_matrix.py','physical_circuit_moment_matrix.py','physical_legacy_linear_moments.py','conditional_matroid_moment_matrix.py','moment-resumption-results/physical-rank-moment-bank.json']},'matroid_bank_hashes':{str(p):sha(p) for p in a.matroid_cuts},'elapsed_seconds':time.monotonic()-start,'scope':'Exact rational feasible point of all listed profile/capacity/weighted/forbidden/ownership/circuit/legacy and supplied conditional-rank families. No physical frame or joint distribution is constructed. Any positive separation by another valid family establishes a strict strengthening of this finite relaxation, not source infeasibility.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='old_profile_replay'},flush=True)
if __name__=='__main__':main()
