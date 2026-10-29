#!/usr/bin/env python3
"""Build a reviewable cover from already accepted immutable proof receipts."""
from pathlib import Path
import argparse,json,hashlib
from verify_anchored_cover_chain import physical,canonical
from verify_strategy_cover_union import check_cover
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--parent',type=Path,required=True);p.add_argument('--proofs',type=Path,nargs='+',required=True,help='JSON catalog with metadata_file/replay_file records');p.add_argument('--output',type=Path,required=True);a=p.parse_args();A,C,pos,sig=physical();parent=check_cover(a.parent,C);retained=parent['retained'];omitted=set(C)-retained;catalog={}
    for path in a.proofs:
        data=json.loads(path.read_text());records=data.get('records',data.get('accepted_anchor_proofs',[]))
        for record in records:
            if not record.get('accepted',True) or not record.get('replay_file'):continue
            mp=path.parent/record['metadata_file'];rp=path.parent/record['replay_file'];assert not record.get('metadata_sha256') or sha(mp)==record['metadata_sha256'];assert not record.get('replay_sha256') or sha(rp)==record['replay_sha256'];m=json.loads(mp.read_text());r=json.loads(rp.read_text());case=canonical(*m['anchor']);domain=set(map(tuple,m['removed_class_tuples']))
            if case not in retained or not omitted<=domain:continue
            assert r['status']=='PASS' and r['answer'] is False and r['proof_status'].startswith('DRAT_PASS');catalog.setdefault(case,[]).append((domain,mp,rp))
    proposed=set(catalog)
    # Keep a valid subset; this does not claim a globally minimum cover.
    while True:
        actual=omitted|proposed;bad=next((c for c in sorted(proposed) if not any(actual<=d for d,mp,rp in catalog[c])),None)
        if bad is None:break
        proposed.remove(bad)
    assert proposed,'No independently certified composable removal';items=[]
    for case in sorted(proposed):
        d,mp,rp=next(row for row in catalog[case] if omitted|proposed<=row[0]);items.append({'case':case,'metadata_file':str(mp.relative_to(a.output.parent)),'metadata_sha256':sha(mp),'replay_file':str(rp.relative_to(a.output.parent)),'replay_sha256':sha(rp),'proof_domain_class_count':len(d)})
    old=json.loads(a.parent.read_text());out={'status':'PASS','cover_union_version':1,'source_C16_answered':False,'old_case_count':len(retained),'new_case_count':len(retained)-len(proposed),'parent_cover_file':str(a.parent.relative_to(a.output.parent)),'parent_cover_sha256':sha(a.parent),'removed_classes':sorted(proposed),'accepted_anchor_proofs':items,'cases':[r for r in old['cases'] if tuple(r['orbit_tuple']) not in proposed],'source_width_candidates':[16,18],'physical_partial_pairs':88,'full_source_anchors_completed':0,'scope':'Sufficient cover using independently checked kept-anchor proofs. Every proof domain contains the actual full-frame avoidance domain. No minimum-cover claim and no full-source completion.'};a.output.write_text(json.dumps(out,indent=2)+'\n');checked=check_cover(a.output,C);assert checked['case_count']==out['new_case_count'];print('ACCEPTED COVER',out['new_case_count'],'removed',sorted(proposed),flush=True)
if __name__=='__main__':main()
