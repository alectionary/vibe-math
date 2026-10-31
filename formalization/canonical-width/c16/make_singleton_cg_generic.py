#!/usr/bin/env python3
"""Create versioned generic adapters; never modify accepted orbit40 sources."""
from pathlib import Path
import difflib,hashlib,json,os
ROOT=Path(__file__).resolve().parent

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    records=[];diffs=[]
    def build(old,new,changes):
        p,q=ROOT/old,ROOT/new;assert not q.exists();original=p.read_text();text=original
        for before,after,count in changes:
            assert text.count(before)==count,(old,before,text.count(before),count)
            text=text.replace(before,after)
        compile(text,new,'exec');q.write_text(text)
        assert p.read_text()==original
        records.append(dict(original=old,original_sha256=hashlib.sha256(original.encode()).hexdigest(),generic=new,generic_sha256=hashlib.sha256(text.encode()).hexdigest()))
        diffs.extend(difflib.unified_diff(original.splitlines(True),text.splitlines(True),fromfile=old,tofile=new))
    build('singleton_exact_column_gate.py','singleton_exact_column_gate_generic.py',[
        ("assert s['anchor_orbit']==40 and s['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'", "orbit=s['anchor_orbit'];assert type(orbit)is int and 0<=orbit<45 and s['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'",1),
        ("point_data(s['point'],40);p=owner[40]", "point_data(s['point'],orbit);p=owner[orbit]",1),
        ("B=[list(b) for b in s['physical_bases']];initial_count=len(B);assert initial_count==3067", "assert E==[j for j in range(720) if (X[16*orbit]&Z[j]).bit_count()%2==0]\n    assert list(map(Q,s['conditional_target']))==q and Q(s['conditional_probability'])==p\n    B=[list(b) for b in s['physical_bases']];initial_count=len(B)\n    assert 1<=initial_count<=5000 and initial_count==s['variable_count']==m['variable_count']\n    assert s['equality_count']==1+len(E) and m['row_count']==initial_count+s['equality_count']",1),
        ("anchor_orbit=40", "anchor_orbit=orbit",3),
        ("run_singleton_archive_cg_soplex.py", "run_singleton_archive_cg_soplex_generic.py",2),
    ])
    build('run_singleton_archive_cg_soplex.py','run_singleton_archive_cg_soplex_generic.py',[
        ('import argparse,hashlib,json,re,signal,subprocess,time','import argparse,gzip,hashlib,json,re,signal,subprocess,time',1),
        ("def read(p):return json.loads(Path(p).read_text())", "def read(p):\n    p=Path(p);raw=p.read_bytes();return json.loads(gzip.decompress(raw) if p.suffix=='.gz' else raw)",1),
        ("assert 3067<=m['variable_count']<=5000 and m['row_count']==m['variable_count']+625", "semantic=read(m['semantic']);n=m['variable_count'];E=semantic['physical_zero_ground_indices']\n    assert type(semantic['anchor_orbit'])is int and 0<=semantic['anchor_orbit']<45\n    assert 1<=n<=5000 and n==semantic['variable_count']==len(semantic['physical_bases'])\n    assert semantic['equality_count']==1+len(E) and m['row_count']==n+semantic['equality_count']",1),
        ("semantic_sha256=m['semantic_sha256'],prep_receipt", "semantic_sha256=m['semantic_sha256'],anchor_orbit=semantic['anchor_orbit'],physical_ground_count=len(E),variable_count=n,prep_receipt",1),
    ])
    build('run_singleton_exact_column_gate.py','run_singleton_exact_column_gate_generic.py',[
        ('single authorized orbit40 gate','single explicitly supplied singleton gate',1),
        ('import hashlib,json,subprocess,sys,time','import argparse,hashlib,json,subprocess,sys,time',1),
        ("PREFIX=ROOT/'two-basis-results/singleton-cg-point22-o40'\n",'',1),
        ("def main():\n    log=Path(str(PREFIX)+'.supervisor.log');out=Path(str(PREFIX)+'.supervisor.json');assert not log.exists() and not out.exists()", "def main():\n    ap=argparse.ArgumentParser();ap.add_argument('--initial-manifest',type=Path,required=True);ap.add_argument('--initial-receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args()\n    prefix=a.prefix.resolve();assert prefix.is_relative_to(ROOT)\n    log=Path(str(prefix)+'.supervisor.log');out=Path(str(prefix)+'.supervisor.json');assert not log.exists() and not out.exists()",1),
        ("command=[sys.executable,'-B','singleton_exact_column_gate.py','--initial-manifest','two-basis-results/singleton-archive-point22-o40.json',\n             '--initial-receipt','two-basis-results/singleton-archive-point22-o40-independent.json','--prefix',str(PREFIX.relative_to(ROOT))]", "command=[sys.executable,'-B','singleton_exact_column_gate_generic.py','--initial-manifest',str(a.initial_manifest),\n             '--initial-receipt',str(a.initial_receipt),'--prefix',str(prefix.relative_to(ROOT))]",1),
    ])
    output=ROOT/'two-basis-results/singleton-cg-generic-adapter.diff';assert not output.exists();output.write_text(''.join(diffs))
    manifest=ROOT/'two-basis-results/singleton-cg-generic-adapter.json';assert not manifest.exists()
    manifest.write_text(json.dumps(dict(status='GENERIC_SINGLETON_CG_ADAPTER_REQUIRES_INDEPENDENT_REVIEW',files=records,
         diff=str(output.relative_to(ROOT)),diff_sha256=hashlib.sha256(output.read_bytes()).hexdigest(),
         changes='Replace fixed orbit/count/ground-size assumptions with independently validated semantic values and explicit supervisor inputs; optimization/pricing/coverage algorithms unchanged.',
         point22_scope_retained=True,maximum_rounds=20,total_seconds=600,physical_query_launched=False),indent=2)+'\n')
    print(json.dumps(dict(manifest=str(manifest.relative_to(ROOT)),files=records)),flush=True)

if __name__=='__main__':main()
