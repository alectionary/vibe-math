"""Same CSS code, different generators: bounded feasibility, no noise study."""
from collections import Counter, deque
from itertools import combinations
from pathlib import Path
import hashlib
import json
import subprocess
import tempfile
import benchmark_decoding as b

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]


def geometry(rows,n=252):
    adjacency=[set() for _ in range(n+len(rows))]
    for c,w in enumerate(rows):
        for v in range(n):
            if w>>v&1:
                adjacency[v].add(n+c);adjacency[n+c].add(v)
    seen=set();sizes=[]
    for root in range(len(adjacency)):
        if root in seen:continue
        queue=[root];seen.add(root)
        for u in queue:
            for v in adjacency[u]:
                if v not in seen:seen.add(v);queue.append(v)
        sizes.append(len(queue))
    girth=len(adjacency)+1
    for root in range(len(adjacency)):
        dist={root:0};parent={root:-1};q=deque([root])
        while q:
            u=q.popleft()
            for v in adjacency[u]:
                if v not in dist:
                    dist[v]=dist[u]+1;parent[v]=u;q.append(v)
                elif parent[u]!=v:
                    girth=min(girth,dist[u]+dist[v]+1)
    four=sum(b.popcount(x&y)*(b.popcount(x&y)-1)//2 for x,y in combinations(rows,2))
    return dict(checks=len(rows),edges=sum(map(b.popcount,rows)),
                row_degree_histogram=dict(sorted(Counter(map(b.popcount,rows)).items())),
                variable_degree_histogram=dict(sorted(Counter(len(adjacency[v]) for v in range(n)).items())),
                connected_components=sorted(sizes),girth=girth,four_cycles=four)


def listrows(rows):
    return [[v for v in range(252) if w>>v&1] for w in rows]


def probes(rows):
    yield 'original',rows,dict(operation='identity')
    yield 'row_order_control',list(reversed(rows)),dict(operation='reverse check labels')
    redundant=next(i for i in range(len(rows)) if b.in_span(rows[i],b.basis(rows[:i]+rows[i+1:])))
    yield 'delete_one',rows[:redundant]+rows[redundant+1:],dict(operation='delete redundant row',row=redundant)
    kept=[]
    for i,w in enumerate(rows):
        if not b.in_span(w,b.basis([rows[j] for j in kept])):kept.append(i)
    yield 'independent_basis',[rows[j] for j in kept],dict(operation='retain greedy row basis',kept=kept)
    for overlap in [1,0]:
        j=next(j for j in range(1,len(rows)) if b.popcount(rows[0]&rows[j])==overlap)
        changed=rows.copy();changed[0]^=rows[j]
        yield f'xor_overlap_{overlap}',changed,dict(operation='row 0 XOR donor row; donor retained',row=0,donor=j,intersection=overlap)


def run():
    source=json.loads((HERE/'distance-matched-selection.json').read_text())
    census=json.loads((HERE/'logical-six-results.json').read_text())
    records=[];rigidity=[]
    paths=[Path(__file__),HERE/'representation_count.cpp',HERE/'benchmark_decoding.py',
           HERE/'minsum.cpp',HERE/'logical-six-results.json',HERE/'distance-matched-selection.json',HERE/'exact-distance-results.json',
           HERE.parent/'REPRESENTATION-PROTOCOL.md']
    frozen={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    (HERE/'representation-selection.json').write_text(json.dumps(dict(status='fixed_before_representation_enumeration',sha256=frozen),indent=2)+'\n')
    with tempfile.TemporaryDirectory(prefix='cyclic-representation-') as tmp:
        counter=Path(tmp)/'counter';decoder=Path(tmp)/'minsum'
        for src,out in [('representation_count.cpp',counter),('minsum.cpp',decoder)]:
            subprocess.run(['c++','-std=c++17','-O3',str(HERE/src),'-o',str(out)],check=True)
        for name,meta in source['codes'].items():
            hx,hz,_=b.construction(meta['B'],meta['r']);original=list(map(b.rowmask,hx))
            span=b.basis(original);zspan=b.basis(hz)
            # X-type stabilizers are exactly the H_X row space.
            item=next(r for r in census['records'] if r['name']==name and r['sector']=='x')
            weight6={b.rowmask(i['support']) for i in item['supports'] if not i['logical']}
            assert weight6==set(original) and len(weight6)==126
            rigidity.append(dict(design=name,weight_six_stabilizers=len(weight6),original_distinct_rows=len(set(original)),
                                 equality_verified=True,scope='126 distinct weight-six checks in unchanged H_X span'))
            logical=None
            # Use the existing certified opposite-sector distance-ten witness.
            exact=json.loads((HERE/'exact-distance-results.json').read_text())
            rec=next(r for r in exact['records'] if r['name']==name and r['sector']=='z')
            witness=next(s['witness'] for s in rec['searches'] if s['witness'])
            logical=b.rowmask(witness)
            assert not any(b.syndrome(original,logical)) and not b.in_span(logical,zspan)
            original_supports=None
            for label,rows,operation in probes(original):
                assert len(b.basis(rows))==121
                assert all(b.in_span(w,span) for w in rows)
                changed_span=b.basis(rows)
                assert all(b.in_span(w,changed_span) for w in original)
                assert all(b.popcount(x&z)%2==0 for x in rows for z in hz)
                rowlists=listrows(rows)
                data=[f'252 {len(rows)}']+[str(len(row))+' '+' '.join(map(str,row)) for row in rowlists]
                found=json.loads(subprocess.run([str(counter)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True).stdout)
                supports={tuple(s) for s in found}
                if label=='original':
                    original_supports=supports
                    assert len(supports)==meta['four_variable_absorbing_sets']
                profiles=Counter()
                for s in supports:
                    word=b.rowmask(s)
                    parity=[b.popcount(w&word)%2 for w in rows]
                    assert all(sum(1-2*parity[c] for c,w in enumerate(rows) if w>>v&1)>0 for v in s)
                    profiles[sum(parity)]+=1
                errors=[0]+[1<<v for v in range(12)]+[hz[0],logical]
                trials=[(.04,b.bit_string(e,252)) for e in errors]
                outputs=b.engine(decoder,rowlists,252,trials,100,.8)
                for (_,error),actual in zip(trials,outputs):
                    assert actual==b.reference_decode(rowlists,252,error,.04,100,.8)
                assert outputs[0]==(0,True,'0'*252)
                assert outputs[-2]==(0,True,'0'*252) and outputs[-1]==(0,True,'0'*252)
                records.append(dict(design=name,representation=label,operation=operation,hx_rows=rowlists,
                                    same_labeled_css_code=True,rank_hx=121,rank_hz=121,n=252,k=10,d_x=10,d_z=10,
                                    **geometry(rows),absorbing_count=len(supports),syndrome_weight_histogram=dict(sorted(profiles.items())),
                                    supports=sorted(map(list,supports)),lost_original_supports=len(original_supports-supports),
                                    gained_supports=len(supports-original_supports),decoder_reference_cases=len(trials)))
                print(name,label,'absorbing',len(supports),'girth',records[-1]['girth'],flush=True)
    for relative,digest in frozen.items():assert hashlib.sha256((ROOT/relative).read_bytes()).hexdigest()==digest
    out=dict(status='same_code_representation_feasibility_not_performance_experiment',new_noise_patterns=0,
             unchanged_decoder='minsum.cpp, p=.04, alpha=.8, 100 iterations',
             rigidity=rigidity,records=records,sha256=frozen)
    (HERE/'representation-results.json').write_text(json.dumps(out,indent=2)+'\n')


if __name__=='__main__':run()
