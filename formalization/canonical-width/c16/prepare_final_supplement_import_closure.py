#!/usr/bin/env python3
"""Read/hash/AST-only closure preflight; never imports scientific modules."""
from pathlib import Path
import argparse,ast,gzip,hashlib,json,os,time

ROOT=Path(__file__).resolve().parent
PLAN='two-basis-results/final-supplement-checkpoint-replay-plan.json'
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
    ap=argparse.ArgumentParser();ap.add_argument('--output',required=True);a=ap.parse_args()
    output=ROOT/a.output;assert not output.exists();start=time.monotonic()
    p=read(ROOT/PLAN);files={};origins={};external={}
    def add(name,h,origin):
        path=Path(name)
        if path.is_absolute():
            if not path.is_relative_to(ROOT):
                assert external.get(name)==h,('external research binding',name,origin)
                assert sha(path)==h
                return
            path=path.relative_to(ROOT)
        assert '..' not in path.parts and not path.is_absolute()
        name=path.as_posix();assert name not in files or files[name]==h,('conflicting frozen binding',name)
        files[name]=h;origins.setdefault(name,set()).add(origin)
    inventories=[n for n in p['inventory_files'] if n!=a.output]
    for name in inventories:
        d=read(ROOT/name);add(name,sha(ROOT/name),'accepted inventory')
        for f,h in d.get('external_runtime_bindings',{}).items():
            assert f not in external or external[f]==h
            external[f]=h
        for key in ('files','additional_files'):
            rows=d.get(key,{})
            if isinstance(rows,dict):rows=[dict(v,path=k) for k,v in rows.items()]
            for r in rows:add(r['path'],r['sha256'],name+':'+key)
        for key in ('input_bindings','repository_input_bindings'):
            for f,h in d.get(key,{}).items():add(f,h,name+':'+key)
    seed_count=len(files);todo=[s['consumer'] for s in p['stages']];seen=set();edges=[];helpers=[]
    while todo:
        name=todo.pop()
        if name in seen:continue
        seen.add(name);source=(ROOT/name).read_text();tree=ast.parse(source,filename=name)
        add(name,sha(ROOT/name),'static local import closure')
        for node in ast.walk(tree):
            mods=[x.name for x in node.names] if isinstance(node,ast.Import) else [node.module] if isinstance(node,ast.ImportFrom) and node.module else []
            for mod in mods:
                local=mod.replace('.','/')+'.py'
                if (ROOT/local).is_file():edges.append([name,local]);todo.append(local)
            if isinstance(node,(ast.FunctionDef,ast.AsyncFunctionDef)) and node.name in ('read','sha','read_named_rational'):
                args=[x.arg for x in node.args.posonlyargs+node.args.args]
                if node.name=='read_named_rational':
                    assert args==['path','names','kind'] and len(node.args.defaults)==1 and ast.literal_eval(node.args.defaults[0])=='primal',(name,args)
                else:assert len(args)==1,(name,node.name,args)
                helpers.append(dict(module=name,attribute=node.name,arguments=args,original_function_source_sha256=hashlib.sha256(ast.get_source_segment(source,node).encode()).hexdigest()))
    for name in (p['driver'],p['worker'],Path(__file__).name):ast.parse((ROOT/name).read_text(),filename=name)
    stage_paths=[]
    for stage in p['stages']:
        args=stage['arguments'];assert len(args)%2==0
        for flag,value in zip(args[::2],args[1::2]):
            assert flag.startswith('--');path=Path(value)
            if path.is_absolute():assert path.is_relative_to(ROOT);path=path.relative_to(ROOT)
            name=path.as_posix();assert name in files,('undeclared stage input',stage['name'],flag,name)
            stage_paths.append(dict(stage=stage['name'],flag=flag,recorded_argument=value,relative=name))
    checked=[]
    for name,h in sorted(files.items()):
        path=ROOT/name;assert path.is_file() and not path.is_symlink(),name
        assert sha(path)==h,('changed frozen bytes',name,origins[name])
        checked.append(dict(path=name,sha256=h,bytes=path.stat().st_size))
    result=dict(status='PASS_NO_IMPORT_SUPPLEMENTAL_CLOSURE_PREFLIGHT',producer_sha256=sha(__file__),plan_sha256=sha(ROOT/PLAN),
        inventory_hashes={n:sha(ROOT/n) for n in inventories},stages=len(p['stages']),accepted_inventory_files=seed_count,
        union_files=len(files),union_bytes=sum(r['bytes'] for r in checked),static_local_modules=sorted(seen),static_import_edges=sorted(edges),
        input_bindings={n:files[n] for n in sorted(seen)},helper_signatures=helpers,stage_input_paths=stage_paths,
        external_runtime_bindings=external,science_imported=False,solver_executed=False,priority=19,seconds=time.monotonic()-start,
        scope='All accepted inventory bytes and stage arguments checked; all static local imports explicitly bound. Runtime audit remains fail-closed for undeclared lazy/dynamic imports. Superseded nested inventory metadata retained as bytes, not reinterpreted as current binding requirements.')
    output.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','stages','accepted_inventory_files','union_files','union_bytes','seconds')}))
if __name__=='__main__':main()
