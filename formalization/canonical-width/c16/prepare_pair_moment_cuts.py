#!/usr/bin/env python3
"""Check two universal forbidden pairs and bind their moment zero faces."""
from pathlib import Path
from fractions import Fraction
import gzip,hashlib,json
from verify_four_term_small import check
from verify_sparse_quotient import SparseQuotientConsumer
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def main():
    X,Z,A=physical();old=ROOT/'relevant-results/comparison-seed-cuts.json';new=ROOT/'transfer-results/four-term/gate.json';records=[];cuts=[]
    values=json.loads(gzip.decompress((ROOT/'algebraic-results/profile-moment-face1.json.gz').read_bytes()))['values']
    for p in [old,new]:
        pairs=[c for c in json.loads(p.read_text())['cuts'] if len(c['indices'])==2];assert len(pairs)==1
        c=pairs[0];row=c['certificate']
        if row['order']==4:check(X,Z,row)
        else:SparseQuotientConsumer(X,Z).check(row)
        i,j=c['indices'];h=(j-i)%16;ii,jj=i//16,j//16;assert h==0
        coeff=[1]+[0]*15;cuts.append({'sector':'X','anchor_orbit':ii,'orbit':jj,'coefficients':coeff,'bound':0})
        k=45+sum(45-t for t in range(ii))+jj-ii;value=Fraction(values[k]);assert value>0
        records.append({'source':str(p.relative_to(ROOT)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'indices':c['indices'],'order':row['order'],'old_moment_value':str(value)})
    result={'status':'PASS','source_C16_answered':False,'cuts':cuts,'source_certificates':records,
            'scope':'Two universal same-sector pair exclusions give zero second moments after cyclic/sector averaging. Both independently separate the previous rational point; only the second is newly discovered in this block. This is not a feasibility decision for the strengthened relaxation.'}
    p=ROOT/'transfer-results/pair-moment-cuts.json';p.write_text(json.dumps(result,indent=2)+'\n');print(result)
if __name__=='__main__':main()
