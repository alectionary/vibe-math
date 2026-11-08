"""Bind a completed point12 singleton cohort and export its exact closed cuts."""
from pathlib import Path
from fractions import Fraction
import argparse,json,hashlib,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension,extend
from verify_full_partner_projection import point_data
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--summary',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--rank-bank',type=Path,required=True);a=ap.parse_args();assert not a.output.exists() and not a.rank_bank.exists();start=time.monotonic();d=read(a.summary);assert d['status']=='BOUNDED_SINGLETON_REFRESH_COMPLETE' and d['point_sha256']==sha(a.point);fp=a.summary.with_suffix('.frozen.json');assert d['frozen_sha256']==sha(fp);assert all(sha(ROOT/p)==v for p,v in d['source_hashes'].items());X,Z,A=physical();passes=[];cuts=[];inc=[];bindings={};exact_mixtures=[];seen=set();lat=[]
    for r in d['records']:
        anchor=r['anchor_orbit'];assert anchor not in seen;seen.add(anchor)
        if not r['status'].startswith('PASS_'):inc.append(anchor);continue
        cp=ROOT/r['candidate_path'];rp=ROOT/r['independent_path'];c=read(cp);receipt=read(rp);assert sha(cp)==r['candidate_sha256']==receipt['certificate_sha256'] and sha(rp)==r['independent_sha256'];assert receipt['consumer_sha256']==sha(ROOT/'coupling-results/full-partner-singleton-independent-generic.py');assert c['anchor_orbit']==anchor and c['point_sha256']==receipt['point_sha256']==sha(a.point);assert receipt['status']==r['status'];bindings[str(cp.relative_to(ROOT))]=sha(cp);bindings[str(rp.relative_to(ROOT))]=sha(rp)
        if r['status'] in ('PASS_ALL_SINGLETON_CONDITIONAL_Z_RANK_INEQUALITIES','PASS_EXACT_SINGLETON_CONDITIONAL_MATROID_MEMBERSHIP'):
            passes.append(anchor)
            if r['status']=='PASS_EXACT_SINGLETON_CONDITIONAL_MATROID_MEMBERSHIP':exact_mixtures.append(anchor)
            else:assert Fraction(receipt['exact_lattice_scaled_error'])<1;lat.append(anchor)
        else:
            assert r['status']=='PASS_EXACT_CONDITIONAL_RANK_CUT' and r['closed_rank_replay_returncode']==0;bp=ROOT/r['closed_rank_bank'];brp=ROOT/r['closed_rank_replay'];bank=read(bp);br=read(brp);assert br['status']=='PASS' and br['certificate_sha256']==sha(bp)==r['closed_rank_bank_sha256'] and sha(brp)==r['closed_rank_replay_sha256'];assert br['consumer_sha256']==sha(ROOT/'verify_weighted_matroid_cuts.py') and bank['point_sha256']==sha(a.point);assert len(bank['cuts'])==1;cut=bank['cuts'][0];assert cut['sector']=='T' and cut['anchor_orbit']==anchor and cut['mandatory_index'] is None;ids=cut['indices'];assert ids==sorted(set(ids));piv={}
            for j in ids:assert type(j)is int and 0<=j<720;extend(piv,Z[j])
            def belongs(v):
                while v:
                    bit=v&-v
                    if bit not in piv:return False
                    v^=piv[bit]
                return True
            assert ids==[j for j in range(720) if belongs(Z[j])];assert len(piv)==dimension(Z[j] for j in ids)==cut['bound'];owner,target=point_data(a.point,anchor);gap=sum(target[55+j]/16 for j in ids)-cut['bound']*owner[anchor];assert gap>0 and gap==Fraction(cut['exact_violation'])==Fraction(r['closed_rank_exact_violation']);cuts.append(cut);bindings[str(bp.relative_to(ROOT))]=sha(bp);bindings[str(brp.relative_to(ROOT))]=sha(brp)
    assert sorted(passes)==sorted(d['anchors_all_rank_certified']);assert sorted(inc)==sorted(d['inconclusive_anchors']);assert sorted(set(range(45))-seen)==sorted(d['unqueried_anchors'])
    bank={'status':'CANDIDATE_RANK_CUTS','source_C16_answered':False,'point_sha256':sha(a.point),'source_summary_sha256':sha(a.summary),'cuts':cuts,'source_bindings':bindings,'scope':'Freshpoint12 independentlyaccepted present-conditionedT rankcuts, closedunderphysicalZspan. No point8cut reused.'};a.rank_bank.write_text(json.dumps(bank,indent=2)+'\n')
    out={'status':'PASS_FRESH_POINT12_SINGLETON_COHORT_BINDINGS_AND_CLOSED_CUTS','source_C16_answered':False,'point_sha256':sha(a.point),'summary_sha256':sha(a.summary),'consumer_sha256':sha(Path(__file__)),'anchors_queried':len(seen),'all_rank_certified_anchors':passes,'exact_mixture_anchors':exact_mixtures,'rank_lattice_anchors':lat,'span_closed_cut_anchors':[c['anchor_orbit'] for c in cuts],'inconclusive_anchors':inc,'unqueried_anchors':d['unqueried_anchors'],'closed_cut_bank_sha256':sha(a.rank_bank),'exact_closed_cut_violations':{str(c['anchor_orbit']):c['exact_violation'] for c in cuts},'elapsed_seconds':time.monotonic()-start,'scope':'Checks freshpoint bindings and independentreceipt hashes. Everyexportedcut also receives fresh physicalspan-closure/rank andrationalpointgap checks here. Allrank receipts implyonlysingletonpresent-conditionedT laws; incompleteanchors remainunresolved.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
