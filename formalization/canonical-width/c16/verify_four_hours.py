#!/usr/bin/env python3
"""Check independent physical enumeration and complete twelve-monomial logs.

This validates recorded outputs and provenance, not a Lean search certificate.
Replaying the corresponding native programs repeats the traversals themselves.
"""
import hashlib
import json
from pathlib import Path
from replay_seed4 import check_log,masks_for
from verify_independent_enumeration import main as verify_enumeration


def main():
    verify_enumeration();root=Path(__file__).parent;folder=root/'four-hours-results/twelve';m=json.loads((folder/'manifest.json').read_text())
    for name,digest in m['source_sha256'].items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==digest,name
    assert m['complete_partner_domain'] and not m['exact_monomial_count_restriction'] and m['capped_quotients']==0
    Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()];rows=m['results'];assert [r['omitted'] for r in rows]==masks_for(4)
    for row in rows:
        p=folder/row['log'];assert hashlib.sha256(p.read_bytes()).hexdigest()==row['sha256']
        actual=check_log(p,Z,row['omitted']);assert all(actual[k]==row[k] for k in actual)
        assert actual['outcome']=='NO_FRAME' and actual['covered']==actual['total'] and not actual['capped']
    assert m['assignments_covered']==sum(r['total'] for r in rows)==54411742864
    assert m['quotient_cases_reached']==sum(r['full'] for r in rows)==16203129
    assert m['search_nodes']==sum(r['nodes'] for r in rows)==115977493
    assert m['rotation_classes']==len(rows)==116
    for engine,meta in m['engines'].items():
        original=json.loads((folder/meta['raw_manifest']).read_text());used=[r for r in rows if r['engine']==engine]
        assert {r['omitted'] for r in used}=={r['omitted'] for r in original['results']}
        for r in original['results']:
            assert r['outcome']=='NO_FRAME' and r['returncode']==3 and not r['capped']
    print('PASS all116 twelve-monomial classes:54,411,742,864 assignments covered;16,203,129 quotient calls;115,977,493 nodes;zero caps.')
    print('Any complete-pool width16 CSS frame has at most11 seed4 X monomials. Exact unrestricted width remains16 or18; no Lean certificate.')


if __name__=='__main__':main()
