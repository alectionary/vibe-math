"""Add root-approved final documents to a versioned, unchanged-science checkpoint.

Writes a NUL pathspec file outside the checkout; never stages or commits files.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,os,subprocess

C16=Path(__file__).resolve().parent;ROOT=C16.parents[2]
BASE=C16/'two-basis-results/post-soplex-stable-checkpoint-complete-inventory.json'
OUT=C16/'two-basis-results/post-soplex-stable-checkpoint-complete-v2-inventory.json'
STAGE=Path('/private/tmp/c16-post-soplex-checkpoint-v2-stage-paths.nul')
DOCS=['RESEARCH-LESSONS.md','formalization/canonical-width/c16/TWO-BASIS-EIGHT-HOURS.md']

def sha(path):
    h=hashlib.sha256()
    with path.open('rb') as f:
        while data:=f.read(1024*1024):h.update(data)
    return h.hexdigest()

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS'):os.environ[key]='1'
    assert not OUT.exists() and not STAGE.exists()
    old=json.loads(BASE.read_text());rows={r['path']:dict(r) for r in old['files']};deltas=[]
    for r in old['files']:
        if r['path'] not in DOCS:assert sha(ROOT/r['path'])==r['sha256'],r['path']
    for name in DOCS:
        p=ROOT/name;h=sha(p);prior=rows.get(name,{}).get('sha256')
        deltas.append(dict(path=name,previous_inventory_sha256=prior,current_sha256=h,
            action='updated_document_binding' if prior else 'added_previously_unbound_document'))
        rows[name]=dict(path=name,sha256=h,bytes=p.stat().st_size)
    for p in [BASE,Path(__file__),C16/'two-basis-results/post-soplex-stable-checkpoint-reader-review.json']:
        name=str(p.relative_to(ROOT));rows[name]=dict(path=name,sha256=sha(p),bytes=p.stat().st_size)
    excluded=set(old['excluded_future_paths'])-set(DOCS)
    for name in rows:
        assert name not in excluded,name
        assert not any(name.startswith(prefix) for prefix in old['excluded_future_prefixes']),name
        assert not name.startswith('local-extraction/') and (ROOT/name).is_file(),name
    for r in rows.values():assert sha(ROOT/r['path'])==r['sha256'],r['path']
    stagepaths=sorted([*rows,str(OUT.relative_to(ROOT))]);assert len(stagepaths)==len(set(stagepaths))
    STAGE.write_bytes(b''.join(p.encode()+b'\0' for p in stagepaths))
    assert STAGE.read_bytes().split(b'\0')[:-1]==[p.encode() for p in stagepaths]
    report=dict(old)
    report.pop('unchanged_prior_non_document_hashes',None)
    report.update(status='STABLE_COMPLETED_FIXED_COLORED_CANONICAL_DOCUMENT_CHECKPOINT_V2',utc=datetime.now(timezone.utc).isoformat(),
        previous_inventory=str(BASE.relative_to(ROOT)),previous_inventory_sha256=sha(BASE),
        document_delta=deltas,all_previous_non_document_payload_hashes_unchanged=True,
        unchanged_prior_C16_non_document_hashes=True,progress_report_excluded=False,
        excluded_future_paths=sorted(excluded),excluded_paths=[r for r in old['excluded_paths'] if r['path'] not in DOCS],
        files=sorted(rows.values(),key=lambda r:r['path']),files_checked=len(rows),
        total_bytes=sum(r['bytes'] for r in rows.values()),
        stage_path_file=str(STAGE),stage_path_file_sha256=sha(STAGE),stage_path_count=len(stagepaths),
        stage_path_scope='Exactly the included repository file paths plus this inventory; NUL-delimited, no ignored full texts, active general-LP prefix or excluded root adapter. Staging file is an external utility, not a repository payload.',
        staged_or_committed_by_this_script=False)
    OUT.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status=report['status'],inventory=str(OUT.relative_to(ROOT)),inventory_sha256=sha(OUT),
        files_checked=len(rows),stage_path_file=str(STAGE),stage_path_file_sha256=sha(STAGE),stage_path_count=len(stagepaths),document_delta=deltas),indent=2))

if __name__=='__main__':main()
