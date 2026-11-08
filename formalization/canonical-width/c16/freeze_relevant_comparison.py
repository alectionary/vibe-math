#!/usr/bin/env python3
"""Freeze a matched baseline/seeded comparison after the relevance gate passes."""
from pathlib import Path
import datetime,gzip,hashlib,json,sys
from sparse_kept_anchor_domain_signature import setup,expand,dump_input,ROOT

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    out=ROOT/'relevant-results';receipt=json.loads((out/'independent-gate.json').read_text());assert receipt['status']=='PASS' and receipt['comparison_seed_orbits']>0
    seedpath=out/'comparison-seed-cuts.json';assert sha(seedpath)==receipt['comparison_seed_sha256'];seeds=json.loads(seedpath.read_text())['cuts'];basepath=ROOT/'three-term-results/matched-order-2.json';base=json.loads(basepath.read_text());assert not base['signature_circuits']
    A,C,E,anchor,R,target,initial,n,owners,events=setup(base['mode'],True,ROOT/base['phase_profiles_c16_path'],True,ROOT/base['restricted_classes_c16_path'],base['anchor']);raw=gzip.decompress((basepath.parent/base['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==base['input_sha256'];lines=raw.decode().splitlines();assert lines[0]==f"p cnf {n} {base['clauses']}";cnf=[list(map(int,line.split()))[:-1] for line in lines[1:]];seen={tuple(sorted(c)) for c in cnf};baseline_sha=dump_input(out/'baseline-initial.cnf.gz',n,cnf);count=len(cnf)
    for cut in seeds:
        for clause in sorted(expand(cut,owners,anchor)-seen):assert all(v<0 for v in clause);cnf.append(list(clause));seen.add(clause)
    strengthened_sha=dump_input(out/'seeded-initial.cnf.gz',n,cnf);assert len(cnf)>count
    # Retrospective relevance is descriptive. These same records supplied the seeds.
    coverage=[]
    for k,record in enumerate(base['records'][:1688]):
        selected=[{v[s] for v in record['pairs']} for s in (0,1)];hit=False
        for cut in seeds:
            for h in range(16):
                ids={16*(i//16)+(i+h)%16 for i in cut['indices']}
                if any(ids<=s for s in selected):hit=True;break
            if hit:break
        if hit:coverage.append(k)
    commands=[]
    for variant in ['baseline','seeded']:
        seedargs=['three-term-results/matched-order-2.json']+(['relevant-results/comparison-seed-cuts.json'] if variant=='seeded' else [])
        commands.append([sys.executable,'sparse_kept_anchor_domain_signature.py','--mode','restricted','--restricted-classes','strategy-results/domain-batch-408.json','--anchor','416','515','--parent-cover','strategy-results/cover-416.json','--seed-cuts',*seedargs,'--separator','closure','--native-library','/private/tmp/c16-domain-propagation.dylib','--word-library','/private/tmp/c16-conditional-word.dylib','--sparse-library','/private/tmp/c16-sparse-quotient.dylib','--sparse-order','0','--signature-independent','--projection-count','--phase-profiles','algebraic-results/orbit-rank-profiles.json.gz','--rounds','10000','--seconds','1200','--output',f'relevant-results/{variant}.json'])
    sources=['sparse_kept_anchor_domain_signature.py','verify_sparse_kept_anchor.py','verify_sparse_quotient.py','freeze_relevant_comparison.py','relevant-results/comparison-seed-cuts.json','relevant-results/independent-gate.json','three-term-results/matched-order-2.json','strategy-results/domain-batch-408.json','strategy-results/cover-416.json','strategy-results/final-cover.json','algebraic-results/orbit-rank-profiles.json.gz']
    f={'status':'FROZEN_BEFORE_SOLVER_COMPARISON','frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'anchor':[416,515],'case':[26,32,3],'variants':['baseline','seeded'],'commands':commands,'discovery_seconds_each':1200,'rounds_each':10000,'workers':1,'sequence':['baseline','seeded'],'initial_inputs':{'baseline':{'file':'baseline-initial.cnf.gz','sha256':baseline_sha,'clauses':count},'seeded':{'file':'seeded-initial.cnf.gz','sha256':strengthened_sha,'clauses':len(cnf)}},'new_seed_orbits':len(seeds),'additional_initial_clauses':len(cnf)-count,'saved_source_matchings_hit':len(coverage),'saved_source_matching_indices_hit':coverage,'source_hashes':{p:sha(ROOT/p) for p in sources},'library_hashes':{p:sha(Path(p)) for p in ['/private/tmp/c16-domain-propagation.dylib','/private/tmp/c16-conditional-word.dylib','/private/tmp/c16-sparse-quotient.dylib']},'fresh_proof_seconds_each':600,'independent_replay_outer_seconds_each':900,'scope':'Both variants use the same existing dynamic separators (sparse-order0). The sole model change is the independently verified initial seed bank. Retrospective coverage is measured on the training cohort and is not a holdout success rate. Outcomes alone do not prove a general speedup; a cover change requires independent source/CNF/DRAT and cover-induction replay.'}
    (out/'comparison-frozen.json').write_text(json.dumps(f,indent=2)+'\n');print({k:v for k,v in f.items() if k not in ['commands','source_hashes','library_hashes','saved_source_matching_indices_hit']},flush=True)
if __name__=='__main__':main()
