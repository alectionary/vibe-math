"""Independent full-basis propagation under an explicit allowed-pair domain.

Domain exclusions are conditional on that domain; they are not universal source
nogoods and must not be transferred to a different domain without replay.
"""
from verify_mandatory_closure import ClosureConsumer,bits
class DomainClosureConsumer(ClosureConsumer):
    def __init__(self,X,Z,A,allowed,dimension=128):
        super().__init__(X,Z,A);self.dimension=dimension;self.allowed_rows=allowed
        assert len(A)==len(allowed) and all(not row&~physical for row,physical in zip(allowed,A))
        self.allowed_cols=[sum(((row>>j)&1)<<i for i,row in enumerate(allowed)) for j in range(len(Z))]
    def replay(self,required_X,required_Z=()):
        A=B=self.full;MX=sum(1<<i for i in required_X);MZ=sum(1<<j for j in required_Z);rounds=0;forced=0
        assert len(required_X)==MX.bit_count() and len(required_Z)==MZ.bit_count()
        def result(possible,reason):return {'possible':possible,'reason':reason,'rounds':rounds,'forced_vectors':forced,'active_X':A.bit_count(),'active_Z':B.bit_count(),'mandatory_X':MX.bit_count(),'mandatory_Z':MZ.bit_count()}
        while True:
            rounds+=1;before=A.bit_count()+B.bit_count()-MX.bit_count()-MZ.bit_count()
            if MX&~A or MZ&~B:return result(False,'mandatory_removed')
            xr,xc=self.info(0,A);zr,zc=self.info(1,B)
            if xr!=self.dimension or zr!=self.dimension:return result(False,'full_pool_rank')
            forced+=(xc&~MX).bit_count()+(zc&~MZ).bit_count();MX|=xc;MZ|=zc
            if self.info(0,MX)[0]!=MX.bit_count() or self.info(1,MZ)[0]!=MZ.bit_count():return result(False,'mandatory_dependent')
            ZX=sum(1<<i for i in bits(A) if not self.rows[i]&MZ);ZZ=sum(1<<j for j in bits(B) if not self.cols[j]&MX)
            xr,xc=self.info(0,ZX);zr,zc=self.info(1,ZZ)
            if xr!=self.dimension-MZ.bit_count() or zr!=self.dimension-MX.bit_count():return result(False,'zero_pool_rank')
            forced+=(xc&~MX).bit_count()+(zc&~MZ).bit_count();MX|=xc;MZ|=zc
            px={};pz={}
            for i in bits(MX):
                hits=self.rows[i]&MZ
                if hits.bit_count()>1:return result(False,'mandatory_multiple_partners')
                for j in bits(hits):
                    if j in pz and pz[j]!=i:return result(False,'mandatory_multiple_partners')
                    if not self.allowed_rows[i]>>j&1:return result(False,'mandatory_forbidden_pair')
                    px[i]=j;pz[j]=i
            newA=0;newB=0
            for i in bits(A):
                hits=self.rows[i]&MZ
                if hits.bit_count()<=1 and all((j not in pz or pz[j]==i) and self.allowed_rows[i]>>j&1 for j in bits(hits)) and self.allowed_rows[i]&B:newA|=1<<i
            for j in bits(B):
                hits=self.cols[j]&MX
                if hits.bit_count()<=1 and all((i not in px or px[i]==j) and self.allowed_cols[j]>>i&1 for i in bits(hits)) and self.allowed_cols[j]&A:newB|=1<<j
            A,B=newA,newB;after=A.bit_count()+B.bit_count()-MX.bit_count()-MZ.bit_count();assert after<=before
            if after==before:return result(True,'fixed_point')
