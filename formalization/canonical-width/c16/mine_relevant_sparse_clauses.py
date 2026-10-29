#!/usr/bin/env python3
"""Mine and shrink source-valid sparse obstructions on the frozen hard case."""
from pathlib import Path
import argparse,collections,datetime,gzip,hashlib,json,time
from sparse_kept_anchor_domain_signature import setup,expand,ROOT
from sparse_quotient_oracle import SparseQuotientOracle
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def orbit(ids):return min(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in ids)) for h in range(16))
class Subsumption:
    def __init__(self,clauses):
        self.rows=set();self.index=collections.defaultdict(list)
        for clause in clauses:self.add(clause)
    def add(self,clause):
        row=frozenset(clause)
        if row in self.rows or any(x>=0 for x in row):return
        self.rows.add(row)
        if row:self.index[min(row)].append(row)
    def witness(self,clause):
        row=frozenset(clause)
        if frozenset() in self.rows:return ()
        for lit in row:
            for old in self.index.get(lit,[]):
                if old<=row:return tuple(sorted(old))
        return None

def main():
    p=argparse.ArgumentParser();p.add_argument('--library',type=Path,required=True);p.add_argument('--output-directory',type=Path,required=True);p.add_argument('--seconds',type=float,default=1200);a=p.parse_args();a.output_directory.mkdir(exist_ok=False)
    start=time.monotonic();source_paths=[ROOT/f'three-term-results/matched-order-{order}.json' for order in (0,2,3)];sources=[json.loads(p.read_text()) for p in source_paths];baseline=sources[1];assert all(len(d['records'])>=1688 for d in sources)
    assert all([r['pairs'] for r in d['records'][:1688]]==[r['pairs'] for r in sources[0]['records'][:1688]] for d in sources)
    assert not baseline['signature_circuits'];X,Z,A=physical();oracle=SparseQuotientOracle(X,Z,a.library);consumer=SparseQuotientConsumer(X,Z)
    AA,C,E,anchor,R,target,base,n,owners,events=setup(baseline['mode'],True,ROOT/baseline['phase_profiles_c16_path'],True,ROOT/baseline['restricted_classes_c16_path'],baseline['anchor']);assert A==AA and n==baseline['variables']
    input_path=source_paths[1].parent/baseline['input_file'];raw=gzip.decompress(input_path.read_bytes());assert hashlib.sha256(raw).hexdigest()==baseline['input_sha256'];lines=raw.decode().splitlines();assert lines[0]==f"p cnf {n} {baseline['clauses']}";clauses=[list(map(int,line.split()))[:-1] for line in lines[1:]];sub=Subsumption(clauses)
    cohort=[]
    for k,record in enumerate(baseline['records'][:1688]):
        pairs=record['pairs'];seeds=[]
        for side in (0,1):seeds.append({'sector':side,'ids':sorted(v[side] for v in pairs),'origin':'full_selected_sector'})
        for idx in record['cut_indices']:
            cut=baseline['cuts'][idx]
            if 'indices' in cut:seeds.append({'sector':cut['sector'],'ids':sorted(cut['indices']),'origin':'associated_propagation_core','cut_index':idx})
            else:
                for side,key in enumerate(['required_X','required_Z']):seeds.append({'sector':side,'ids':sorted(cut[key]),'origin':'associated_joint_core_sector','cut_index':idx})
        unique=[];seen=set()
        for seed in seeds:
            key=(seed['sector'],tuple(seed['ids']))
            if key not in seen:unique.append(seed);seen.add(key)
        cohort.append({'source_record':k,'pairs':pairs,'starting_sets':unique})
    cp=a.output_directory/'cohort.json';cp.write_text(json.dumps({'records':cohort},indent=2)+'\n')
    frozen={'status':'FROZEN_BEFORE_MINING','frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'source_paths':[str(p.relative_to(ROOT)) for p in source_paths],'source_sha256':[sha(p) for p in source_paths],'cohort_file':cp.name,'cohort_sha256':sha(cp),'baseline_seed_c16_path':str(source_paths[1].relative_to(ROOT)),'baseline_input_sha256':baseline['input_sha256'],'baseline_input_file':str(input_path.relative_to(ROOT)),'seconds':a.seconds,'library_sha256':sha(a.library),'code_sha256':{p:sha(ROOT/p) for p in ['mine_relevant_sparse_clauses.py','sparse_quotient_oracle.py','sparse_quotient_native.cpp','verify_sparse_quotient.py','sparse_kept_anchor_domain_signature.py']},'shrink_orders':['ascending','descending'],'fallback':'If no initial starting set rejects in a sector, inspect its full-set one-deletion neighbors until the first rejection. No arbitrary subset enumeration.','bank_filter':'Final certificate verified; source pattern hits a frozen matching; at least one emitted clause is not syntactically subsumed by baseline or previously accepted shorter cores.'}
    (a.output_directory/'frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    cache={};stats=collections.Counter();cores={};records=[];expired=False
    def probe(side,ids):
        if time.monotonic()-start>=a.seconds:raise TimeoutError
        key=(side,tuple(sorted(ids)))
        if key in cache:stats['cache_hits']+=1;return cache[key]
        rows=oracle.probe(1-side,list(key[1]),3,cap=1);row=rows[0] if rows else None;cache[key]=row;stats['native_queries']+=1;stats['rejecting_queries']+=bool(row);return row
    def shrink(side,ids,reverse):
        current=sorted(ids);row=probe(side,current);assert row;removed=[]
        while True:
            changed=False
            for i in sorted(current,reverse=reverse):
                trial=[j for j in current if j!=i];candidate=probe(side,trial)
                if candidate:current=trial;row=candidate;removed.append(i);changed=True
            if not changed:break
        consumer.check(row);key=orbit(current)
        if key not in cores:
            cut={'kind':'universal_sparse_quotient','sector':side,'indices':current,'certificate':row};expanded=sorted(expand(cut,owners,anchor));fresh=[c for c in expanded if sub.witness(c) is None]
            cores[key]={'cut':cut,'canonical_orbit':list(key),'initial_ids':ids,'removed_ids':removed,'reverse_deletion_order':reverse,'expanded_clauses':[list(c) for c in expanded],'baseline_non_subsumed_clauses':[list(c) for c in fresh],'first_source_record':k,'initial_cardinality':len(ids),'final_cardinality':len(current),'single_deletion_minimal_for_complete_order3_native':True}
        return key
    for k,item in enumerate(cohort):
        found_by_sector=[False,False];keys=set()
        try:
            for seed in item['starting_sets']:
                side=seed['sector'];ids=seed['ids']
                if probe(side,ids):
                    found_by_sector[side]=True
                    for reverse in (False,True):keys.add(shrink(side,ids,reverse))
            for side in (0,1):
                if found_by_sector[side]:continue
                ids=sorted(v[side] for v in item['pairs'])
                for i in ids:
                    trial=[j for j in ids if j!=i]
                    if probe(side,trial):
                        found_by_sector[side]=True
                        for reverse in (False,True):keys.add(shrink(side,trial,reverse))
                        break
        except TimeoutError:expired=True;break
        records.append({'source_record':k,'sector_rejections':found_by_sector,'core_orbits':[list(key) for key in sorted(keys)]})
        if k%100==0:print('RELEVANT MINE',k,dict(stats),'cores',len(cores),'seconds',round(time.monotonic()-start,2),flush=True)
    accepted=[];retained=Subsumption(clauses)
    for key,record in sorted(cores.items(),key=lambda kv:(len(kv[0]),kv[0])):
        new=[c for c in record['expanded_clauses'] if retained.witness(c) is None]
        record['accepted_seed']=bool(new);record['new_clauses_at_acceptance']=new
        if new:
            accepted.append(record['cut'])
            for clause in record['expanded_clauses']:retained.add(clause)
    result={'status':'TIME_LIMIT' if expired else 'COMPLETE','source_C16_answered':False,'frozen_sha256':sha(a.output_directory/'frozen.json'),'cohort_sha256':sha(cp),'source_records_processed':len(records),'source_records_total':len(cohort),'records':records,'core_records':list(cores.values()),'stats':dict(stats),'unique_core_orbits':len(cores),'accepted_seed_orbits':len(accepted),'elapsed_seconds':time.monotonic()-start,'scope':'Exact source certificates on bounded subsets of saved hard-case matchings. Native discovery shrinks until every single deletion fails its complete order3 predicate. Final certificates independently checked; independent minimality and subsumption replay are separate. No source case or cover exclusion.'}
    (a.output_directory/'mining.json').write_text(json.dumps(result,indent=2)+'\n');(a.output_directory/'seed-cuts.json').write_text(json.dumps({'status':'SOURCE_CERTIFICATES_DISCOVERED','source_C16_answered':False,'mining_sha256':sha(a.output_directory/'mining.json'),'cuts':accepted},indent=2)+'\n');oracle.close();print('RELEVANT END',result['status'],result['source_records_processed'],len(cores),len(accepted),result['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
