"""Rebuild local import closure against pinned Mathlib, or print its order.

With no module arguments, select only exact-source modules admitted in the
published manifest. This deliberately excludes deferred weight-ten chunks.
"""
from pathlib import Path
import argparse,json,re,subprocess,sys
R=Path(__file__).resolve().parent

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--plan',action='store_true')
    ap.add_argument('--mathlib');ap.add_argument('--lean-bin');ap.add_argument('--build-dir')
    ap.add_argument('--threads',type=int,default=2)
    ap.add_argument('--timeout',type=int,default=600)
    ap.add_argument('modules',nargs='*')
    a=ap.parse_args()
    paths={p.stem:p for root in [R.parent,R,R/'catalog-chunks'] for p in root.glob('*.lean')}
    manifest=json.loads((R/'verification.json').read_text())
    roots=a.modules or [n for n,s in manifest['modules'].items() if s['status']=='PASS']
    order=[];active=set();done=set()
    def visit(n):
        if n in done:return
        if n in active:raise ValueError('Local import cycle at '+n)
        if n not in paths:raise ValueError('Unknown local module '+n)
        active.add(n)
        for line in paths[n].read_text().splitlines():
            if not line.startswith('import '):continue
            for dep in line[7:].split():
                if dep in paths:visit(dep)
                elif not dep.startswith(('Mathlib','Lean','Std','Init')):
                    raise ValueError('Unresolved local import '+dep+' from '+n)
        active.remove(n);done.add(n);order.append(n)
    for n in roots:visit(n)
    if a.plan:
        print(json.dumps(dict(modules=len(order),order=order),indent=2));return 0
    for arg in ['mathlib','lean_bin','build_dir']:
        if not getattr(a,arg):ap.error('--'+arg.replace('_','-')+' is required for a build')
    cmd=[sys.executable,str(R/'build_round.py'),'--mathlib',a.mathlib,'--lean-bin',a.lean_bin,
         '--build-dir',a.build_dir,'--threads',str(a.threads),'--timeout',str(a.timeout)]+order
    return subprocess.run(cmd,check=False).returncode

if __name__=='__main__':raise SystemExit(main())
