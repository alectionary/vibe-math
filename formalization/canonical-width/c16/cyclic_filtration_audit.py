#!/usr/bin/env python3
"""Exact epsilon-adic rank profiles for t^16-1=(t+1)^16 over F2."""
from itertools import combinations
import json
from pathlib import Path
from rank_oracle import basis,rotate_value
from rank_cut_check import echelon


def epsilon(value):
    out=0
    for b in range(8):
        word=value>>(16*b)&65535;answer=0
        for p in range(16):
            if not word>>p&1:continue
            s=p
            while True:
                answer^=1<<s
                if not s:break
                s=(s-1)&p
        out|=answer<<(16*b)
    return out


def main():
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Y=[epsilon(v) for v in X]
    for v,w in zip(X,Y):
        assert epsilon(w)==v
        multiplied=sum(((w>>(16*b)&65535)<<1&65535)<<(16*b) for b in range(8))
        assert epsilon(rotate_value(v,1)^v)==multiplied
    source=json.loads((root/'physical-pool-source.json').read_text());groups=[[] for _ in range(5)]
    for a,support in enumerate(source['Z_orbit_representatives']):
        columns={(q//32)%5 for q in support};assert len(columns)==1;groups[next(iter(columns))].extend(range(16*a,16*a+16))
    records=[];D=[1<<p for p in range(128)]
    for j in range(17):
        mask=sum(((1<<j)-1)<<(16*b) for b in range(8))
        def rank(ids):
            rows=[Y[i]&mask for i in ids];r=len(basis(rows));assert len(echelon(rows))==r;return r
        whole=rank(range(720));assert whole==8*j
        jordan=len(basis(D));assert jordan==8*(16-j)
        record={'j':j,'ambient_quotient_dimension':8*j,'whole_pool_quotient_rank':whole,'rank_D_power':jordan,'column_group_ranks':[rank(g) for g in groups],'column_pair_ranks':{f'{a},{b}':rank(groups[a]+groups[b]) for a,b in combinations(range(5),2)}};records.append(record)
        D=[rotate_value(v,1)^v for v in D]
    result={'status':'PASS','identity':'F2[t]/(t^16-1)=F2[epsilon]/epsilon^16, epsilon=t+1','evidence':'exact finite arithmetic with independent high/low-pivot rank checks','canonical_question_answered':False,'conclusion':'The complete pool spans every epsilon-adic quotient. Linear whole-pool filtration rank alone gives no new obstruction. Pair-specific profiles are recorded without a global impossibility claim.','records':records}
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
