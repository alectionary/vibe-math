"""Validate this block's question-harvesting joins and source hashes."""
from pathlib import Path
import datetime,hashlib,json
W=Path(__file__).resolve().parent;R=W.parents[1];D=R/'literature'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
if __name__=='__main__':
    screen=read(D/'distance-preservation-source-screening.json')
    rows={x['id']:x for x in read(D/'open-problems.json')}
    coverage={x['paper_id']:x for x in read(D/'downstream-paper-coverage.json')}
    manifest={x['paper_id']:x for x in read(D/'downstream-source-manifest.json')}
    raw={'F86':'2607.28795v1.html','F87':'2603.22532v2.html','F88':'2605.16523v1.html','F89':'2607.28621v1.html','F90':'Kelley2004.pdf'}
    assert {s['paper_id'] for s in screen['screens']}==set(raw)
    ids=[];checks=[]
    for s in screen['screens']:
        fid=s['paper_id'];source=R/manifest[fid]['local_file'];text=R/manifest[fid]['extracted_text_file']
        assert sha(source)==s['source_sha256']==manifest[fid]['sha256'],fid
        assert sha(text)==s['text_sha256']==manifest[fid]['extracted_text_sha256'],fid
        line_count=len(text.read_text().splitlines())
        assert set(s['target_ids'])==set(coverage[fid]['recorded_target_ids']),fid
        for tid in s['target_ids']:
            q=rows[tid];assert not q['eligible_for_coverage']
            assert q['lean_proof_status']=='not_assessed_in_this_extension'
            assert any(o['source_id']==fid and o['source_sha256']==s['source_sha256'] and 0<o['extracted_text_lines'][0]<=o['extracted_text_lines'][1]<=line_count for o in q['occurrences'])
        ids+=s['target_ids'];checks.append({'paper_id':fid,'source_sha256':sha(source),'text_sha256':sha(text),'new_directions':len(s['target_ids'])})
    assert len(ids)==len(set(ids))==24
    assert set(ids)==set(screen['cohort_delta']['added_target_ids'])
    summary=read(D/'open-problem-summary.json')
    assert (summary['canonical_inventory_entries'],summary['eligible_targets'],summary['article_records'],summary['full_text_screened'],summary['eligible_verified_lean_proofs'])==(319,144,124,113,5)
    out={'status':'PASS','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'screens':checks,
         'new_directions':24,'new_eligible_targets':0,'new_full_texts':5,'canonical_completion_delta':0,
         'scope':'Source hashes, paper/target joins and cohort bookkeeping. Does not certify mathematical novelty, global resolution or interpretation of the source passages.'}
    (W/'source-screening-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
