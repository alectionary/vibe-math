"""Exact replay of the final proposed direction; never a membership consumer."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_projection import read,point_data,weights,local_score,turn
from verify_full_partner_basis_oracle import rebuild_domain,check_support
from full_partner_native import NativeFullPartnerBatch
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();d=read(a.candidate);assert d['status']=='NO_EXACT_SEPARATOR_FOUND' and not d['cuts'];assert d['point_sha256']==sha(a.point) and d['frozen_sha256']==sha(a.candidate.with_suffix('.frozen.json'));assert all(sha(ROOT/p)==v for p,v in d['source_hashes'].items())
 X,Z,A=physical();profiles=read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz');bad=[c['mask'] for r in profiles['records'] if r['orbit']==32 for c in r['minimal_bad_certificates']];allowed=[m for m in range(65536) if not any(m&b==b for b in bad)];reps=sorted({min(turn(m,h) for h in range(16)) for m in allowed});assert len(allowed)==4597 and len(reps)==291 and reps==d['representatives'];c=d['last_coefficients'];assert len(c)==775 and all(type(v)is int for v in c)
 batch=NativeFullPartnerBatch(reps);priced=batch.price(c);batch.close();bounds=[];checks=0
 for i,m in enumerate(reps):
  selected=[512+h for h in range(16) if m>>h&1];domain=rebuild_domain(X,Z,selected,128);B=list(map(int,priced['bases'][i]));nz=128-m.bit_count();r={'status':'EXACT_FULL_PARTNER_BASIS_SUPPORT','value':int(priced['values'][i]),'selected_Z_indices':B,'zero_basis_indices':B[:nz],'owner_indices':B[nz:]};checks+=check_support(Z,selected,128,domain,weights(m,c),r);full=local_score(m,c)+r['value'];assert full==int(priced['full_values'][i]);bounds.append(full)
 _,target=point_data(a.point,32);value=sum(a*b for a,b in zip(c,target));upper=max(bounds);gap=value-upper;last=d['rounds'][-1];assert upper==last['upper_bound'] and gap==Q(last['exact_gap'])<0
 out={'status':'PASS_NEGATIVE_ENDPOINT_SUPPORT_REPLAY_ONLY','source_C16_answered':False,'membership_proved':False,'accepted_cuts':0,'candidate_sha256':sha(a.candidate),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'source_hashes':d['source_hashes'],'representatives_checked':291,'exact_low_pivot_prefix_checks':checks,'last_exact_upper_bound':upper,'last_exact_target':str(value),'last_exact_gap':str(gap),'priced_rounds':sum('exact_gap'in r for r in d['rounds']),'numeric_master_start':d['rounds'][0]['numeric_L1_objective'],'numeric_master_end':last['numeric_L1_objective'],'scope':'Replays only the final proposed direction against the frozen allowed-domain cohort and exact target. Nonpositive gap and bounded master timeout prove neither separation nor membership; no model row is accepted.','elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='source_hashes'})
if __name__=='__main__':main()
