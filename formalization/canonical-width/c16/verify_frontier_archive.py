#!/usr/bin/env python3
"""Validate the saved task tree and export its unresolved leaves.

This checks bookkeeping, hashes and partition records. It does not replay every
native search or convert an incomplete frontier into a nonexistence proof.
"""
import argparse
import gzip
import hashlib
import json
from pathlib import Path


def main():
    ap=argparse.ArgumentParser();ap.add_argument('archive',type=Path);ap.add_argument('--export-unresolved',type=Path);args=ap.parse_args()
    with gzip.open(args.archive,'rt') as source:d=json.load(source)
    m=d['manifest'];rows=m['tasks'];assert m['status']=='INCOMPLETE';inputs=d['inputs'];results=d['results'];root=d['root_result'];root_lines=d['root_tasks'];assert root['status']=='FRONTIER' and root['frontier_tasks']==len(root_lines)
    root_bytes=('\n'.join(root_lines)+'\n').encode();assert hashlib.sha256(root_bytes).hexdigest()==m['initial_tasks_sha256']
    children=[];roots=[];nodes=0;unresolved=[]
    for ident,row in enumerate(rows):
        assert row['id']==ident;line=inputs[str(ident)];parts=line.split();assert parts[0]=='TASK';remaining=int(parts[1]);n=int(parts[5]);assert remaining==128-n and len(parts)==6+2*n and remaining==row['remaining'] and int(parts[2])==row['remaining_seed4_cap']
        assert int(parts[3],16).bit_length()<=720 and int(parts[4],16).bit_length()<=720
        if row['parent'] is None:roots.append(ident)
        else:assert 0<=row['parent']<ident
        if row['status'] in ['UNSAT','EXPANDED']:
            result=results[str(ident)];assert result['nodes']==row['nodes'];nodes+=result['nodes']
            if row['status']=='UNSAT':assert result['status']=='UNSAT' and result['frontier_tasks']==0 and row['returncode']==3
            else:
                ids=row['children'];assert result['status']=='FRONTIER' and len(ids)==result['frontier_tasks'] and row['returncode']==2
                assert all(rows[k]['parent']==ident for k in ids)
                content=('\n'.join(inputs[str(k)] for k in ids)+'\n').encode() if ids else b''
                assert hashlib.sha256(content).hexdigest()==d['expanded_output_sha256'][str(ident)];children.extend(ids)
        else:
            assert row['status'] in ['QUEUED','INTERRUPTED','ERROR','RUNNING'];unresolved.append(ident)
    assert roots==list(range(len(root_lines))) and [inputs[str(i)] for i in roots]==root_lines
    assert sorted(roots+children)==list(range(len(rows))) and len(set(children))==len(children)
    assert unresolved==m['unresolved_ids'] and nodes==m['counts']['nodes']
    source_root=Path(__file__).parent
    for name,digest in d['source_sha256'].items():assert hashlib.sha256((source_root/name).read_bytes()).hexdigest()==digest,name
    if args.export_unresolved:args.export_unresolved.write_text(''.join(inputs[str(i)]+'\n' for i in unresolved))
    print(f'PASS frontier archive: {len(rows)} registered tasks, {m["counts"]["UNSAT"]} closed, {m["counts"]["expanded"]} expanded, {len(unresolved)} unresolved; {nodes+root["nodes"]:,} recorded nodes including root.')
    print('Global frame existence remains unresolved. Every unresolved leaf is preserved.')


if __name__=='__main__':main()
