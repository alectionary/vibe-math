"""Independent low-pivot quotient and pair-set test, allowing large mandatory sets."""
from verify_sparse_quotient import SparseQuotientConsumer

class FourTermConsumer(SparseQuotientConsumer):
    def check(self,row,literal=False):
        if row['order']<4:return super().check(row,literal)
        assert row['kind']=='sparse_quotient_obstruction' and row['order']==4
        side,J=row['side'],row['mandatory_opposite'];assert side in (0,1) and len(J)==len(set(J))
        U,V=(self.X,self.Z) if side==0 else (self.Z,self.X)
        assert all(0<=j<len(V) for j in J)
        w=int(row['witness_hex'],16);assert 0<w<1<<self.dimension
        residue=self.quotient(V[j] for j in J);target=residue(w);assert target
        labels=list({0,*(residue(v) for v in V)})
        pair_sums={x^y for k,x in enumerate(labels) for y in labels[k:]}
        # Including zero permits every shorter representation as well.
        assert pair_sums.isdisjoint({target^p for p in pair_sums})
        D=[i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J)]
        assert D==row['detecting_support'] and len(D)==4 and row['minimum_outside_basis_terms']==5
        clause=[-j-1-(len(self.X) if side==0 else 0) for j in J];assert row['clause']==clause
        if literal:
            from verify_four_term_small import check
            check(self.X,self.Z,row,self.dimension)
        return clause
