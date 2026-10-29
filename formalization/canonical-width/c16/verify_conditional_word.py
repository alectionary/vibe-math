"""Independent RREF quotient consumer for conditional short-word clauses."""
import collections
from verify_full_span_frame import check_row as check_span_row
class WordConsumer:
    def __init__(self,X,Z,A):
        self.X=X;self.Z=Z;self.A=A;self.columns=[sum(((row>>j)&1)<<i for i,row in enumerate(A)) for j in range(len(Z))];self.cache=collections.OrderedDict()
    def quotient(self,side,ids):
        key=(side,tuple(ids))
        if key in self.cache:self.cache.move_to_end(key);return self.cache[key]
        opposite=(self.Z,self.X)[side];rows={}
        for i in ids:
            v=opposite[i]
            for pivot,row in sorted(rows.items()):
                if v>>pivot&1:v^=row
            if not v:continue
            pivot=(v&-v).bit_length()-1
            for other,row in list(rows.items()):
                if row>>pivot&1:rows[other]=row^v
            rows[pivot]=v
        def residue(v):
            for pivot,row in rows.items():
                if v>>pivot&1:v^=row
            return v
        labels={residue(v) for v in opposite};out=(rows,labels);self.cache[key]=out
        if len(self.cache)>256:self.cache.popitem(last=False)
        return out
    def check(self,row):
        if row['kind']!='conditional_no_short_word':return check_span_row(self.X,self.Z,self.A,row,self.columns)
        side=row['side'];assert side in (0,1);V=(self.X,self.Z)[side];opposite=(self.Z,self.X)[side];owner=lambda s,i:i+1+(len(self.X) if s else 0);ids=row['mandatory_opposite'];assert len(ids)==len(set(ids)) and all(0<=i<len(opposite) for i in ids);w=int(row['annihilator_hex'],16);assert 0<w<1<<128;rows,labels=self.quotient(side,ids);target=w
        for pivot,r in rows.items():
            if target>>pivot&1:target^=r
        assert target and target not in labels and not any(target^v in labels for v in labels)
        masks=(self.A,self.columns)[side];selected=sum(1<<i for i in ids);support=[i for i,v in enumerate(V) if not masks[i]&selected and (v&w).bit_count()%2];assert support==row['positive_support'];allowed=row['allowed_support_indices'];assert len(allowed)==len(set(allowed))<=2 and set(allowed)<=set(support);assert row['minimum_outside_basis_terms']==3;expected=[-owner(1-side,i) for i in ids]+[owner(side,i) for i in support if i not in allowed];assert expected==row['clause'];return expected
