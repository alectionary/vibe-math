"""Independent checks of same-code check mergers and their count increments."""
from pathlib import Path
from collections import Counter,deque
from itertools import combinations
import hashlib,json,subprocess,sys,tempfile
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b
from scan import girth
from decoding import components,cycles8_projection,cycles8_dfs


def low_basis(words):
    p={}
    for w in words:
        while w:
            v=w&-w
            if v in p:w^=p[v]
            else:p[v]=w;break
    return p


def contains(w,p):
    while w:
        v=w&-w
        if v not in p:return False
        w^=p[v]
    return True


def graph(rows):
    out={('v',v):set() for v in range(252)}
    for c,row in enumerate(rows):
        out['c',c]={('v',v) for v in row}
        for v in row:out['v',v].add(('c',c))
    return out


def project_distances(rows,root):
    sets=list(map(set,rows));adj=[set() for _ in rows]
    for i,j in combinations(range(len(rows)),2):
        if sets[i]&sets[j]:adj[i].add(j);adj[j].add(i)
    distances={root:0};ways={root:1};queue=deque([root])
    while queue:
        u=queue.popleft()
        for v in sorted(adj[u]):
            if v not in distances:distances[v]=distances[u]+1;ways[v]=0;queue.append(v)
            if distances[v]==distances[u]+1:ways[v]+=ways[u]
    return distances,ways


d=json.loads((S/'degree-preserving-results.json').read_text())
selection=json.loads((S/'degree-preserving-selection.json').read_text())
assert d['sha256']==selection['sha256']
for rel,digest in d['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
assert d['new_noise_patterns']==d['new_Lean_declarations']==0 and len(d['records'])==2
source=json.loads((S/'distance-matched-selection.json').read_text())
old=json.loads((S/'representation-results.json').read_text())
for rel,digest in old['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
census=json.loads((S/'logical-six-results.json').read_text())
cases=0
with tempfile.TemporaryDirectory(prefix='degree-preserving-independent-') as tmp:
    binary=Path(tmp)/'counter'
    subprocess.run(['c++','-std=c++17','-O3',str(S/'representation_count_independent.cpp'),'-o',str(binary)],check=True)
    for rec in d['records']:
        name=rec['design'];meta=source['codes'][name];hx,hz,_=b.construction(meta['B'],14)
        base=list(map(b.rowmask,hx));new=list(map(b.rowmask,rec['hx_rows']))
        p,q=low_basis(base),low_basis(new)
        assert len(p)==len(q)==121 and all(contains(w,q) for w in base) and all(contains(w,p) for w in new)
        assert all(b.popcount(x&z)%2==0 for x in new for z in hz)
        # Independent certificate of minimum nonzero H_X span weight six.
        assert all(b.popcount(w)%2==0 for w in base)
        zcols=[sum(((w>>v)&1)<<c for c,w in enumerate(hz)) for v in range(252)]
        assert 0 not in zcols and len(set(zcols))==252
        pairs=[zcols[a]^zcols[z] for a,z in combinations(range(252),2)]
        assert 0 not in pairs and len(set(pairs))==31626
        six=next(r for r in census['records'] if r['name']==name and r['sector']=='x')
        assert {b.rowmask(s['support']) for s in six['supports'] if not s['logical']}==set(base)
        assert len(set(base))==126 and rec['minimum_nonzero_span_weight']==6
        adj=graph(rec['hx_rows'])
        assert girth(adj)==8 and components(adj)==[377]
        assert all(len(adj['v',v])==3 for v in range(252))
        assert Counter(map(len,rec['hx_rows']))==Counter({6:124,12:1})
        assert sum(map(len,rec['hx_rows']))==756
        data=['252 125']+[str(len(row))+' '+' '.join(map(str,row)) for row in rec['hx_rows']]
        found=json.loads(subprocess.run([str(binary)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True).stdout)
        assert found==rec['absorbing_supports'] and len(found)==rec['merged_absorbing_count']
        assert sum(cycles8_projection(adj).values())==len(found)
        assert cycles8_projection(adj)==cycles8_dfs(adj)
        original=next(r for r in old['records'] if r['design']==name and r['representation']=='original')
        a={tuple(s) for s in original['supports']};z={tuple(s) for s in found}
        assert not a-z and z-a=={tuple(s) for s in rec['gained_supports']}
        i,j=rec['representative_pair'];dist,ways=project_distances(hx,i)
        assert len(low_basis([w for c,w in enumerate(base) if c not in (i,j)]))==121
        assert dist[j]==4 and ways[j]==rec['gained_absorbing_count']==len(rec['shortest_path_witnesses'])
        original_graph=graph(hx);path_supports=set()
        for path in rec['shortest_path_witnesses']:
            assert len(path)==len(set(path))==9 and path[0]==252+i and path[-1]==252+j
            converted=[('v',v) if v<252 else ('c',v-252) for v in path]
            assert all(v in original_graph[u] for u,v in zip(converted,converted[1:]))
            path_supports.add(tuple(sorted(v for v in path if v<252)))
        assert path_supports==z-a
        hist=Counter();eligible=[]
        for aindex in range(126):
            distances,_=project_distances(hx,aindex)
            for bindex in range(aindex+1,126):
                distance=2*distances[bindex];hist[distance]+=1
                if distance>=8:eligible.append([aindex,bindex])
        assert eligible==rec['eligible_pairs']
        assert dict(hist)=={int(k):v for k,v in rec['check_pair_distance_histogram'].items()}
        assert len(rec['orbit_cases'])==14
        for case in rec['orbit_cases']:
            aindex,bindex=case['pair'];assert not base[aindex]&base[bindex]
            changed=[w if k!=aindex else base[aindex]^base[bindex] for k,w in enumerate(base) if k!=bindex]
            basis=low_basis(changed);assert len(basis)==121 and all(contains(w,basis) for w in base)
            rows=[[v for v in range(252) if w>>v&1] for w in changed]
            g=graph(rows)
            assert girth(g)==8 and components(g)==[377] and all(len(g['v',v])==3 for v in range(252))
            k=case['translation']
            translated={sum(1<<(14*(v//14)+(v%14+k)%14) for v in row) for row in rec['hx_rows']}
            assert translated==set(changed)
            assert case['absorbing_count']==len(found)
            cases+=1
        assert rec['decoder_control_cases']==267 and rec['direct_reference_cases']==20
        print(name,'PASS: same CSS span, degree 3, girth 8, count',len(a),'->',len(z),
              'with',len(z-a),'new shortest-path supports; 14 translated candidates',flush=True)
assert cases==28
print('PASS: 28 same-code degree/girth-preserving representations; independent span elimination, all-pair distance scans, full support enumeration, projected/DFS cycle counts and shortest-path dynamic counts agree. No decoding-performance experiment performed.')
