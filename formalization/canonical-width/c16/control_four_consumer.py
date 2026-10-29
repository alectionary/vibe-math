#!/usr/bin/env python3
"""Replay literal tiny controls through the second low-pivot consumer as well."""
from pathlib import Path
import hashlib,json,sys
import control_four_term as c
from verify_four_term import FourTermConsumer
original=c.check
def both(X,Z,row,N):
    result=original(X,Z,row,N)
    assert FourTermConsumer(X,Z,N).check(row)==row['clause']
    return result
if __name__=='__main__':
    c.check=both;c.main();p=Path(sys.argv[sys.argv.index('--output')+1]);d=json.loads(p.read_text())
    d['additional_consumer_sha256']=hashlib.sha256(Path(__file__).with_name('verify_four_term.py').read_bytes()).hexdigest()
    d['additional_check']='Every accepted tiny certificate also checked by low-pivot FourTermConsumer.'
    p.write_text(json.dumps(d,indent=2)+'\n')
