"""Exact no-solver affine repair in empty and singleton pattern allocations.

Starts from an independently accepted physical fixed-lambda mixture. This
constructs an exact affine target allocation; boxes and rank conditions may
fail and are never interpreted as global target infeasibility.
"""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm
import argparse,gzip,hashlib,json,time
import numpy as np
from verify_two_sided_full_basis_oracle import physical_source,domains,target,rank
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(gzip.decompress(Path(p).read_bytes()) if str(p).endswith('.gz') else Path(p).read_text())
def state_y(d):
 out=[[Q(0)]*720 for _ in range(16)]
 for r in d['pattern_basis_records']:
  w=Q(r['weight'])
  for j in r['selected_indices']:out[r['mask']][j]+=w
 return out

def load_mixture(report,receipt):
 d=read(report);check=read(receipt);assert check['point_sha256']==d['point_sha256'];assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items());details={}
 if d['status']=='EXACT_NORMALIZED_PHASE_I_STATE_CANDIDATE':
  assert check['status']=='PASS_EXACT_FIXED_LAMBDA_PHASE_I_STATE' and check['certificate_sha256']==sha(report) and check['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_phase_one.py');out=state_y(d);details['normalized_weight_mass']='1'
 else:
  assert d['status']=='BOUNDED_FIXED_LAMBDA_L2_INCONCLUSIVE';assert check['status']=='PASS_FULL_FIXED_LAMBDA_ENDPOINT_INCONCLUSIVE' and check['report_sha256']==sha(report) and check['auditor_sha256']==sha(ROOT/'audit_two_basis_fixed_lambda_endpoint.py');z=np.load(d['columns_artifact']);assert sha(d['columns_artifact'])==d['columns_sha256']==check['archive_sha256'];w=[Q(float(x)) for x in z['master_mixture_weights']];assert min(w)>=0;DW=lcm(*(x.denominator for x in w));wi=[int(x*DW) for x in w];S=sum(wi);assert S>0;W0=Q(wi[0],S);initial=read(ROOT/d['initial_atom_source']);assert sha(ROOT/d['initial_atom_source'])==d['initial_atom_sha256'];old=state_y(initial);lam=list(map(Q,d['lambda_masses']));counts=[[0]*720 for _ in range(16)];B=z['pattern_selected_indices']
  for a,weight in enumerate(wi):
   if not a or not weight:continue
   for m in range(16):
    if lam[m]:
     for j in B[a,m]:counts[m][int(j)]+=weight
  out=[[W0*old[m][j]+lam[m]*Q(counts[m][j],S) for j in range(720)] for m in range(16)];details.update(normalized_weight_mass=str(Q(S,DW)),positive_aggregate_atoms=sum(x>0 for x in wi),initial_atom_normalized_mass=str(W0),archive_sha256=d['columns_sha256'])
 return d,out,details

def features(y):return [sum(y[m][j] for m in range(16)) for j in range(720)]+[sum(y[m][j] for m in range(16) if m>>i&1) for i in range(4) for j in range(720)]

def affine_checks(y,lam,dd):
 bad=[]
 for m,(row,l,d) in enumerate(zip(y,lam,dd)):
  if sum(row)!=128*l:bad.append(['cardinality',m])
  for j in range(720):
   wanted=l if j in d['forced'] else Q(0) if j in d['absent'] or len(d['signatures'][j])>1 else None
   if wanted is not None and row[j]!=wanted:bad.append(['fixed',m,j])
  if sum(row[j] for j in d['zero_forced']+d['zero_free'])!=d['zero_required']*l:bad.append(['zero_count',m])
  for k,choices in enumerate(d['bins']):
   if sum(row[j] for j in choices)!=l:bad.append(['owner_count',m,k])
 return bad

