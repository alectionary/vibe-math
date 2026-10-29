#!/usr/bin/env python3
"""Independent physical, sparse-minimality and CNF relevance replay."""
from pathlib import Path
import argparse,collections,gzip,hashlib,itertools,json,time
from verify_anchored_cover_chain import physical as graph,canonical
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer
from verify_sparse_gate import independent_obstruction
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def orbit(ids):return min(tuple(sorted(16*(i//16)+(i+h)%16 for i in ids)) for h in range(16))
class IndependentBlockers:
    def __init__(self,clauses,owners):
        self.rows=set();self.by_max=collections.defaultdict(list);self.lengths=set();self.owner_variables=set().union(*(set(o.values()) for o in owners))
        for row in clauses:self.add(row)
    def add(self,clause):
        row=frozenset(clause)
        if any(v>=0 or -v not in self.owner_variables for v in row) or row in self.rows:return
        self.rows.add(row);self.lengths.add(len(row))
        if row:self.by_max[max(row)].append(row)
    def rejects(self,clause):
        row=frozenset(clause)
        if frozenset() in self.rows:return True
        if len(row)<=12:
            return any(frozenset(c) in self.rows for n in sorted(self.lengths) if n<=len(row) for c in itertools.combinations(row,n))
        return any(old<=row for v in row for old in self.by_max.get(v,[]))

def main():
    p=argparse.ArgumentParser();p.add_argument('--directory',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--max-seeds',type=int,default=256);a=p.parse_args();assert a.max_seeds>0;start=time.monotonic();f=json.loads((a.directory/'frozen.json').read_text());data=json.loads((a.directory/'mining.json').read_text());cohort=json.loads((a.directory/f['cohort_file']).read_text())['records'];seed=json.loads((a.directory/'seed-cuts.json').read_text())
    assert sha(a.directory/'frozen.json')==data['frozen_sha256'];assert sha(a.directory/f['cohort_file'])==data['cohort_sha256']==f['cohort_sha256'];assert seed['mining_sha256']==sha(a.directory/'mining.json')
    for path,digest in f['code_sha256'].items():assert sha(ROOT/path)==digest
    sources=[]
    for name,digest in zip(f['source_paths'],f['source_sha256']):assert sha(ROOT/name)==digest;sources.append(json.loads((ROOT/name).read_text()))
    base=sources[1];receipt=json.loads((ROOT/'three-term-results/clean-trial-replay/matched-order-2-independent.json').read_text());manifest=json.loads((ROOT/'three-term-results/clean-trial-replay/manifest.json').read_text());binding=next(r for r in manifest['records'] if r['source']==f['baseline_seed_c16_path']);assert binding['source_sha256']==f['source_sha256'][1] and binding['receipt_sha256']==sha(ROOT/'three-term-results/clean-trial-replay'/binding['receipt']);assert receipt['status']=='PASS' and receipt['input_sha256']==base['input_sha256']==f['baseline_input_sha256']
    X,Z,A=physical();AA,C,pos,sig=graph();assert A==AA;consumer=SparseQuotientConsumer(X,Z);R=set(map(tuple,base['removed_class_tuples']));anchor=tuple(base['anchor']);assert anchor==(416,515)
    E=[(i,j,s,0) for (i,j),s in sig.items() if s and canonical(i,j) in R and i!=anchor[0] and j!=anchor[1] and not A[i]>>anchor[1]&1 and not A[anchor[0]]>>j&1];assert len(E)==base['free_edges'];groups=[sorted({e[side] for e in E}) for side in (0,1)];owners=[{i:len(E)+k+1 for k,i in enumerate(groups[0])},{i:len(E)+len(groups[0])+k+1 for k,i in enumerate(groups[1])}]
    columns=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)];assert A==columns
    for i,row in enumerate(A):
        shifted=sum(((((row>>(16*o))&65535)<<1|((row>>(16*o))&65535)>>15)&65535)<<(16*o) for o in range(45));assert shifted==A[16*(i//16)+(i%16+1)%16]
    for k,item in enumerate(cohort):
        assert item['source_record']==k and all(d['records'][k]['pairs']==item['pairs'] for d in sources)
        pairs=item['pairs'];selected=[{v[side] for v in pairs} for side in (0,1)]
        for i,(x,z) in enumerate(pairs):
            assert A[x]>>z&1
            for xx,zz in pairs[:i]:assert x!=xx and z!=zz and not A[x]>>zz&1 and not A[xx]>>z&1
        for s in item['starting_sets']:
            assert len(s['ids'])==len(set(s['ids'])) and set(s['ids'])<=selected[s['sector']]
            if s['origin']=='full_selected_sector':assert set(s['ids'])==selected[s['sector']]
            else:
                cut=base['cuts'][s['cut_index']];assert s['cut_index'] in base['records'][k]['cut_indices']
                expected=cut.get('indices',cut.get(['required_X','required_Z'][s['sector']]))
                assert s['ids']==sorted(expected)
    raw=gzip.decompress((ROOT/f['baseline_input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==base['input_sha256'];lines=raw.decode().splitlines();assert lines[0]==f"p cnf {base['variables']} {base['clauses']}";clauses=[]
    for line in lines[1:]:nums=list(map(int,line.split()));assert nums[-1]==0;clauses.append(nums[:-1])
    baseline=IndependentBlockers(clauses,owners);retained=IndependentBlockers(clauses,owners)
    expected_seed=[];comparison_seed=[];cores=data['core_records'];assert len({tuple(r['canonical_orbit']) for r in cores})==len(cores)==data['unique_core_orbits'];counts=collections.Counter();proof_rows=[];minimality_cache={}
    def predicate(side,ids):
        key=(side,tuple(sorted(ids)))
        if key not in minimality_cache:minimality_cache[key]=independent_obstruction(X,Z,1-side,list(key[1]))
        return minimality_cache[key]
    for record in sorted(cores,key=lambda r:(len(r['canonical_orbit']),r['canonical_orbit'])):
        cut=record['cut'];row=cut['certificate'];consumer.check(row);ids=cut['indices'];side=cut['sector'];assert side==1-row['side'] and ids==row['mandatory_opposite'];assert list(orbit(ids))==record['canonical_orbit'];source=cohort[record['first_source_record']];assert set(ids)<=set(record['initial_ids'])<={v[side] for v in source['pairs']};assert len(record['initial_ids'])==record['initial_cardinality'] and len(ids)==record['final_cardinality'];assert set(record['removed_ids'])==set(record['initial_ids'])-set(ids) and len(record['removed_ids'])==len(set(record['removed_ids']))
        expanded=set()
        for h in range(16):
            shifted=[16*(i//16)+(i+h)%16 for i in ids]
            for owner_side,owner in enumerate(owners):
                rest=[i for i in shifted if i!=anchor[owner_side]]
                if all(i in owner for i in rest):expanded.add(tuple(sorted(-owner[i] for i in rest)))
        expanded=sorted(expanded);assert [list(c) for c in expanded]==record['expanded_clauses'];fresh=[list(c) for c in expanded if not baseline.rejects(c)];assert fresh==record['baseline_non_subsumed_clauses'];new=[list(c) for c in expanded if not retained.rejects(c)];assert new==record['new_clauses_at_acceptance'] and bool(new)==record['accepted_seed']
        counts['all_source_certificates']+=1;counts['all_order_'+str(row['order'])]+=1
        if new:
            expected_seed.append(cut)
            for c in expanded:retained.add(c)
            assert set(ids)<={v[side] for v in source['pairs']}
            selected_owners={owners[side][i] for i in ids if i!=anchor[side]};actual_clause=tuple(sorted(-v for v in selected_owners));assert actual_clause in expanded
        if new and len(ids)<record['initial_cardinality'] and len(comparison_seed)<a.max_seeds:
            comparison_seed.append(cut)
            for removed in ids:
                outcome=predicate(side,[i for i in ids if i!=removed]);assert not outcome[3],(ids,removed)
                counts['single_deletion_non_rejections']+=1
            complete=predicate(side,ids);assert complete[3];counts['accepted_strict3_over_complete2']+=not complete[2];counts['accepted_order_'+str(row['order'])]+=1;counts['accepted_shorter_than_initial']+=len(ids)<record['initial_cardinality'];counts['accepted_new_clauses']+=len(new)
            proof_rows.append({'sector':side,'ids':ids,'order':row['order'],'source_record':record['first_source_record'],'single_deletion_checks':len(ids),'complete2_reject':complete[2],'complete3_reject':complete[3],'new_clause_count':len(new)})
        if counts['all_source_certificates']%500==0:print('RELEVANT REPLAY',dict(counts),'seconds',round(time.monotonic()-start,2),flush=True)
    assert expected_seed==seed['cuts'] and len(expected_seed)==data['accepted_seed_orbits'];assert data['source_records_processed']==len(data['records'])<=len(cohort)
    selection={'status':'INDEPENDENTLY_VERIFIED_COMPARISON_SEEDS','source_C16_answered':False,'parent_seed_sha256':sha(a.directory/'seed-cuts.json'),'selection_rule':'From accepted cores sorted by cardinality then canonical orbit, retain the first max_seeds that strictly shrink their recorded starting set. No trial outcome is used.','max_seeds':a.max_seeds,'cuts':comparison_seed};selected_path=a.output.with_name('comparison-seed-cuts.json');selected_path.write_text(json.dumps(selection,indent=2)+'\n')
    out={'status':'PASS','source_C16_answered':False,'mining_sha256':sha(a.directory/'mining.json'),'seed_sha256':sha(a.directory/'seed-cuts.json'),'frozen_sha256':sha(a.directory/'frozen.json'),'cohort_physical_matchings_checked':len(cohort),'accepted_seed_orbits':len(expected_seed),'comparison_seed_orbits':len(comparison_seed),'comparison_seed_sha256':sha(selected_path),'counts':dict(counts),'independent_predicate_queries':len(minimality_cache),'accepted_core_checks':proof_rows,'elapsed_seconds':time.monotonic()-start,'scope':'All mined final source certificates, physical cohort, exact clause expansion and syntactic subsumption independently replay. Every selected comparison seed is shorter than its starting set, has a source occurrence, and every single-vector deletion is independently non-rejecting for the complete order3 criterion. This is single-deletion irreducibility, not globally shortest clauses, completeness for nonexistence, logical nonredundancy or a cover proof.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print('RELEVANT REPLAY PASS',dict(counts),out['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
