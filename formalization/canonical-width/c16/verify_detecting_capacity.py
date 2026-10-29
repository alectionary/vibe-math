"""Independent physical and short-sum consumer for composed source exclusions."""
from itertools import combinations
from verify_sparse_quotient import SparseQuotientConsumer

class CapacityConsumer:
    def __init__(self,X,Z,bank,dimension=128):
        self.X,self.Z,self.bank,self.dimension=X,Z,bank,dimension
        self.child_consumer=SparseQuotientConsumer(X,Z,dimension);self.checked_children=set()
        # The source bank is transferred by actual full-pool Gram automorphisms.
        assert len(X)==len(Z)==720 and dimension==128
        rows=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
        assert rows==[sum(((row>>j)&1)<<i for i,row in enumerate(rows)) for j in range(720)]
        rotate=lambda i:16*(i//16)+(i+1)%16
        for i,row in enumerate(rows):
            assert sum(1<<rotate(j) for j in range(720) if row>>j&1)==rows[rotate(i)]
    def check(self,row):
        assert row['kind']=='detecting_capacity_obstruction';side=row['side'];J=row['mandatory_opposite']
        assert side in (0,1) and len(J)==len(set(J)) and all(0<=j<720 for j in J)
        U,V=(self.X,self.Z) if side==0 else (self.Z,self.X)
        w=int(row['witness_hex'],16);assert 0<w<1<<self.dimension
        D=[i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J)]
        assert D==row['detecting_support'] and 2<=len(D)<=3
        prov=row['child_provenance'];k=prov['bank_index'];h=prov['cyclic_shift'];assert 0<=k<len(self.bank) and 0<=h<16
        child=self.bank[k];assert child['kind']=='universal_sparse_quotient'
        if k not in self.checked_children:
            clause=self.child_consumer.check(child['certificate'])
            assert child['sector']==1-child['certificate']['side'] and child['indices']==child['certificate']['mandatory_opposite']
            assert clause==[-i-1-720*child['sector'] for i in child['indices']];self.checked_children.add(k)
        K=sorted(16*(i//16)+(i%16+h)%16 for i in child['indices'])
        assert K==row['forbidden_child_indices'] and set(K)<=set(D)
        bound=len(D)-1;assert row['capacity_bound']==bound and row['minimum_outside_basis_terms']==bound+1
        residue=self.child_consumer.quotient(V[j] for j in J);target=residue(w);assert target
        # Literal pairs of source indices, using independent low-pivot RREF.
        labels=[0,*[residue(v) for v in V]]
        assert target not in labels
        if bound==2:
            assert all(target!=a^b for k,a in enumerate(labels) for b in labels[k:])
        clause=[-j-1-720*(1-side) for j in J];assert row['clause']==clause
        return clause
