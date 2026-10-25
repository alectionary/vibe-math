"""Deterministic boundary checks of the proved parameter template, separate from sampling."""
from pathlib import Path
import json
import independent_verify as iv
R=Path(__file__).resolve().parent

def support(L,a,b):
    left=[(0,0,0),(1,1,-2*a),(2,2,-2*b),(3,0,-2*a),
          (3,1,-4*a),(3,1,-2*a),(3,2,-b-2*a),(3,3,-4*a)]
    right=[(0,2,0),(1,1,0),(2,0,0)]
    # These are polynomial terms over F2: coincident terms cancel.
    terms=[(4*i+j)*L+s%L for i,j,s in left]+[16*L+(3*i+j)*L+s%L for i,j,s in right]
    out=set()
    for j in terms:
        if j in out:out.remove(j)
        else:out.add(j)
    return sorted(out)

def no_rcpc(E,L):
    rows=[]
    for k in range(3):
        i,j=[v for v in range(3) if v!=k]
        rows.append(all((E[i][c]+E[j][c]-2*E[k][c])%L==0 for c in range(4)))
    cols=[]
    for a,b,c,d in [(0,1,2,3),(0,2,1,3),(0,3,1,2)]:
        cols.append(all((E[i][a]+E[i][b]-E[i][c]-E[i][d])%L==0 for i in range(3)))
    return not any(rows+cols)

if __name__=='__main__':
    out=[]
    # Fixed parity/boundary cases: unit and nonunit parameters; the last case
    # has an even-voltage, disconnected cover. No sampling or selection on outcomes.
    for L,a,b in [(22,1,16),(22,12,5),(22,12,16)]:
        assert a%11==1 and b%11==5
        E=[[0,0,0,0],[0,a%L,b%L,3*a%L],[0,2*a%L,2*b%L,(b+2*a)%L]]
        x=iv.verify(E,L,support(L,a,b),list(range(L))+list(range(4*L,5*L)))
        assert no_rcpc(E,L) and x['girth_classical']>=8 and x['classical']['distance']>=12
        x.update(a=a,b=b,no_RCPC=True);out.append(x)
        print(json.dumps({'L':L,'a':a,'b':b,'dC':x['classical']['distance'],'dT':x['transpose_classical']['distance'],'k':x['k'],'logical':x['quantum_logical_weight']}),flush=True)
    (R/'independent-parametric.json').write_text(json.dumps({'method':'Independent dense source expansion, full classical/transpose enumeration and rank/girth/RCPC checks of three predetermined parameter boundary cases.','instances':out},indent=2)+'\n')
