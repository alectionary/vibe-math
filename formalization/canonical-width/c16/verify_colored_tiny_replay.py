"""Second consumer: literal GF(2) spans, weighted subsets and tiny physical bases.

Does not import the colored solver or previous endpoint consumer. The physical
representation is the object tested against exhaustive original physical bases.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
from collections import Counter
import copy,gzip,hashlib,json,os,time

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rank(vectors):
    span={0}
    for v in vectors:
        assert type(v)is int and v>=0
        span |= {x^v for x in span}
    assert len(span)&(len(span)-1)==0
    return len(span).bit_length()-1

def check(pools,masses,target,out,allow_partial=False):
    masses,target=list(map(Q,masses)),list(map(Q,target))
    n=len(target);ranks=list(map(rank,pools));positive=[c for c,a in enumerate(masses) if a>0]
    assert len(masses)==len(pools)>0 and all(len(U)==n for U in pools)
    assert min(masses)>=0 and sum(masses)==1 and min(target,default=0)>=0
    r=ranks[positive[0]];assert all(ranks[c]==r for c in positive) and sum(target)==r
    D=int(out['denominator']);assert D>0
    assert out['ground_size']==n and out['color_count']==len(pools) and out['common_rank']==r
    assert out['full_ranks_by_color']==ranks and list(map(Q,out['color_masses']))==masses
    assert all((x*D).denominator==1 for x in masses+target)
    assert list(map(int,out['target_numerators']))==[int(x*D) for x in target]
    assert list(map(int,out['color_mass_numerators']))==[int(x*D) for x in masses]
    achieved=[0]*n;cm=[0]*len(pools);seen=set()
    for row in out['bases']:
        c=row['color'];B=row['indices'];w=int(row['weight_numerator'])
        assert type(c)is int and c in positive and w>0
        assert B==sorted(set(B)) and len(B)==r
        assert all(type(j)is int and 0<=j<n for j in B)
        assert rank(pools[c][j] for j in B)==r and (c,tuple(B)) not in seen
        seen.add((c,tuple(B)));cm[c]+=w
        for j in B:achieved[j]+=w
    assert cm==[int(x*D) for x in masses]
    assert cm==list(map(int,out['achieved_color_mass_numerators']))
    assert achieved==list(map(int,out['achieved_numerators']))
    defects={}
    for bits in range(1<<n):
        S=[j for j in range(n) if bits>>j&1]
        rr=[rank(U[j] for j in S) for U in pools]
        bound=sum(a*r for a,r in zip(masses,rr));mass=sum(target[j] for j in S)
        if mass>bound:defects[tuple(S)]=(rr,bound,mass)
    if out['status']=='EXACT_COLORED_BASE_MIXTURE':
        assert not defects and achieved==[int(x*D) for x in target]
        assert out['violated_weighted_rank'] is None
    elif out['status']=='EXACT_WEIGHTED_RANK_VIOLATION':
        cut=out['violated_weighted_rank'];S=cut['indices']
        assert S==sorted(set(S)) and tuple(S) in defects
        rr,bound,mass=defects[tuple(S)]
        assert cut['ranks_by_color']==rr and Q(cut['weighted_rank'])==bound
        assert int(cut['weighted_rank_numerator'])==bound*D
        assert Q(cut['target_mass'])==mass and Q(cut['exact_violation'])==mass-bound>0
    else:
        assert allow_partial and out['status']=='BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE'
        assert out['violated_weighted_rank'] is None
    return 1<<n,len(seen)

def physical():
    import colored_physical_domain_representation_draft as tested
    domains=identities=bases_checked=0
    for d in [2,3]:
        pool=list(range(1,1<<d));n=len(pool)
        full=[B for B in combinations(range(n),d) if rank(pool[j] for j in B)==d]
        for mask in range(16):
            own=[i for i in [0,1] if mask>>i&1]
            absent=[i for i in [0,1] if not mask>>i&1]
            initial=[i for i in [0,1] if mask>>(i+2)&1]
            for W in [initial,sorted(initial+[2])]:
                allowed=[]
                for B in full:
                    if not set(own)<=set(B) or set(absent)&set(B):continue
                    rows=[[(pool[j]&pool[w]).bit_count()%2 for w in W] for j in B]
                    if any(sum(row)>1 for row in rows):continue
                    if any(sum(row[k] for row in rows)!=1 for k in range(len(W))):continue
                    allowed.append(B)
                dom=tested.source_domain(pool,pool,W,own,absent,d)
                assert dom['feasible']==bool(allowed);domains+=1
                if not allowed:continue
                proxy=tested.represent(pool,dom)['vectors']
                assert len(proxy)==n and rank(proxy)==d
                represented=[B for B in combinations(range(n),d) if rank(proxy[j] for j in B)==d]
                assert represented==allowed;bases_checked+=len(allowed)
                for bits in range(1<<n):
                    S=[j for j in range(n) if bits>>j&1]
                    # Rank is the maximum size of a subset extendible to a full basis.
                    expected=max(sum(j in B for j in S) for B in allowed)
                    assert rank(proxy[j] for j in S)==expected;identities+=1
    return dict(domains=domains,subset_rank_identities=identities,full_physical_bases=bases_checked)

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1')
    started=time.monotonic();bankpath=ROOT/'two-basis-results/colored-draft-tiny-v1.json.gz'
    oldpath=ROOT/'two-basis-results/colored-draft-tiny-v1-independent.json';old=json.loads(oldpath.read_text())
    assert old['status']=='PASS_FINITE_COLORED_AND_PHYSICAL_CONTROLS' and sha(bankpath)==old['bank_sha256']
    for p,h in old['source_hashes'].items():assert sha(ROOT/p)==h
    bank=json.loads(gzip.decompress(bankpath.read_bytes()));counts=Counter();subsets=bases=0
    for record in bank['records']:
        a,b=check(record['pools'],record['masses'],record['target'],record['endpoint'])
        subsets+=a;bases+=b;counts[record['endpoint']['status']]+=1
        assert time.monotonic()-started<110
    assert len(bank['records'])==old['cases'] and subsets==old['exhaustive_subset_checks']
    assert dict(counts)==old['outcomes']
    U=[[1,1,2,2],[1,2,1,2]];mass=[Q(1,3),Q(2,3)];target=[Q(1,2)]*4
    check(U,mass,target,bank['collision']);assert int(bank['collision']['denominator'])==30
    for cap in bank['caps']:check(U,mass,target,cap['result'],True)
    assert len(bank['caps'])==4
    rejected=[]
    mixture=next(r for r in bank['records'] if r['endpoint']['status']=='EXACT_COLORED_BASE_MIXTURE' and len(r['pools'][0])>=4)
    cut=next(r for r in bank['records'] if r['endpoint']['status']=='EXACT_WEIGHTED_RANK_VIOLATION')
    for name in ['negative-weight','wrong-mass','wrong-achieved','wrong-color','wrong-cut-rank','wrong-cut-gap','empty-cut']:
        rec=copy.deepcopy(cut if name.startswith('wrong-cut') or name=='empty-cut' else mixture);o=rec['endpoint']
        if name=='negative-weight':o['bases'][0]['weight_numerator']='-1'
        elif name=='wrong-mass':o['achieved_color_mass_numerators'][0]=str(int(o['achieved_color_mass_numerators'][0])+1)
        elif name=='wrong-achieved':o['achieved_numerators'][0]=str(int(o['achieved_numerators'][0])+1)
        elif name=='wrong-color':o['bases'][0]['color']=len(rec['pools'])
        elif name=='wrong-cut-rank':o['violated_weighted_rank']['ranks_by_color'][0]+=1
        elif name=='wrong-cut-gap':o['violated_weighted_rank']['exact_violation']='0'
        else:o['violated_weighted_rank']['indices']=[]
        try:check(rec['pools'],rec['masses'],rec['target'],o)
        except (AssertionError,ValueError,KeyError):rejected.append(name)
        else:raise AssertionError(name)
    phys=physical();assert phys==dict(domains=64,subset_rank_identities=3040,full_physical_bases=88)
    result=dict(status='PASS_SECOND_INDEPENDENT_COLORED_TINY_REPLAY',bank_sha256=sha(bankpath),previous_receipt_sha256=sha(oldpath),consumer_sha256=sha(__file__),source_hashes=old['source_hashes'],cases=len(bank['records']),outcomes=dict(counts),literal_span_subset_checks=subsets,positive_basis_records_checked=bases,collision_replayed=True,cap_states_replayed=len(bank['caps']),physical=phys,mutants_rejected=rejected,rank_method='Explicit full binary span enumeration, no producer elimination or circuit cache',elapsed_seconds=time.monotonic()-started,priority=19,not_repeated=['Producer invalid-input rejection calls','48 physical colored endpoints not separately stored in the frozen bank; independently repeated physical basis/proxy equality instead'],scope='Finite tiny exact endpoints and physical-domain representation controls only. No universal runtime, maximum-defect, physical128 or C16 frame conclusion.')
    out=ROOT/'two-basis-results/colored-draft-tiny-v1-second-independent.json';assert not out.exists();out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
if __name__=='__main__':main()
