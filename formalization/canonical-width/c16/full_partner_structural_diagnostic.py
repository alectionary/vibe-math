"""Read-only matched count/component/prefix-rank diagnostics on accepted cuts."""
from pathlib import Path
from fractions import Fraction
from collections import Counter,defaultdict
import gzip,json,hashlib,time
from full_partner_basis_oracle import FullPartnerBasisOracle,rank
from full_partner_batched_weights import IntegerPhaseWeightBatch
from full_partner_projection_features import mask_score
from verify_full_partner_basis_oracle import extend
ROOT=Path(__file__).resolve().parent
def read(p):
    b=Path(p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def components(O,E):
    parent={j:j for j in E};piv={};basis=[]
    def find(j):
        while parent[j]!=j:parent[j]=parent[parent[j]];j=parent[j]
        return j
    for j in E:
        v=O.Z[j];rep=0
        while v:
            p=v.bit_length()-1
            if p in piv:vv,rr=piv[p];v^=vv;rep^=rr
            else:piv[p]=(v,rep^(1<<len(basis)));basis.append(j);break
        if not v:
            circuit=[basis[h] for h in range(len(basis)) if rep>>h&1]+[j]
            for i in circuit:parent[find(i)]=find(j)
    groups=defaultdict(list)
    for j in E:groups[find(j)].append(j)
    out=[(v,rank(O.Z[j] for j in v)) for v in groups.values()]
    assert sum(r for v,r in out)==rank(O.Z[j] for j in E)
    return out
def main():
    start=time.monotonic();P=ROOT/'coupling-results';out=P/'full-partner-witness9-structural-diagnostic.json';assert not out.exists()
    path=P/'native775-witness9-gauge-rounded.json.gz';receipt=P/'native775-witness9-gauge-rounded-independent.json';bank=read(path);gate=read(receipt);assert gate['status']=='PASS' and gate['bank_sha256']==sha(path)
    hashes={str(p.relative_to(ROOT)):sha(p) for p in [path,receipt,Path(__file__).resolve(),ROOT/'full_partner_basis_oracle.py',ROOT/'full_partner_batched_weights.py',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']}
    frozen=P/'full-partner-witness9-structural-diagnostic.frozen.json';assert not frozen.exists();frozen.write_text(json.dumps({'status':'FROZEN_BEFORE_STRUCTURAL_DIAGNOSTIC','source_hashes':hashes,'cuts':list(range(len(bank['cuts']))),'methods':['owner_plus_zero_cardinality','owner_plus_component_cardinalities','owner_plus_best_single_weight_prefix_rank']},indent=2)+'\n')
    O=FullPartnerBasisOracle();Ds=[O.prepare(32,m) for m in bank['representatives']];Cs=[components(O,d['zero_indices']) for d in Ds];batch=IntegerPhaseWeightBatch(bank['representatives']);records=[];prefixsets=[set() for _ in Ds]
    for ci,cut in enumerate(bank['cuts']):
        c=cut['coefficients'];Ws=batch.weights(c);values=[]
        for di,(m,d,comps,w) in enumerate(zip(bank['representatives'],Ds,Cs,Ws)):
            w=list(map(int,w));local=mask_score(m,c)+sum(max(w[j] for j in A) for A in d['owner_bins']);order=sorted(d['zero_indices'],key=lambda j:(-w[j],j));r=d['zero_basis_required'];prefix=[0]
            for j in order:prefix.append(prefix[-1]+w[j])
            count=local+prefix[r];component=local+sum(sum(sorted((w[j] for j in A),reverse=True)[:rr]) for A,rr in comps);best=count;best_prefix=None;rows={};exact=0
            for t,j in enumerate(order,1):
                oldrank=len(rows);extend(rows,O.Z[j]);exact+=(len(rows)-oldrank)*w[j]
                if t<len(order) and w[j]>w[order[t]] and len(rows)<min(t,r):
                    rr=len(rows);bound=local+prefix[rr]+prefix[t+r-rr]-prefix[t]
                    if bound<best:best=bound;best_prefix={'prefix_size':t,'rank':rr,'threshold':w[j]}
                    prefixsets[di].add(tuple(sorted(order[:t])))
            assert local+exact==cut['support_records'][di]['full_value']
            values.append({'mask':m,'basis':local+exact,'owner_cardinality':count,'component_cardinality':component,'single_prefix_rank':best,'best_prefix':best_prefix})
        target=Fraction(cut['exact_target_value']);bounds={key:max(v[key] for v in values) for key in ('basis','owner_cardinality','component_cardinality','single_prefix_rank')}
        records.append({'cut':ci,'exact_target':str(target),'bounds':bounds,'exact_gaps':{k:str(target-v) for k,v in bounds.items()},'critical_masks':{k:[v['mask'] for v in values if v[k]==b] for k,b in bounds.items()},'per_mask':values})
    domainrows=[{'mask':m,'zero_count':len(d['zero_indices']),'owner_candidate_count':sum(map(len,d['owner_bins'])),'zero_rank':d['zero_basis_required'],'component_sizes_ranks':sorted([(len(A),r) for A,r in cc],reverse=True),'distinct_proper_weight_prefix_ranks':len(ps)} for m,d,cc,ps in zip(bank['representatives'],Ds,Cs,prefixsets)]
    result={'status':'COMPLETE_EXACT_MATCHED_STRUCTURAL_DIAGNOSTIC','source_C16_answered':False,'source_hashes':hashes,'frozen_sha256':sha(frozen),'domains':domainrows,'cuts':records,'aggregate':{'selection_mass_variables':len(Ds),'zero_selection_variables':sum(len(d['zero_indices']) for d in Ds),'owner_selection_variables':sum(sum(map(len,d['owner_bins'])) for d in Ds),'owner_simplex_equalities':sum(len(d['owner_bins']) for d in Ds),'connected_zero_matroids':sum(len(cc)==1 for cc in Cs),'largest_component_min':min(max(len(A) for A,r in cc) for cc in Cs),'largest_component_max':max(max(len(A) for A,r in cc) for cc in Cs),'distinct_proper_prefix_rank_rows':sum(map(len,prefixsets))},'elapsed_seconds':time.monotonic()-start,'scope':'Exact support comparisons for this frozen14-functional cohort only. Count and component relaxations are outer bounds. No general matroid facet enumeration or membership claim.'};assert all(sha(ROOT/p)==h for p,h in hashes.items());out.write_text(json.dumps(result,indent=2)+'\n');print(result['aggregate']);print([(r['cut'],r['bounds'],r['exact_gaps']['single_prefix_rank']) for r in records]);print('seconds',result['elapsed_seconds'])
if __name__=='__main__':main()
