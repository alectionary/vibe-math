#!/usr/bin/env python3
"""Bind all four positive source pair classes and independently compare moment rows."""
from pathlib import Path
from fractions import Fraction
import collections,datetime,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_four_term_small import check
from verify_four_term import FourTermConsumer
from certify_profile_moment_point import layout
from forbidden_moment_matrix import matrix as old_matrix
from canonical_forbidden_moment_matrix import matrix
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();out=ROOT/'moment-resumption-results';out.mkdir(exist_ok=True)
    cp=ROOT/'transfer-results/pair-four/screen.json';cuts=json.loads(cp.read_text())['cuts'];assert len(cuts)==4
    X,Z,A=physical();consumer=FourTermConsumer(X,Z);weighted=[];checks=[]
    for c in cuts:
        assert c['sector']==1 and len(c['indices'])==2
        check(X,Z,c['certificate']);consumer.check(c['certificate']);i,j=c['indices'];h=(j-i)%16;coeff=[int(k==h) for k in range(16)]
        weighted.append({'sector':'X','anchor_orbit':i//16,'orbit':j//16,'coefficients':coeff,'bound':0})
        checks.append({'indices':c['indices'],'order':c['certificate']['order'],'coefficient_phase':h})
    assert all(((X[i]&Z[j]).bit_count()%2)==((X[j]&Z[i]).bit_count()%2) for i in range(720) for j in range(720))
    rot=lambda i:16*(i//16)+(i%16+1)%16
    assert all(((X[i]&Z[j]).bit_count()%2)==((X[rot(i)]&Z[rot(j)]).bit_count()%2) for i in range(720) for j in range(720))
    source={'status':'PASS','source_C16_answered':False,'source_c16_path':str(cp.relative_to(ROOT)),'source_sha256':sha(cp),'cuts':cuts,'scope':'Only four independently checked positive pair certificates are imported. No reliance on the negative outcomes of the16200-pair discovery screen.'}
    bank=out/'all-pair-word-cuts.json';bank.write_text(json.dumps(source,indent=2)+'\n')
    faces={'status':'PASS','source_C16_answered':False,'cuts':weighted,'source_pair_bank_sha256':sha(bank),'source_checks':checks,'physical_cyclic_and_sector_pairing_symmetries_checked':True,'scope':'Four universal forbidden same-sector pairs imply zero averaged second moments. Physical cyclic and sector pairing symmetries checked. This is not an infeasibility certificate.'}
    (out/'all-pair-moment-faces.json').write_text(json.dumps(faces,indent=2)+'\n')
    paths=[ROOT/'relevant-results/seed-cuts.json',bank];M,rows=matrix(paths);old,tagged=old_matrix(paths)
    rowkey=lambda mat,k:tuple(zip(map(int,mat[k:k+1].indices),map(int,mat[k:k+1].data)))
    expected={rowkey(old,k) for k in range(old.shape[0])};assert expected==set(rows) and len(rows)==len(set(rows))
    hull=ROOT/'algebraic-results/hulls-16-rank.json.gz';names,index,m=layout(json.loads(gzip.decompress(hull.read_bytes())));point=ROOT/'algebraic-results/profile-moment-face1.json.gz';v=list(map(Fraction,json.loads(gzip.decompress(point.read_bytes()))['values']))
    flat=[v[index['p',i]] for i in range(45)]+[v[m('S',h,i,j)] for h in range(9) for i in range(45) for j in range(45)];values=[sum(Fraction(c)*flat[j] for j,c in row) for row in rows]
    result={'status':'PASS','source_C16_answered':False,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_pair_checks':checks,'conditioned_anchor_tagged_rows':old.shape[0],'distinct_coefficient_rows':M.shape[0],'duplicate_rows_removed':old.shape[0]-M.shape[0],'old_point_violated_distinct_rows':sum(x>0 for x in values),'maximum_exact_violation':str(max(values)),'old_point_sha256':sha(point),'bank_hashes':{str(p.relative_to(ROOT)):sha(p) for p in paths},'source_hashes':{p:sha(ROOT/p) for p in ['prepare_resumed_moments.py','canonical_forbidden_moment_matrix.py','verify_four_term.py','verify_four_term_small.py']},'elapsed_seconds':time.monotonic()-start,'scope':'Literal coset and low-pivot replay of four source pairs, physical pairing symmetry, coefficient-wise equivalence to earlier conditioned-row compiler, and exact old-point screen. The previous compiler kept duplicate zero-bound pair rows under different anchor labels; removing those duplicates does not alter the feasible set.'}
    (out/'preparation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
