"""Independent physical consumer for two disjoint forbidden detector pairs."""
from verify_detector_five import CapacityFiveConsumer
from verify_mixed_rank_cover_cuts import check as rank_check
class DoublePairConsumer(CapacityFiveConsumer):
    def check(self,row):
        assert row['kind']=='double_pair_capacity_obstruction';side=row['side'];J=row['mandatory_opposite'];assert side in (0,1) and len(J)==len(set(J)) and all(0<=j<720 for j in J)
        U,V=(self.X,self.Z) if side==0 else (self.Z,self.X);w=int(row['witness_hex'],16);assert 0<w<1<<128
        D=[i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J)]
        assert D==row['detecting_support'] and 4<=len(D)<=6;children=[];assert len(row['forbidden_children'])==2
        for reference in row['forbidden_children']:
            p=reference['provenance'];k,h=p['bank_index'],p['cyclic_shift'];assert 0<=k<len(self.bank) and 0<=h<16;child=self.bank[k];assert len(child['indices'])==2
            if k not in self.checked:
                if child['kind']=='z_zero':
                    X,Z=(self.X,self.Z) if child['sector']==0 else (self.Z,self.X);rank_check(X,Z,child['indices'],int(child['annihilator'],16))
                else:
                    assert child['kind'] in ('universal_sparse_quotient','universal_sparse_quotient_four');clause=self.child_consumer.check(child['certificate']);assert child['indices']==child['certificate']['mandatory_opposite'] and child['sector']==1-child['certificate']['side'];assert clause==[-i-1-720*child['sector'] for i in child['indices']]
                self.checked.add(k)
            K=sorted(16*(i//16)+(i%16+h)%16 for i in child['indices']);assert K==reference['indices'] and set(K)<=set(D);children.append(set(K))
        assert children[0].isdisjoint(children[1]);bound=len(D)-2;assert row['capacity_bound']==bound and row['minimum_outside_basis_terms']==bound+1
        residue=self.child_consumer.quotient(V[j] for j in J);target=residue(w);assert target;values=[0,*[residue(v) for v in V]]
        pairs={a^b for i,a in enumerate(values) for b in values[i:]};assert target not in pairs
        if bound>=3:assert all(target^a not in pairs for a in values)
        if bound>=4:assert pairs.isdisjoint({target^a for a in pairs})
        clause=[-j-1-720*(1-side) for j in J];assert row['clause']==clause;return clause
