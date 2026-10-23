"""Audit the bounded quantum follow-up without rerunning its full benchmark.

Independently reduce stabilizers from their lowest pivots, reconstruct every
stored sector outcome and Pauli<=2 probability, and check fresh noise prefixes
against the Python message definition as well as the compiled decoder.
"""
from collections import Counter, defaultdict
from itertools import combinations, product
from pathlib import Path
import base64
import hashlib
import json
import math
import random
import shutil
import subprocess
import sys
import tempfile
import zlib

sys.dont_write_bytecode = True
R = Path(__file__).resolve().parent.parent
P = R/'formalization/dyadic-performance'
sys.path.insert(0, str(P/'search'))
import pilot as p
import quantum_css as q
import targeted as t


def low_basis(rows):
    basis = {}
    for word in rows:
        while word:
            pivot = word & -word
            if pivot in basis:
                word ^= basis[pivot]
            else:
                basis[pivot] = word
                break
    return basis


def reduced(word, basis):
    for pivot in sorted(basis):
        if word & pivot:
            word ^= basis[pivot]
    return word


def unpack(value, count):
    raw = zlib.decompress(base64.b64decode(value))
    assert len(raw) == (count+7)//8
    bits = [int(c) for byte in raw for c in f'{byte:08b}']
    assert not any(bits[count:])
    return bits[:count]


def syndrome(h, word):
    return sum((p.popcount(row & word) % 2) << i for i, row in enumerate(h))


def samples(fi, ri, n):
    rng = random.Random(20261120+100000*fi+100*ri)
    return [(''.join(str(int(rng.random() < .02)) for _ in range(n)),
             ''.join(str(int(rng.random() < .02)) for _ in range(n))) for _ in range(20000)]


