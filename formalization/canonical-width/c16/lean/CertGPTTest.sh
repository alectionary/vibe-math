#!/usr/bin/env bash
# Requires Lean v4.36.0-rc1 lean/leanc on PATH and Python 3.
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export LEAN_PATH="$work:$here"
for m in CertGPTBits CertGPTKernel CertGPTCheck CertGPTData CertGPTTest; do
  lean -o "$work/$m.olean" -c "$work/$m.c" "$here/$m.lean" > "$work/$m.build.log" 2>&1 || { cat "$work/$m.build.log"; exit 1; }
done
leanc -O3 -o "$work/CertGPTTest" "$work/CertGPTBits.c" "$work/CertGPTKernel.c" "$work/CertGPTCheck.c" "$work/CertGPTData.c" "$work/CertGPTTest.c"
python3 - "$here" "$work" "${1:-$here/CertGPTResults.json}" <<'PY'
import importlib.util,json,subprocess,sys,time
from pathlib import Path
here,work,out=map(Path,sys.argv[1:]); spec=importlib.util.spec_from_file_location('gen',here/'CertGPTGen.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
certdir=here.parent/'restricted-frames-20261031/certificates'
runs=[]
out.write_text(json.dumps(dict(scope="Unsharded executable checks; NOT no_swap_frame",status="running",runs=runs),indent=2)+"\n")
def check(name,path,kind,expected):
    start=time.monotonic();p=subprocess.run([str(work/'CertGPTTest'),str(path),kind],capture_output=True,text=True)
    text=p.stdout+p.stderr
    actual='ACCEPT' if 'status := "ACCEPT"' in text else 'FRAME' if 'status := "FRAME"' in text else 'REJECT'
    kernel=('generic kernel accepted: true' in text)
    passed=actual==expected and (p.returncode==0 if expected in ('ACCEPT','FRAME') else p.returncode==1) and kernel==(expected=='ACCEPT')
    r=dict(test=name,expected=expected,result=actual,exit_code=p.returncode,seconds=time.monotonic()-start,generic_kernel_accepted=kernel,passed=passed,output=text)
    runs.append(r);out.write_text(json.dumps(dict(scope='Unsharded executable checks; NOT no_swap_frame',runs=runs),indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='output'}),flush=True)
    assert passed,text
for name,inst,kind,pools,expected in [
 ('test-quarter','test-quarter','quarter','real','ACCEPT'),
 ('test-bad-1','test-quarter','quarter','real','REJECT'),
 ('test-bad-2','test-quarter','quarter','real','REJECT'),
 ('test-bad-3','test-quarter','quarter','real','REJECT'),
 ('test-planted','test-planted','quarter','planted','FRAME'),
 ('swap','swap','swap','real','ACCEPT')]:
    path=work/(name+'.input');g.generate(certdir/(inst+'.inst'),certdir/(name+'.cert.gz'),path,pools);check(name,path,kind,expected)
a=(work/'test-quarter.input').read_text().split();p=3+int(a[0])+int(a[1])
for _ in range(int(a[2])):p+=1+2*int(a[p])
h=a[:p];t=list(map(int,a[p+1:]));cases={}
v=t.copy();v[3]-=1;cases['drop-child-count']=v
v=t.copy();v[1]=128;cases['entry-out-of-range']=v
v=t.copy();v[:4]=[0];cases['branch-to-rank']=v
v=t.copy();v[5]=int(a[2]);cases['item-out-of-range']=v
v=t.copy();v[0]=1;cases['branch-to-empty']=v
v=t.copy();del v[4:6];cases['drop-child-record']=v
i=0
while t[i]!=0:i+={1:3,2:4,3:2,4:2,5:2,6:1}[t[i]]
v=t.copy();v[i:i+1]=[1,0,0];cases['rank-to-empty']=v
for name,v in cases.items():
    path=work/(name+'.input');path.write_text(' '.join(h+[str(len(v))]+list(map(str,v))));check(name,path,'quarter','REJECT')
PY
