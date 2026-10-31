"""Conditional absence of one- and two-term allowed dual representations."""
from conditional_span_oracle import NativeConditionalSpan,in_span
from bounded_span_oracle import BoundedSpanOracle
class WordNativeConditionalSpan(NativeConditionalSpan):
    def check(self,values):
        assert len(values)==self.total
        for i,v in enumerate(values):self.values[i]=v
        n=self.fn(self.ctx,self.values,self.out,4);assert 0<=n<=4,n;records=[]
        for raw in self.out[:n]:
            side=raw.side;assert side in (0,1) and 0<=raw.count<=129;ids=list(raw.ids[:raw.count]);assert len(ids)==len(set(ids));V=(self.X,self.Z)[side];other=(self.Z,self.X)[side];pairings=(self.rows,self.cols)[side]
            if raw.kind==1:
                assert ids and all(0<=i<len(V) for i in ids);v=0
                for i in ids:v^=V[i]
                assert v==0;clause=[-self.owner(side,i) for i in ids];record={'kind':'basis_circuit','side':side,'indices':ids,'clause':clause}
            else:
                assert raw.kind in (2,3,4) and all(0<=i<len(other) for i in ids);w=raw.lo|(raw.hi<<64);assert 0<w<1<<self.dimension and not in_span(w,[other[i] for i in ids]);mask=sum(1<<i for i in ids);support=[i for i,v in enumerate(V) if not pairings[i]&mask and (v&w).bit_count()%2]
                if raw.kind==4:
                    live=[i for i in support if values[self.owner(side,i)-1]>=0];assert len(live)<=2
                    piv,groups=self.quotient_groups(side,tuple(ids));target=self.remainder(w,piv);assert target not in groups and all(target^key not in groups for key in groups)
                    clause=[-self.owner(1-side,j) for j in ids]+[self.owner(side,i) for i in support if i not in live]
                    record={'kind':'conditional_no_short_word','side':side,'mandatory_opposite':ids,'annihilator_hex':hex(w),'positive_support':support,'allowed_support_indices':live,'minimum_outside_basis_terms':3,'clause':clause}
                elif raw.kind==2:
                    clause=[-self.owner(1-side,j) for j in ids]+[self.owner(side,i) for i in support];record={'kind':'conditional_span','side':side,'mandatory_opposite':ids,'annihilator_hex':hex(w),'positive_support':support,'clause':clause}
                else:
                    omitted=raw.omitted;assert omitted in support;piv,groups=self.quotient_groups(side,tuple(ids));partners=groups.get(self.remainder(w,piv),[]);clause=[-self.owner(1-side,j) for j in ids]+[self.owner(side,i) for i in support if i!=omitted]+[self.owner(1-side,j) for j in partners];record={'kind':'conditional_private_partner','side':side,'mandatory_opposite':ids,'annihilator_hex':hex(w),'positive_support':support,'omitted_positive_index':omitted,'possible_partners':partners,'clause':clause}
            assert not any(values[abs(lit)-1]==(1 if lit>0 else -1) for lit in clause),'native certificate is already satisfied'
            assert sum(values[abs(lit)-1]==0 for lit in clause)<=1,'native certificate is not unit or conflicting'
            records.append(record)
        return records

class WordSpanOracle(BoundedSpanOracle):
    def __init__(self,X,Z,library,path,dimension=128,**kwargs):
        super().__init__(X,Z,library,path,dimension=dimension,**kwargs)
        self.native.close();self.native=WordNativeConditionalSpan(X,Z,library,dimension)
