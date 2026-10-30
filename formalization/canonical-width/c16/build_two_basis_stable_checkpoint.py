"""Stable byte inventory for completed C16 science and current source accounting.

This is a checkpoint inventory, not a fresh theorem/solver replay. Historical
failed runs remain included and retain their own status. Mutable root files are
excluded explicitly. Run nice19 with single-thread environment.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse, hashlib, json, os, subprocess

C16=Path(__file__).resolve().parent
ROOT=C16.parents[2]
PREFIX='formalization/canonical-width/c16/'
BASE=C16/'two-basis-results/membership-checkpoint-complete-inventory.json'
OUT=C16/'two-basis-results/post-soplex-stable-checkpoint-inventory.json'
EXCLUDED={PREFIX+p for p in ['TWO-BASIS-EIGHT-HOURS.md','export_joint_general_exact_lp.py',
    'run_soplex_general_bounded.py','adapt_soplex_general_endpoint.py','verify_general_joint_primal.py']}
EXCLUDED_PREFIXES=[PREFIX+'two-basis-results/joint-general-pinned-refine1-point22']

def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        while data:=f.read(1024*1024):h.update(data)
    return h.hexdigest()

def git_paths(*args):
    return set(p for p in subprocess.check_output(['git',*args,'-z'],cwd=ROOT).decode().split('\0') if p)

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS'):os.environ[key]='1'
    ap=argparse.ArgumentParser();ap.add_argument('--supplement',action='append',default=[]);a=ap.parse_args()
    assert not OUT.exists()
    base=json.loads(BASE.read_text());old={r['path']:r['sha256'] for r in base['files']}
    changed=git_paths('diff','--name-only')|git_paths('diff','--cached','--name-only')|git_paths('ls-files','--others','--exclude-standard')
    delta={p for p in changed if p.startswith((PREFIX,'literature/','planning/')) or p=='scripts/integrate_owner_lift_literature.py'}
    candidates=set(old)|delta|{str(BASE.relative_to(ROOT))}
    supplements=[]
    for name in a.supplement:
        p=(C16/name).resolve();assert p.is_relative_to(ROOT) and p.is_file()
        candidates.add(str(p.relative_to(ROOT)));supplements.append(dict(path=str(p.relative_to(ROOT)),sha256=sha(p)))
    canonical=ROOT/'literature/owner-lift-20261030/inventory.json'
    ci=json.loads(canonical.read_text());candidates.update(ci['files']);candidates.add(str(canonical.relative_to(ROOT)))
    candidates.add('literature/owner-lift-20261030/validation.json')
    omitted=[];paths=[]
    for name in sorted(candidates):
        p=ROOT/name
        if name in EXCLUDED or any(name.startswith(prefix) for prefix in EXCLUDED_PREFIXES):
            omitted.append(dict(path=name,reason='Root-owned mutable or forthcoming report/general-LP file'));continue
        if name.startswith('local-extraction/') or p.suffix=='.pdf' or '__pycache__' in p.parts:
            omitted.append(dict(path=name,reason='Author-owned full text or generated local cache; intentionally outside portable checkpoint'));continue
        if p==OUT:continue
        assert p.is_file(),name
        paths.append(name)
    rows=[];prior_changes=[]
    for name in paths:
        p=ROOT/name;before=p.stat();h=sha(p);after=p.stat()
        assert (before.st_size,before.st_mtime_ns)==(after.st_size,after.st_mtime_ns),name
        rows.append(dict(path=name,sha256=h,bytes=after.st_size))
        if name in old and old[name]!=h:prior_changes.append(dict(path=name,prior_sha256=old[name],current_sha256=h))
    for row in rows:assert sha(ROOT/row['path'])==row['sha256'],row['path']
    for name,h in ci['files'].items():assert sha(ROOT/name)==h,name
    frozen_prior_science=[x for x in prior_changes if x['path'].startswith(PREFIX) and not x['path'].endswith(('.md','.html'))]
    assert not frozen_prior_science, frozen_prior_science
    report=dict(status='STABLE_COMPLETED_SCIENCE_AND_CANONICAL_CHECKPOINT',utc=datetime.now(timezone.utc).isoformat(),
        head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),priority=19,
        thread_environment={key:os.environ[key] for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS')},
        source_C16_answered=False,selected_source_cases_excluded=0,latest_exact_global_point=22,
        scope='Byte-preservation checkpoint of earlier accepted evidence plus completed new science, negative attempts, and canonical source accounting; individual receipts retain their mathematical scope. No fresh all-stage replay, LP solve, all-rank mixture claim, or source-frame claim.',
        source_records=141,source_unique_ids=140,canonical_entries=430,eligible_targets=161,paper_records=213,full_text_screens=170,complete_Lean_targets=6,
        base_inventory=str(BASE.relative_to(ROOT)),base_sha256=sha(BASE),supplementary_inventories=supplements,
        canonical_inventory=str(canonical.relative_to(ROOT)),canonical_inventory_sha256=sha(canonical),
        excluded_paths=omitted,excluded_future_paths=sorted(EXCLUDED),excluded_future_prefixes=EXCLUDED_PREFIXES,
        ignored_fulltext_policy='All local-extraction/ texts and external SoPlex executables/bottles are excluded; acquisition/executable hashes and portable endpoint records are included.',
        prior_inventory_changed_documents=prior_changes,unchanged_prior_non_document_hashes=True,
        files_checked_twice=len(rows),total_bytes=sum(r['bytes'] for r in rows),files=rows)
    OUT.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:report[k] for k in ['status','files_checked_twice','total_bytes','prior_inventory_changed_documents']},indent=2))
    print('inventory_sha256',sha(OUT))

if __name__=='__main__':main()
