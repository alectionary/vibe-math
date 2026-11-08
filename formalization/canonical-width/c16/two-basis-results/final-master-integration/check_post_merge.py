#!/usr/bin/env python3
"""Focused integration checks only; preserve all scientific sources/artifacts."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
THREADS = ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
assert all(os.environ.get(k) == '1' for k in THREADS)
from pathlib import Path
from urllib.parse import urlsplit, unquote
import datetime, hashlib, json, re, subprocess, sys, time

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[4]
PRE = 'c04fffddc552a81735904dd9d0d9655621396f95'
MERGED = '85bdc843134579a842ebe97622747ac1a83c3d71'
MASTER = 'e89a439b057e9d5e76abc6af66f7b978471af3c6'
VALIDATORS = ('validate_literature.py','validate_open_problems.py',
              'validate_current_difficulty.py','validate_research_question_screening.py')

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def git(*args): return subprocess.check_output(['git','-C',str(ROOT),*args], text=True)
def write(name, content):
    p = OUT/name; assert not p.exists(), p
    p.write_text(content)
    return dict(path=str(p.relative_to(ROOT)), sha256=sha(p), bytes=p.stat().st_size)
def tree(commit):
    result = {}
    for entry in git('ls-tree','-rz',commit).split('\0'):
        if entry:
            info, name = entry.split('\t',1)
            result[name] = info
    return result

def main():
    start = time.monotonic(); assert git('rev-parse','HEAD').strip() == MERGED
    assert git('rev-list','--parents','-n','1',MERGED).split() == [MERGED,PRE,MASTER]
    old, new = tree(PRE), tree(MERGED)
    def selected(name):
        return (name.startswith(('formalization/canonical-width/','planning/','audit/'))
                or name == 'RESEARCH-LESSONS.md'
                or (name.startswith('literature/') and not name.startswith('literature/scheduled-'))
                or name in ('catalog.json','source-manifest.json','analysis.html','index.html','PUBLICATION-STATUS.md'))
    scope = sorted(n for n in set(old)|set(new) if selected(n))
    differences = [n for n in scope if old.get(n) != new.get(n)]
    categories = {
        'canonical_width_files': sum(n.startswith('formalization/canonical-width/') for n in scope),
        'C16_files': sum(n.startswith('formalization/canonical-width/c16/') for n in scope),
        'planning_files': sum(n.startswith('planning/') for n in scope),
        'audit_files': sum(n.startswith('audit/') for n in scope),
        'literature_non_scheduled_files': sum(n.startswith('literature/') for n in scope),
        'lessons_files': int('RESEARCH-LESSONS.md' in scope),
    }
    comparison = dict(status='PASS_BYTE_IDENTICAL_SCOPED_COMMIT_TREES' if not differences else 'FAIL',
                      premerge=PRE, merged=MERGED, checked_files=len(scope), category_counts=categories,
                      differences=differences, method='Exact equality of Git mode/type/blob IDs for every path in both scoped trees.',
                      exceptions='Scheduled replication records are incoming unrelated work; README/THIRD_PARTY additions are checked separately.',
                      entries=[dict(path=n, git_entry=new.get(n)) for n in scope])
    outputs = [write('scoped-tree-comparison.json',json.dumps(comparison,indent=2)+'\n')]
    assert not differences
    scope_status = git('status','--porcelain','--','planning','audit','literature','RESEARCH-LESSONS.md','catalog.json','source-manifest.json')
    outputs.append(write('canonical-working-tree-status.log',scope_status))
    assert not scope_status, scope_status
    runs=[]
    for name in VALIDATORS:
        source=ROOT/'scripts'/name
        assert git('rev-parse',PRE+':scripts/'+name).strip() == git('rev-parse',MERGED+':scripts/'+name).strip()
        t=time.monotonic()
        run=subprocess.run([sys.executable,'-B',str(source)],cwd=ROOT,env=os.environ.copy(),
                           capture_output=True,text=True,timeout=120)
        body='command: '+sys.executable+' -B scripts/'+name+'\nexit_code: '+str(run.returncode)+'\nstdout:\n'+run.stdout+'\nstderr:\n'+run.stderr
        log=write(name+'.log',body);outputs.append(log)
        runs.append(dict(script='scripts/'+name,source_sha256=sha(source),returncode=run.returncode,
                         seconds=time.monotonic()-t,log=log))
    added=[line[1:] for line in git('diff','--unified=0',PRE,MERGED,'--','README.md').splitlines()
           if line.startswith('+') and not line.startswith('+++')]
    links=[]
    for href in re.findall(r'\]\(([^)]+)\)','\n'.join(added)):
        url=urlsplit(href)
        if url.scheme or not url.path:
            continue
        local=unquote(url.path);p=ROOT/local
        exists=p.is_file() or p.is_dir()
        tracked=local in new or any(n.startswith(local.rstrip('/')+'/') for n in new)
        links.append(dict(href=href,path=local,exists=exists,exists_in_merge_tree=tracked,
                          sha256=sha(p) if p.is_file() else None))
    assert len(links)==2
    link_result=dict(status='PASS' if all(x['exists'] and x['exists_in_merge_tree'] for x in links) else 'FAIL',
                     scope='Only local links added to root README by this merge; no remote availability claim.',
                     README_sha256=sha(ROOT/'README.md'),links=links)
    outputs.append(write('new-readme-local-links.json',json.dumps(link_result,indent=2)+'\n'))
    passed=all(r['returncode']==0 for r in runs) and link_result['status']=='PASS'
    receipt=dict(status='PASS_FOCUSED_POST_MERGE_C16_CANONICAL_INTEGRATION' if passed else 'FAIL_FOCUSED_POST_MERGE_INTEGRATION',
                 premerge_commit=PRE,merge_commit=MERGED,incoming_master_commit=MASTER,
                 merged_tree=git('rev-parse',MERGED+'^{tree}').strip(),
                 exact_scoped_commit_file_count=len(scope),category_counts=categories,
                 canonical_working_tree_clean=True,validators=runs,readme_added_local_links_checked=len(links),
                 outputs=outputs,consumer_path=str(Path(__file__).relative_to(ROOT)),consumer_sha256=sha(__file__),
                 nice=19,thread_environment={k:os.environ[k] for k in THREADS},
                 python_executable=sys.executable,elapsed_seconds=time.monotonic()-start,
                 utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                 no_scientific_optimization=True,no_source_changes=True,
                 scope='These four named bookkeeping validators, byte-identical scoped commit trees, and two new root README local links only. No blanket historical-validator or scientific-correctness claim.')
    write('receipt.json',json.dumps(receipt,indent=2)+'\n')
    print(json.dumps(dict(status=receipt['status'],receipt=str((OUT/'receipt.json').relative_to(ROOT)),
                          sha256=sha(OUT/'receipt.json'),files=len(scope),validators=[(r['script'],r['returncode']) for r in runs],
                          new_readme_links=len(links),elapsed_seconds=receipt['elapsed_seconds'])))
    raise SystemExit(0 if passed else 1)

if __name__=='__main__':main()
