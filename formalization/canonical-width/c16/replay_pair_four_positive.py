#!/usr/bin/env python3
"""Replay the four positive pair certificates; not the16200 negative decisions."""
from pathlib import Path
import argparse,hashlib,json,time
from verify_four_term_small import check
from verify_four_term import FourTermConsumer
from verify_sparse_gate import independent_obstruction
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();p=ROOT/'transfer-results/pair-four/screen.json';d=json.loads(p.read_text());f=json.loads(p.with_name('frozen.json').read_text())
    sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    assert d['status']=='COMPLETE' and d['processed']==16200 and d['frozen_sha256']==sha(p.with_name('frozen.json'))
    for name,h in f['source_hashes'].items():assert sha(ROOT/name)==h
    X,Z,A=physical();consumer=FourTermConsumer(X,Z);records=[]
    for c in d['cuts']:
        r=c['certificate'];check(X,Z,r);consumer.check(r);old=independent_obstruction(X,Z,0,c['indices']);records.append({'ids':c['indices'],'order':r['order'],'old_complete_orders':old})
    assert [r['ids'] for r in records]==[[368,589],[368,622],[400,496],[416,512]]
    result={'status':'PASS','source_C16_answered':False,'screen_sha256':sha(p),'records':records,'elapsed_seconds':time.monotonic()-start,
            'scope':'Four positive source certificates replayed by literal cosets and low-pivot quotient checks. Old complete order3 independently accepts only the last pair. The full16200 negative screen has not been independently replayed and its one rank-deficient pair is separately reported, not accepted as extendible.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
