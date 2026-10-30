"""Bounded geometry-only bank for one shared master; old weights are discarded."""
from pathlib import Path
from fractions import Fraction as Q
import gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def main():
 assert os.getpriority(os.PRIO_PROCESS,0)==19
 assert all(os.environ.get(k)=='1' for k in THREADS)
 from two_sided_full_basis_oracle import TwoSidedFullBasisOracle
 from verify_algebraic_model import physical
 from verify_two_sided_full_basis_oracle import domains,rank
 start=time.monotonic();out=ROOT/'shared-master-results/geometry-v1.json.gz'
 assert not out.exists();out.parent.mkdir(exist_ok=True)
 seedpath=ROOT/'two-basis-results/shared-basis-phase-one-point22-seed.json.gz'
 seed=read(seedpath);assert sha(seedpath)=='27bbbe759c93cb20dc7b581a35434bb6c4b35aa132fb7412bf395c1035d40473'
 seedblocks={(b['side'],b['mask']):b for b in seed['blocks']}
 masses=list(map(Q,seed['lambda_masses']))
 oracle=TwoSidedFullBasisOracle();prepared=oracle.prepare([80,512],[186,433])
 X,Z,_=physical();dd=domains(X,Z,[80,512],[186,433]);assert all(d['feasible'] for d in dd)
 assert tuple(X)==oracle.X and tuple(Z)==oracle.Z
 sources={str(seedpath.relative_to(ROOT)):sha(seedpath)}
 columns=[];summaries=[];seen=set()
 def add(side,m,indices,origin):
  chosen=tuple(sorted(indices));key=(side,m,chosen)
  if key in seen:return False
  U=X if side=='X' else Z;d=dd[m][side];selected=set(chosen)
  assert len(chosen)==len(selected)==128 and all(type(j)is int and 0<=j<720 for j in chosen)
  assert rank(U[j] for j in chosen)==128
  assert set(d['forced'])<=selected and not selected.intersection(d['absent'])
  assert all(len(d['signatures'][j])<=1 for j in chosen)
  assert sum(not d['signatures'][j] for j in chosen)==d['zero_required']
  for opposite,bucket in zip(d['opposite'],d['bins']):
   owners=[j for j in chosen if d['signatures'][j]==(opposite,)]
   assert len(owners)==1 and owners[0] in bucket
  seen.add(key);columns.append(dict(side=side,mask=m,indices=list(chosen),**origin));return True
 for m in range(16):
  zero_support=oracle.support_pattern(prepared[m],[0]*1440) if not masses[m] else None
  for side in 'XZ':
   start_index=len(columns);b=seedblocks.get((side,m))
   if b:add(side,m,b['indices'],dict(origin_kind='accepted_phase_one_seed',origin_certificate=str(seedpath.relative_to(ROOT))))
   else:add(side,m,zero_support[side+'_support']['selected_indices'],dict(origin_kind='zero_weight_full_domain_basis'))
   target={j for j,v in enumerate(seed['parent_exact_allocations'][side][m]) if Q(v)>0}
   available=[];archive=None;receipt=None;extra=0
   if masses[m]:
    archive=ROOT/f'two-basis-results/joint-capacity-ranks-point22-{side}-m{m:02}.json.gz'
    receipt=ROOT/f'two-basis-results/joint-capacity-ranks-point22-{side}-m{m:02}-independent.json'
    a,r=read(archive),read(receipt)
    assert r['status'].startswith('PASS_EXACT_PHYSICAL_')
    assert r['certificate_sha256']==sha(archive)
    assert a['side']==side and a['selected_mask']==m
    sources[str(archive.relative_to(ROOT))]=sha(archive);sources[str(receipt.relative_to(ROOT))]=sha(receipt)
    unique={}
    for i,record in enumerate(a['physical_basis_records']):unique.setdefault(tuple(sorted(record['selected_indices'])),i)
    available=list(unique.items());n=len(available)
    selected_positions=sorted({k*(n-1)//63 for k in range(64)}) if n>=64 else list(range(n))
    def from_archive(i,reason):
     B,original=available[i]
     return add(side,m,B,dict(origin_kind=reason,origin_certificate=str(archive.relative_to(ROOT)),origin_receipt=str(receipt.relative_to(ROOT)),origin_record_index=original))
    for i in selected_positions:extra+=from_archive(i,'evenly_spaced_archive_geometry')
    covered=set().union(*(set(c['indices']) for c in columns[start_index:]))
    while target-covered and extra<96:
     scored=[(len((target-covered).intersection(B)),-i,i) for i,(B,_) in enumerate(available)]
     gain,_,i=max(scored)
     if not gain:break
     assert from_archive(i,'positive_coordinate_coverage_geometry');extra+=1;covered.update(available[i][0])
   else:covered=set(columns[-1]['indices'])
   summaries.append(dict(side=side,mask=m,column_start=start_index,column_count=len(columns)-start_index,
       archived_unique_bases=len(available),archive_extras=extra,positive_coordinates=len(target),uncovered_positive_coordinates=sorted(target-covered)))
 initial=[]
 for side in 'XZ':
  for m in range(16):
   if (side,m) in seedblocks:
    B=tuple(sorted(seedblocks[side,m]['indices']))
    i=next(i for i,c in enumerate(columns) if c['side']==side and c['mask']==m and tuple(c['indices'])==B)
    initial.append([i,str(masses[m])])
 assert len(initial)==22 and len(columns)<=32+22*96
 for name in ['shared_master_geometry.py','two_sided_full_basis_oracle.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','pools/xcoords.txt','pools/zcoords.txt']:
  sources[name]=sha(ROOT/name)
 result=dict(status='BOUNDED_SHARED_MASTER_GEOMETRY_REQUIRES_INDEPENDENT_REPLAY',columns=columns,initial_seed_weights=initial,blocks=summaries,
  source_hashes=sources,X_anchors=[80,512],Z_anchors=[186,433],all_sector_pattern_domains=32,physical_bases_checked=len(columns),
  selection='One accepted seed or zero-weight full-domain basis, then64 evenly spaced unique archived bases, then positive-coordinate coverage up to96 extras per positive block.',
  old_weights_reused=False,source_C16_answered=False,producer_sha256=sha(__file__),priority=19,threads=1,elapsed_seconds=time.monotonic()-start)
 raw=(json.dumps(result,indent=2)+'\n').encode();out.write_bytes(gzip.compress(raw,mtime=0))
 print(json.dumps(dict(path=str(out.relative_to(ROOT)),sha256=sha(out),column_count=len(columns),uncovered_positive_coordinates=sum(len(b['uncovered_positive_coordinates']) for b in summaries),elapsed_seconds=result['elapsed_seconds'])))
if __name__=='__main__':main()