def screen(y,lam,dd,U):
 records=[]
 for m in [0,1,2,4,8]:
  row,l,d=y[m],lam[m],dd[m];assert l>0;low=[j for j,v in enumerate(row) if v<0];high=[j for j,v in enumerate(row) if v>l];r=dict(mask=m,negative_indices=low,above_lambda_indices=high,minimum_value=str(min(row)),maximum_value=str(max(row)),minimum_box_slack=str(min([*row,*[l-v for v in row]])),negative_mass=str(-sum(row[j] for j in low)),excess_mass=str(sum(row[j]-l for j in high)),negative_count=len(low),above_lambda_count=len(high))
  if not low and not high:
   zero=d['zero_forced']+d['zero_free'];positive=[j for j in zero if row[j]>0];forced=[j for j in zero if row[j]==l];r.update(zero_positive_support=len(positive),zero_support_rank=rank(U[j] for j in positive),zero_required=d['zero_required'],unit_probability_zero_elements=len(forced),unit_probability_zero_rank=rank(U[j] for j in forced),remaining_zero_rank=d['zero_required']-len(forced));r['cheap_rank_gate_pass']=r['zero_support_rank']==r['zero_required'] and r['unit_probability_zero_rank']==len(forced)
  records.append(r)
 return records

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--report',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();d,y,details=load_mixture(a.report,a.receipt);assert sha(a.point)==d['point_sha256'];lam=list(map(Q,d['lambda_masses']));X,Z,_=physical_source();side=d['side'];s=int(side=='Z');U=X if not s else Z;xx,zz=d['X_anchors'],d['Z_anchors'];dd=[r[side] for r in domains(X,Z,xx,zz)];assert all(r['feasible'] for r in dd);t=target(a.point,xx,zz);b=t[11+720*s:731+720*s]+[t[1451+1440*i+720*s+j] for i in range(4) for j in range(720)];assert b==list(map(Q,d['sector_target']));assert not affine_checks(y,lam,dd);f=features(y);res=[v-u for v,u in zip(b,f)];after=[list(row) for row in y]
 for i in range(4):
  for j in range(720):after[1<<i][j]+=res[720*(i+1)+j]
 for j in range(720):after[0][j]+=res[j]-sum(res[720*(i+1)+j] for i in range(4))
 assert features(after)==b;affine=affine_checks(after,lam,dd);assert not affine;gates=screen(after,lam,dd,U);bad=sum(r['negative_count']+r['above_lambda_count'] for r in gates);status='EXACT_AFFINE_REPAIR_BOX_OBSTRUCTION' if bad else 'EXACT_AFFINE_ALLOCATION_REQUIRES_RANK_PROOF'
 out=dict(status=status,scope='One deterministic affine allocation repair only. Its failure is not nonmembership of the fixed-lambda hull. Cheap rank checks are necessary only; no full rank membership claimed.',source_C16_answered=False,side=side,X_anchors=xx,Z_anchors=zz,point_sha256=sha(a.point),input_report=str(a.report),input_report_sha256=sha(a.report),input_receipt=str(a.receipt),input_receipt_sha256=sha(a.receipt),producer_sha256=sha(__file__),dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py']},lambda_masses=list(map(str,lam)),normalization=details,exact_initial_feature_L1_error=str(sum(abs(v) for v in res)),approximate_initial_feature_L1_error=float(sum(abs(v) for v in res)),exact_target_feature_equations=3600,exact_fixed_anchor_cardinality_owner_failures=affine,changed_patterns=[0,1,2,4,8],unchanged_patterns=[3,5,6,7,9,10,11,12,13,14,15],pattern_screens=gates,total_coordinate_box_failures=bad,original_allocations=[[str(v) for v in row] for row in y],repaired_allocations=[[str(v) for v in row] for row in after],sector_target=list(map(str,b)),elapsed_seconds=time.monotonic()-start);raw=(json.dumps(out,indent=2)+'\n').encode();a.output.write_bytes(gzip.compress(raw,mtime=0) if str(a.output).endswith('.gz') else raw);print(side,status,'L1',out['approximate_initial_feature_L1_error'],'box_failures',bad,[(r['mask'],r['negative_count'],r['above_lambda_count']) for r in gates],flush=True)
if __name__=='__main__':main()
