"""Independent reconstruction/checking of the saved bounded pattern identities."""
from pathlib import Path
from collections import Counter
from itertools import permutations
import datetime,hashlib,json
R=Path(__file__).resolve().parent
def main():
    path=R/'permutation-patterns.json';d=json.loads(path.read_text());seen=set();counts=Counter()
    for rec in d['records']:
        k,l=rec['column_map'],rec['row_map'];assert sorted(k)==list(range(4)) and sorted(l)==list(range(3))
        key=tuple(k),tuple(l);assert key not in seen;seen.add(key)
        matrices=[]
        for i,j in [(1,1),(1,2),(1,3),(2,1),(2,2),(2,3)]:
            E=[[0]*4 for _ in range(3)];E[i][j]=1
            F=[[E[a][k[b]]+E[l[a]][b] for b in range(4)] for a in range(3)]
            matrices.append([F[a][b]-F[a][0]-F[0][b]+F[0][0] for a,b in [(1,1),(1,2),(1,3),(2,1),(2,2),(2,3)]])
        A=[list(x) for x in zip(*matrices)];assert A==rec['A']
        def coeff(fn):
            out=[]
            for i,j in [(1,1),(1,2),(1,3),(2,1),(2,2),(2,3)]:
                E=[[0]*4 for _ in range(3)];E[i][j]=1;out.append(fn(E))
            return out
        def check(target,weights):
            assert len(weights)==6 and all(type(x) is int and abs(x)<=2 for x in weights)
            assert [sum(weights[a]*A[a][b] for a in range(6)) for b in range(6)]==list(target)
        c=rec['certificate'];kind=c['kind'];counts[kind]+=1
        if kind=='short_cycle_implied':
            loc=c['cycle'];idx=loc['indices']
            if loc['kind']=='four':
                i,j,a,b=idx;assert i!=j and a!=b
                target=coeff(lambda E:E[i][a]-E[j][a]+E[j][b]-E[i][b])
            else:
                i,j,h,a,b,f=idx;assert len({i,j,h})==len({a,b,f})==3
                target=coeff(lambda E:E[i][a]-E[j][a]+E[j][b]-E[h][b]+E[h][f]-E[i][f])
            assert c['target'] in [target,[-v for v in target]];check(c['target'],c['coefficients'])
        elif kind=='RCPC_implied':
            p=c['partition']
            if p['kind']=='row':
                h=p['middle'];i,j=[a for a in range(3) if a!=h]
                forms=[coeff(lambda E,b=b:E[i][b]+E[j][b]-2*E[h][b]) for b in [1,2,3]]
            else:
                (a,b),(h,f)=p['pairs'];assert len({a,b,h,f})==4
                forms=[coeff(lambda E,i=i:E[i][a]+E[i][b]-E[i][h]-E[i][f]) for i in [1,2]]
            assert forms==p['forms']
            for f,w in zip(forms,c['coefficients']):check(f,w)
        elif kind=='cyclic_torsion_collision':
            i,j=c['rows'];g=c['torsion'];assert i!=j and g in [2,3]
            targets=[coeff(lambda E,b=b:g*(E[i][b]-E[j][b])) for b in [1,2,3]]
            assert targets==c['targets']
            for f,w in zip(targets,c['coefficients']):check(f,w)
        else:
            assert kind=='unclassified_with_coefficient_cap2'
            assert l==[0,1,2] and sum(a==b for a,b in enumerate(k))==2
    assert seen=={(k,l) for k in permutations(range(4)) for l in permutations(range(3))}
    out={'status':'PASS','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'cases':len(seen),
         'outcomes':dict(counts),'catalog_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
         'scope':'Independent scalar basis reconstruction of every normalized pattern constraint and each short-cycle/RCPC/torsion form; direct Python integer verification of all saved combinations; all144 maps covered. The six unclassified maps have two fixed columns and identity row map. This does not supply Lean source/support-geometry bridges.'}
    (R/'pattern-certificate-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
