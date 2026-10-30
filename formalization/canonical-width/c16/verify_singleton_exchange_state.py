"""Independent exact validation of resumable partial exchange-repair states."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,hashlib,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_full_partner_projection import point_data
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();b=json.loads(a.certificate.read_text());assert b['point_sha256']==sha(a.point);assert b['frozen_sha256']==sha(a.certificate.with_suffix('.frozen.json'));assert all(sha(ROOT/p)==h for p,h in b['source_hashes'].items());X,Z,A=physical();o=b['anchor_orbit'];owner,target=point_data(a.point,o);p=owner[o];assert Q(b['conditional_probability'])==p and 0<p<1;q=[v/(16*p) for v in target[55:]];assert list(map(Q,b['conditional_target']))==q and all(0<=v<=1 for v in q);zero=[j for j in range(720) if not(A[16*o]>>j&1)];units=[j for j in range(720) if A[16*o]>>j&1];assert sum(q[j] for j in zero)==127 and sum(q[j] for j in units)==1;assert b['ground_indices']==[j for j in zero if q[j]>0];x=[Q(0)]*720;mass=Q(0);seen=set()
    for r in b['zero_bases']:
        B=r['indices'];w=Q(r['weight']);assert B==sorted(set(B)) and len(B)==127 and tuple(B) not in seen and w>0;assert all(type(j)is int and j in zero and q[j]>0 for j in B);assert dimension(Z[j] for j in B)==127;seen.add(tuple(B));mass+=w
        for j in B:x[j]+=w
    assert mass==1 and len(seen)==b['active_bases'];law={}
    for r in b['unit_probabilities']:
        j=r['index'];w=Q(r['probability']);assert j in units and j not in law and w==q[j]>0;law[j]=w;x[j]=w
    assert sum(law.values())==1 and all(x[j]==q[j] for j in units);error=sum(max(Q(0),wanted-found) for wanted,found in zip(q,x));assert error==Q(b['final_positive_error']);assert sum(x)==sum(q)==128
    result={'status':'PASS_VALID_EXACT_REPAIR_STATE_AND_RESIDUAL','source_C16_answered':False,'certificate_sha256':sha(a.certificate),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'anchor_orbit':o,'basis_count':len(seen),'zero_basis_rank':127,'zero_mixture_mass':str(mass),'unit_probability_mass':'1','conditional_target_coordinates_checked':720,'exact_positive_error':str(error),'approximate_positive_error':float(error),'exact_target_mixture':error==0,'resumable_exact_physical_basis_mixture':True,'elapsed_seconds':time.monotonic()-start,'scope':'Validatesexactphysicalmixturestate anditsdistancefromconditionaltarget. Nonzeroerror isnotrankmembership andnotaseparator; no globalterminationclaim.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
