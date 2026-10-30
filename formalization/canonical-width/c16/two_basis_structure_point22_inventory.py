"""Freeze the actual point22 local-allocation source/data closure, without solving."""
from pathlib import Path
import json,hashlib
from two_basis_portable_replay_v4 import closure,ROOT,data

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 output=ROOT/'two-basis-results/two-basis-point22-local-allocation-closure.json';assert not output.exists()
 point='coupling-results/two-basis-integer-witness22-rational.json.gz';reference='two-basis-results/two-basis-structure-zonotope-32x27-point15.json'
 seeds=[Path(__file__).name,'two_basis_structure_point22_review.md',point,reference,'two-basis-results/two-basis-structure-zonotope-32x27-point15-independent.json','two-basis-results/two-basis-zero-high-point22.json','two_basis_structure_zero_high_gate.py','two_basis_structure_direct_rank_geometry.py','two_basis_structure_dyadic_recovery.py','verify_two_basis_rank_geometry_allocation.py'];gate=data(ROOT/seeds[-5]);assert gate['point_sha256']==sha(ROOT/point) and gate['geometry_reference_sha256']==sha(ROOT/reference);accepted=[]
 for side in 'XZ':
  for prefix in [f'two-basis-small-flat-{side}-geometry',f'two-basis-direct-{side}-fullrank3-point22',f'two-basis-direct-{side}-fullrank3-dyadic-point22-b50']:
   name='two-basis-results/'+prefix+('.json' if 'geometry' in prefix else '.json.gz');receipt='two-basis-results/'+prefix+'-independent.json';seeds.extend([name,receipt]);d=data(ROOT/receipt)
   if 'geometry' in prefix:assert d['status']=='PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY' and d['bank_sha256']==sha(ROOT/name)
   else:assert d['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS' and d['certificate_sha256']==sha(ROOT/name) and d['point_sha256']==sha(ROOT/point) and d['all_contracted_rank_le_three_rows_proved'] and not d['all_subset_rank_membership_proved']
   accepted.append(dict(path=name,sha256=sha(ROOT/name),receipt=receipt,receipt_sha256=sha(ROOT/receipt),status=d['status']))
 names=closure(seeds);files=[dict(path=n,sha256=sha(ROOT/n),bytes=(ROOT/n).stat().st_size) for n in names]
 # Recheck every declared relative source/dependency hash within this closure.
 declared=0
 for n in names:
  if n.endswith(('.json','.json.gz')):
   d=data(ROOT/n)
   if isinstance(d,dict):
    for key in ['source_hashes','dependencies']:
     for p,h in d.get(key,{}).items():
      if isinstance(h,str) and len(h)==64 and (ROOT/p).is_file():assert sha(ROOT/p)==h,(n,p);declared+=1
 out=dict(status='FROZEN_POINT22_LOCAL_ALLOCATION_SOURCE_DATA_CLOSURE',producer_sha256=sha(__file__),point_path=point,point_sha256=sha(ROOT/point),X_anchors=gate['X_anchors'],Z_anchors=gate['Z_anchors'],lambda_masses=gate['lambda_masses'],zero_high_gate='two-basis-results/two-basis-zero-high-point22.json',zero_high_gate_sha256=sha(ROOT/'two-basis-results/two-basis-zero-high-point22.json'),geometry_reference=reference,accepted=accepted,files=files,total_files=len(files),total_bytes=sum(r['bytes'] for r in files),declared_hash_bindings_checked=declared,clean_copy_replay_performed=False,all_subset_rank_membership_proved=False,two_sector_basis_membership_proved=False,source_C16_answered=False,scope='Actual source/data closure for the exact point22 shared zero-high law, complete rank<=3 geometry, count allocations and separate dyadic50 allocations. No physical full-rank membership or source-case claim. Existing accepted files are not modified.');output.write_text(json.dumps(out,indent=2)+'\n');print({k:out[k] for k in ['status','total_files','total_bytes','declared_hash_bindings_checked']})
if __name__=='__main__':main()
