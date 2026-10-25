"""Compare every frozen fresh search matrix against independent dense expansion."""
from pathlib import Path
import datetime,hashlib,json,time
import numpy as np
import independent_verify as iv
import research as r
R=Path(__file__).resolve().parent
def pack(row):return sum(int(v)<<i for i,v in enumerate(row))
def main():
    start=time.monotonic();records=[]
    cs=json.loads((R/'fresh-candidates.json').read_text())['candidates']
    for c in cs:
        E,L=c['E'],c['L'];C,X,Z=iv.expand(E,L)
        assert r.classical(E,L)==[pack(row) for row in C]
        x,z=r.product(E,L)
        assert x==[pack(row) for row in X] and z==[pack(row) for row in Z]
        assert not np.any(X@Z.T%2)
        # Check the generic sector row/qubit permutation literally on all entries.
        perm=[(4*j+i)*L+s for i in range(4) for j in range(4) for s in range(L)]
        perm += [16*L+(3*j+i)*L+s for i in range(3) for j in range(3) for s in range(L)]
        rows=[(3*j+i)*L+s for i in range(3) for j in range(4) for s in range(L)]
        assert np.array_equal(X,Z[rows][:,perm])
        rec={'id':c['id'],'L':L,'classical_shape':list(C.shape),'quantum_shape':list(X.shape),
             'matrix_sha256':{k:hashlib.sha256(A.tobytes()).hexdigest() for k,A in [('C',C),('HX',X),('HZ',Z)]}}
        records.append(rec)
    out={'status':'PASS','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'instances':len(records),
         'records':records,'seconds':time.monotonic()-start,'frozen_input_sha256':hashlib.sha256((R/'fresh-candidates.json').read_bytes()).hexdigest(),
         'scope':'Every frozen fresh matrix: independent coefficient/Kronecker/circulant expansion equals the search generator, full CSS commutation, and literal generic X/Z row/qubit permutation. Does not independently certify the C++ exclusion algorithm or a general Lean sector theorem.'}
    (R/'frozen-matrix-crosschecks.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='records'}),flush=True)
if __name__=='__main__':main()
