"""Independent binary algebra on the three edge matchings; no decoder distance oracle."""
from pathlib import Path
from itertools import combinations
import json
import stim

def basis(rows):
    piv={}
    for v in rows:
        while v:
            i=v.bit_length()-1
            if i in piv:v^=piv[i]
            else:piv[i]=v;break
    return piv
def in_span(v,piv):
    while v:
        i=v.bit_length()-1
        if i not in piv:return False
        v^=piv[i]
    return True

def check(c):
    edges=[]
    for ins in c.flattened():
        if ins.name=='MPP':edges.append([tuple(t.value for t in g) for g in ins.target_groups()])
        if len(edges)==3:break
    n=c.num_qubits;faces={}
    for missing in range(3):
        adj={i:[] for i in range(n)}
        for color in range(3):
            if color==missing:continue
            for a,b in edges[color]:adj[a].append(b);adj[b].append(a)
        unseen=set(adj);fs=[]
        while unseen:
            todo=[min(unseen)];component=set()
            while todo:
                u=todo.pop()
                if u in component:continue
                component.add(u);todo.extend(adj[u])
            unseen-=component;fs.append(component)
        faces[missing]=fs
    results=[]
    for color in range(3):
        pairing=edges[color];xchecks=[];zchecks=[]
        for missing,fs in faces.items():
            for f in fs:
                if missing==color:
                    zchecks.append(sum(1<<i for i,(a,b) in enumerate(pairing) if ((a in f)!=(b in f))))
                else:
                    assert all((a in f)==(b in f) for a,b in pairing)
                    xchecks.append(sum(1<<i for i,(a,b) in enumerate(pairing) if a in f))
        assert all((x&z).bit_count()%2==0 for x in xchecks for z in zchecks)
        distances=[]
        for constraints,trivial in [(xchecks,zchecks),(zchecks,xchecks)]:
            piv=basis(trivial);found=None
            for weight in range(1,5):
                for support in combinations(range(len(pairing)),weight):
                    v=sum(1<<j for j in support)
                    if all((v&h).bit_count()%2==0 for h in constraints) and not in_span(v,piv):found=weight;break
                if found is not None:break
            distances.append(found)
        results.append({'color':color,'effective_qubits':len(pairing),'rank_X':len(basis(xchecks)),
            'rank_Z':len(basis(zchecks)),'logical_qubits':len(pairing)-len(basis(xchecks))-len(basis(zchecks)),
            'X_Z_distances':distances,'null_distance_means':'greater than 4; search stopped at weight 4'})
    return {'data_qubits':n,'edges':sum(map(len,edges)),'faces':sum(map(len,faces.values())),
        'euler_characteristic':n-sum(map(len,edges))+sum(map(len,faces.values())),
        'restricted_codes':results,'embedded_distance':min(d for r in results for d in r['X_Z_distances'] if d is not None)}

if __name__=='__main__':
    import argparse
    ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,required=True);a=ap.parse_args()
    results={}
    for l in [1,2]:
        p=next(a.source.glob(f'*_l={l}_*basis=X*noise_model=SDEM3*'));results[l]=check(stim.Circuit(p.read_text()))
    path=Path(__file__).parent/'provenance'/'independent_code_parameters.json'
    path.write_text(json.dumps(results,indent=2)+'\n');print(path.read_text())
