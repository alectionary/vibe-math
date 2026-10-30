#!/usr/bin/env python3
"""One frozen colored physical pilot; no cohort or retry is performed."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'research worker must be nice19'
for _key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_key) == '1'
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json, subprocess, sys, time

ROOT = Path(__file__).resolve().parent
PREFIX = 'two-basis-results/colored-physical-point22-Z-m02-X614-v1'
POINT = 'coupling-results/two-basis-integer-witness22-rational.json.gz'
ALLOC = {s: f'two-basis-results/two-basis-direct-{s}-fullrank3-dyadic-point22-b50' for s in ('X','Z')}
J = [51,56,194,230,485,492,501,547,588,642,646]

def sha(path): return hashlib.sha256((ROOT/path).read_bytes()).hexdigest()
def read(path):
    raw=(ROOT/path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)
def write(path, obj):
    target=ROOT/path
    assert not target.exists(), ('immutable output exists', path)
    raw=(json.dumps(obj,sort_keys=True,indent=2)+'\n').encode()
    target.write_bytes(gzip.compress(raw,mtime=0) if str(path).endswith('.gz') else raw)

def prepare():
    from verify_two_sided_full_basis_oracle import physical_source
    from colored_physical_domain_representation_draft import source_domain, represent, high_basis, remainder
    names=[Path(__file__).name,'verify_colored_physical_pilot_v1.py',
           'exact_colored_matroid_push_relabel_draft.py','colored_physical_domain_representation_draft.py',
           'verify_colored_physical_endpoint_draft.py','colored_matroid_controls_draft.py',
           'verify_colored_tiny_replay.py','verify_two_sided_full_basis_oracle.py',
           'verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py',
           'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',POINT,
           'two-basis-results/colored-draft-tiny-v1.json.gz',
           'two-basis-results/colored-draft-tiny-v1.frozen.json',
           'two-basis-results/colored-draft-tiny-v1-independent.json',
           'two-basis-results/colored-draft-tiny-v1-second-independent.json',
           'two-basis-results/colored-draft-tiny-rootreview-independent.json']
    bindings={p:sha(p) for p in names}
    tiny=read(names[-2]); assert tiny['status']=='PASS_SECOND_INDEPENDENT_COLORED_TINY_REPLAY'
    assert tiny['bank_sha256']==sha('two-basis-results/colored-draft-tiny-v1.json.gz')
    assert tiny['consumer_sha256']==sha('verify_colored_tiny_replay.py')
    for p,h in tiny['source_hashes'].items(): assert sha(p)==h
    allocations={}; configs={}
    for side,prefix in ALLOC.items():
        c=read(prefix+'.json.gz'); f=read(prefix+'.frozen.json'); r=read(prefix+'-independent.json')
        assert r['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert r['certificate_sha256']==sha(prefix+'.json.gz')
        assert r['frozen_sha256']==c['frozen_sha256']==sha(prefix+'.frozen.json')
        assert r['point_sha256']==f['point_sha256']==sha(POINT)
        assert r['consumer_sha256']==sha('verify_two_basis_rank_geometry_allocation.py')
        assert f['side']==side and f['X_anchors']==[80,512] and f['Z_anchors']==[186,433]
        for p,h in {**f['source_hashes'], **r['dependencies']}.items():
            assert sha(p)==h; bindings[p]=h
        for suffix in ('.json.gz','.frozen.json','-independent.json'):
            bindings[prefix+suffix]=sha(prefix+suffix)
        allocations[side]=c; configs[side]=f
    assert configs['X']['lambda_masses']==configs['Z']['lambda_masses']
    lam=Q(configs['Z']['lambda_masses'][2]); a=Q(allocations['X']['exact_allocations'][2][614])
    z=list(map(Q, allocations['Z']['exact_allocations'][2]))
    assert lam>0 and 0<=a<=lam and sum(z)==128*lam
    masses=[a/lam,1-a/lam]; target=[v/lam for v in z]
    X,Z,bridge=physical_source()
    specs=[dict(selected_opposite=[512,614],selected_own=[],absent_own=[186,433]),
           dict(selected_opposite=[512],selected_own=[],absent_own=[186,433])]
    domains=[source_domain(Z,X,dimension=128,**s) for s in specs]
    assert all(d['feasible'] for d in domains)
    proxies=[represent(Z,d) for d in domains]
    closures=[]
    for p in proxies:
        rows=high_basis(p['vectors'][j] for j in J)
        closures.append({j for j,v in enumerate(p['vectors']) if not remainder(v,rows)})
    common=sorted(set.intersection(*closures))
    frozen=dict(status='FROZEN_ONE_COLORED_PHYSICAL_PILOT', source_hashes=bindings,
                point=POINT,point_sha256=sha(POINT), allocations=ALLOC, side='Z',mask=2,probe_X=614,
                color_order=['selected_probe','original_domain'],domain_specs=specs,
                lambda_mass=str(lam),probe_raw_mass=str(a),color_masses=list(map(str,masses)),
                raw_Z_target=list(map(str,z)),normalized_target=list(map(str,target)),
                vectors_by_color_hex=[[hex(v) for v in p['vectors']] for p in proxies],
                proxy_ambient_bits=[p['ambient_bit_width'] for p in proxies],
                known_J=J,known_plain_star_gap='6268396875783/1125899906842624',
                proposed_common_closure=common,source_bridge=bridge,
                initialization='Cold target-weight greedy independently in each color; no warm start',
                solver_caps=dict(seconds=30,maximum_steps=1000000,maximum_bases=5000),
                external_seconds=60,priority=19,threads=1,
                scope='One local conditional allocation test only; no cross-pattern or source-frame conclusion.')
    write(PREFIX+'.frozen.json',frozen)
    print(json.dumps(dict(frozen_sha256=sha(PREFIX+'.frozen.json'),lambda_mass=str(lam),a=str(a),common_closure_size=len(common))),flush=True)

def worker():
    f=read(PREFIX+'.frozen.json')
    for p,h in f['source_hashes'].items(): assert sha(p)==h
    from exact_colored_matroid_push_relabel_draft import solve
    vectors=[[int(v,16) for v in row] for row in f['vectors_by_color_hex']]
    endpoint=solve(vectors,list(map(Q,f['color_masses'])),list(map(Q,f['normalized_target'])),**f['solver_caps'])
    write(PREFIX+'.json.gz',dict(status='COLORED_PHYSICAL_ENDPOINT_REQUIRES_REPLAY',
          frozen_sha256=sha(PREFIX+'.frozen.json'),endpoint=endpoint,priority=19))
    print(json.dumps({k:endpoint[k] for k in ('status','seconds','steps') if k in endpoint}),flush=True)

def supervise():
    prepare()
    started=time.monotonic()
    with (ROOT/(PREFIX+'.log')).open('x') as log:
        proc=subprocess.Popen([sys.executable,'-B',str(Path(__file__).resolve()),'worker'],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,env=os.environ.copy())
        timed_out=False
        try: code=proc.wait(timeout=60)
        except subprocess.TimeoutExpired:
            timed_out=True; proc.kill(); code=proc.wait()
    write(PREFIX+'.exit.json',dict(returncode=code,external_timeout=timed_out,seconds=time.monotonic()-started,priority=19,child_pid=proc.pid))
    assert code==0 and not timed_out

if __name__=='__main__':
    p=argparse.ArgumentParser(); p.add_argument('mode',choices=['prepare','worker','supervise']); args=p.parse_args()
    globals()[args.mode]()
