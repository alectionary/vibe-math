"""Shrink a fixed detecting witness by an exact hitting-set argument.

If J' is a subset of J and its residual detecting support is still D, absence
of at most q words modulo span(J) implies absence modulo span(J'). The only search
needed is thus a hitting set on at most16 mandatory coordinates, not new
ambient functionals or short-word decompositions.
"""
def minimize(U,V,row):
    assert 1<=row['order']<=4
    J=row['mandatory_opposite'];assert len(J)<=32 and len(J)==len(set(J))
    w=int(row['witness_hex'],16);D=set(row['detecting_support']);masks=set()
    for i,u in enumerate(U):
        if i in D or not (u&w).bit_count()%2:continue
        mask=sum(((u&V[j]).bit_count()%2)<<k for k,j in enumerate(J));assert mask;masks.add(mask)
    # A clause containing a smaller clause adds no hitting-set requirement.
    minimal=[]
    for mask in sorted(masks,key=lambda m:(m.bit_count(),m)):
        if not any(m&mask==m for m in minimal):minimal.append(mask)
    best=(1<<len(J))-1;nodes=0
    def visit(chosen,remaining):
        nonlocal best,nodes
        nodes+=1
        if not remaining:
            if (chosen.bit_count(),chosen)<(best.bit_count(),best):best=chosen
            return
        if chosen.bit_count()>=best.bit_count():return
        mask=min(remaining,key=int.bit_count)
        choices=[]
        while mask:
            bit=mask&-mask;mask-=bit;choices.append(bit)
        choices.sort(key=lambda b:-sum(bool(r&b) for r in remaining))
        for bit in choices:visit(chosen|bit,[r for r in remaining if not r&bit])
    visit(0,minimal);core=[j for k,j in enumerate(J) if best>>k&1]
    actual=[i for i,u in enumerate(U) if (u&w).bit_count()%2 and all(not (u&V[j]).bit_count()%2 for j in core)];assert actual==row['detecting_support']
    result=dict(row);result['mandatory_opposite']=core;result['clause']=[-j-1-(len(U) if row['side']==0 else 0) for j in core]
    return result,{'original_size':len(J),'reduced_size':len(core),'minimal_hitting_masks':len(minimal),'search_nodes':nodes,'minimum_cardinality_for_this_fixed_witness':True}
