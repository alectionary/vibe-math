#!/usr/bin/env python3
"""Independent low-pivot, bit-set consumer for mandatory-pool exclusions.

Every forced coloop has a directly checked physical covector supported at just
that pool point. No native propagation library or discovery routine is used.
"""
from functools import lru_cache

def bits(mask):
    while mask:
        low=mask&-mask;mask-=low;yield low.bit_length()-1

class ClosureConsumer:
    def __init__(self,X,Z,A):
        self.V=[X,Z];self.rows=A;self.cols=[sum(((row>>j)&1)<<i for i,row in enumerate(A)) for j in range(len(Z))];self.full=(1<<len(X))-1;assert len(X)==len(Z)
        self.forced_covectors_checked=0

    @lru_cache(maxsize=2048)
    def info(self,side,domain):
        values=self.V[side];piv={};original=[];used=0
        for i in bits(domain):
            value=values[i];tag=0
            while value:
                p=(value&-value).bit_length()-1
                if p not in piv:break
                row,comb=piv[p];value^=row;tag^=comb
            if value:
                k=len(original);original.append(i);piv[(value&-value).bit_length()-1]=(value,tag^(1<<k))
            else:used|=tag
        forced=0
        for k,i in enumerate(original):
            if used>>k&1:continue
            w=0
            for p in sorted(piv,reverse=True):
                value,tag=piv[p]
                if (value&w).bit_count()%2 != (tag>>k&1):w^=1<<p
            assert w and all((values[j]&w).bit_count()%2==(j==i) for j in bits(domain))
            self.forced_covectors_checked+=1;forced|=1<<i
        return len(original),forced

    def replay(self,required_X,required_Z=()):
        A=B=self.full;MX=sum(1<<i for i in required_X);MZ=sum(1<<j for j in required_Z);rounds=0;forced=0
        assert len(required_X)==MX.bit_count() and len(required_Z)==MZ.bit_count()
        def result(possible,reason):return {'possible':possible,'reason':reason,'rounds':rounds,'forced_vectors':forced,'active_X':A.bit_count(),'active_Z':B.bit_count(),'mandatory_X':MX.bit_count(),'mandatory_Z':MZ.bit_count()}
        while True:
            rounds+=1;before=A.bit_count()+B.bit_count()-MX.bit_count()-MZ.bit_count()
            if MX&~A or MZ&~B:return result(False,'mandatory_removed')
            xr,xc=self.info(0,A);zr,zc=self.info(1,B)
            if xr!=128 or zr!=128:return result(False,'full_pool_rank')
            forced+=(xc&~MX).bit_count()+(zc&~MZ).bit_count();MX|=xc;MZ|=zc
            if self.info(0,MX)[0]!=MX.bit_count() or self.info(1,MZ)[0]!=MZ.bit_count():return result(False,'mandatory_dependent')
            ZX=sum(1<<i for i in bits(A) if not self.rows[i]&MZ);ZZ=sum(1<<j for j in bits(B) if not self.cols[j]&MX)
            xr,xc=self.info(0,ZX);zr,zc=self.info(1,ZZ)
            if xr!=128-MZ.bit_count() or zr!=128-MX.bit_count():return result(False,'zero_pool_rank')
            forced+=(xc&~MX).bit_count()+(zc&~MZ).bit_count();MX|=xc;MZ|=zc
            px={};pz={}
            for i in bits(MX):
                hits=self.rows[i]&MZ
                if hits.bit_count()>1:return result(False,'mandatory_multiple_partners')
                for j in bits(hits):
                    if j in pz and pz[j]!=i:return result(False,'mandatory_multiple_partners')
                    px[i]=j;pz[j]=i
            newA=0;newB=0
            for i in bits(A):
                hits=self.rows[i]&MZ
                if hits.bit_count()<=1 and all(j not in pz or pz[j]==i for j in bits(hits)):newA|=1<<i
            for j in bits(B):
                hits=self.cols[j]&MX
                if hits.bit_count()<=1 and all(i not in px or px[i]==j for i in bits(hits)):newB|=1<<j
            A,B=newA,newB;after=A.bit_count()+B.bit_count()-MX.bit_count()-MZ.bit_count();assert after<=before
            if after==before:return result(True,'fixed_point')
