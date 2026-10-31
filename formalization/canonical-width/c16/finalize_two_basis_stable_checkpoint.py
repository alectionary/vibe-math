"""Add the now-final producer closure to the completed fixed/colored checkpoint.

Does not rescan new active work. Preserves the first inventory verbatim.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,os

C16=Path(__file__).resolve().parent;ROOT=C16.parents[2]
P='formalization/canonical-width/c16/'
BASE=C16/'two-basis-results/post-soplex-stable-checkpoint-inventory.json'
OUT=C16/'two-basis-results/post-soplex-stable-checkpoint-complete-inventory.json'

def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        while data:=f.read(1024*1024):h.update(data)
    return h.hexdigest()

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS'):os.environ[key]='1'
    assert not OUT.exists()
    b=json.loads(BASE.read_text());rows={r['path']:r for r in b['files']}
    manifests=[C16/'two-basis-results/joint-soplex0-separation-point22-complete-inventory.json',
               C16/'two-basis-results/colored-physical-point22-Z-m02-X614-v1-inventory.json',
               ROOT/'literature/owner-lift-20261030/inventory.json']
    bindings=[]
    def attach(p,expected=None):
        p=p.resolve();assert p.is_relative_to(ROOT) and p.is_file()
        name=str(p.relative_to(ROOT));h=sha(p)
        if expected is not None:assert h==expected,(name,h,expected)
        if name in rows:assert h==rows[name]['sha256'],name
        else:rows[name]=dict(path=name,sha256=h,bytes=p.stat().st_size)
        return name,h
    for manifest in manifests:
        d=json.loads(manifest.read_text());items=d.get('files',d.get('source_data_closure'))
        if isinstance(items,dict):items=[dict(path=p,sha256=h) for p,h in items.items()]
        assert isinstance(items,list),manifest
        for r in items:
            name=r['path'];path=ROOT/name if (ROOT/name).is_file() else C16/name
            assert not name.startswith('local-extraction/')
            attach(path,r['sha256'])
        name,h=attach(manifest);bindings.append(dict(path=name,sha256=h,file_bindings_checked=len(items)))
    attach(BASE);attach(Path(__file__))
    for r in rows.values():assert sha(ROOT/r['path'])==r['sha256'],r['path']
    report=dict(b)
    report.update(status='STABLE_COMPLETED_FIXED_COLORED_CANONICAL_CHECKPOINT',utc=datetime.now(timezone.utc).isoformat(),
        first_inventory=str(BASE.relative_to(ROOT)),first_inventory_sha256=sha(BASE),
        final_supplementary_bindings=bindings,files=sorted(rows.values(),key=lambda r:r['path']),
        files_checked=len(rows),total_bytes=sum(r['bytes'] for r in rows.values()),
        active_general_LP_excluded=True,progress_report_excluded=True,
        closure_scope='All explicit file bindings of the final SoPlex cohort inventory, completed colored-pilot inventory and canonical-accounting inventory match current bytes. External runtime files remain separately recorded; no fresh mathematical replay is implied.')
    OUT.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(status=report['status'],files_checked=len(rows),bytes=report['total_bytes'],manifest_bindings=bindings,sha256=sha(OUT)),indent=2))

if __name__=='__main__':main()
