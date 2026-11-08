"""Run an unchanged consumer from a declared copy with explicit path relocation.

Only path arguments are adapted; original helper bodies and artifact bytes are
preserved. Research reads outside the copy and input writes are denied.
"""
from pathlib import Path
import argparse,hashlib,importlib,inspect,json,os,subprocess,sys,tempfile,time,types

THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19 and all(os.environ.get(k)=='1' for k in THREADS)
    ap=argparse.ArgumentParser()
    for key in ['copy-root','recorded-root','consumer','portability-output']:ap.add_argument('--'+key,required=True)
    ap.add_argument('arguments',nargs=argparse.REMAINDER);a=ap.parse_args();start=time.monotonic()
    current=Path(a.copy_root).resolve();recorded=Path(a.recorded_root).resolve();output=current/'_replay_outputs'
    assert Path(__file__).resolve().parent==current and current!=recorded and output.is_dir()
    roots=(recorded,Path('/private/tmp/c16-two-basis-20261030T1438/formalization/canonical-width/c16'),Path('/private/tmp/c16-coupling-20261030T0514/formalization/canonical-width/c16'))
    runtime={Path(sys.prefix).resolve(),Path(sys.base_prefix).resolve(),Path(sys.exec_prefix).resolve(),Path(os.__file__).resolve().parent}
    allowed={Path(p).resolve() for p in ['/dev/null','/dev/urandom','/dev/random','/etc/localtime','/System/Library/CoreServices/SystemVersion.plist']}
    reads=set();denied=[];rewrites=set();adapters=[]
    def relocated(value):
        p=Path(value);assert '..' not in p.parts
        if p.is_absolute():
            for root in roots:
                if p.is_relative_to(root):
                    rel=p.relative_to(root);rewrites.add((str(p),str(rel)));p=current/rel;break
        else:p=current/p
        p=p.resolve();assert p.is_relative_to(current),('Foreign research path',str(p))
        return p
    def audit(event,args):
        if event in ['subprocess.Popen','os.system','os.exec','os.posix_spawn','os.posix_spawnp','os.spawn','os.fork','os.forkpty']:
            denied.append('process:'+event);raise PermissionError('No process creation during proof replay')
        mutation_counts={'os.remove':1,'os.unlink':1,'os.rmdir':1,'os.mkdir':1,'os.rename':2,'os.replace':2,
            'os.chmod':1,'os.chown':1,'os.utime':1,'os.truncate':1,'os.symlink':2,'os.link':2,
            'os.setxattr':1,'os.removexattr':1,'os.chflags':1}
        if event in mutation_counts:
            descriptor_positions={'os.remove':(1,),'os.unlink':(1,),'os.rmdir':(1,),'os.mkdir':(2,),
                'os.rename':(2,3),'os.replace':(2,3),'os.chmod':(2,),'os.chown':(3,),'os.utime':(3,),
                'os.symlink':(2,),'os.link':(2,3)}
            for i in descriptor_positions.get(event,()):
                if len(args)>i and args[i] not in (None,-1):
                    denied.append('directory-descriptor:'+event);raise PermissionError('No directory-descriptor mutations')
            for raw in args[:mutation_counts[event]]:
                if not isinstance(raw,(str,bytes,os.PathLike)):
                    denied.append('mutation:'+event);raise PermissionError('Undeclared descriptor mutation')
                p=Path(os.fsdecode(raw)).resolve()
                if not p.is_relative_to(output):
                    denied.append(str(p));raise PermissionError('Mutation outside replay output: '+str(p))
            return
        if event!='open' or not args or not isinstance(args[0],(str,bytes,os.PathLike)):return
        p=Path(os.fsdecode(args[0])).resolve();mode=args[1] if len(args)>1 else None;flags=args[2] if len(args)>2 else 0
        writing=(isinstance(mode,str) and any(c in mode for c in 'wa+')) or (isinstance(flags,int) and bool(flags&(os.O_WRONLY|os.O_RDWR|os.O_CREAT|os.O_TRUNC|os.O_APPEND)))
        if p.is_relative_to(output):return
        if p.is_relative_to(current):
            if writing:raise PermissionError('Read-only copied input: '+str(p))
            reads.add(str(p.relative_to(current)));return
        if not writing and not any(p.is_relative_to(r) for r in roots) and (p in allowed or any(p.is_relative_to(r) for r in runtime)):return
        denied.append(str(p));raise PermissionError('Outside-copy research access: '+str(p))
    os.chdir(current);tempfile.tempdir=str(output);os.environ['TMPDIR']=str(output)
    sys.path=[str(current),*[p for p in sys.path if p and not any(Path(p).resolve().is_relative_to(r) for r in roots) and Path(p).resolve()!=current]]
    sys.addaudithook(audit);controls=[]
    for label,p in [('original_input_denied',recorded/'physical-pool-source.json'),('foreign_path_denied',Path('/private/tmp/undeclared-shared-master/input'))]:
        try:p.read_bytes()
        except PermissionError:controls.append(label)
        else:raise AssertionError(label)
    for label,p in [('traversal_denied','../input'),('foreign_absolute_denied','/private/tmp/undeclared-shared-master/input')]:
        try:relocated(p)
        except AssertionError:controls.append(label)
        else:raise AssertionError(label)
    try:os.chmod(current/'physical-pool-source.json',0o600)
    except PermissionError:controls.append('copied_input_chmod_denied')
    else:raise AssertionError('Input metadata mutation allowed')
    try:subprocess.Popen(['/usr/bin/true'])
    except PermissionError:controls.append('process_creation_denied')
    else:raise AssertionError('Process creation allowed during replay')
    expected_denied=len(denied)
    assert a.consumer.endswith('.py') and '/' not in a.consumer
    module=importlib.import_module(a.consumer[:-3])
    for name,m in sorted(list(sys.modules.items())):
        filename=getattr(m,'__file__',None)
        if not filename:continue
        p=Path(filename).resolve()
        if not p.is_relative_to(current) or p.suffix!='.py':continue
        for attr in ['resolve','sha','read','read_named_rational']:
            original=getattr(m,attr,None)
            if not isinstance(original,types.FunctionType):continue
            signature=inspect.signature(original)
            if attr=='read_named_rational':assert list(signature.parameters)==['path','names','kind']
            else:assert len(signature.parameters)==1,(name,attr,str(signature))
            adapters.append(dict(module=name,attribute=attr,original_source_sha256=hashlib.sha256(inspect.getsource(original).encode()).hexdigest()))
            def wrap(body):
                def adapted(value,*rest,**kw):return body(relocated(value),*rest,**kw)
                return adapted
            setattr(m,attr,wrap(original))
    arguments=a.arguments[1:] if a.arguments[:1]==['--'] else a.arguments
    sys.argv=[str(current/a.consumer),*arguments];module.main()
    assert len(denied)==expected_denied
    result=dict(status='PASS_EXPLICIT_SHARED_MASTER_CLEAN_REPLAY',consumer=a.consumer,
        consumer_sha256=hashlib.sha256((current/a.consumer).read_bytes()).hexdigest(),worker_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        current_root=str(current),recorded_root=str(recorded),recorded_prefixes=list(map(str,roots)),original_research_reads=0,
        path_controls=controls,explicit_path_rewrites=[dict(recorded=p,relative=r) for p,r in sorted(rewrites)],adapted_helpers=adapters,
        copied_files_opened=sorted(reads),scientific_input_bytes_mutated=False,solver_executed=False,
        adapter_semantics='original_body(relocated(first_path_argument), *unchanged_remaining_arguments, **unchanged_keywords)',
        priority=19,threads=1,elapsed_seconds=time.monotonic()-start)
    out=Path(a.portability_output).resolve();assert out.is_relative_to(output) and not out.exists()
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['status','consumer','original_research_reads','elapsed_seconds']}))

if __name__=='__main__':main()
