"""All parameter pairs at L1..9 test the universal template's boundary cases."""
from pathlib import Path
from collections import Counter
import datetime,json,time
import numpy as np
import independent_verify as iv
import independent_parametric as ip
R=Path(__file__).resolve().parent
def main():
    start=time.monotonic();records=[]
    for L in range(1,10):
        counts=Counter();dimensions=[]
        for a in range(L):
            for b in range(L):
                E=[[0,0,0,0],[0,a,b,3*a%L],[0,2*a%L,2*b%L,(b+2*a)%L]]
                C,X,Z=iv.expand(E,L);support=ip.support(L,a,b)
                w=np.zeros(25*L,dtype=np.uint8);w[support]=1
                sep=np.zeros(25*L,dtype=np.uint8);sep[:L]=1;sep[4*L:5*L]=1
                assert not np.any(X@Z.T%2) and not np.any(Z@w%2)
                assert not np.any(X@sep%2) and int(w@sep%2)==1
                rx=len(iv.eliminate(X)[1]);rz=len(iv.eliminate(Z)[1])
                assert len(iv.eliminate(np.vstack([X,w]))[1])==rx+1
                assert len(support)<=11
                assert len(support)==(9 if 2*a%L==0 else 11)
                counts[len(support)]+=1;dimensions.append(25*L-rx-rz)
        rec={'L':L,'parameter_pairs':L*L,'logical_weight_counts':dict(sorted(counts.items())),
             'quantum_dimension_min':min(dimensions),'quantum_dimension_max':max(dimensions)}
        records.append(rec);print(json.dumps(rec),flush=True)
    out={'status':'PASS','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
         'parameter_pairs':sum(x['parameter_pairs'] for x in records),'records':records,'seconds':time.monotonic()-start,
         'scope':'Independent dense coefficient/Kronecker source expansion, CSS, syndrome, full-span augmented rank and separator checks for every a,b at L1..9. Includes cancelling terms and zero/nonunit parameters. No small-L classical girth or distance-drop claim.'}
    (R/'independent-degenerate.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':main()