s = json.loads((P/'search/targeted-selection.json').read_text())
d = json.loads((P/'search/targeted-results.json').read_text())
original = json.loads((P/'search/quantum-selection.json').read_text())
assert d['selection_sha256'] == hashlib.sha256((P/'search/targeted-selection.json').read_bytes()).hexdigest()
for name, sha in s['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
for name, sha in original['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
reps = binary_count = pauli_count = reference_checks = fresh_evaluations = 0
with tempfile.TemporaryDirectory(prefix='p11-targeted-audit-') as temp:
    engine = Path(temp)/'minsum'
    subprocess.run(['c++','-std=c++17','-O2',str(p.OLD/'minsum.cpp'),'-o',str(engine)],check=True)
    for fi, (sf, rf, of) in enumerate(zip(s['families'], d['families'], original['families'])):
        assert sf['configuration'] == rf['configuration'] == of['configuration']
        n, ell = sf['configuration']['n'], sf['configuration']['ell']
        errors = [sum(1 << v for v in support) for w in range(3) for support in combinations(range(n), w)]
        groups = defaultdict(list)
        for pool in of['pools']:
            for code in pool['candidates']:
                key = json.dumps([code['graph_x'],code['graph_z'],code['logical_x']['kernel_supports'],
                                  code['logical_z']['kernel_supports']],sort_keys=True)
                groups[key].append({'pool_id':pool['id'],'candidate_id':code['id'],'code':code})
        assert len(groups) == len(sf['profiles']) == len(rf['profiles']) == [7,4][fi]
        expected_discordances = []
        for a,c in combinations(sf['profiles'],2):
            ca,cc = a['representatives'][0]['code'], c['representatives'][0]['code']
            if ca['cycles_total'] < cc['cycles_total'] and ca['scores']['absorbing'] > cc['scores']['absorbing']:
                expected_discordances.append({'cycle_preferred':a['id'],'absorbing_preferred':c['id']})
            elif ca['cycles_total'] > cc['cycles_total'] and ca['scores']['absorbing'] < cc['scores']['absorbing']:
                expected_discordances.append({'cycle_preferred':c['id'],'absorbing_preferred':a['id']})
        assert sf['discordant_profile_pairs'] == rf['discordant_profile_pairs'] == expected_discordances
        equal_cycles = defaultdict(set)
        for prof in sf['profiles']:
            code=prof['representatives'][0]['code']
            equal_cycles[tuple(code['cycles_total'])].add(tuple(code['absorbing_features_total']))
        assert sum(len(v)>1 for v in equal_cycles.values()) == sf['equal_total_cycles_different_aggregate_absorbing'] == 0
        noise = {ri:samples(fi,ri,n) for ri in range(2)}
        for (key, entries), sp, rp in zip(sorted(groups.items()), sf['profiles'], rf['profiles']):
            ordered=sorted(entries,key=lambda e:json.dumps(e['code']['parameters'],sort_keys=True))
            expected=[ordered[0],next(e for e in ordered if e['pool_id'] != ordered[0]['pool_id'])]
            assert sp['representatives'] == expected and sp['instances_in_saved_sample']==len(entries)
            assert sp['profile_sha256'] == hashlib.sha256(key.encode()).hexdigest()
            for ri,(selected,result) in enumerate(zip(sp['representatives'],rp['representatives'])):
                reps+=1
                code=selected['code']; lw=result['low_weight'];mc=result['monte_carlo']
                assert (result['source_pool'],result['source_candidate']) == (selected['pool_id'],selected['candidate_id'])
                hx,hz,vx,vz=q.expansion(code['bx'],code['bz'],ell)
                xm,zm=list(map(p.decoder.rowmask,hx)),list(map(p.decoder.rowmask,hz))
                xb,zb=low_basis(xm),low_basis(zm)
                assert len(xb)==len(zb)==sf['configuration']['rank']
                responses=[]
                for stored,hm,stab,h,vn in [(lw['sector_x'],zm,xb,hz,vz),(lw['sector_z'],xm,zb,hx,vx)]:
                    assert len(stored['estimate_hex'])==len(stored['status_codes'])==len(errors)
                    response={};counts=Counter(); chosen={}
                    for e,est,status in zip(errors,stored['estimate_hex'],stored['status_codes']):
                        est=int(est,16); residual=e^est
                        actual='0' if reduced(residual,stab)==0 else '1' if syndrome(hm,residual)==0 else '2'
                        assert actual==status and est < 1<<n
                        sy=syndrome(hm,e);cl=reduced(e,stab);outcl=reduced(est,stab)
                        assert sy not in chosen or chosen[sy]==outcl
                        chosen[sy]=outcl
                        response[e]=(actual,sy,cl,outcl)
                        counts[(p.popcount(e),{'0':'success','1':'logical','2':'syndrome'}[actual])]+=1
                    assert stored['counts']==[{'weight':w,'status':status,'count':v} for (w,status),v in sorted(counts.items())]
                    # Includes singleton/pair errors, not just the all-zero response.
                    probe=[0,1,n+1,len(errors)-1]
                    trials=[(.02,p.decoder.bit_string(errors[i],n)) for i in probe]
                    compiled=p.decoder.engine(engine,h,n,trials,50,.8)
                    for index,trial,out in zip(probe,trials,compiled):
                        assert out==p.decoder.reference_decode(h,n,trial[1],.02,50,.8)
                        assert hex(p.decoder.string_mask(out[2]))==stored['estimate_hex'][index]
                        reference_checks+=1
                    # Recompute all binary-pair diagnostics, including 32-qubit containment.
                    adapted={e:{'status':{'0':'success','1':'logical','2':'syndrome'}[v[0]]} for e,v in response.items()}
                    diagnosis=t.pair_diagnosis(adapted,vn,n==32)
                    assert diagnosis==lw['pair_diagnosis_x' if len(responses)==0 else 'pair_diagnosis_z']
                    responses.append(response)
                xr,zr=responses
                patterns=[]
                for w in range(3):
                    for support in combinations(range(n),w):
                        for types in product((1,2,3),repeat=w):
                            ex=sum(1<<v for v,typ in zip(support,types) if typ in (1,3))
                            ez=sum(1<<v for v,typ in zip(support,types) if typ in (2,3))
                            patterns.append((ex,ez,w))
                assert len(patterns)==1+3*n+9*n*(n-1)//2==lw['pauli_patterns']
                fail=unpack(lw['failure_bitmap_zlib_base64'],len(patterns))
                logical=unpack(lw['logical_failure_bitmap_zlib_base64'],len(patterns))
                mismatch=unpack(lw['syndrome_failure_bitmap_zlib_base64'],len(patterns))
                buckets=defaultdict(lambda:defaultdict(lambda:[0]*5));counts=Counter()
                low_responses={}
                for i,(ex,ez,w) in enumerate(patterns):
                    x,z=xr[ex],zr[ez];bad=x[0]!='0' or z[0]!='0';sy=x[0]=='2' or z[0]=='2'
                    assert (fail[i],logical[i],mismatch[i])==(int(bad),int(bad and not sy),int(sy))
                    k=p.popcount(ex)+p.popcount(ez)
                    counts[(w,k,'syndrome' if sy else 'logical' if bad else 'success')]+=1
                    buckets[(x[1],z[1])][(x[2],z[2])][k]+=1
                    low_responses[(ex,ez)]=int(bad)
                assert all(kind=='success' for (w,k,kind) in counts if w<=1)
                assert lw['counts']==[{'physical_weight':w,'component_weight':k,'status':status,'count':v}
                                     for (w,k,status),v in sorted(counts.items())]
                den=50**(2*n);powers=[49**(2*n-k) for k in range(5)]
                failure=sum(v*powers[k] for (w,k,kind),v in counts.items() if kind!='success')
                total=sum(v*powers[k] for (w,k,kind),v in counts.items())
                correct=sum(max(sum(a*b for a,b in zip(v,powers)) for v in classes.values()) for classes in buckets.values())
                ambiguity=total-correct
                for name,v in [('probability_denominator',den),('failure_mass_numerator',failure),
                               ('enumerated_mass_numerator',total),('ambiguity_bound_numerator',ambiguity),
                               ('decoder_excess_numerator',failure-ambiguity)]:assert int(lw[name])==v
                assert 0<=ambiguity<=failure<=total<=den
                assert lw['failure_mass']==failure/den and lw['ambiguity_lower_bound']==ambiguity/den
                spectrum=Counter(tuple(sorted(tuple(v) for v in cs.values())) for cs in buckets.values())
                assert lw['ambiguity_spectrum']==[{'class_component_weight_counts':[list(c) for c in key],
                    'syndrome_buckets':v} for key,v in sorted(spectrum.items())]
                for witness in lw['ambiguous_syndrome_examples']:
                    (ex,ez),(fx,fz)=[tuple(int(v,16) for v in pair) for pair in witness['inequivalent_errors_hex']]
                    sy=[syndrome(zm,ex),syndrome(xm,ez)]
                    assert sy==[syndrome(zm,fx),syndrome(xm,fz)]==list(map(lambda v:int(v,16),witness['syndrome_hex']))
                    assert reduced(ex^fx,xb)!=0 or reduced(ez^fz,zb)!=0
                if n==32:
                    diagnoses=lw['pair_diagnosis_x']+lw['pair_diagnosis_z']
                    assert sum(e['count'] for e in diagnoses)==992
                    assert all(e['containing_absorbing4_b'] for e in diagnoses)
                    assert sum(e['count'] for e in diagnoses if e['absorbing'])==32
                    assert all(e['status']=='syndrome' for e in diagnoses if e['absorbing'])
                frames=noise[ri];bits=unpack(mc['failure_bitmap_zlib_base64'],20000)
                assert mc['sample_sha256']==hashlib.sha256(''.join(x+z for x,z in frames).encode()).hexdigest()
                assert mc['frames']==20000 and sum(bits)==mc['failures'] and sum(bits)/20000==mc['fer']
                low_count=0
                for (xs,zs),bit in zip(frames,bits):
                    ex,ez=p.decoder.string_mask(xs),p.decoder.string_mask(zs)
                    if p.popcount(ex|ez)<=2:
                        assert low_responses[(ex,ez)]==bit
                        low_count+=bit
                assert low_count==mc['low_weight_failures_observed']
                # Actual fresh-noise prefix, independently checked message-by-message.
                ox=p.decoder.engine(engine,hz,n,[(.02,x) for x,z in frames[:4]],50,.8)
                oz=p.decoder.engine(engine,hx,n,[(.02,z) for x,z in frames[:4]],50,.8)
                for i,((xs,zs),x,z) in enumerate(zip(frames[:4],ox,oz)):
                    assert x==p.decoder.reference_decode(hz,n,xs,.02,50,.8)
                    assert z==p.decoder.reference_decode(hx,n,zs,.02,50,.8)
                    failx=reduced(p.decoder.string_mask(xs)^p.decoder.string_mask(x[2]),xb)!=0
                    failz=reduced(p.decoder.string_mask(zs)^p.decoder.string_mask(z[2]),zb)!=0
                    assert bits[i]==int(failx or failz)
                    reference_checks+=2
                binary_count+=len(errors)*2;pauli_count+=len(patterns);fresh_evaluations+=20000
            a,c=[rr['low_weight'] for rr in rp['representatives']]
            for field in ('counts','failure_mass_numerator','ambiguity_bound_numerator','ambiguity_spectrum'):
                assert a[field]==c[field]
        assert rf['contrasts']==t.contrasts(rf)
        for contrast in rf['contrasts']:
            assert contrast['two_contrast_ci97_5'][0]>0
assert reps==d['representatives']==22
assert binary_count==d['exact_binary_sector_responses']==89324
assert pauli_count==d['exact_pauli_pattern_evaluations']==394486
assert fresh_evaluations==d['fresh_quantum_frame_evaluations']==440000
assert d['fresh_sector_decoder_executions']==880000 and d['fresh_independent_noise_frames']==80000
assert reference_checks==352
print(f'PASS: {reps} representatives; {binary_count} sector responses; {pauli_count} exact Pauli patterns; '
      f'all rational masses and coset bounds; {fresh_evaluations} fresh-frame bitmap checks; '
      f'{reference_checks} C++/Python reference comparisons; geometry-only selection and two paired contrasts.')

if '--lean' in sys.argv:
    lean_dir=R/'formalization/dyadic-rank'
    source=lean_dir/'QuantumSyndromeAmbiguity.lean'
    assert source.read_text().count('\ntheorem ')==5
    assert not any(token in source.read_text() for token in ('sorry','admit','native_decide','axiom '))
    lake=shutil.which('lake') or str(Path.home()/'.elan/bin/lake')
    proc=subprocess.run([lake,'-f','lakefile-forbidden.toml','env','lean',source.name],
                        cwd=lean_dir,capture_output=True,text=True,check=True)
    assert proc.stdout.count('depends on axioms:')==5
    assert 'sorryAx' not in proc.stdout and 'error:' not in proc.stdout+proc.stderr
    (P/'ambiguity-lean-check.txt').write_text(proc.stdout+proc.stderr)
    print('PASS: five Lean ambiguity lemmas rebuilt; standard foundational axioms only.')
