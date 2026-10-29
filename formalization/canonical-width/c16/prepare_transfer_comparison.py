#!/usr/bin/env python3
"""Freeze three held-out anchors and a common proof domain before discovery."""
from pathlib import Path
import datetime, hashlib, json, sys, time
from signature_cover import logical_data
from sparse_kept_anchor_domain_signature import setup, expand, dump_input
ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'transfer-results'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p, d): p.write_text(json.dumps(d, indent=2) + '\n')
def main():
    start = time.monotonic(); OUT.mkdir(exist_ok=True)
    assert not (OUT/'comparison-frozen.json').exists()
    parent = ROOT/'relevant-results/cover-408.json'
    A,C,E = logical_data(); rows = json.loads(parent.read_text())['cases']
    retained = {tuple(r['orbit_tuple']) for r in rows}; old = set(C)-retained
    # Disjoint structural strata, selected by input size, not fresh solver results.
    groups = [lambda c: c[0]!=c[1] and not set(c[:2])&{26,32},
              lambda c: c[0]!=c[1] and 26 in c[:2],
              lambda c: c[0]==c[1]]
    sizes=[]
    for row in rows:
        c=tuple(row['orbit_tuple']); x,z=row['X_index'],row['Z_index']
        n=sum(C[k] in old|{c} and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1 for i,j,s,k in E)
        sizes.append((n,c,x,z))
    selected=[min(v for v in sizes if group(v[1])) for group in groups]
    assert [v[1] for v in selected]==[(6,28,13),(8,26,1),(32,32,3)]
    cases=[v[1] for v in selected]; domain=OUT/'domain.json'
    save(domain,{'classes':sorted(old|set(cases)),'candidate_cases':cases,'parent_case_count':408,
                 'candidate_selection':'Minimum individual compatible free-edge count in each of three disjoint strata: cross-orbit without26/32; cross-orbit containing26; same-orbit. Tuple tie break. Frozen before new solver trials.',
                 'individual_free_edge_counts':[v[0] for v in selected], 'source_C16_answered':False})
    basepaths=['strategy-results/closure-cover-extension.json','strategy-results/closure-global.json',
               'strategy-results/matroid-closure-global.json','strategy-results/phase-matroid-closure-global.json',
               'strategy-results/rank-global.json','strategy-results/universal-from-domain416.json',
               'strategy-results/universal-short-word-seeds.json']
    seedpath=ROOT/'relevant-results/comparison-seed-cuts.json'
    seeds=json.loads(seedpath.read_text())['cuts']; assert len(seeds)==256
    gate=json.loads((ROOT/'relevant-results/independent-gate.json').read_text()); assert sha(seedpath)==gate['comparison_seed_sha256']
    basecuts=[]
    for p in basepaths: basecuts += json.loads((ROOT/p).read_text())['cuts']
    assert not any('domain' in c['kind'] for c in basecuts)
    profiles=ROOT/'algebraic-results/orbit-rank-profiles.json.gz'
    libraries=['/private/tmp/c16-domain-propagation.dylib','/private/tmp/c16-conditional-word.dylib','/private/tmp/c16-sparse-quotient.dylib']
    trials=[]; initial=[]
    for k,(count,case,x,z) in enumerate(selected):
        _,_,edges,anchor,_,_,cnf,n,owners,_=setup('restricted',True,profiles,True,domain,[x,z])
        seen={tuple(sorted(c)) for c in cnf}
        for cut in basecuts:
            for clause in sorted(expand(cut,owners,anchor)-seen): cnf.append(list(clause));seen.add(clause)
        info={'case':case,'anchor':[x,z],'variables':n,'common_domain_free_edges':len(edges),'inputs':{}}
        for variant,additional in [('baseline',[]),('seeded',seeds)]:
            for cut in additional:
                for clause in sorted(expand(cut,owners,anchor)-seen):
                    assert all(v<0 for v in clause);cnf.append(list(clause));seen.add(clause)
            path=OUT/f'case-{k:02d}-{variant}-initial.cnf.gz'
            info['inputs'][variant]={'file':path.name,'sha256':dump_input(path,n,cnf),'clauses':len(cnf)}
        info['added_clauses']=info['inputs']['seeded']['clauses']-info['inputs']['baseline']['clauses']; assert info['added_clauses']>0
        initial.append(info)
        for variant in (['baseline','seeded'] if k%2==0 else ['seeded','baseline']):
            name=f'case-{k:02d}-{variant}'
            cmd=[sys.executable,'sparse_kept_anchor_domain_signature.py','--mode','restricted','--restricted-classes','transfer-results/domain.json',
                 '--anchor',str(x),str(z),'--parent-cover','relevant-results/cover-408.json','--seed-cuts',*basepaths,
                 *(['relevant-results/comparison-seed-cuts.json'] if variant=='seeded' else []),
                 '--separator','closure','--native-library',libraries[0],'--word-library',libraries[1],
                 '--sparse-library',libraries[2],'--sparse-order','0','--signature-independent','--projection-count',
                 '--phase-profiles','algebraic-results/orbit-rank-profiles.json.gz','--rounds','10000','--seconds','900',
                 '--output',f'transfer-results/{name}.json']
            trials.append({'name':name,'case_index':k,'variant':variant,'command':cmd})
    sources=['prepare_transfer_comparison.py','run_transfer_comparison.py','verify_transfer_case.py',
             'sparse_kept_anchor_domain_signature.py','verify_sparse_kept_anchor.py','verify_sparse_quotient.py',
             'verify_strategy_cover_union.py','verify_strategy_cover_bindings.py','transfer-results/domain.json',
             'relevant-results/cover-408.json','relevant-results/comparison-seed-cuts.json',
             'relevant-results/independent-gate.json','algebraic-results/orbit-rank-profiles.json.gz',*basepaths]
    result={'status':'FROZEN_BEFORE_ALL_SIX_TRIALS','frozen_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'source_C16_answered':False,'parent_cover_count':408,'common_domain_class_count':len(old|set(cases)),
            'workers':1,'seconds_each':900,'rounds_each':10000,'trials':trials,'initial_inputs':initial,
            'unchanged_seed_orbits':256,'baseline_seed_records':len(basecuts),'old_conditional_domain_seeds_imported':0,
            'source_hashes':{p:sha(ROOT/p) for p in sources},'library_hashes':{p:sha(Path(p)) for p in libraries},
            'full_completion_anchor_preselected':[48,48], 'preparation_seconds':time.monotonic()-start,
            'gate':'Require repeated proof progress or faster completed outcomes in at least two held-out cases before scaling the bank. Two timeouts establish no speedup. A single benefit is inconclusive; report any regressions.',
            'scope':'Held out from the one-case training corpus, not a random sample. All three domains are identical and contain the avoidance domain for any subset of these removals. Only initial universal seeds differ within each pair. No mining or tuning using the new trials.'}
    save(OUT/'comparison-frozen.json',result)
    print(json.dumps({k:v for k,v in result.items() if k not in ['trials','source_hashes','library_hashes']},indent=2),flush=True)
if __name__=='__main__': main()
