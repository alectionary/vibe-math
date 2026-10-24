"""Exact, exhaustive four-triple comparison with the classical C14 pattern.

Enumerate the 2^11 possible collections of check supports of size >=2 on four
variables. Linearity permits at most one check for any such support and forbids
two supports from sharing a pair. Private checks fill each variable to degree 3.
This covers every four-column cubic linear incidence up to private-check labels.
It is an external finite computation, not a general Lean classification theorem.
"""
import itertools, json, hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parent
V = range(4)
large = [frozenset(t) for k in (2,3,4) for t in itertools.combinations(V,k)]
perms = list(itertools.permutations(V))

def canonical(supports):
    return min(tuple(sorted(tuple(sorted(p[i] for i in s)) for s in supports)) for p in perms)

def enumerate_shapes():
    shapes = {}; labeled = 0
    for bits in range(1 << len(large)):
        shared = [s for i,s in enumerate(large) if bits >> i & 1]
        deg = [sum(i in s for s in shared) for i in V]
        if any(d > 3 for d in deg): continue
        pairs = [p for s in shared for p in itertools.combinations(sorted(s),2)]
        if len(set(pairs)) != len(pairs): continue
        labeled += 1
        supports = shared + [frozenset([i]) for i in V for _ in range(3-deg[i])]
        key = canonical(supports)
        elementary = all(len(s) <= 2 for s in supports)
        odd = sum(len(s) % 2 for s in supports)
        absorbing = all(sum(i in s and len(s)%2 == 1 for s in supports) <
                        sum(i in s and len(s)%2 == 0 for s in supports) for i in V)
        shapes.setdefault(key, dict(supports=key, degree_sequence=sorted(map(len,supports)),
                                   elementary=elementary, odd_checks=odd, absorbing=absorbing))
    rows = sorted(shapes.values(), key=lambda x:(len(x['supports']), x['supports']))
    assert len(rows) == 16
    targets = [r for r in rows if r['elementary'] and r['odd_checks'] == 2]
    assert len(targets) == 1 and targets[0]['absorbing']
    assert targets[0]['degree_sequence'] == [1,1,2,2,2,2,2]
    assert all(r['elementary'] for r in rows if r['odd_checks'] == 2)
    return dict(candidate_shared_support_families=1 << len(large),
                labeled_valid_families=labeled, nonisomorphic_shapes=rows,
                unique_elementary_42_shape=targets[0])

def sts_counts(blocks, points):
    assert all(len(b)==3 for b in blocks) and len(set(blocks))==len(blocks)
    assert all(sum(x in b and y in b for b in blocks)==1 for x,y in itertools.combinations(points,2))
    counts={0:0,2:0}
    for chosen in itertools.combinations(blocks,4):
        d=[sum(p in b for b in chosen) for p in points]
        if max(d)>2:continue
        odd=sum(t%2 for t in d)
        if odd in counts: counts[odd]+=1
    v=len(points)
    assert 4*counts[2]+24*counts[0]==v*(v-1)*(v-3)
    root_count=0;delta_count=0;missing_count=0
    for u,w in itertools.permutations(blocks,2):
        if not u&w:continue
        root_count+=1
        common=[b for b in blocks if b!=u and b!=w and b&u and b&w and not b&u&w]
        assert len(common)==4
        adjacent=sum(bool(a&b) for a,b in itertools.combinations(common,2))
        delta=adjacent-4
        energy=sum(sum(c in b for b in common)**2 for c in points)
        missing=sum(not (a&b) for a,b in itertools.permutations(common,2))
        assert delta in (0,1,2) and energy==20+2*delta and missing==4-2*delta
        delta_count+=delta;missing_count+=missing
    r=(v-1)//2
    assert root_count==v*r*(r-1) and delta_count==12*counts[0] and missing_count==4*counts[2]
    return dict(v=v, blocks=len(blocks), four_subsets_checked=len(list(itertools.combinations(blocks,4))),
                N42=counts[2], Pasch=counts[0], classical_1995_identity=True,
                ordered_central_pairs=root_count,each_proper_common_card=4,
                diagonal_equality_sum=delta_count,ordered_missing_pair_sum=missing_count,
                written_STS_root_specialization_checked=True)

def main():
    fano=sorted({frozenset([x,y,x^y]) for x,y in itertools.combinations(range(1,8),2)})
    pts=[(x,y) for x in range(3) for y in range(3)]
    affine=sorted({frozenset(((x+t*a)%3,(y+t*b)%3) for t in range(3))
                   for x,y in pts for a,b in pts if (a,b)!=(0,0)})
    # The STS(13) trade was already credited in the first block to
    # Jiang et al., arXiv:2605.13690v1, Appendix F.1. It is not a new witness.
    thirteen={tuple(sorted((i,(i+a)%13,(i+b)%13)))
              for i in range(13) for a,b in [(1,4),(2,7)]}
    old={(3,4,7),(3,5,10),(4,10,12),(5,7,12)}
    new={(3,4,10),(3,5,7),(4,7,12),(5,10,12)}
    assert old <= thirteen
    traded=(thirteen-old)|new
    t13=[frozenset(b) for b in sorted(thirteen)]
    t13prime=[frozenset(b) for b in sorted(traded)]
    def gram(blocks):
        return [[sum(x in b and y in b for b in blocks) for y in range(13)] for x in range(13)]
    assert gram(t13)==gram(t13prime)==[[6 if x==y else 1 for y in range(13)] for x in range(13)]
    decompositions=[]
    for right in ([0,22,14],[0,22,8]):
        blocks=[{(a+e)%24 for e in offsets} for offsets in ([0,1,5],right) for a in range(24)]
        assert all(len({x%3 for x in block})==3 for block in blocks)
        decompositions.append(dict(right_socket_offsets=right,column_count=48,
                                   color='check coordinate modulo 3',every_column_meets_all_three_groups=True))
    r=dict(evidence='exact_finite_computation', shapes=enumerate_shapes(),
           classical_consumers=[sts_counts(fano,list(range(1,8))),sts_counts(affine,pts),
                                sts_counts(t13,list(range(13))),sts_counts(t13prime,list(range(13)))],
           existing_sts13_credit='Jiang et al., arXiv:2605.13690v1, Appendix F.1; preserved first-block research.py data',
           existing_sts13_same_integer_point_Gram=True,
           gb48_three_group_consumers=decompositions,
           limit='Checks the finite shape translation and four classical consumer systems, including a previously credited STS(13) trade. The general 1995 STS counting theorem is attributed to its authors and is not formalized here.',
           script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
    (ROOT/'classical-shape-check.json').write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps(dict(shapes=len(r['shapes']['nonisomorphic_shapes']), consumers=r['classical_consumers'])))

if __name__=='__main__':main()
