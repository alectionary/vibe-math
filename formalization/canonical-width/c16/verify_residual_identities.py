#!/usr/bin/env python3
"""Independent physical replay of residual identities and global cover cuts.

Standard library only; neither producer nor SAT/optimization libraries imported.
UNSAT covers are checked separately by verify_signature_cover.py + DRAT-trim.
"""
from pathlib import Path
import argparse
import itertools
import json
import time

ROOT=Path(__file__).resolve().parent


def rank(vs):
    piv={}
    for v in vs:
        while v:
            b=v&-v
            if b not in piv:piv[b]=v;break
            v^=piv[b]
    return len(piv)


def canonical(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def algebra_controls():
    total=0;separated=0
    dot=lambda x,z:(x&z).bit_count()%2
    for n in range(1,4):
        for X in itertools.permutations(range(1,1<<n),n):
            if rank(X)!=n:continue
            Z=[next(z for z in range(1<<n) if all(dot(x,z)==(i==j) for j,x in enumerate(X))) for i in range(n)]
            for selected in range(1<<n):
                R=[1<<i for i in range(n)];m=selected.bit_count()
                for k in range(n):
                    if selected>>k&1:
                        for i in range(n):
                            if X[k]>>i&1:R[i]^=Z[k]
                assert rank(R)==n-m
                for row in R:
                    assert row==__import__('functools').reduce(int.__xor__,(R[j] for j in range(n) if row>>j&1),0)
                if m<n:
                    i=next(i for i,r in enumerate(R) if r);j=(R[i]&-R[i]).bit_length()-1
                    assert sum(((X[k]>>i)&1)*((Z[k]>>j)&1) for k in range(n) if selected>>k&1)%2 != (i==j)
                    assert sum(((X[k]>>i)&1)*((Z[k]>>j)&1) for k in range(n))%2 == (i==j)
                    separated+=1
                total+=1
    return {'partial_projectors_checked':total,'nonfull_partial_matchings_separated':separated}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text())
    Zp=[shift(mask(seed),h) for seed in source['Z_orbit_representatives'] for h in range(16)]
    Xp=list(map(exchange,Zp))
    seeds={s:[shift(mask(seed[s]),h) for seed in source['canonical_seeds'] for h in range(16)] for s in ['X','Z']}
    beta=lambda x,z:(x&z).bit_count()%2
    assert all(beta(x,z)==(i==j) for i,x in enumerate(seeds['X']) for j,z in enumerate(seeds['Z']))
    X=[sum(beta(x,z)<<i for i,z in enumerate(seeds['Z'])) for x in Xp]
    Z=[sum(beta(x,z)<<i for i,x in enumerate(seeds['X'])) for z in Zp]
    assert rank(X)==rank(Z)==128
    assert all(beta(x,z)==beta(X[i],Z[j]) for i,x in enumerate(Xp) for j,z in enumerate(Zp))

    def check_matching(pairs):
        assert len(set(map(tuple,pairs)))==len(pairs)
        for k,(i,j) in enumerate(pairs):
            assert 0<=i<720 and 0<=j<720 and beta(Xp[i],Zp[j])
            for ii,jj in pairs[:k]:
                assert i!=ii and j!=jj and not beta(Xp[i],Zp[jj]) and not beta(Xp[ii],Zp[j])

    free_edges=[(i,j) for i in range(720) if i!=48 and not beta(Xp[i],Zp[48])
                for j in range(720) if j!=48 and not beta(Xp[48],Zp[j]) and beta(Xp[i],Zp[j])]
    assert len(free_edges)==53511
    folder=ROOT/'residual-identity-results';adaptive=[]
    for path in sorted(folder.glob('adaptive-anchor*.json')):
        d=json.loads(path.read_text());eqs=d['equations'];positives=0;separations=0;sizes=[]
        assert d['edge_count']==len(free_edges)
        functionals=[sum(int(eq['u_hex'],16)<<(128*i) for i in range(128) if int(eq['v_hex'],16)>>i&1) for eq in eqs]
        for eq in eqs:
            u,v=int(eq['u_hex'],16),int(eq['v_hex'],16)
            assert 0<=u<1<<128 and 0<=v<1<<128
            assert beta(u,v)==eq['full_target']
            assert beta(X[48],v)*beta(u,Z[48])==eq['anchor_value']
            assert sum(beta(X[i],v)*beta(u,Z[j]) for i,j in free_edges)==eq['free_edges_with_value_one']
        for r in d['records']:
            if r['answer'] is not True:continue
            pairs=r['partial_matching'];assert pairs[0]==d['anchor']==[48,48]
            check_matching(pairs)
            R=[1<<i for i in range(128)]
            for i,j in pairs:
                for k in range(128):
                    if X[i]>>k&1:R[k]^=Z[j]
            assert R==list(map(lambda s:int(s,16),r['residual_rows_hex']))
            assert rank(R)==128-len(pairs)
            for row in R:
                squared=0
                for j in range(128):
                    if row>>j&1:squared^=R[j]
                assert squared==row
            for eq in eqs[:r['equation_count']]:
                u,v=int(eq['u_hex'],16),int(eq['v_hex'],16)
                assert sum(beta(X[i],v)*beta(u,Z[j]) for i,j in pairs)%2==beta(u,v)
            if 'selected_next_equation' in r:
                row,col=r['selected_next_equation'];assert R[row]>>col&1
                nxt=eqs[r['equation_count']]
                assert int(nxt['u_hex'],16)==1<<col and int(nxt['v_hex'],16)==1<<row
                assert rank(functionals[:r['equation_count']+1])==rank(functionals[:r['equation_count']])+1
                separations+=1
            positives+=1;sizes.append(len(pairs))
        adaptive.append({'file':path.name,'equations_saved':len(eqs),'functional_rank':rank(functionals),'positive_partial_matchings_checked':positives,'adaptive_separations_checked':separations,'max_equations_with_positive_witness':max((r['equation_count'] for r in d['records'] if r['answer'] is True),default=None),'partial_sizes':[min(sizes),max(sizes)] if sizes else None,'unknown_calls':sum(r['answer'] is None for r in d['records'])})
    global_records=[]
    def signature(pairs):
        value=0
        for i,j in pairs:
            value^=sum((beta(Xp[i],Zp[608+t])*beta(Xp[608+t],Zp[j]))<<t for t in range(16))
        return value
    for path in sorted(folder.glob('global-cover*.json')):
        d=json.loads(path.read_text());checked=0
        for pairs in d['seed_witnesses']:
            check_matching(pairs);assert signature(pairs)==65535;checked+=1
        for r in d['trials']:
            if r['answer'] is not True:continue
            pairs=r['counterexample_edges'];check_matching(pairs);assert signature(pairs)==65535
            assert {canonical(i,j) for i,j in pairs}==set(map(tuple,r['counterexample_classes']));checked+=1
        global_records.append({'file':path.name,'valid_hitting_set_witnesses_checked':checked,'unknown_calls':len(d['unknown_candidates']),'discovery_best':d['retained_case_count']})
    compact=[]
    for path in sorted(folder.glob('compact-attempts*.json')):
        d=json.loads(path.read_text());checked=0
        for r in d['records']:
            if r['answer'] is not True:continue
            pairs=r['partial_matching'];check_matching(pairs);assert signature(pairs)==65535
            assert all(canonical(i,j) in set(map(tuple,r['removed_classes'])) for i,j in pairs);checked+=1
        compact.append({'file':path.name,'SAT_witnesses_checked':checked})
    compact_greedy=[]
    for path in sorted(folder.glob('compact-greedy-*.json')):
        d=json.loads(path.read_text())
        if 'trials' not in d:continue
        prior=json.loads(Path(d['prior']).read_text());initial=set(map(tuple,prior['removed_case_tuples']));checked=0;unresolved=[]
        for r in d['trials']:
            if r['answer'] is True:
                pairs=r['partial_matching'];check_matching(pairs);assert signature(pairs)==65535
                support={canonical(i,j) for i,j in pairs}
                assert support==set(map(tuple,r['support_classes'])) and support<=initial|{tuple(r['case'])}
                checked+=1
            elif r['answer'] is False:initial.add(tuple(r['case']))
            else:unresolved.append(r['case'])
        assert initial==set(map(tuple,d['removed_case_tuples']))
        compact_greedy.append({'file':path.name,'SAT_hitting_witnesses_checked':checked,'unresolved_classes':unresolved})
    extension=None
    ep=folder/'compact-extension.json'
    if ep.exists():
        d=json.loads(ep.read_text());checked=0
        for r in d['records']:
            if r['answer'] is True:
                pairs=r['partial_matching'];check_matching(pairs);assert signature(pairs)==65535
                assert all(canonical(i,j) in set(map(tuple,r['trial_removed_classes'])) for i,j in pairs)
                checked+=1
        extension={'SAT_hitting_witnesses_checked':checked,'unknown_calls':sum(r['answer'] is None for r in d['records']),'discovery_UNSAT_improvements':sum(r['answer'] is False for r in d['records']),'discovery_best':d['retained_case_count']}
    packing=None
    pp=folder/'method-cover-packing.json'
    if pp.exists():
        d=json.loads(pp.read_text());used=set();singletons=0
        for r in d['disjoint_class_supports']:
            pairs=r['partial_matching'];check_matching(pairs);assert signature(pairs)==65535
            support={canonical(i,j) for i,j in pairs};assert support==set(map(tuple,r['classes']))
            assert not used&support;used.update(support);singletons+=int(len(support)==1)
        count=len(d['disjoint_class_supports']);assert count==d['method_cover_lower_bound']
        packing={'method_cover_lower_bound':count,'disjoint_witness_supports_checked':count,'singleton_supports':singletons,'scope':'Only covers proved by the original16-signature partial-induced-matching UNSAT criterion; not arbitrary covers or full-frame feasibility.'}
    controls=algebra_controls()
    result={'status':'PASS','source_C16_answered':False,'physical_pairings_checked':518400,'all_compatible_free_edges_rebuilt':len(free_edges),'adaptive_replays':adaptive,'global_cut_replays':global_records,'compact_SAT_replays':compact,'compact_greedy_replays':compact_greedy,'monotone_extension_replay':extension,'disjoint_packing_replay':packing,'small_algebra_controls':controls,'elapsed_seconds':time.monotonic()-start,'scope':'Physical positive witnesses and separating equations only. No unknown or discovery UNSAT is a proved exclusion. Cover UNSAT must pass separate physical CNF/DRAT replay.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':main()
