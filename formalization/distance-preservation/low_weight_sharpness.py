"""Independent finite sharpness example for the generic check-rooted bound."""
from pathlib import Path
import datetime,hashlib,json
import numpy as np
import independent_verify as iv
R=Path(__file__).resolve().parent
def main():
    # Four roots share check0. Root i has private spokes to outer vertices
    # i and i+4. Eight outer vertices form a cycle, with opposite private pairs.
    H=np.zeros((17,12),dtype=np.uint8);H[0,:4]=1
    for k in range(8):
        H[1+k,k%4]=1;H[1+k,4+k]=1
        H[9+k,4+k]=1;H[9+k,4+(k+1)%8]=1
    assert set(map(int,H.sum(axis=0)))=={3}
    assert sorted(map(int,H.sum(axis=1)))==[2]*16+[4]
    assert iv.bfs_girth(H)==8
    d=iv.distance(H);assert d['dimension']==1 and d['distance']==12
    assert not np.any(H@np.ones(12,dtype=np.uint8)%2)
    out={'status':'PASS','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'H':H.tolist(),
         'parameters':[12,1,12],'girth':8,'variable_degrees':[3]*12,'check_degrees':list(map(int,H.sum(axis=1))),
         'enumeration':d,'matrix_sha256':hashlib.sha256(H.tobytes()).hexdigest(),
         'scope':'Exact finite ordinary binary Tanner-graph example. Its unique nonzero word meets one check in4 positions, so the generic <=11 threshold is sharp. This is not a lifted-product quantum instance and not a Lean finite certificate.'}
    (R/'low-weight-sharpness.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['H','enumeration']}),flush=True)
if __name__=='__main__':main()
