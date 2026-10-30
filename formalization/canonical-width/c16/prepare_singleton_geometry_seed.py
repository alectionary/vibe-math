#!/usr/bin/env python3
"""Geometry-only old-column reuse; no transferred target, weights, or solver."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time
from verify_projected_profile_moment_rows import point_vector
from full_partner_projection_features import moment_target
ROOT=Path(__file__).resolve().parent
POINT='coupling-results/two-basis-integer-witness22-rational.json.gz'
POINT_SHA='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'

def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,o):
    p=ROOT/p;assert not p.exists();raw=(json.dumps(o,sort_keys=True,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def rank(vs):
    rows={}
    for v in vs:
        while v:
            b=v.bit_length()-1
            if b in rows:v^=rows[b]
            else:rows[b]=v;break
    return len(rows)
def paths(k):
    return [f'coupling-results/singleton-rank-refresh-witness12-o{k:02d}-{suffix}.json' for suffix in ('numeric','exact')]
def columns(d):
    result=[]
    for i,B in enumerate(d.get('numerical_basis_archive',[])):result.append(('numerical_basis_archive',i,B))
    for i,row in enumerate(d.get('zero_bases',[])):result.append(('zero_bases',i,row['indices']))
    return result

def availability(output):
    rows=[]
    for k in range(45):
        sources=[]
        for p in paths(k):
            if not (ROOT/p).exists():sources.append(dict(path=p,present=False));continue
            d=read(p);sources.append(dict(path=p,present=True,sha256=sha(p),bytes=(ROOT/p).stat().st_size,
                         declared_anchor_orbit=d.get('anchor_orbit'),legacy_status=d.get('status'),
                         numerical_columns=len(d.get('numerical_basis_archive',[])),exact_or_partial_basis_records=len(d.get('zero_bases',[]))))
        rows.append(dict(anchor_orbit=k,sources=sources,has_geometry=any(r.get('numerical_columns',0)+r.get('exact_or_partial_basis_records',0)>0 for r in sources)))
    write(output,dict(status='LEGACY_SINGLETON_GEOMETRY_AVAILABILITY_METADATA_ONLY',source_point_label='witness12',
          anchors=rows,available_anchor_count=sum(r['has_geometry'] for r in rows),physical_bases_validated=False,
          old_target_claims_transferred=False,producer_sha256=sha(Path(__file__).name),physical_queries=0,priority=19))
    return rows

def main():
    p=argparse.ArgumentParser();p.add_argument('--orbit',type=int,choices=[32],default=32);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--availability-output',type=Path,required=True);a=p.parse_args();start=time.monotonic()
    assert sha(POINT)==POINT_SHA;summary='coupling-results/two-basis-integer-witness22-checks-summary.json'
    assert read(summary)['status']=='PASS_LISTED_RELAXATION'
    available=availability(a.availability_output)
    X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert len(X)==len(Z)==720 and rank(X)==rank(Z)==128
    k=a.orbit;owner=point_vector(ROOT/POINT);prob=owner[k];assert 0<prob<1
    q=[v/(16*prob) for v in moment_target(owner,k)[55:]]
    E=[j for j in range(720) if not((X[16*k]&Z[j]).bit_count()%2)];U=sorted(set(range(720))-set(E));EE=set(E)
    assert rank(Z[j] for j in E)==127 and all(0<=v<=1 for v in q)
    assert sum(q[j] for j in E)==127 and sum(q[j] for j in U)==1
    B=[];origins=[];lookup={};legacy=[]
    for path in paths(k):
        if not (ROOT/path).exists():continue
        d=read(path);assert d.get('anchor_orbit')==k
        cc=columns(d);legacy.append(dict(path=path,sha256=sha(path),declared_anchor_orbit=k,legacy_status=d.get('status'),columns_seen=len(cc)))
        for field,index,J in cc:
            assert J==sorted(set(J)) and len(J)==127 and all(type(j)is int and j in EE for j in J)
            assert rank(Z[j] for j in J)==127
            key=tuple(J);origin=dict(path=path,field=field,index=index)
            if key not in lookup:lookup[key]=len(B);B.append(J);origins.append([])
            origins[lookup[key]].append(origin)
    assert 1<=len(B)<=5000
    source_names=[Path(__file__).name,'verify_projected_profile_moment_rows.py','full_partner_projection_features.py',
                  'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',POINT,summary,str(a.availability_output),*[r['path'] for r in legacy]]
    sources={p:sha(p) for p in source_names}
    out=dict(status='GEOMETRY_SEED',seed_kind='LEGACY_PHYSICAL_COLUMNS_ONLY',source_hashes=sources,
             point=POINT,point_sha256=POINT_SHA,anchor_orbit=k,conditional_probability=str(prob),conditional_target=list(map(str,q)),
             physical_zero_ground_indices=E,physical_bases=B,unit_probabilities=[dict(index=j,probability=str(q[j])) for j in U if q[j]],
             column_origins=origins,legacy_sources=legacy,variable_count=len(B),
             old_weights_used=False,old_target_claims_used=False,current_point_membership_claimed=False,
             exact_current_target_rebuilt=True,discovery_solver_launched=False,
             scope='Only the physical basis indices are reused. Fresh point22 conditional target and unit law; no primal weights or fresh partial-state claim.',
             priority=19,elapsed_seconds=time.monotonic()-start)
    write(a.output,out);print(dict(status='GEOMETRY_SEED',orbit=k,columns=len(B),legacy_records=sum(r['columns_seen'] for r in legacy),available_anchors=sum(r['has_geometry'] for r in available),sha256=sha(a.output),seconds=out['elapsed_seconds']),flush=True)

if __name__=='__main__':main()
