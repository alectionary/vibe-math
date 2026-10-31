#!/usr/bin/env python3
"""UNRUN: explicit recorded-prefix relocation for unchanged frozen consumers.

Only one-argument JSON read and SHA256 helpers are adapted. The mathematical
consumer, its imports, all input bytes, and all expected hashes remain intact.
An audit guard rejects research reads outside the declared copy. No solver runs.
"""
from pathlib import Path
import argparse,gzip,hashlib,importlib,inspect,json,os,sys,tempfile,time,types

THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
         'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)

class Paths:
    def __init__(self,current,recorded,output):
        self.current=current.resolve();self.recorded=recorded.resolve();self.output=output.resolve()
        assert self.current!=self.recorded and not self.current.is_relative_to(self.recorded)
        assert not self.output.is_relative_to(self.recorded)
        assert not self.output.is_relative_to(self.current)
        self.rewrites=set();self.reads=set();self.denied=[]
        self.runtime={Path(sys.prefix).resolve(),Path(sys.base_prefix).resolve(),Path(sys.exec_prefix).resolve()}
        # Python's framework prefix can differ from its venv and executable.
        self.runtime.add(Path(os.__file__).resolve().parent)
        # Explicit read-only OS metadata/device exceptions; no broad /tmp,
        # home-directory, /etc or suffix-based allowance is permitted.
        self.os_files={Path(p).resolve() for p in ('/dev/null','/dev/urandom','/dev/random',
            '/etc/localtime','/System/Library/CoreServices/SystemVersion.plist')}
        self.runtime_reads=set();self.os_reads=set()
    def resolve(self,value):
        p=Path(value)
        assert '..' not in p.parts
        if p.is_absolute():
            if p.is_relative_to(self.recorded):
                rel=p.relative_to(self.recorded);self.rewrites.add((str(p),str(rel)));p=self.current/rel
            else:assert p.is_relative_to(self.current) or p.is_relative_to(self.output),('undeclared absolute research path',str(p))
        else:p=self.current/p
        p=p.resolve()
        assert p.is_relative_to(self.current) or p.is_relative_to(self.output)
        return p
    def audit(self,event,args):
        if event!='open' or not args or not isinstance(args[0],(str,bytes,os.PathLike)):return
        p=Path(os.fsdecode(args[0])).resolve()
        mode=args[1] if len(args)>1 else None;flags=args[2] if len(args)>2 else 0
        writing=(isinstance(mode,str) and any(c in mode for c in 'wa+')) or (isinstance(flags,int) and bool(flags&(os.O_WRONLY|os.O_RDWR|os.O_CREAT|os.O_TRUNC|os.O_APPEND)))
        if p.is_relative_to(self.current):
            if writing:raise PermissionError('copied scientific input is read-only: '+str(p))
            self.reads.add(str(p.relative_to(self.current)));return
        if p.is_relative_to(self.output):return
        if not p.is_relative_to(self.recorded) and not writing:
            if any(p.is_relative_to(r) for r in self.runtime):self.runtime_reads.add(str(p));return
            if p in self.os_files:self.os_reads.add(str(p));return
        self.denied.append(str(p));raise PermissionError('undeclared outside-copy file access: '+str(p))

