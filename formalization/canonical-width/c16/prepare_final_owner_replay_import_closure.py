#!/usr/bin/env python3
"""Freeze explicit inventory input bindings and all static local consumer imports."""
from pathlib import Path
import ast,hashlib,json,os
ROOT=Path(__file__).resolve().parent
INVENTORIES=['two-basis-results/owner-flow-capacity-zero-face-inventory.json',
 'two-basis-results/joint-capacity-rank-closure-supplement.json',
 'two-basis-results/fixed-owner-residual-capacity-point22-Z-m02-X614-v1-inventory.json',
 'two-basis-results/singleton-global-point22-o40-complete-inventory.json']
ROOTS=['verify_owner_star_flow_extension.py','verify_owner_star_capacity_extension.py',
 'verify_owner_capacity_zero_face.py','verify_owner_capacity_joint_literal.py',
 'verify_capacity_joint_sector_handoff.py','verify_two_basis_rank_closed_allocation.py',
 'two_basis_structure_verify_physical_push_closed.py','verify_fixed_owner_residual_tiny.py',
 'verify_fixed_owner_residual_physical.py','verify_fixed_owner_existing_subset_screen.py',
 'verify_singleton_exchange_terminal.py']
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'))
    inherited={};bound={};external={};binding_count=0
    def add(table,p,h):
        p=Path(p)
        if p.is_absolute():
            if not p.is_relative_to(ROOT):
                assert p.suffix not in ('.py','.json','.gz','.npz','.txt','.md','.lp'),('external scientific input',str(p))
                assert sha(p)==h;external[str(p)]=h;return
            p=p.relative_to(ROOT)
        assert '..' not in p.parts and (ROOT/p).is_file() and not (ROOT/p).is_symlink()
        name=p.as_posix();assert name not in table or table[name]==h
        assert sha(ROOT/name)==h;table[name]=h
    for f in INVENTORIES:
        d=json.loads((ROOT/f).read_text())
        for key in ('files','additional_files'):
            rows=d.get(key,{})
            if isinstance(rows,dict):rows=[dict(v,path=k) for k,v in rows.items()]
            for row in rows:add(inherited,row['path'],row['sha256'])
        for p,h in d.get('input_bindings',{}).items():
            add(bound,p,h);binding_count+=1
    seen=set();todo=ROOTS[:];edges=[]
    while todo:
        f=todo.pop()
        if f in seen:continue
        seen.add(f)
        for node in ast.walk(ast.parse((ROOT/f).read_text())):
            mods=[x.name for x in node.names] if isinstance(node,ast.Import) else [node.module] if isinstance(node,ast.ImportFrom) and node.module else []
            for mod in mods:
                local=mod.replace('.','/')+'.py'
                if (ROOT/local).is_file():edges.append([f,local]);todo.append(local)
    for f in seen:add(bound,f,sha(ROOT/f))
    for f in [Path(__file__).name,'two-basis-results/final-owner-checkpoint-static-import-review.json']:
        add(bound,f,sha(ROOT/f))
    conflicts=[p for p,h in bound.items() if p in inherited and inherited[p]!=h];assert not conflicts
    missing=sorted(seen-(inherited.keys()|bound.keys()));assert not missing
    extra={p:dict(sha256=h,bytes=(ROOT/p).stat().st_size) for p,h in bound.items()}
    out=dict(status='PASS_EXPLICIT_INPUT_BINDINGS_AND_STATIC_IMPORT_CLOSURE',
        inherited_inventory_hashes={f:sha(ROOT/f) for f in INVENTORIES},files=extra,
        input_binding_records_checked=binding_count,normalized_local_input_bindings=len(bound),
        newly_declared_files=sorted(set(bound)-set(inherited)),static_local_modules=sorted(seen),
        static_consumer_roots=ROOTS,static_import_edges=edges,missing_local_imports=missing,
        external_runtime_bindings=external,producer_sha256=sha(__file__),priority=19,
        scope='All explicit top-level input_bindings plus the complete static local import graph of the34-stage consumers. Dynamic reads remain subject to fail-closed default-deny audit; no consumer imported or executed.')
    p=ROOT/'two-basis-results/final-owner-checkpoint-import-closure.json';assert not p.exists()
    p.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
    print(json.dumps(dict(status=out['status'],file_count=len(extra),newly_declared=out['newly_declared_files'],local_modules=len(seen),sha256=sha(p))))
if __name__=='__main__':main()
