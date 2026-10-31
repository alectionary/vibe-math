"""Exact private-owner allocation with replayable Hall-deficiency witnesses."""


def allocation(owner_masks,demands):
    """Return an allocation, or bins B with sum demands[B] > |union owners[B]|.

    Each bit is one of at most16 selected operators. A bin requires its demand
    many distinct owners; an owner can serve only one bin. Augmenting paths
    find a maximum bipartite matching after replacing each demand by slots.
    The returned negative witness is checked by literal union/cardinality.
    """
    assert len(owner_masks)==len(demands) and all(n>=0 for n in demands)
    slots=[b for b,n in enumerate(demands) for _ in range(n)]
    slots.sort(key=lambda b:owner_masks[b].bit_count())
    matched={};assigned={}
    for slot,b in enumerate(slots):
        seen_owners=set();seen_bins=set()
        def augment(s):
            bin_id=slots[s];seen_bins.add(bin_id);available=owner_masks[bin_id]
            while available:
                bit=available&-available;available^=bit;o=bit.bit_length()-1
                if o in seen_owners:continue
                seen_owners.add(o)
                if o not in matched or augment(matched[o]):
                    matched[o]=s;assigned[s]=o;return True
            return False
        if not augment(slot):
            bins=sorted(seen_bins);union=0
            for c in bins:union|=owner_masks[c]
            required=sum(demands[c] for c in bins)
            assert required>union.bit_count()
            return {'possible':False,'bins':bins,'required':required,'available_owners':union,'deficiency':required-union.bit_count()}
    result=[[] for _ in demands]
    for o,s in matched.items():result[slots[s]].append(o)
    assert all(len(v)==n for v,n in zip(result,demands)) and sum(map(len,result))==len(set(o for v in result for o in v))
    assert all(owner_masks[b]>>o&1 for b,row in enumerate(result) for o in row)
    return {'possible':True,'allocation':result}


def literal_owners(pattern,selected,P=16):
    """Independent explicit degree counts, with no packed-column intersections."""
    zero=0;owners=0
    for j in range(P):
        neighbors=[i for i in range(P) if selected>>i&1 and pattern>>((j-i)%P)&1]
        if not neighbors:zero+=1
        elif len(neighbors)==1:owners|=1<<neighbors[0]
    return zero,owners