def main():
    guard();start=time.monotonic();ap=argparse.ArgumentParser()
    for name in ('copy-c16','recorded-c16','output-dir','consumer','portability-output'):ap.add_argument('--'+name,required=True)
    ap.add_argument('arguments',nargs=argparse.REMAINDER);a=ap.parse_args()
    copy,recorded,output=map(Path,(a.copy_c16,a.recorded_c16,a.output_dir))
    assert Path(__file__).resolve().parent==copy.resolve()
    assert a.consumer.endswith('.py') and '/' not in a.consumer and (copy/a.consumer).is_file()
    args=a.arguments[1:] if a.arguments[:1]==['--'] else a.arguments
    paths=Paths(copy,recorded,output);os.chdir(copy)
    # Any library temporary file must also remain in the declared output tree.
    tempfile.tempdir=str(output.resolve());os.environ['TMPDIR']=str(output.resolve())
    sys.path=[str(copy),*[p for p in sys.path if p and not Path(p).resolve().is_relative_to(recorded.resolve()) and Path(p).resolve()!=copy.resolve()]]
    sys.addaudithook(paths.audit)
    controls=[]
    assert paths.resolve(recorded/'physical-pool-source.json')==copy.resolve()/'physical-pool-source.json'
    for label,value in [('foreign_absolute','/private/tmp/undeclared-science/source.json'),('parent_traversal','../source.json')]:
        try:paths.resolve(value)
        except AssertionError:controls.append(label)
        else:raise AssertionError(('accepted path control',label))
    # Verify that an original-file read is rejected before any bytes are read.
    try:(recorded/'physical-pool-source.json').read_bytes()
    except PermissionError:controls.append('original_root_read_denied')
    else:raise AssertionError('original source was readable')
    for label,path in [('original_arbitrary_suffix_read_denied',recorded/'undeclared.control-opaque'),
                       ('foreign_arbitrary_suffix_read_denied',Path('/private/tmp/undeclared-science/control-opaque'))]:
        try:path.read_bytes()
        except PermissionError:controls.append(label)
        else:raise AssertionError(('undeclared arbitrary-suffix path readable',str(path)))
    control_rewrites=sorted(paths.rewrites);paths.rewrites.clear()
    expected_denied=len(paths.denied)
    module=importlib.import_module(a.consumer[:-3]);adapters=[]
    for name,m in sorted(list(sys.modules.items())):
        filename=getattr(m,'__file__',None)
        if not filename:continue
        p=Path(filename).resolve()
        if not p.is_relative_to(copy.resolve()) or p.suffix!='.py':continue
        for attr in ('sha','read'):
            old=getattr(m,attr,None)
            if not isinstance(old,types.FunctionType):continue
            signature=inspect.signature(old)
            assert len(signature.parameters)==1,(name,attr,str(signature))
            source=inspect.getsource(old)
            adapters.append(dict(module=name,attribute=attr,original_function_module=old.__module__,
                                 original_function_source_sha256=hashlib.sha256(source.encode()).hexdigest()))
            # Preserve every original parsing, normalization and validation
            # operation. Only the one path argument is explicitly relocated.
            def wrap(original):
                def adapted(value):return original(paths.resolve(value))
                return adapted
            setattr(m,attr,wrap(old))
    assert adapters and callable(module.main)
    sys.argv=[str(copy/a.consumer),*args]
    module.main()
    assert len(paths.denied)==expected_denied,'consumer attempted an undeclared research read'
    out=Path(a.portability_output);assert out.resolve().is_relative_to(output.resolve()) and not out.exists()
    result=dict(status='PASS_EXPLICIT_RELOCATED_FROZEN_CONSUMER',consumer=a.consumer,
                consumer_sha256=hashlib.sha256((copy/a.consumer).read_bytes()).hexdigest(),
                wrapper_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                current_root=str(copy.resolve()),recorded_root=str(recorded.resolve()),
                explicit_path_rewrites=[dict(recorded=p,relative=q) for p,q in sorted(paths.rewrites)],
                control_path_rewrites=[dict(recorded=p,relative=q) for p,q in control_rewrites],
                adapted_helpers=adapters,copy_files_opened=sorted(paths.reads),path_controls=controls,
                outside_copy_open_policy='default deny; read-only declared Python runtime and exact OS allowlist; temporary files only in output',
                runtime_read_prefixes=sorted(map(str,paths.runtime)),runtime_files_opened=sorted(paths.runtime_reads),
                os_read_allowlist=sorted(map(str,paths.os_files)),os_files_opened=sorted(paths.os_reads),
                adapter_semantics='original_one_argument_function(resolve_recorded_path(value)); original body retained',
                original_research_reads=0,input_json_mutated=False,scientific_source_mutated=False,
                solver_executed=False,priority=19,elapsed_seconds=time.monotonic()-start)
    out.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','consumer','original_research_reads','elapsed_seconds')}),flush=True)
if __name__=='__main__':main()
