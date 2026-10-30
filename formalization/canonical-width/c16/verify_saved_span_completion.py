"""Prove the full775 auxiliary hull has exactly affine dimension771."""
from pathlib import Path
import argparse,hashlib,json,time
import numpy as np
from flint import nmod_mat
from verify_algebraic_model import physical
from verify_full_partner_projection import read,literal_features
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidate',type=Path,required=True);ap.add_argument('--replay',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();started=time.monotonic();d=read(a.candidate);r=read(a.replay);assert r['status']=='PASS_EXACT_SAVED_SPAN_AFFINE_DIAGNOSTIC' and r['candidate_sha256']==sha(a.candidate) and r['consumer_sha256']==sha(ROOT/'verify_saved_span_affine_gate.py');assert all(sha(ROOT/p)==v for p,v in d['source_hashes'].items());archive=Path(d['archive']);assert sha(archive)==d['archive_sha256'];saved=np.load(archive);X,Z,A=physical();pair=[(X[512]&z).bit_count()%2 for z in Z];cols=[];records=[]
 def check(m,B):
  assert m in d['representatives'] and len(B)==len(set(B))==128 and all(type(j)is int and 0<=j<720 for j in B);assert dimension(Z[j] for j in B)==128
  phases=[h for h in range(16) if m>>h&1];assert dimension(X[512+h] for h in phases)==len(phases);sig=[sum(((X[512+h]&Z[j]).bit_count()%2)<<h for h in phases) for j in B];assert all(v.bit_count()<=1 for v in sig) and all(sig.count(1<<h)==1 for h in phases);f=literal_features(m,B);assert sum(f[10:55])==128*f[0] and sum(f[55:])==128*f[1] and sum(x*y for x,y in zip(pair,f[55:]))==f[1];return f
 indices=d['independent_row_indices'];assert len(indices)==758 and len(set(indices))==758
 for i in indices:
  m=int(saved['masks'][i]);B=list(map(int,saved['selected_Z_indices'][i]));f=check(m,B);assert f==list(saved['features'][i]);cols.append(f)
 assert nmod_mat(cols,2147483647).rank()==758
 for result in d['results']:
  branch=next(s for s in result['signs'] if s['sign']==1);w=max(branch['records'],key=lambda q:q['full_value']);m=w['mask'];B=w['selected_Z_indices'];f=check(m,B);assert sum(c*v for c,v in zip(result['coefficients'],f))==w['full_value']>0;cols.append(f);records.append({'candidate_index':result['index'],'mask':m,'selected_Z_indices':B,'feature':f})
 assert len(cols)==772 and nmod_mat(cols,2147483647).rank()==772
 # Universal upper bound: three independent homogeneous equations plus phi0=1.
 g1=[0]*775;g1[0]=-128;g1[10:55]=[1]*45
 g2=[0]*775;g2[1]=-128;g2[55:]=[1]*720
 g3=[0]*775;g3[1]=-1;g3[55:]=pair
 assert nmod_mat([g1,g2,g3],2147483647).rank()==3 and all(sum(x*y for x,y in zip(g,f))==0 for g in [g1,g2,g3] for f in cols)
 out={'status':'PASS_EXACT_FULL775_AUXILIARY_AFFINE_HULL_DIMENSION','source_C16_answered':False,'physical_full_frame':False,'candidate_sha256':sha(a.candidate),'candidate_replay_sha256':sha(a.replay),'consumer_sha256':sha(Path(__file__)),'archive_sha256':sha(archive),'physically_verified_columns':772,'archive_columns_rechecked':758,'new_counterexample_columns':records,'modulus':2147483647,'linear_rank':772,'affine_dimension':771,'complete_homogeneous_identity_basis':[g1,g2,g3],'proof':'All source-compatible auxiliary columns satisfy three independent homogeneous identities and phi0=1. The772 explicitly replayed physical auxiliary columns have modular rank772, hence rational rank772 and affine rank771. Therefore these three identities span all homogeneous linear identities of this full775 auxiliary hull.','scope':'Completeness applies to the one-orbit/full-opposite-basis auxiliary hull. It neither asserts target membership nor the affine hull of complete source frames.','elapsed_seconds':time.monotonic()-started};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['new_counterexample_columns','complete_homogeneous_identity_basis']},flush=True)
if __name__=='__main__':main()
