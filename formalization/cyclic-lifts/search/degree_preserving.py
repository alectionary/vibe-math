"""Finite same-code check mergers preserving all column degrees and girth."""
from collections import Counter,deque
from itertools import combinations
from pathlib import Path
import hashlib,json,subprocess,tempfile
import benchmark_decoding as b
from representation_feasibility import geometry,listrows

HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]


def adjacency(rows,n=252):
    graph={i:set() for i in range(n+len(rows))}
    for c,row in enumerate(rows):
        for v in row:graph[v].add(n+c);graph[n+c].add(v)
    return graph


def distances(graph,root):
    out={root:0};q=deque([root])
    while q:
        u=q.popleft()
        for v in graph[u]:
            if v not in out:out[v]=out[u]+1;q.append(v)
    return out


def merge(rows,i,j):
    assert i<j and not rows[i]&rows[j]
    return [w if c!=i else rows[i]^rows[j] for c,w in enumerate(rows) if c!=j]


def shift(word,k=1):
    return sum(1<<(14*(v//14)+(v%14+k)%14) for v in range(252) if word>>v&1)


def shortest_paths(graph,source,target):
    dist=distances(graph,source);back=distances(graph,target);length=dist[target]
    found=[]
    def visit(path):
        u=path[-1]
        if u==target:found.append(path);return
        for v in sorted(graph[u]):
            if dist.get(v)==dist[u]+1 and dist[v]+back[v]==length:visit(path+[v])
    visit([source]);return found


def count(binary,rows):
    listing=listrows(rows)
    data=[f'252 {len(rows)}']+[str(len(row))+' '+' '.join(map(str,row)) for row in listing]
    return json.loads(subprocess.run([str(binary)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True).stdout)


def run():
    paths=[Path(__file__),HERE/'representation_feasibility.py',HERE/'benchmark_decoding.py',
           HERE/'representation_count.cpp',HERE/'representation_count_independent.cpp',HERE/'minsum.cpp',
           HERE/'distance-matched-selection.json',HERE/'representation-results.json',
           HERE/'exact-distance-results.json',HERE.parent/'DEGREE-PRESERVING-PROTOCOL.md']
    hashes={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    (HERE/'degree-preserving-selection.json').write_text(json.dumps(dict(status='fixed_before_absorbing_enumeration',sha256=hashes),indent=2)+'\n')
    source=json.loads((HERE/'distance-matched-selection.json').read_text())
    old=json.loads((HERE/'representation-results.json').read_text())
    exact=json.loads((HERE/'exact-distance-results.json').read_text())
    records=[]
    with tempfile.TemporaryDirectory(prefix='degree-preserving-') as tmp:
        binaries={}
        for name,file in [('counter','representation_count.cpp'),('independent','representation_count_independent.cpp'),('decoder','minsum.cpp')]:
            binary=Path(tmp)/name
            subprocess.run(['c++','-std=c++17','-O3',str(HERE/file),'-o',str(binary)],check=True);binaries[name]=binary
        for name,meta in source['codes'].items():
            hx,hz,_=b.construction(meta['B'],14);rows=list(map(b.rowmask,hx));graph=adjacency(hx)
            spans=b.basis(rows);zspan=b.basis(hz)
            histogram=Counter();eligible=[]
            for i in range(126):
                ds=distances(graph,252+i)
                for j in range(i+1,126):
                    histogram[ds[252+j]]+=1
                    if ds[252+j]>=8:eligible.append((i,j))
            assert len(eligible)==14 and max(histogram)==8
            i,j=eligible[0];representative=merge(rows,i,j)
            geodesics=shortest_paths(graph,252+i,252+j)
            assert all(len(p)==9 and len(set(p))==9 for p in geodesics)
            path_supports={tuple(sorted(v for v in p if v<252)) for p in geodesics}
            assert len(path_supports)==len(geodesics)
            found=count(binaries['counter'],representative)
            assert found==count(binaries['independent'],representative)
            supports={tuple(s) for s in found}
            original=next(r for r in old['records'] if r['design']==name and r['representation']=='original')
            old_supports={tuple(s) for s in original['supports']}
            assert not old_supports-supports and supports-old_supports==path_supports
            # Verify all representative supports belong to the same (4,4) class.
            for support in supports:
                word=b.rowmask(support);odd=[b.popcount(w&word)%2 for w in representative]
                assert sum(odd)==4
                assert all(sum(odd[c] for c,w in enumerate(representative) if w>>v&1)==1 for v in support)
            index={w:c for c,w in enumerate(rows)};orbit=[]
            cases=[]
            for k in range(14):
                pair=tuple(sorted([index[shift(rows[i],k)],index[shift(rows[j],k)]]));orbit.append(pair)
                changed=merge(rows,*pair);pivots=b.basis(changed)
                assert len(pivots)==121 and all(b.in_span(w,pivots) for w in rows)
                assert all(b.in_span(w,spans) for w in changed)
                assert all(b.popcount(x&z)%2==0 for x in changed for z in hz)
                assert {shift(w,k) for w in representative}==set(changed)
                geo=geometry(changed)
                assert geo['girth']==8 and geo['four_cycles']==0 and geo['connected_components']==[377]
                assert geo['variable_degree_histogram']=={3:252} and geo['row_degree_histogram']=={6:124,12:1}
                assert geo['checks']==125 and geo['edges']==756
                shifted={tuple(sorted(14*(v//14)+(v%14+k)%14 for v in s)) for s in supports}
                assert len(shifted)==len(supports)
                # Recheck absorbing membership after translation, not only orbit size.
                cols=[sum((1<<c) for c,w in enumerate(changed) if w>>v&1) for v in range(252)]
                for support in shifted:
                    odd=0
                    for v in support:odd^=cols[v]
                    assert b.popcount(odd)==4 and all(b.popcount(odd&cols[v])==1 for v in support)
                cases.append(dict(pair=list(pair),translation=k,rank=121,absorbing_count=len(supports),**geo))
            assert set(orbit)==set(eligible) and len(set(orbit))==14
            # Absence of kernel weights two and four implies minimum span weight six.
            zcols=[sum(((w>>v)&1)<<c for c,w in enumerate(hz)) for v in range(252)]
            assert len(set(zcols))==252 and 0 not in zcols
            pairsynd=[zcols[a]^zcols[c] for a,c in combinations(range(252),2)]
            assert 0 not in pairsynd and len(set(pairsynd))==31626
            # All rows in H_X span are even, excluding weights one, three and five.
            assert all(b.popcount(w)%2==0 for w in rows)
            logical=b.rowmask(next(s['witness'] for r in exact['records'] if r['name']==name and r['sector']=='z' for s in r['searches'] if s['witness']))
            errors=[0]+[1<<v for v in range(252)]+[hz[0],logical]
            selected=[0,1,14,55,127,252,253,254]
            for a in range(12):errors.append((1<<a)|(1<<((a+43)%252)))
            trials=[(.04,b.bit_string(w,252)) for w in errors]
            outcomes=b.engine(binaries['decoder'],listrows(representative),252,trials,100,.8)
            for q in selected+list(range(255,len(errors))):
                assert outcomes[q]==b.reference_decode(listrows(representative),252,trials[q][1],.04,100,.8)
            assert all(matched and b.in_span(error^b.string_mask(estimate),zspan) for error,(_,matched,estimate) in zip(errors[:254],outcomes[:254]))
            assert outcomes[254]==(0,True,'0'*252) and not b.in_span(logical,zspan)
            records.append(dict(design=name,original_absorbing_count=len(old_supports),merged_absorbing_count=len(supports),
                                gained_absorbing_count=len(path_supports),lost_absorbing_count=0,representative_pair=[i,j],
                                hx_rows=listrows(representative),absorbing_supports=found,
                                gained_supports=sorted(map(list,path_supports)),shortest_path_witnesses=geodesics,
                                check_pair_distance_histogram=dict(sorted(histogram.items())),eligible_pairs=list(map(list,eligible)),
                                orbit_cases=cases,minimum_nonzero_span_weight=6,fixed_126_check_rigidity=True,
                                decoder_control_cases=len(errors),direct_reference_cases=len(selected)+len(errors)-255))
            print(name,'pair',(i,j),'absorbing',len(old_supports),'->',len(supports),'gained',len(path_supports),
                  'degree=3, girth=8, same CSS span; all 14 translates verified',flush=True)
    for rel,digest in hashes.items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==digest,rel
    out=dict(status='same_code_degree_three_girth_eight_count_changes_verified',new_noise_patterns=0,
             new_Lean_declarations=0,check_count_changed=[126,125],records=records,sha256=hashes)
    (HERE/'degree-preserving-results.json').write_text(json.dumps(out,indent=2)+'\n')


if __name__=='__main__':run()
