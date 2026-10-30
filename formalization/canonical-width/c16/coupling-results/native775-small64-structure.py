#!/usr/bin/env python3
"""Readable exact scale64 structure and cardinality-versus-rank diagnostic."""
from pathlib import Path
from fractions import Fraction
from collections import Counter,defaultdict
from functools import reduce
import gzip,hashlib,json,math,sys,time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from full_partner_native import NativeFullPartnerBatch
from verify_full_partner_projection import read,weights,local_score,compile_row,point_data
from verify_full_partner_basis_oracle import rebuild_domain,dimension,extend
from verify_algebraic_model import physical
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 start=time.monotonic();path=ROOT/'coupling-results/native775-witness9-gauge-rounded.json.gz';receipt=ROOT/'coupling-results/native775-witness9-gauge-rounded-independent.json';bank=read(path);assert read(receipt)['status']=='PASS' and read(receipt)['bank_sha256']==sha(path);reps=bank['representatives'];X,Z,_=physical();A=[(X[512]&z).bit_count()%2 for z in Z];domains=[rebuild_domain(X,Z,[512+h for h in range(16) if m>>h&1],128) for m in reps];batch=NativeFullPartnerBatch(reps);out=[]
 for index in (0,7):
  cut=bank['cuts'][index];c=cut['coefficients'];assert c[0]==0 and c[1]==-64 and c[2:10]==[46,40,29,29,56,28,38,27] and not any(c[10:55]);cross=c[55:];patterns=[tuple(cross[16*j:16*j+16]) for j in range(45)];canonical=[min(v[h:]+v[:h] for h in range(16)) for v in patterns]
  groups=defaultdict(list)
  for j,v in enumerate(patterns):groups[v].append(j)
  row,rhs=compile_row(c,0,32);gcd=reduce(math.gcd,[int(v) for v in row.values()]);assert gcd==16 and rhs==0;owner_row=[[j,int(v)//gcd] for j,v in row.items()]
  native=batch.price(c);negative=batch.price([-v for v in c]);assert max(native['full_values'])==0;details=[]
  for i,(m,d) in enumerate(zip(reps,domains)):
   k=m.bit_count();r=128-k;w=weights(m,c);local=local_score(m,c);owner=sum(max(w[j] for j in b) for b in d['bins']);order=sorted(d['zero'],key=lambda j:(-w[j],j));card=local+owner+sum(w[j] for j in order[:r]);positive=local+owner+sum(max(0,w[j]) for j in d['zero']);actual=int(native['full_values'][i]);assert positive>=card>=actual
   detail=dict(mask=m,k=k,mask_score=local,owner_support=owner,exact_basis_bound=actual,cardinality_only_bound=card,unlimited_positive_zero_bound=positive,rank_gain=card-actual)
   if card>0:
    B=order[:r]+[max(b,key=lambda j:(w[j],-j)) for b in d['bins']];assert len(B)==128 and len(set(B))==128;detail['cardinality_optimum_physical_rank']=dimension(Z[j] for j in B);detail['cardinality_relaxation_selected_Z_indices']=B
    rows={};losses=[];loss_sum=0
    for position,j in enumerate(order):
     extend(rows,Z[j]);drop=w[j]-(w[order[position+1]] if position+1<len(order) else w[j]);defect=min(r,position+1)-len(rows)
     if drop and defect:losses.append(dict(weight_threshold=w[j],next_weight=w[order[position+1]],prefix_size=position+1,prefix_rank=len(rows),rank_defect=defect,weighted_loss=drop*defect));loss_sum+=drop*defect
    assert loss_sum==card-actual;detail['exact_prefix_rank_loss_decomposition']=losses
   details.append(detail)
  phase_stats=[]
  for h in range(16):
   vals=cross[h::16];phase_stats.append(dict(phase_distance=h,nonzero=sum(v!=0 for v in vals),positive_sum=sum(max(0,v) for v in vals),negative_sum=sum(min(0,v) for v in vals),histogram=dict(sorted(Counter(vals).items()))))
  classes={str(a):dict(sorted(Counter(v for bit,v in zip(A,cross) if bit==a).items())) for a in (0,1)}
  record=dict(cut_index=index,exact_violation=cut['exact_violation'],normalized_violation=float(Fraction(cut['exact_violation'])/64),coefficient_gcd=reduce(math.gcd,c),compiled_owner_gcd=16,compiled_owner_row_divided_by16=owner_row,compiled_owner_rhs=0,p_coefficient=-64,autocorrelation_coefficients=c[2:10],cross_term_count=sum(v!=0 for v in cross),cross_coefficient_histogram=dict(sorted(Counter(cross).items())),physical_pairing_class_histograms=classes,phase_distance_statistics=phase_stats,orbit_weight_patterns=[dict(orbits=js,weights=list(v)) for v,js in groups.items()],distinct_orbit_patterns=len(groups),distinct_patterns_modulo_cyclic_rotation=len(set(canonical)),zero_orbits=[j for j,v in enumerate(patterns) if not any(v)],primitive_feature_nonzeros=sum(v!=0 for v in c),primitive_owner_nonzeros=len(owner_row),global_minimum=-int(max(negative['full_values'])),global_maximum=0,cardinality_relaxation_positive_masks=sum(r['cardinality_only_bound']>0 for r in details),cardinality_relaxation_maximum=max(r['cardinality_only_bound'] for r in details),unlimited_positive_zero_positive_masks=sum(r['unlimited_positive_zero_bound']>0 for r in details),rank_gain_masks=sum(r['rank_gain']>0 for r in details),maximum_rank_gain=max(r['rank_gain'] for r in details),mask_details=details)
  out.append(record);print({k:v for k,v in record.items() if k in ('cut_index','cardinality_relaxation_positive_masks','cardinality_relaxation_maximum','rank_gain_masks','maximum_rank_gain','unlimited_positive_zero_positive_masks','global_minimum','global_maximum','primitive_owner_nonzeros')},flush=True)
 c0=bank['cuts'][0]['coefficients'];c1=bank['cuts'][7]['coefficients'];differences=[dict(feature=i,orbit=(i-55)//16,phase=(i-55)%16,cut0=a,cut7=b,physical_pairing=A[i-55]) for i,(a,b) in enumerate(zip(c0,c1)) if a!=b];assert all(d['feature']>=55 for d in differences)
 result=dict(status='EXACT_ACCEPTED_SMALL64_STRUCTURE_AND_RELAXATION_DIAGNOSTIC',source_C16_answered=False,bank_sha256=sha(path),receipt_sha256=sha(receipt),script_sha256=sha(Path(__file__)),formula='46*C1+40*C2+29*C3+29*C4+56*C5+28*C6+38*C7+27*C8+sum(b[j,h]*d[j,h]) <=64*k',owner_formula='46*S1[32,32]+40*S2[32,32]+29*S3[32,32]+29*S4[32,32]+56*S5[32,32]+28*S6[32,32]+38*S7[32,32]+27*S8[32,32]+sum(b[j,h]*T_h[32,j]) <=64*p32',cuts=out,cut_differences=differences,elapsed_seconds=time.monotonic()-start,scope='No claim of facet irredundancy or complete affine hull. Exact source support remains authority. Cardinality/owner relaxation counterexamples, when present, show that discarding physical rank cannot prove this same functional.')
 p=ROOT/'coupling-results/native775-small64-structure.json';assert not p.exists();p.write_text(json.dumps(result,indent=2)+'\n');print('SHA',sha(p),flush=True)
if __name__=='__main__':main()
