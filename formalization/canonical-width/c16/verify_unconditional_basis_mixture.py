"""Independent physical basis/rational weight/cyclic marginal acceptance."""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    b=Path(p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def verify(bank,point):
    assert bank['status']=='EXACT_UNCONDITIONAL_BASIS_MIXTURE_CANDIDATE' and bank['point_sha256']==sha(point)
    required={'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'};assert required<=set(bank['source_hashes']);assert all(sha(ROOT/p)==v for p,v in bank['source_hashes'].items())
    data=read(point);assert 'values' in data;p=list(map(Fraction,data['values'][:45]));assert len(p)==45 and all(0<=v<=1 for v in p) and sum(p)==8
    X,Z,A=physical();assert len(Z)==len(set(Z))==720 and dimension(X)==dimension(Z)==128;assert Z==[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    receipt=read(ROOT/'moment-resumption-results/symmetry-bridge-independent.json');assert receipt['status']=='PASS' and all(sha(ROOT/q)==v for q,v in receipt['pool_sha256'].items())
    move=lambda j,h:16*(j//16)+(j%16+h)%16
    assert dimension([Z[j]|(Z[move(j,1)]<<128) for j in range(720)])==128
    assert dimension([X[j]|(Z[j]<<128) for j in range(720)])==128
    mass=Fraction(0);counts=[Fraction(0)]*45;marginals=[Fraction(0)]*720;rank_checks=0
    for record in bank['records']:
        B=record['selected_Z_indices'];assert len(B)==len(set(B))==128 and all(type(j)is int and 0<=j<720 for j in B);assert dimension(Z[j] for j in B)==128;rank_checks+=1
        w=Fraction(record['weight']);assert w>0;mass+=w;literal=[sum(j//16==o for j in B) for o in range(45)];assert literal==record['orbit_counts']
        for j,v in enumerate(literal):counts[j]+=w*v
        for h in range(16):
            rotated=[move(j,h) for j in B];assert dimension(Z[j] for j in rotated)==128;rank_checks+=1
            for j in rotated:marginals[j]+=w/16
    assert mass==1 and counts==[16*v for v in p] and marginals==[p[j//16] for j in range(720)]
    assert bank['retained_bases']==len(bank['records'])
    return {'status':'PASS_EXACT_UNCONDITIONAL_BASIS_MARGINAL_MIXTURE','source_C16_answered':False,'point_sha256':sha(point),'retained_bases':len(bank['records']),'positive_rotated_basis_atoms':16*len(bank['records']),'physical_basis_rank_checks':rank_checks,'exact_weight_sum':str(mass),'exact_orbit_count_equalities':45,'exact_physical_marginal_equalities':720,'all_unconditional_Z_matroid_rank_inequalities':True,'all_unconditional_X_matroid_rank_inequalities_via_sector_isomorphism':True,'full_775_membership_proved':False,'source_completion_proved':False,'scope':'Exactmixtureofrotatedphysicalfullbases realizesall720firstmarginals. For everyphysicalsubsetA, sum_(j in A)p_j=E|B intersectA|<=rank(A). Sectorisomorphism transferssamefirstmarginals toX; nojointX/Z orprofilecoupling is asserted.'}
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();bank=read(a.certificate);result=verify(bank,a.point);result.update(bank_sha256=sha(a.certificate),consumer_sha256=sha(Path(__file__)),elapsed_seconds=time.monotonic()-start);a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
