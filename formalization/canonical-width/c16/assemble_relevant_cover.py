#!/usr/bin/env python3
"""Compose one independently replayed kept-anchor proof with an existing cover."""
from pathlib import Path
import argparse,hashlib,json,os
from verify_anchored_cover_chain import physical,canonical
from verify_strategy_cover_union import check_cover

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--parent',type=Path,required=True);p.add_argument('--certificate',type=Path,required=True);p.add_argument('--replay',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();A,C,pos,sig=physical();parent=check_cover(a.parent,C);meta=json.loads(a.certificate.read_text());receipt=json.loads(a.replay.read_text());assert meta['answer'] is False and receipt['status']=='PASS' and receipt['answer'] is False and receipt['proof_status'].startswith('DRAT_PASS');assert receipt['input_sha256']==meta['input_sha256'] and receipt['proof_sha256']==meta['fresh_proof']['proof_sha256']
    case=canonical(*meta['anchor']);assert case in parent['retained'];retained=parent['retained']-{case};actual=set(C)-retained;assert actual<=set(map(tuple,meta['removed_class_tuples']));old=json.loads(a.parent.read_text());relative=lambda p:os.path.relpath(p.resolve(),a.output.parent.resolve())
    d={'status':'PASS','cover_union_version':1,'source_C16_answered':False,'old_case_count':len(parent['retained']),'new_case_count':len(retained),'parent_cover_file':relative(a.parent),'parent_cover_sha256':sha(a.parent),'removed_classes':[case],'accepted_anchor_proofs':[{'case':case,'metadata_file':relative(a.certificate),'metadata_sha256':sha(a.certificate),'replay_file':relative(a.replay),'replay_sha256':sha(a.replay),'proof_domain_class_count':len(meta['removed_class_tuples'])}],'cases':[r for r in old['cases'] if tuple(r['orbit_tuple'])!=case],'source_width_candidates':[16,18],'physical_partial_pairs':88,'full_source_anchors_completed':0,'scope':'Sufficient selected-pair cover after a checked kept-anchor contradiction under the complete avoidance domain. No individual full source anchor or global frame nonexistence is proved.'};a.output.write_text(json.dumps(d,indent=2)+'\n');r=check_cover(a.output,C);assert r['case_count']==len(retained);print('COVER COMPOSED',len(parent['retained']),len(retained),case,flush=True)
if __name__=='__main__':main()
