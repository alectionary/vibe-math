"""Exhaustive small matching controls and an exact shared-flow strictness witness.

No LP and no C16 strictness claim. This file does not import the extension.
"""
from fractions import Fraction as Q
from pathlib import Path
import hashlib,json,os,time

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    start=time.monotonic();matching_selections=checked_edges=forced_zeros=0
    for graph in range(1<<9):
        edge=lambda x,z:bool(graph>>(3*x+z)&1)
        for xs in range(8):
            for zs in range(8):
                if any(sum(edge(x,z) for z in range(3) if zs>>z&1)!=1 for x in range(3) if xs>>x&1):continue
                if any(sum(edge(x,z) for x in range(3) if xs>>x&1)!=1 for z in range(3) if zs>>z&1):continue
                matching_selections+=1;mask=(xs&3)|((zs&3)<<2)
                for x in range(3):
                    for z in range(3):
                        if not edge(x,z):continue
                        a,b=int(bool(xs>>x&1)),int(bool(zs>>z&1));t=a*b
                        assert 0<=t<=a and t<=b and t>=a+b-1
                        forbidden=(x<2 and not(mask>>x&1)) or (z<2 and not(mask>>(z+2)&1))
                        forbidden|=any(mask>>h&1 and h!=x and edge(h,z) for h in range(2))
                        forbidden|=any(mask>>(h+2)&1 and h!=z and edge(x,h) for h in range(2))
                        if forbidden:assert t==0;forced_zeros+=1
                        checked_edges+=1
                for x in range(3):assert sum(int(bool(xs>>x&1))*int(bool(zs>>z&1)) for z in range(3) if edge(x,z))==int(bool(xs>>x&1))
                for z in range(3):assert sum(int(bool(xs>>x&1))*int(bool(zs>>z&1)) for x in range(3) if edge(x,z))==int(bool(zs>>z&1))
    # Two disjoint K3,3 components; all per-probe flow arrays are exact witnesses.
    lam=[Q(1,2)]*2;p=[Q(1,6)]*6
    X0=[Q(2,15)]*3+[Q(1,30)]*3;Z0=[Q(1,15)]*3+[Q(1,10)]*3
    X=[X0,[p[i]-X0[i] for i in range(6)]];Z=[Z0,[p[j]-Z0[j] for j in range(6)]]
    assert [sum(row) for row in X]==[Q(1,2)]*2 and [sum(row) for row in Z]==[Q(1,2)]*2
    flows=[];flow_cells=0
    for side in 'XZ':
        for center in range(6):
            neighbors=list(range(0,3) if center<3 else range(3,6))
            t0=Q(2,45) if side=='X' and center<3 else Q(1,90) if side=='X' else Q(1,45) if center<3 else Q(1,30)
            values=[[t0]*3,[Q(1,18)-t0]*3]
            for m in range(2):
                assert sum(values[m])==(X if side=='X' else Z)[m][center]
                for j,t in zip(neighbors,values[m]):
                    x,z=(center,j) if side=='X' else (j,center)
                    assert max(Q(0),X[m][x]+Z[m][z]-lam[m])<=t<=min(X[m][x],Z[m][z])
                    flow_cells+=1
            for k in range(3):assert sum(values[m][k] for m in range(2))==Q(1,18)
            flows.append(dict(side=side,center=center,neighbors=neighbors,flows=[[str(v) for v in row] for row in values]))
    common_lower=2*(Q(2,15)-Q(1,18));common_upper=2*Q(1,15)-2*Q(1,45)
    assert common_lower==Q(7,45) and common_upper==Q(4,45) and common_lower-common_upper==Q(1,15)
    out=dict(status='PASS_OWNER_STAR_MATCHING_AND_GENERIC_STRICTNESS_CONTROLS',producer_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),priority=19,
        exhaustive_graphs=512,matching_selections=matching_selections,literal_owner_edges_checked=checked_edges,forced_zero_instances=forced_zeros,
        generic_individual_stars=len(flows),generic_flow_cells=flow_cells,generic_individual_flows=flows,
        shared_two_by_two_lower=str(common_lower),shared_two_by_two_upper=str(common_upper),exact_contradiction_gap=str(common_lower-common_upper),
        generic_interface_strictness_proved=True,C16_specific_strictness_proved=False,solver_run=False,elapsed_seconds=time.monotonic()-start,
        scope='The tiny graphs check elementary owner-matching row and forbidden-edge identities. The rational interface witness proves shared cells can strengthen separate stars; it is not a C16 physical realization or a source-frame obstruction.')
    path=Path('two-basis-results/owner-star-extension-tiny-controls.json');assert not path.exists();path.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k!='generic_individual_flows'},indent=2))
if __name__=='__main__':main()
