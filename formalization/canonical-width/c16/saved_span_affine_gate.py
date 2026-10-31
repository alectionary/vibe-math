"""Bounded exact saved-span null candidates, followed by both-sign pricing."""
from pathlib import Path
from functools import reduce
import argparse,gzip,hashlib,json,math,time
import numpy as np
from flint import nmod_mat,fmpz_mat
from full_partner_native import NativeFullPartnerBatch
from full_partner_projection import mask_universe
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();started=time.monotonic();F=np.load(a.archive)['features'].astype(int)
 X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];A=[(X[512]&z).bit_count()%2 for z in Z];drop=[54,55+A.index(0),55+A.index(1)];coords=[i for i in range(775) if i not in drop]
 R,rank=nmod_mat(F[:,coords].T.tolist(),2147483647).rref();rows=[]
 for i in range(rank):rows.append(next(j for j in range(len(F)) if int(R[i,j])))
 print(json.dumps({'stage':'independent_rows','rank':rank,'rows':len(rows),'seconds':time.monotonic()-started}),flush=True)
 S=fmpz_mat(F[rows][:,coords].tolist());N,nullity=S.nullspace();print(json.dumps({'stage':'exact_nullspace','nullity':nullity,'seconds':time.monotonic()-started}),flush=True)
 assert nullity==len(coords)-rank
 coefficients=[]
 for j in range(nullity):
  small=[int(N[i,j]) for i in range(len(coords))];g=reduce(math.gcd,map(abs,small));small=[v//g for v in small];first=next(v for v in small if v);small=[v if first>0 else -v for v in small];c=[0]*775
  for i,v in zip(coords,small):c[i]=v
  coefficients.append(c)
 test=fmpz_mat(F.tolist())*fmpz_mat(np.array(coefficients,dtype=object).T.tolist());assert all(test[i,j]==0 for i in range(len(F)) for j in range(nullity));print(json.dumps({'stage':'all_saved_nulls_exact','count':nullity,'max_coefficient_bits':max(abs(v).bit_length() for c in coefficients for v in c),'seconds':time.monotonic()-started}),flush=True)
 allowed,reps=mask_universe(32);batch=NativeFullPartnerBatch(reps);results=[]
 for k,c in enumerate(coefficients):
  signs=[]
  for sign in (1,-1):
   priced=batch.price([sign*v for v in c]);records=[]
   for i,m in enumerate(reps):
    B=list(map(int,priced['bases'][i]));nz=128-m.bit_count();records.append({'mask':m,'support_value':int(priced['values'][i]),'full_value':int(priced['full_values'][i]),'selected_Z_indices':B,'zero_basis_indices':B[:nz],'owner_indices':B[nz:]})
   signs.append({'sign':sign,'upper':max(r['full_value'] for r in records),'records':records})
  results.append({'index':k,'coefficients':c,'signs':signs,'proposed_identity':all(s['upper']==0 for s in signs)});print(json.dumps({'stage':'priced','index':k,'uppers':[s['upper'] for s in signs],'seconds':time.monotonic()-started}),flush=True)
 batch.close();paths=['saved_span_affine_gate.py','full_partner_native.py','full_partner_anchor_native.py','full_partner_anchor_native.cpp','coupling-results/anchor-native-accepted.dylib','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz'];out={'status':'EXACT_SAVED_SPAN_AFFINE_CANDIDATES','source_C16_answered':False,'archive':str(a.archive),'archive_sha256':sha(a.archive),'archive_rows':len(F),'modular_rank':rank,'modulus':2147483647,'independent_row_indices':rows,'dropped_gauge_coordinates':drop,'nullity_after_three_gauges':nullity,'all_saved_null_equations_exact':True,'allowed_masks':len(allowed),'representatives':reps,'source_hashes':{p:sha(ROOT/p) for p in paths},'results':results,'elapsed_seconds':time.monotonic()-started};a.output.write_bytes(gzip.compress((json.dumps(out,separators=(',',':'))+'\n').encode(),mtime=0))
if __name__=='__main__':main()
