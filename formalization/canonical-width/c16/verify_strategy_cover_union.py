#!/usr/bin/env python3
"""Compose kept-anchor proofs whenever each proof covers the actual wider domain.

The parent recorded during discovery need not equal the parent used now: it is
not an input clause. The indispensable check is inclusion of the new avoidance
domain in each actual independently replayed proof domain. This rejects unsafe
combinations of separately proved removals in narrower domains.
"""
from pathlib import Path
import argparse,hashlib,json
from verify_strategy_cover_bindings import check_cover as legacy_check
from verify_anchored_cover_chain import physical,canonical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def check_cover(path,C=None):
    d=json.loads(path.read_text())
    if d.get('cover_union_version')!=1:return legacy_check(path,C)
    if C is None:_,C,_,_=physical()
    C=set(C);assert d['status']=='PASS';retained={tuple(r['orbit_tuple']) for r in d['cases']};assert len(retained)==len(d['cases'])==d['new_case_count'] and retained<=C;parent_path=path.parent/d['parent_cover_file'];assert sha(parent_path)==d['parent_cover_sha256'];parent=check_cover(parent_path,C);removed=parent['retained']-retained;assert retained<=parent['retained'] and removed==set(map(tuple,d['removed_classes']));actual_domain=C-retained;seen=set()
    for item in d['accepted_anchor_proofs']:
        case=tuple(item['case']);assert case in removed and case not in seen;seen.add(case);mp=path.parent/item['metadata_file'];rp=path.parent/item['replay_file'];assert sha(mp)==item['metadata_sha256'] and sha(rp)==item['replay_sha256'];meta=json.loads(mp.read_text());receipt=json.loads(rp.read_text());assert meta['answer'] is False and receipt['status']=='PASS' and receipt['answer'] is False and receipt['proof_status'].startswith('DRAT_PASS');assert meta['signature_independence_scope']=='free_pairs_only_keeps_anchor' and meta['projection_count_bound']==16 and canonical(*meta['anchor'])==case;proof_domain=set(map(tuple,meta['removed_class_tuples']));domain_path=ROOT/meta['restricted_classes_c16_path'];assert sha(domain_path)==meta['restricted_classes_sha256'] and proof_domain==set(map(tuple,json.loads(domain_path.read_text())['classes']));assert actual_domain<=proof_domain<=C;assert receipt['domain_signature_restriction_checked'] and receipt['input_sha256']==meta['input_sha256'] and receipt['proof_sha256']==meta['fresh_proof']['proof_sha256']
    assert seen==removed and len(seen)==len(d['accepted_anchor_proofs'])
    for row in d['cases']:assert canonical(row['X_index'],row['Z_index'])==tuple(row['orbit_tuple'])
    # A hypothetical full frame avoiding retained has a pair in removed by the
    # parent cover. Its actual domain is contained in the corresponding proof
    # domain. Preserve that pair and normalize only the free signatures (<=16).
    # The resulting model contradicts its independently checked anchored UNSAT.
    return {'case_count':len(retained),'accepted_after_root':parent['accepted_after_root']+len(removed),'root417_bound':True,'retained':retained}
def main():
    p=argparse.ArgumentParser();p.add_argument('--cover',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();d=check_cover(a.cover);d.pop('retained');out={'status':'PASS','source_C16_answered':d['case_count']==0,'cover_sha256':sha(a.cover),**d,'scope':'Cover induction and domain inclusion with hash-bound independently replayed kept-anchor proofs. Discovery-parent metadata is not treated as an additional input hypothesis.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
