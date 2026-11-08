#!/usr/bin/env python3
"""Frozen all-mask native/Python equality and independent contraction replay."""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
import argparse,hashlib,json,time
import numpy as np
from full_partner_anchor_native import NativeAnchorBatch,STATUS
from full_partner_anchor_basis_oracle import FullPartnerAnchorBasisOracle
from verify_full_partner_anchor_basis_oracle import domain,check,dimension
from verify_algebraic_model import physical
from verify_full_partner_projection import weights,local_score
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def tiny_controls(library):
 X=list(range(1,8));selected=[list(P) for k in range(4) for P in combinations(range(7),k)];queries=0;missing=0;overflow=0
 for Z in [list(range(1,8)),[1,2,4],[2,4,6],[0,1,1,2,4]]:
  oracle=FullPartnerAnchorBasisOracle(X,Z,3)
  for anchor in range(len(Z)):
   batch=NativeAnchorBatch(anchor=anchor,library=library,x_pool=X,z_pool=Z,dimension=3,selected_sets=selected);assert batch.context
   expected=np.array([STATUS.index(oracle.prepare_selected(P,anchor,s)['status']) for P in selected for s in (False,True)],dtype=np.int32);assert np.array_equal(batch.status,expected);missing+=sum(batch.status!=0)
   for raw in [[0]*len(Z),[-j-1 for j in range(len(Z))],[(j*7+3)%11-5 for j in range(len(Z))]]:
    w=np.tile(raw,(len(batch.branches),1));values,bases=batch.support_feasible(w)
    for k,(P,state) in enumerate(batch.branches):
     r=oracle.support(oracle.prepare_selected(P,anchor,state),raw);assert int(values[k])==r['value'] and tuple(map(int,bases[k]))==r['selected_Z_indices'];queries+=1
   if batch.branches:
    large=np.full((len(batch.branches),len(Z)),(1<<63)-1,dtype=np.int64);v,b=batch.support_feasible(large);assert batch.last_backend=='python_exact_fallback' and all(x==3*((1<<63)-1) for x in v);overflow+=1
    rational=np.empty_like(large,dtype=object);rational[:]=Fraction(-1,3);v,b=batch.support_feasible(rational);assert batch.last_backend=='python_exact_fallback' and all(x==-1 for x in v);overflow+=1
    try:batch.support_feasible(np.zeros_like(large,dtype=float))
    except TypeError:pass
    else:raise AssertionError('float weights accepted')
   batch.close()
 # Native input range and native accumulated-sum overflow are distinct routes.
 one=NativeAnchorBatch([0],80,library=library);c=[0]*1512;c[10]=1<<70;r=one.price(c);assert r['backend']=='python_exact_fallback';c[10]=(1<<63)-1;r=one.price(c);assert r['backend']=='python_exact_fallback';overflow+=2
 return dict(exact_tiny_value_and_basis_comparisons=queries,excluded_tiny_branches=missing,exact_overflow_or_rational_fallback_controls=overflow,float_inputs_rejected=True)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--library',type=Path,default=Path('/private/tmp/c16-anchor-native.dylib'));ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists() and not a.output.with_suffix('.frozen.json').exists();start=time.monotonic()
 parent=ROOT/'coupling-results/full-partner-projection-wolfe-strengthen-witness2.json';base=json.loads(parent.read_text());masks=sorted({((m<<h)|(m>>(16-h)))&65535 for m in base['representatives'] for h in range(16)});assert len(masks)==4597
 zero=[0]*1512;negative=zero.copy()
 for j in range(45):negative[10+j]=-1-j%13
 for j in range(720):negative[792+j]=-1-j%5
 signed=[((i*37+11)%31)-15 for i in range(1512)];wolfe=base['cuts'][0]['coefficients']+[-7]+[(-1)**t*(t+1) for t in range(16)]+[(7*j+3)%19-9 for j in range(720)]
 cohorts=[('zero',zero),('negative',negative),('signed',signed),('wolfe',wolfe)]
 sources=[parent,ROOT/'full_partner_anchor_native.cpp',ROOT/'full_partner_anchor_native.py',ROOT/'full_partner_anchor_basis_oracle.py',ROOT/'full_partner_basis_oracle.py',ROOT/'full_partner_projection_features.py',ROOT/'verify_full_partner_anchor_basis_oracle.py',ROOT/'verify_full_partner_basis_oracle.py',ROOT/'verify_full_partner_projection.py',ROOT/'verify_algebraic_model.py',ROOT/'verify_partial_frame.py',ROOT/'audit_pools.py',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',Path(__file__)]
 frozen=dict(status='FROZEN_BEFORE_NATIVE_MATCHED_GATE',anchor=80,orbit=32,masks=masks,cohorts=[dict(name=n,coefficients=c) for n,c in cohorts],source_hashes={str(p.relative_to(ROOT)):sha(p) for p in sources},native_library_path=str(a.library),native_library_sha256=sha(a.library),compiler_command='/usr/bin/clang++ -O3 -std=c++17 -dynamiclib full_partner_anchor_native.cpp -o /private/tmp/c16-anchor-native.dylib',scope='Same exact integer inputs, all4597 masks and both anchor branches. Timing includes native weight construction, sorting and outputs; excludes one-time domain preparation and Python independent replay.')
 fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n')
 t=time.monotonic();batch=NativeAnchorBatch(masks,80,library=a.library);native_prepare=time.monotonic()-t;assert batch.context
 X,Z,_=physical();oracle=FullPartnerAnchorBasisOracle(X,Z);prepared=[];independent=[];t=time.monotonic()
 for mask in masks:
  selected=[512+h for h in range(16) if mask>>h&1]
  for state in (False,True):
   d=oracle.prepare(32,mask,80,state);q=domain(X,Z,selected,80,state,128);assert d['status']==q['status'];prepared.append(d);independent.append(q)
 python_prepare=time.monotonic()-t;expected=np.array([STATUS.index(d['status']) for d in prepared]);assert np.array_equal(batch.status,expected)
 stats=[];values_save=[];full_save=[];bases_save=[];total_prefix=0
 for name,c in cohorts:
  t=time.monotonic();got=batch.price(c);native_seconds=time.monotonic()-t;assert got['backend']=='native_int64';times=[]
  # Matched Python construction computes each base weight once per mask.
  t=time.monotonic();py_values=[];py_full=[];py_bases=[];records=[]
  for mask_index,mask in enumerate(masks):
   ordinary=weights(mask,c[:775]);constant=local_score(mask,c[:775]);extra=c[775]+sum(c[776+t] for t in range(16) if mask>>t&1)
   for state in (False,True):
    q=2*mask_index+int(state)
    if expected[q]:continue
    w=[x+int(state)*c[792+j] for j,x in enumerate(ordinary)];r=oracle.support(prepared[q],w);py_values.append(r['value']);py_full.append(r['value']+constant+int(state)*extra);py_bases.append(r['selected_Z_indices']);records.append((q,w,r))
  python_seconds=time.monotonic()-t
  assert list(got['values'])==py_values and list(got['full_values'])==py_full and np.array_equal(got['bases'],np.array(py_bases,dtype=np.uint16))
  t=time.monotonic()
  for q,w,r in records:total_prefix+=check(Z,list(prepared[q]['selected_X_indices']),independent[q],w,r,128)
  replay_seconds=time.monotonic()-t
  # Explicit arbitrary-weight API also returns the same values and bases.
  W=np.array([w for _,w,_ in records],dtype=np.int64);t=time.monotonic();v,B=batch.support_feasible(W);raw_seconds=time.monotonic()-t;assert np.array_equal(v,got['values']) and np.array_equal(B,got['bases'])
  values_save.append(got['values']);full_save.append(got['full_values']);bases_save.append(got['bases']);stat=dict(cohort=name,native_whole_pricing_seconds=native_seconds,python_whole_pricing_seconds=python_seconds,speedup=python_seconds/native_seconds,native_prebuilt_weight_batch_seconds=raw_seconds,independent_replay_seconds=replay_seconds,feasible_queries=len(records));stats.append(stat);print('NATIVE COHORT',stat,flush=True)
 controls=tiny_controls(a.library);npz=a.output.with_suffix('.npz');np.savez_compressed(npz,feasible_indices=batch.feasible_indices,status=batch.status,values=np.array(values_save),full_values=np.array(full_save),bases=np.array(bases_save));assert all(sha(ROOT/p)==h for p,h in frozen['source_hashes'].items()) and sha(a.library)==frozen['native_library_sha256']
 out=dict(status='PASS_MATCHED_EXACT_NATIVE_GATE',source_C16_answered=False,frozen_sha256=sha(fp),source_hashes=frozen['source_hashes'],native_library_path=str(a.library),native_library_sha256=sha(a.library),arrays_path=str(npz.relative_to(ROOT)),arrays_sha256=sha(npz),mask_count=len(masks),branch_count=2*len(masks),feasible_branches=len(batch.branches),excluded_branches=int(sum(batch.status!=0)),all_values_fullscores_and_basis_orders_identical=True,native_preparation_seconds=native_prepare,python_and_independent_preparation_seconds=python_prepare,cohort_timings=stats,independent_prefix_rank_checks=total_prefix,controls=controls,elapsed_seconds=time.monotonic()-start,
          scope='Exact native match against frozen Python oracle plus independent low-pivot prefix-rank source replay for all4 frozen coefficient cohorts. Measured local speedup only; no projected separator or source frame claimed. Native int64 overflow/rational input falls back to exact Python.')
 a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['source_hashes','cohort_timings']},flush=True)
if __name__=='__main__':main()
