#!/usr/bin/env python3
"""Exercise nonempty quotient spans and retain a known128-frame enlargement."""
from pathlib import Path
from itertools import combinations
import argparse,collections,json,random,sys,hashlib
from conditional_word_oracle import WordNativeConditionalSpan
from verify_conditional_word import WordConsumer
from verify_algebraic_model import physical
def add(piv,v):
    while v:
        low=v&-v
        if low not in piv:piv[low]=v;return True
        v^=piv[low]
    return False
def run(X,Z,N,trials,rng,library,literal):
    native=WordNativeConditionalSpan(X,Z,library,N);A=native.rows;consumer=WordConsumer(X,Z,A);units=[1<<i for i in range(N)];xi={v:i for i,v in enumerate(X)};zj={v:j for j,v in enumerate(Z)};truth=[v in units for v in X]+[v in units for v in Z];counts=collections.Counter();nonempty=0;literal_checks=0
    for trial in range(trials):
        J=sorted(rng.sample(range(N),trial%min(N,4)));mask=sum(1<<j for j in J);candidates=[i for i,x in enumerate(X) if not x&mask];rng.shuffle(candidates);basis={};B=[]
        for i in candidates:
            if add(basis,X[i]):B.append(i)
            if len(B)==N-len(J):break
        assert len(B)==N-len(J);facts=[-1]*len(X)+[0]*len(Z)
        for i in B:facts[i]=0
        for j in J:facts[xi[1<<j]]=1;facts[len(X)+zj[1<<j]]=1
        records=native.check(facts)
        for row in records:
            counts[row['kind']]+=1;assert any(truth[abs(l)-1]==(l>0) for l in row['clause']);consumer.check(row)
            if row['kind']=='conditional_no_short_word':
                nonempty+=bool(row['mandatory_opposite'])
                if literal:
                    span={0}
                    for j in row['mandatory_opposite']:span|={v^Z[j] for v in list(span)}
                    w=int(row['annihilator_hex'],16);assert all(w^z not in span for z in Z) and all(w^z^zz not in span for z,zz in combinations(Z,2));literal_checks+=1
    native.close();return {'trials':trials,'clause_kinds':dict(counts),'new_rule_nonempty_quotient_certificates':nonempty,'independent_consumer_checks':sum(counts.values()),'literal_quotient_short_sum_checks':literal_checks,'known_full_identity_frame_retained':True}
def main():
    p=argparse.ArgumentParser();p.add_argument('--library',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();rng=random.Random(20261029);small=run(list(range(1,64)),[1<<i for i in range(6)],6,600,rng,a.library,True);assert small['new_rule_nonempty_quotient_certificates']>0
    X,Z,A=physical();units=[1<<i for i in range(128)];XX=sorted(set(X)|set(units));ZZ=sorted(set(Z)|set(units));large=run(XX,ZZ,128,50,rng,a.library,False)
    out={'status':'PASS','small_quotient_control':small,'full128_control':large,'enlarged_pool_sizes':[len(XX),len(ZZ)],'native_library_sha256':hashlib.sha256(a.library.read_bytes()).hexdigest(),'source_C16_answered':False,'scope':'Nonempty quotient certificates are exercised and literally checked on tiny pools. The128-frame control enlarges each source pool by unit vectors; it does not construct a minimum-weight source frame.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('QUOTIENT WORD CONTROL PASS',small,large,flush=True)
if __name__=='__main__':main()
