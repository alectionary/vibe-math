"""Reusable independent checks of necessary X-selection clauses."""
from rank_oracle import rotate_value


def echelon(values):
    rows={}
    for value in values:
        while value:
            p=(value&-value).bit_length()-1
            if p not in rows:rows[p]=value;break
            value^=rows[p]
    return rows


def in_span(value,rows):
    while value:
        p=(value&-value).bit_length()-1
        if p not in rows:return False
        value^=rows[p]
    return True


class CutChecker:
    def __init__(self,X,Z,cyclic=True):
        self.X=X;self.Z=Z;self.az=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z];self.prepared=None
        if cyclic:
            assert all(rotate_value(v,h)==V[(i//16)*16+(i%16+h)%16] for V in [X,Z] for i,v in enumerate(V) for h in range(16))
    def check(self,row):
        ids=row['indices'];assert len(ids)==len(set(ids)) and all(0<=i<len(self.X) for i in ids)
        assert row['clause']==[-i-1 for i in ids]
        kind=row['kind'];bits=sum(1<<i for i in ids)
        if kind=='x_circuit':
            assert ids
            value=0
            for i in ids:value^=self.X[i]
            assert value==0
        elif kind in ['z_zero','z_eligible']:
            w=int(row['annihilator'],16);assert 0<w<(1<<128)
            if kind=='z_zero':
                span=echelon(self.X[i] for i in ids);assert len(span)==len(ids) and not in_span(w,span)
                assert all(not (w&z).bit_count()%2 for z,mask in zip(self.Z,self.az) if not mask&bits)
            else:assert all(not (w&z).bit_count()%2 for z,mask in zip(self.Z,self.az) if (mask&bits).bit_count()<=1)
        elif kind=='forced_propagation':
            from forced_propagation import propagate_prepared
            if self.prepared is None:
                ax=[{j for j,z in enumerate(self.Z) if (x&z).bit_count()%2} for x in self.X]
                az=[{i for i,x in enumerate(self.X) if (x&z).bit_count()%2} for z in self.Z]
                self.prepared=(ax,az)
            assert not propagate_prepared(self.X,self.Z,*self.prepared,ids)['possible']
        else:raise ValueError(kind)
        return True
