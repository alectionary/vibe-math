#!/usr/bin/env python3
"""Independent edge-orbit and physical phase-length consumer for case floors."""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bridge',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();d=json.loads(a.bridge.read_text())
    assert d['status']=='PASS_SELECTED_PAIR_MOMENT_BRIDGE'
    assert all(sha(ROOT/p)==s for p,s in d['source_hashes'].items())
    X,Z,A=physical();assert len(set(X))==len(set(Z))==720
    ranks={side:[dimension(pool[16*o:16*(o+1)]) for o in range(45)] for side,pool in [('X',X),('Z',Z)]}
    assert all(r==16 for rr in ranks.values() for r in rr)
    cover=json.loads((ROOT/'transfer-results/cover-405.json').read_text());assert len(cover['cases'])==len(d['records'])==405
    counts={16:0,32:0}
    for case,record in zip(cover['cases'],d['records']):
        i,j,h=case['orbit_tuple'];assert record['case']==[i,j,h]
        a0,b0=16*i,16*j+h;assert A[a0]>>b0&1
        # A cross-sector edge has typed X/Z endpoints; swapping reverses them.
        images=set()
        for r in range(16):
            images.add((16*i+r,16*j+(h+r)%16))
            images.add((16*j+(h+r)%16,16*i+r))
        n=len(images);assert n in (16,32);counts[n]+=1
        assert record['edge_orbit_size']==n and record['edge_stabilizer_size']==32//n
        assert Fraction(record['necessary_floor'])==Fraction(1,n)
        hh,ii,jj=(16-h,j,i) if h>8 else (h,i,j)
        if hh in (0,8) and ii>jj:ii,jj=jj,ii
        column=45+9*2025+hh*2025+45*ii+jj
        assert record['owner_coordinate']==column
        assert record['owner_inequality']=={'indices':[column],'coefficients':[-n],'rhs':-1}
        literal=sum((16*i+t==a0 and 16*j+(t+h)%16==b0)+
                    (16*i+t==b0 and 16*j+(t+h)%16==a0) for t in range(16))
        assert Fraction(literal,32)==Fraction(1,n)
    assert counts=={16:15,32:390}
    out={'status':'PASS','source_C16_answered':False,'bridge_sha256':sha(a.bridge),
        'consumer_sha256':sha(Path(__file__)),'physical_pool_sizes':[len(X),len(Z)],
        'all90_phase_orbits_rank16':True,'all_phase_vectors_distinct_within_each_sector':True,
        'edge_orbit_size_histogram':counts,'case_count':405,'scope':'Independent physical phase-length, edge-orbit, stabilizer, literal floor and owner-coordinate replay. No case feasibility or source exclusion is claimed.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))


if __name__=='__main__':main()
