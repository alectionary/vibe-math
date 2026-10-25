"""Replay the two finite family instances without importing the discovery code."""
from pathlib import Path
import json
import independent_verify as iv
R=Path(__file__).resolve().parent
E=[[0,0,0,0],[0,1,5,3],[0,2,10,7]]

def witness(L):
    # Written U,V formula, independently converted to block indices.
    left=[(0,0,0),(1,1,-2),(2,2,-10),(3,0,-2),(3,1,-4),
          (3,1,-2),(3,2,-7),(3,3,-4)]
    right=[(0,2,0),(1,1,0),(2,0,0)]
    return sorted([(4*i+j)*L+s%L for i,j,s in left]+
                  [16*L+(3*i+j)*L+s%L for i,j,s in right])

if __name__=='__main__':
    out=[]
    for L,d in [(11,12),(22,18)]:
        sep=list(range(L))+list(range(4*L,5*L))
        result=iv.verify(E,L,witness(L),sep)
        assert result['classical']['distance']==d
        assert result['transpose_classical']['distance']==2*L
        out.append(result)
    report={'method':'Independent dense coefficient/Kronecker expansion and elimination. Family witness rebuilt directly from the written U,V formula; complete classical and transpose code enumeration; BFS on all three actual Tanner graphs.',
            'numpy_version':iv.np.__version__,'instances':out}
    (R/'independent-family-verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps([{'L':x['L'],'dC':x['classical']['distance'],'dTranspose':x['transpose_classical']['distance'],'logical_weight':x['quantum_logical_weight'],'n':x['n'],'k':x['k']} for x in out]))
