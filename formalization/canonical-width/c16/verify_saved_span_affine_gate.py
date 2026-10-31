"""Independent physical both-sign support of saved-span affine candidates."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json,time
import numpy as np
from flint import fmpz_mat
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import rebuild_domain,check_support,dimension
from verify_full_partner_projection import read,turn,move,weights,local_score,literal_features,point_data
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();started=time.monotonic();d=read(a.candidate);assert d['status']=='EXACT_SAVED_SPAN_AFFINE_CANDIDATES' and all(sha(ROOT/p)==v for p,v in d['source_hashes'].items());archive=Path(d['archive']);assert sha(archive)==d['archive_sha256'];F=np.load(archive)['features'];C=[r['coefficients'] for r in d['results']];assert len(C)==d['nullity_after_three_gauges'] and all(len(c)==775 and all(type(v)is int for v in c) for c in C);assert fmpz_mat(C).rank()==len(C);D=fmpz_mat(F.astype(int).tolist())*fmpz_mat(np.array(C,dtype=object).T.tolist());assert all(D[i,j]==0 for i in range(len(F)) for j in range(len(C)))
 X,Z,A=physical();assert dimension(X)==dimension(Z)==128
 graph_ranks=[dimension([X[i]|X[move(i,1)]<<128 for i in range(720)]),dimension([Z[i]|Z[move(i,1)]<<128 for i in range(720)])];assert graph_ranks==[128,128] and all((A[i]>>j&1)==(A[move(i,1)]>>move(j,1)&1) for i in range(720) for j in range(720))
 profiles=read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz');row=next(r for r in profiles['records'] if r['orbit']==32);V=X[512:528];patterns=[sum(((x&z).bit_count()%2)<<h for h,x in enumerate(V)) for z in Z];assert dimension(V)==16
 for cert in row['minimal_bad_certificates']:
  m=cert['mask'];w=int(cert['annihilator_hex'],16);assert 0<w<1<<128
  if cert['kind']=='zero_rank':
   selected=[V[h] for h in range(16) if m>>h&1];assert dimension(selected+[w])==len(selected)+1 and all(p&m for z,p in zip(Z,patterns) if (z&w).bit_count()%2)
  else:assert cert['kind']=='missing_private' and all((p&m).bit_count()>1 for z,p in zip(Z,patterns) if (z&w).bit_count()%2)
 bad=[c['mask'] for c in row['minimal_bad_certificates']];allowed=[m for m in range(65536) if not any(m&b==b for b in bad)];reps=sorted({min(turn(m,h) for h in range(16)) for m in allowed});assert len(allowed)==4597 and len(reps)==291 and reps==d['representatives'];domains={m:rebuild_domain(X,Z,[512+h for h in range(16) if m>>h&1],128) for m in reps};_,target=point_data(a.point,32);checks=0;accepted=[];disproved=[];results=[]
 for result in d['results']:
  c=result['coefficients'];uppers=[];counterexamples=[]
  for branch in result['signs']:
   sign=branch['sign'];assert sign in (-1,1);signed=[sign*v for v in c];records=branch['records'];assert [r['mask'] for r in records]==reps;upper=None
   for record in records:
    m=record['mask'];adapted={**record,'status':'EXACT_FULL_PARTNER_BASIS_SUPPORT','value':record['support_value']};checks+=check_support(Z,[512+h for h in range(16) if m>>h&1],128,domains[m],weights(m,signed),adapted);value=local_score(m,signed)+record['support_value'];assert value==record['full_value']==sum(x*y for x,y in zip(signed,literal_features(m,record['selected_Z_indices'])));upper=value if upper is None else max(upper,value)
    if value and not counterexamples:counterexamples.append({'sign':sign,'mask':m,'selected_Z_indices':record['selected_Z_indices'],'exact_signed_value':str(value)})
   assert upper==branch['upper'];uppers.append(upper)
   # The exact weight formula proves covariance for every mask; these literal
   # checks additionally fix orientation on an asymmetric representative.
   m=3;w=weights(m,signed)
   for h in range(16):
    shifted=weights(turn(m,h),signed);assert all(shifted[move(j,h)]==w[j] for j in range(720)) and local_score(turn(m,h),signed)==local_score(m,signed)
  assert len(uppers)==2 and {s['sign'] for s in result['signs']}=={-1,1};identity=all(v==0 for v in uppers);(accepted if identity else disproved).append(result['index']);value=sum(x*y for x,y in zip(c,target));results.append({'index':result['index'],'identity':identity,'sign_uppers':uppers,'exact_point_value':str(value),'counterexamples':counterexamples,'coefficient_nonzeros':sum(v!=0 for v in c),'max_coefficient':max(map(abs,c))})
 out={'status':'PASS_EXACT_SAVED_SPAN_AFFINE_DIAGNOSTIC','source_C16_answered':False,'candidate_sha256':sha(a.candidate),'consumer_sha256':sha(Path(__file__)),'point_sha256':sha(a.point),'archive_sha256':sha(archive),'source_hashes':d['source_hashes'],'exact_candidates':len(C),'global_identity_indices':accepted,'disproved_saved_null_indices':disproved,'global_affine_hull_completeness_claimed':False,'exact_prefix_rank_checks':checks,'source_profile_witnesses_replayed':len(bad),'symmetry_graph_ranks':graph_ranks,'results':results,'elapsed_seconds':time.monotonic()-started,'scope':'Both-sign exact full-basis support accepts only listed global affine identities; literal physical vertices disprove the other saved-span nulls. Existing source question and full joint-profile membership remain unresolved.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['source_hashes','results']},flush=True)
if __name__=='__main__':main()
