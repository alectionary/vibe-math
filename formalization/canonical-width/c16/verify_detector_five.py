"""Independent physical/coset and child-certificate consumer for supports<=5."""
from verify_four_term import FourTermConsumer

class CapacityFiveConsumer:
    def __init__(self,X,Z,bank,dimension=128):
        self.X,self.Z,self.bank,self.dimension=X,Z,bank,dimension;assert len(X)==len(Z)==720 and dimension==128
        self.child_consumer=FourTermConsumer(X,Z,dimension);self.checked=set()
        A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
        assert A==[sum(((r>>j)&1)<<i for i,r in enumerate(A)) for j in range(720)]
        rot=lambda i:16*(i//16)+(i%16+1)%16
        for i,row in enumerate(A):assert sum(1<<rot(j) for j in range(720) if row>>j&1)==A[rot(i)]
    def check(self,row):
        assert row['kind']=='detecting_capacity_obstruction';side=row['side'];J=row['mandatory_opposite'];assert side in (0,1) and len(J)==len(set(J)) and all(0<=j<720 for j in J)
        U,V=(self.X,self.Z) if side==0 else (self.Z,self.X);w=int(row['witness_hex'],16);assert 0<w<1<<128
        D=[i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J)]
        assert D==row['detecting_support'] and 2<=len(D)<=5
        p=row['child_provenance'];k,h=p['bank_index'],p['cyclic_shift'];assert 0<=k<len(self.bank) and 0<=h<16;child=self.bank[k]
        assert child['kind'] in ('universal_sparse_quotient','universal_sparse_quotient_four')
        if k not in self.checked:
            clause=self.child_consumer.check(child['certificate']);assert child['indices']==child['certificate']['mandatory_opposite'] and child['sector']==1-child['certificate']['side'];assert clause==[-i-1-720*child['sector'] for i in child['indices']];self.checked.add(k)
        K=sorted(16*(i//16)+(i%16+h)%16 for i in child['indices']);assert K==row['forbidden_child_indices'] and set(K)<=set(D)
        bound=len(D)-1;assert row['capacity_bound']==bound and row['minimum_outside_basis_terms']==bound+1
        residue=self.child_consumer.quotient(V[j] for j in J);target=residue(w);assert target
        values=[0,*[residue(v) for v in V]];assert target not in values
        if bound>=2:
            pairs={a^b for i,a in enumerate(values) for b in values[i:]};assert target not in pairs
        if bound>=3:assert all(target^a not in pairs for a in values)
        if bound>=4:assert pairs.isdisjoint({target^a for a in pairs})
        clause=[-j-1-720*(1-side) for j in J];assert row['clause']==clause;return clause
