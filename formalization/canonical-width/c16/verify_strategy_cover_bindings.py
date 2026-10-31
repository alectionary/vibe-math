#!/usr/bin/env python3
"""Bind already replayed source/proof receipts into a nested sufficient cover.

This checks the cover induction and all hashes, not solver proofs again. The
session replay runner must regenerate each cited source/DRAT receipt first.
"""
from pathlib import Path
import argparse,hashlib,json
from verify_anchored_cover_chain import physical,canonical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text())
def check_cover(path,C=None):
    if C is None:_,C,_,_=physical()
    C=set(C);d=load(path);assert d['status']=='PASS' and not d['source_C16_answered'];retained={tuple(r['orbit_tuple']) for r in d['cases']};assert len(retained)==len(d['cases'])==d['new_case_count'] and retained<=C
    for r in d['cases']:assert canonical(r['X_index'],r['Z_index'])==tuple(r['orbit_tuple'])
    if 'parent_cover_file' not in d:
        assert d['old_case_count']==418 and d['new_case_count']==417 and d['removed_from_cover']==[26,32,15];chain=ROOT/'algebraic-results/exchange/chain.json';assert sha(chain)==d['parent_chain_sha256'];removed=set(map(tuple,load(chain)['removed_case_tuples']));assert len(removed)==100 and retained==C-removed-{(26,32,15)}
        for name in ['parent_replay','new_conditional_replay']:
            rp=path.parent/d[name+'_file'];assert sha(rp)==d[name+'_sha256'];assert load(rp)['status']=='PASS'
        meta=load(ROOT/'strategy-results/closure-cover-extension.json');receipt=load(path.parent/d['new_conditional_replay_file']);assert meta['input_sha256']==receipt['input_sha256']==d['new_input_sha256'] and meta['fresh_proof']['proof_sha256']==receipt['proof_sha256']==d['new_proof_sha256'] and receipt['answer'] is False and receipt['proof_status']=='DRAT_PASS_EMPTY_PROOF_REJECTED'
        return {'case_count':417,'accepted_after_root':0,'root417_bound':True,'retained':retained}
    parent=path.parent/d['parent_cover_file'];assert sha(parent)==d['parent_cover_sha256'];prior=check_cover(parent,C);assert retained<=prior['retained'];removed=prior['retained']-retained;assert removed==set(map(tuple,d['removed_classes'])) and len(removed)==len(d['accepted_anchor_proofs']);domain_path=path.parent/d['batch_domain_file'];assert sha(domain_path)==d['batch_domain_sha256'];domain=load(domain_path);B=set(map(tuple,domain.get('candidate_cases',[domain.get('candidate_removed_case')])));assert removed<=B<=prior['retained'];R=set(map(tuple,domain['classes']));assert R==(C-prior['retained'])|B
    seen=set()
    for r in d['accepted_anchor_proofs']:
        case=tuple(r['case']);assert case in removed and case not in seen;seen.add(case);mp=path.parent/r['metadata_file'];rp=path.parent/r['replay_file'];assert sha(mp)==r['metadata_sha256'] and sha(rp)==r['replay_sha256'];meta=load(mp);receipt=load(rp);assert receipt['status']=='PASS' and receipt['answer'] is False and receipt['proof_status'].startswith('DRAT_PASS');assert meta['answer'] is False and meta['signature_independence_scope']=='free_pairs_only_keeps_anchor' and meta['projection_count_bound']==16;assert set(map(tuple,meta['removed_class_tuples']))==R and canonical(*meta['anchor'])==case;assert meta['anchored_parent_cover_sha256']==sha(parent) and meta['restricted_classes_sha256']==sha(domain_path);assert receipt['input_sha256']==meta['input_sha256'] and receipt['proof_sha256']==meta['fresh_proof']['proof_sha256'];assert receipt['domain_signature_restriction_checked']
    # A full frame avoiding retained has a pair in removed by the parent cover.
    # Preserve that pair; delete zero-signature and dependent free subsets until
    # <=16 independent free signatures remain. All negative domain clauses survive.
    # Its full nonzero pair domain is contained in R, even if only a subset of B
    # was removed. The corresponding wider-domain anchored proof contradicts it.
    return {'case_count':len(retained),'accepted_after_root':prior['accepted_after_root']+len(removed),'root417_bound':True,'retained':retained}
def main():
    p=argparse.ArgumentParser();p.add_argument('--cover',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();r=check_cover(a.cover);r.pop('retained');out={'status':'PASS','source_C16_answered':False,'cover_sha256':sha(a.cover),**r,'scope':'Nested cover induction and immutable receipt bindings. Source and DRAT receipts must be independently regenerated; no full anchor is completed.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
