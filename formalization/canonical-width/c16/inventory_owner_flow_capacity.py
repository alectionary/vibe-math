#!/usr/bin/env python3
"""Freeze the actual reachable flow/capacity/face proof files; no replay/solve."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_k)=='1'
from pathlib import Path
from collections import deque
import ast,gzip,hashlib,json,re,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
HEX=re.compile(r'^[0-9a-f]{64}$')

def main():
    start=time.monotonic();outpath=ROOT/'two-basis-results/owner-flow-capacity-zero-face-inventory.json';assert not outpath.exists()
    names=['two_basis_owner_star_extension.py','export_owner_star_flow_lp.py','verify_owner_star_flow_extension.py',
           'run_soplex_owner_flow_bounded.py','adapt_soplex_owner_flow_endpoint.py','verify_owner_flow_joint_literal.py',
           'two_basis_owner_star_capacity.py','export_owner_star_capacity_lp.py','verify_owner_star_capacity_extension.py',
           'export_owner_capacity_zero_face.py','verify_owner_capacity_zero_face.py','adapt_soplex_zero_face_endpoint.py',
           'verify_owner_capacity_joint_literal.py','owner_capacity_endpoint_controls.py','count_owner_flow_zero_face.py',
           'verify_capacity_joint_sector_handoff.py','extract_capacity_joint_exact_sectors.py',Path(__file__).name]
    prefixes=['joint-owner-flow-k22-pinned-point22','joint-owner-flow-capacity-k22-pinned-point22',
              'joint-owner-capacity-zero-face-point22','owner-flow-preparation-independent-v1',
              'owner-capacity-preparation-independent-v1','owner-capacity-endpoint-controls-v1',
              'owner-capacity-literal-endpoint-independent-v1','joint-capacity-sector-point22']
    for pref in prefixes:names += [str(p.relative_to(ROOT)) for p in (ROOT/'two-basis-results').glob(pref+'*') if p.is_file()]
    names += [str(p.relative_to(ROOT)) for p in (ROOT/'two-basis-results').glob('owner-star-extension*') if p.is_file()]
    names += ['two-basis-results/owner-capacity-endpoint-small-controls.json','two-basis-results/owner-flow-capacity-zero-face-count.json.gz']
    heads=sorted(set(names));queue=deque();seen={};external={};bindings=[];mismatches=[];missing=[];unresolved_code=[];modules=set()
    def resolve(raw):
        p=Path(raw);return (p if p.is_absolute() else ROOT/p).resolve()
    def add(raw,expected=None,origin=None,kind='reference'):
        p=resolve(raw)
        if not p.is_file():
            if expected:missing.append(dict(path=str(p),expected=expected,origin=origin))
            return
        key=str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p)
        if key not in seen and key not in external:queue.append(p)
        if expected:bindings.append(dict(path=key,sha256=expected,origin=origin,kind=kind))
    for p in heads:
        assert resolve(p).is_file(),p
        add(p)
    add(sys.executable,origin='running Python interpreter',kind='external_runtime')
    def walk(obj,origin):
        stack=[obj]
        while stack:
            d=stack.pop()
            if isinstance(d,list):stack.extend(x for x in d if isinstance(x,(dict,list)));continue
            if not isinstance(d,dict):continue
            for key,v in d.items():
                if key in ('source_hashes','source_bindings','dependencies','pool_sha256','runtime_files','files','file_hashes') and isinstance(v,dict):
                    for p,h in v.items():
                        if isinstance(p,str) and isinstance(h,str) and HEX.match(h):add(p,h,origin,key)
                if isinstance(v,str) and HEX.match(v) and (key.endswith('_sha256') or key=='sha256'):
                    label=key[:-7] if key.endswith('_sha256') else ''
                    choices=[d.get(label),d.get(label+'_path')]
                    if key=='sha256':choices += [d.get('path'),d.get('file')]
                    for p in choices:
                        if isinstance(p,str) and resolve(p).is_file():add(p,v,origin,key);break
                    else:
                        if key in ('consumer_sha256','producer_sha256','runner_sha256','source_sha256','physical_consumer_sha256','adapter_sha256','exporter_sha256'):
                            unresolved_code.append((v,origin,key))
                        if key=='frozen_sha256':
                            op=resolve(origin);stem=str(op).removesuffix('.gz').removesuffix('.json')
                            for p in (Path(stem+'.frozen.json'),Path(str(op).removesuffix('.gz')+'.frozen.json')):
                                if p.is_file() and hashlib.sha256(p.read_bytes()).hexdigest()==v:add(str(p),v,origin,key);break
                if isinstance(v,(dict,list)):stack.append(v)
    def drain():
        while queue:
            assert time.monotonic()-start<120,'inventory cap'
            p=queue.popleft();key=str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p)
            if key in seen or key in external:continue
            raw=p.read_bytes();info=dict(sha256=hashlib.sha256(raw).hexdigest(),bytes=len(raw))
            if not p.is_relative_to(ROOT):external[key]=info;continue
            seen[key]=info
            if p.suffix=='.py':
                try:tree=ast.parse(raw)
                except (SyntaxError,UnicodeDecodeError):continue
                for node in ast.walk(tree):
                    imports=[x.name for x in node.names] if isinstance(node,ast.Import) else [node.module] if isinstance(node,ast.ImportFrom) and node.module else []
                    for name in imports:
                        first=name.split('.')[0];local=ROOT/(first+'.py')
                        if local.is_file():add(str(local),origin=key,kind='local_python_import')
                        else:modules.add(first)
            if p.name.endswith('.json') or p.name.endswith('.json.gz'):
                try:data=json.loads(gzip.decompress(raw) if p.name.endswith('.gz') else raw)
                except (ValueError,OSError):continue
                walk(data,key)
    drain()
    # Resolve code-only digest fields against local source files, adding only exact matches.
    known={v['sha256'] for v in seen.values()}|{v['sha256'] for v in external.values()};wanted={h for h,o,k in unresolved_code if h not in known}
    if wanted:
        listed=subprocess.run(['rg','--files','-g','*.py','-g','*.cpp','-g','*.c','-g','*.h','-g','*.md'],cwd=ROOT,capture_output=True,text=True,check=True).stdout.splitlines()
        for name in listed:
            p=ROOT/name;h=hashlib.sha256(p.read_bytes()).hexdigest()
            if h in wanted:add(name,h,'code digest resolution');wanted.remove(h)
            if not wanted:break
        drain()
    for b in bindings:
        actual=(seen.get(b['path']) or external.get(b['path']))
        if not actual or actual['sha256']!=b['sha256']:mismatches.append(dict(**b,actual_sha256=actual['sha256'] if actual else None))
    all_hashes={v['sha256'] for v in seen.values()}|{v['sha256'] for v in external.values()}
    unresolved=[dict(sha256=h,origin=o,label=k) for h,o,k in unresolved_code if h not in all_hashes]
    result=dict(status='PASS_RECURSIVE_OWNER_FLOW_CAPACITY_SOURCE_DATA_INVENTORY' if not(missing or mismatches or unresolved) else 'RECURSIVE_INVENTORY_WITH_EXPLICIT_GAPS',
                head_files=heads,files=seen,external_runtime_or_absolute_inputs=external,
                file_count=len(seen),local_bytes=sum(v['bytes'] for v in seen.values()),external_files=len(external),
                explicit_file_hash_bindings_checked=len(bindings),binding_mismatches=mismatches,missing_bound_files=missing,unresolved_code_digests=unresolved,
                external_python_import_names=sorted(modules),local_imports_followed_statically=True,
                excluded_other_owned_or_future_prefixes=['joint-capacity-rank','joint-capacity-separation','fixed-owner'],
                accepted_endpoint='two-basis-results/joint-owner-capacity-zero-face-point22-exact.json',
                accepted_endpoint_receipt='two-basis-results/joint-owner-capacity-zero-face-point22-exact-independent.json',
                preserved_first_capped_trial='two-basis-results/joint-owner-flow-k22-pinned-point22-solve.json',
                preserved_preflight_collision='two-basis-results/owner-capacity-literal-endpoint-independent-v1.preflight-collision.json',
                source_C16_answered=False,all_subset_rank_membership_proved=False,clean_replay_performed=False,
                scope='Immutable actual-file/hash closure for accepted flow/capacity/zero-face controls and endpoint, including capped trial and exact sector handoff. External binaries/absolute inputs are listed separately; this is an inventory, not a new scientific replay.',
                priority=19,elapsed_seconds=time.monotonic()-start)
    outpath.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','file_count','local_bytes','external_files','explicit_file_hash_bindings_checked','elapsed_seconds')} | dict(mismatches=len(mismatches),missing=len(missing),unresolved_code=len(unresolved)),flush=True)
    print('inventory_sha256',hashlib.sha256(outpath.read_bytes()).hexdigest())
if __name__=='__main__':main()
