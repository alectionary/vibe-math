#!/usr/bin/env python3
"""Known physical88-pair control and corruptions of source-rank SDP duals."""
from pathlib import Path
import argparse,json,gzip,copy
from rank_moment_dual import verify
from verify_inverse_lift import vp,mp,outer,shifts,parts,cyclic,F
from audit_pools import exchange
from verify_partial_frame import shift,mask


def read(path):
    raw=path.read_bytes();return json.loads(gzip.decompress(raw) if path.suffix=='.gz' else raw)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    root=Path(__file__).parent;source=read(root/'inversion-results/normal-form.json');cert=read(a.certificate);q=source['dictionary']
    A=list(map(vp,q['X_left_dictionary']));B=list(map(vp,q['X_right_factors']));C=list(map(vp,q['Z_left_factors']));D=list(map(vp,q['Z_right_dictionary']))
    owners={'X':{v:(c,i) for c,b in enumerate(B) for i,u in enumerate(A) for v in shifts(outer(u,b))},
            'Z':{v:(c,i) for c,u in enumerate(C) for i,d in enumerate(D) for v in shifts(outer(u,d))}}
    physical=read(root/'physical-pool-source.json');zp=[shift(mask(v),h) for v in physical['Z_orbit_representatives'] for h in range(16)];xp=[exchange(v) for v in zp]
    ix={v:i for i,v in enumerate(xp)};iz={v:i for i,v in enumerate(zp)};sx=list(map(mp,source['tensor']['X_tensor_coordinates']));sz=list(map(mp,source['tensor']['Z_tensor_coordinates']))
    pairs=[(sx[ix[mask(p['X'])]],sz[iz[mask(p['Z'])]]) for p in read(root/'partial-frame-88.json')['pairs']]
    word=lambda v:[(a>>h&1)|((b>>h&1)<<1) for a,b in map(cyclic,parts(v)) for h in range(16)]
    xt=[word(x) for x,z in pairs];zt=[word(z) for x,z in pairs]
    assert len(pairs)==88 and all(sum((F[a][b]>>1)&1 for a,b in zip(x,z))%2==(i==j) for i,x in enumerate(xt) for j,z in enumerate(zt))
    selected={'X':[x for x,z in pairs],'Z':[z for x,z in pairs]}
    for cut in cert['rank_rectangles']:
        side=cut['sector'];count=sum(bool(cut['thin_mask']>>owners[side][v][0]&1) and bool(cut['thick_mask']>>owners[side][v][1]&1) for v in selected[side])
        assert count<=cut['rank']
    rejected=[]
    for tag in ['false_source_rank','invalid_linear_row','dropped_family','indefinite_dual']:
        d=copy.deepcopy(cert)
        if tag=='false_source_rank':d['rank_rectangles'][0]['rank']-=1
        if tag=='invalid_linear_row':d['linear_terms'][0]['rhs']+=12345
        if tag=='dropped_family':d['X_thin_families']=d['X_thin_families'][:-1]
        if tag=='indefinite_dual':d['constant']=-abs(d['constant'])-10*d['denominator']
        try:verify(d,source)
        except (AssertionError,ValueError,IndexError,__import__('numpy').linalg.LinAlgError):rejected.append({'mutation':tag,'rejected':True})
        else:raise AssertionError('Corruption accepted: '+tag)
    result={'status':'PASS','known_physical_pairs':88,'literal_trace_Gram_pairings':7744,'rank_rectangle_occupancy_controls':len(cert['rank_rectangles']),'negative_controls':rejected,'source_C16_answered':False}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
