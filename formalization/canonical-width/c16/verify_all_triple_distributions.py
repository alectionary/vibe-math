#!/usr/bin/env python3
"""Direct exact common-denominator replay of all local triple distributions.

This consumer does not import the fixed-point triangle screen or its compiler.
It constructs the allowable interval for the triple intersection directly and
checks it with arbitrary-precision integer arithmetic, in bounded row chunks.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,math,time
import numpy as np
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    hulls=json.loads(gzip.decompress((ROOT/'algebraic-results/hulls-16-rank.json.gz').read_bytes()));_,index,m=layout(hulls)
    values=list(map(Fraction,json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    moment_keys=[key for key in index if key[0]!='w'];D=math.lcm(*(values[index[key]].denominator for key in moment_keys));v=np.array([x.numerator*(D//x.denominator) if D%x.denominator==0 else None for x in values],dtype=object)
    ids=np.arange(1440);marginal=np.array([v[index['p',(e%720)//16]] for e in ids],dtype=object)
    matrix=np.empty((1440,1440),dtype=object)
    for a0 in range(1440):
        s,i=divmod(a0,720)
        matrix[a0]=[v[m('S' if s==t else 'T',(j-i)%16,i//16,j//16)] for t in (0,1) for j in range(720)]
    assert np.array_equal(matrix,matrix.T);assert np.array_equal(matrix.diagonal(),marginal)
    checked=0;records=[]
    for orbit in range(45):
        anchor=16*orbit;pa=marginal[anchor];before=checked
        for b in range(1440):
            if b==anchor:continue
            cs=ids[b+1:];cs=cs[cs!=anchor]
            if not len(cs):continue
            pb=marginal[b];pc=marginal[cs];ab=matrix[anchor,b];ac=matrix[anchor,cs];bc=matrix[b,cs]
            low=np.maximum(np.maximum(0,ab+ac-pa),np.maximum(ab+bc-pb,ac+bc-pc))
            high=np.minimum(np.minimum(ab,ac),np.minimum(bc,D-pa-pb-pc+ab+ac+bc))
            if np.any(low>high):
                k=int(np.flatnonzero(low>high)[0]);raise AssertionError(('no_triple_distribution',anchor,b,int(cs[k]),str(low[k]-high[k])))
            # The lower endpoint yields eight nonnegative atoms. Sum and
            # marginals follow algebraically; these comparisons check all atoms.
            assert np.all(low>=0) and np.all(ab-low>=0) and np.all(ac-low>=0) and np.all(bc-low>=0)
            assert np.all(pa-ab-ac+low>=0) and np.all(pb-ab-bc+low>=0) and np.all(pc-ac-bc+low>=0)
            assert np.all(D-pa-pb-pc+ab+ac+bc-low>=0)
            checked+=len(cs)
        records.append({'anchor_orbit':orbit,'triple_distributions':checked-before});print(records[-1],flush=True)
    result={'status':'PASS','source_C16_answered':False,'point_sha256':hashlib.sha256(a.point.read_bytes()).hexdigest(),
            'consumer_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'exact_common_denominator':str(D),
            'local_triple_distributions_including_symmetry_duplicates':checked,'nonnegative_atom_checks':8*checked,
            'records':records,'elapsed_seconds':time.monotonic()-start,
            'scope':'Every physical triple has some rational joint distribution under cyclic/sector symmetry. The distributions need not agree on moments of order three or higher across different triples; no global distribution or source frame follows.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS',checked,flush=True)
if __name__=='__main__':main()
