#!/usr/bin/env python3
"""Exercise the new rule itself, including a SAT pool with sparse dual words."""
from pathlib import Path
from itertools import combinations
import argparse,json,random,collections,hashlib
from conditional_word_oracle import WordNativeConditionalSpan
def rank(values):
    b={}
    for v in values:
        while v:
            p=v&-v
            if p not in b:b[p]=v;break
            v^=b[p]
    return len(b)
def main():
    p=argparse.ArgumentParser();p.add_argument('--library',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();X=list(range(1,16));Z=[1,2,4,8];native=WordNativeConditionalSpan(X,Z,a.library,4);rows=[]
    for B in combinations(range(15),4):
        if rank(X[i] for i in B)!=4:continue
        facts=[0 if i in B else -1 for i in range(15)]+[0]*4;rows+=native.check(facts)
    native.close();counts=collections.Counter(r['kind'] for r in rows);assert counts['conditional_no_short_word']>0
    # There is exactly one unordered full frame in this pool: the two unit bases.
    truth=[x in Z for x in X]+[True]*4
    for r in rows:assert any(truth[abs(l)-1]==(l>0) for l in r['clause'])
    from verify_conditional_word import WordConsumer
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X];consumer=WordConsumer(X,Z,A)
    for r in rows:consumer.check(r)
    # Check the new quotient nonmembership certificates by literal <=2 sums.
    for r in rows:
        if r['kind']!='conditional_no_short_word':continue
        assert not r['mandatory_opposite'];w=int(r['annihilator_hex'],16);assert w not in Z and all(w!=z^zz for z,zz in combinations(Z,2))
    out={'status':'PASS','tiny_X_pool_size':15,'tiny_Z_pool_size':4,'independent_X_bases_exhausted':840,'certificate_count':len(rows),'kinds':dict(counts),'known_full_frame_truth_checks':len(rows),'independent_RREF_consumer_checks':len(rows),'new_rule_short_sums_checked_by_literal_enumeration':counts['conditional_no_short_word'],'native_library_sha256':hashlib.sha256(a.library.read_bytes()).hexdigest(),'scope':'The new no-one-or-two-term rule is actually exercised; every learned clause retains the known unique full frame. This is not a C16 answer.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('NEW WORD RULE CONTROL PASS',dict(counts),flush=True)
if __name__=='__main__':main()
