"""Bounded P11 disagreement, exhaustive Pauli<=2 and ambiguity diagnosis."""
from collections import Counter, defaultdict
from itertools import combinations, product
from pathlib import Path
import hashlib
import json
import math
import random
import subprocess
import tempfile
import pilot as p
import quantum_css as q
import quantum_benchmark as b

HERE = Path(__file__).resolve().parent


def profile_key(code):
    return json.dumps([code['graph_x'], code['graph_z'], code['logical_x']['kernel_supports'],
                       code['logical_z']['kernel_supports']], sort_keys=True)


def selection():
    original = json.loads((HERE/'quantum-selection.json').read_text())
    families = []
    for fi, family in enumerate(original['families']):
        groups = defaultdict(list)
        for pool in family['pools']:
            for code in pool['candidates']:
                groups[profile_key(code)].append({'pool_id': pool['id'], 'candidate_id': code['id'], 'code': code})
        profiles = []
        for key, entries in sorted(groups.items()):
            ordered = sorted(entries, key=lambda e: json.dumps(e['code']['parameters'], sort_keys=True))
            first = ordered[0]
            second = next(e for e in ordered if e['pool_id'] != first['pool_id'])
            profiles.append({'id': len(profiles), 'instances_in_saved_sample': len(entries),
                             'profile_sha256': hashlib.sha256(key.encode()).hexdigest(),
                             'representatives': [first, second]})
        disagreements, equal_cycles = [], defaultdict(set)
        for profile in profiles:
            code = profile['representatives'][0]['code']
            equal_cycles[tuple(code['cycles_total'])].add(tuple(code['absorbing_features_total']))
        for a, c in combinations(profiles, 2):
            ca, cc = a['representatives'][0]['code'], c['representatives'][0]['code']
            cy = (ca['cycles_total'] > cc['cycles_total'])-(ca['cycles_total'] < cc['cycles_total'])
            ab = (ca['scores']['absorbing'] > cc['scores']['absorbing'])-(ca['scores']['absorbing'] < cc['scores']['absorbing'])
            if cy*ab < 0:
                disagreements.append({'cycle_preferred': a['id'] if cy < 0 else c['id'],
                                      'absorbing_preferred': a['id'] if ab < 0 else c['id']})
        families.append({'family_index': fi, 'configuration': family['configuration'], 'profiles': profiles,
                         'discordant_profile_pairs': disagreements,
                         'equal_total_cycles_different_aggregate_absorbing': sum(len(v)>1 for v in equal_cycles.values())})
    assert [len(f['profiles']) for f in families] == [7, 4]
    paths = [Path(__file__), HERE.parent/'TARGETED-PROTOCOL.md', HERE/'quantum-selection.json',
             HERE/'quantum_css.py', HERE/'quantum_benchmark.py', HERE/'pilot.py', p.OLD/'minsum.cpp',
             p.OLD/'benchmark_decoding.py', p.OLD/'decoding.py', p.OLD/'optimize_absorbing.py', p.OLD/'scan.py']
    result = {'status': 'geometry_only_representatives_saved_before_new_decoding', 'families': families,
              'sha256': {str(path.relative_to(p.ROOT)): hashlib.sha256(path.read_bytes()).hexdigest() for path in paths}}
    (HERE/'targeted-selection.json').write_text(json.dumps(result, indent=2)+'\n')
    return result


def canonical(word, basis):
    # Eliminate all pivot columns, even if the current highest bit is not a pivot.
    for pivot in sorted(basis, reverse=True):
        if word & (1 << pivot):
            word ^= basis[pivot]
    return word


def binary_errors(n):
    return [sum(1 << v for v in support) for w in range(3) for support in combinations(range(n), w)]


def pauli_errors(n):
    yield 0, 0, 0
    for weight in (1, 2):
        for support in combinations(range(n), weight):
            for types in product((1, 2, 3), repeat=weight):  # X, Z, Y
                x = sum(1 << v for v, t in zip(support, types) if t & 1)
                z = sum(1 << v for v, t in zip(support, types) if t & 2)
                yield x, z, weight


def absorbing_pair_data(vn, containment=False):
    masks = [sum(1 << c for c in cs) for cs in vn]
    covered = defaultdict(set)
    if containment:
        for support in combinations(range(len(vn)), 4):
            odd = 0
            for v in support:
                odd ^= masks[v]
            if all(2*p.popcount(odd & masks[v]) < len(vn[v]) for v in support):
                for pair in combinations(support, 2):
                    covered[pair].add(p.popcount(odd))
    return masks, covered


def sector_responses(binary, h, vn, opposite_basis, n):
    errors = binary_errors(n)
    out = p.decoder.engine(binary, h, n, [(.02, p.decoder.bit_string(e, n)) for e in errors], 50, .8)
    hm = list(map(p.decoder.rowmask, h))
    response, counts = {}, Counter()
    for e, result in zip(errors, out):
        estimate = p.decoder.string_mask(result[2])
        same_class = canonical(e, opposite_basis) == canonical(estimate, opposite_basis)
        assert same_class == p.decoder.in_span(e ^ estimate, opposite_basis)
        matched = not any(p.decoder.syndrome(hm, e ^ estimate))
        assert matched == result[1]
        status = 'success' if same_class else 'logical' if matched else 'syndrome'
        syndrome = sum(bit << i for i, bit in enumerate(p.decoder.syndrome(hm, e)))
        response[e] = {'status': status, 'estimate': estimate, 'syndrome': syndrome,
                       'class': canonical(e, opposite_basis), 'estimate_class': canonical(estimate, opposite_basis)}
        counts[(p.popcount(e), status)] += 1
    stored = {'estimate_hex': [hex(response[e]['estimate']) for e in errors],
              'status_codes': ''.join({'success':'0','logical':'1','syndrome':'2'}[response[e]['status']] for e in errors),
              'counts': [{'weight': w, 'status': status, 'count': count} for (w,status),count in sorted(counts.items())]}
    return response, stored


def pair_diagnosis(response, vn, containment):
    masks, covered = absorbing_pair_data(vn, containment)
    counts, witnesses = Counter(), {}
    for a, c in combinations(range(len(vn)), 2):
        e = (1 << a)|(1 << c)
        shared = p.popcount(masks[a] & masks[c])
        absorbing = 2*shared > len(vn[a]) and 2*shared > len(vn[c])
        odd = masks[a] ^ masks[c]
        assert absorbing == all(2*p.popcount(masks[v] & odd) < len(vn[v]) for v in (a,c))
        key = (response[e]['status'], absorbing, shared, tuple(sorted(covered[(a,c)])))
        counts[key] += 1
        witnesses.setdefault(key, [a,c])
    return [{'status': status, 'absorbing': ab, 'shared_checks': shared,
             'containing_absorbing4_b': list(bs), 'count': count, 'witness': witnesses[(status,ab,shared,bs)]}
            for (status,ab,shared,bs),count in sorted(counts.items())]


def low_weight(binary, code, ell):
    hx, hz, vx, vz = q.expansion(code['bx'], code['bz'], ell)
    xm, zm = list(map(p.decoder.rowmask,hx)), list(map(p.decoder.rowmask,hz))
    xb, zb = p.decoder.basis(xm), p.decoder.basis(zm)
    xr, xs = sector_responses(binary, hz, vz, xb, code['n'])
    zr, zs = sector_responses(binary, hx, vx, zb, code['n'])
    n = code['n']
    buckets = defaultdict(lambda: defaultdict(lambda: [0]*5))
    choices, examples, counts = {}, {}, Counter()
    fail, logical, mismatch = [], [], []
    for ex, ez, weight in pauli_errors(n):
        x, z = xr[ex], zr[ez]
        syndrome, coset = (x['syndrome'], z['syndrome']), (x['class'], z['class'])
        chosen = (x['estimate_class'],z['estimate_class'])
        if syndrome in choices:
            assert choices[syndrome] == chosen, 'decoder must depend only on syndrome'
        choices[syndrome] = chosen
        components = p.popcount(ex)+p.popcount(ez)
        buckets[syndrome][coset][components] += 1
        examples.setdefault((syndrome,coset),[hex(ex),hex(ez)])
        bad = x['status'] != 'success' or z['status'] != 'success'
        nonmatch = x['status'] == 'syndrome' or z['status'] == 'syndrome'
        kind = 'syndrome' if nonmatch else 'logical' if bad else 'success'
        counts[(weight,components,kind)] += 1
        fail.append(bad);logical.append(bad and not nonmatch);mismatch.append(nonmatch)
    powers = [49**(2*n-t) for t in range(5)]
    denominator = 50**(2*n)
    fail_numerator = sum(count*powers[t] for (w,t,kind),count in counts.items() if kind != 'success')
    total_numerator = sum(count*powers[t] for (w,t,kind),count in counts.items())
    oracle_correct, ambiguity_spectrum = 0, Counter()
    witness_buckets = []
    for syndrome, classes in buckets.items():
        mass = lambda coefficients: sum(c*a for c,a in zip(coefficients,powers))
        oracle_correct += max(map(mass,classes.values()))
        key = tuple(sorted(tuple(c) for c in classes.values()))
        ambiguity_spectrum[key] += 1
        if len(classes)>1 and len(witness_buckets)<3:
            witness_buckets.append({'syndrome_hex':list(map(hex,syndrome)),
                'inequivalent_errors_hex':[examples[(syndrome,coset)] for coset in list(classes)[:2]]})
    ambiguity_numerator = total_numerator-oracle_correct
    assert fail_numerator >= ambiguity_numerator >= 0
    return {'sector_x':xs,'sector_z':zs,
        'binary_decoder_executions':len(xr)+len(zr),
        'pauli_patterns':len(fail), 'failure_bitmap_zlib_base64':p.pack(fail),
        'logical_failure_bitmap_zlib_base64':p.pack(logical), 'syndrome_failure_bitmap_zlib_base64':p.pack(mismatch),
        'counts':[{'physical_weight':w,'component_weight':t,'status':kind,'count':count}
                  for (w,t,kind),count in sorted(counts.items())],
        'probability_denominator':str(denominator), 'failure_mass_numerator':str(fail_numerator),
        'enumerated_mass_numerator':str(total_numerator), 'ambiguity_bound_numerator':str(ambiguity_numerator),
        'decoder_excess_numerator':str(fail_numerator-ambiguity_numerator),
        'failure_mass':fail_numerator/denominator,'ambiguity_lower_bound':ambiguity_numerator/denominator,
        'decoder_excess_mass':(fail_numerator-ambiguity_numerator)/denominator,
        'ambiguity_spectrum':[{'class_component_weight_counts':[list(c) for c in key],'syndrome_buckets':count}
                               for key,count in sorted(ambiguity_spectrum.items())],
        'ambiguous_syndrome_examples':witness_buckets,
        'pair_diagnosis_x':pair_diagnosis(xr,vz,n==32),
        'pair_diagnosis_z':pair_diagnosis(zr,vx,n==32)}


def samples(fi,rep,n):
    rng=random.Random(20261120+100000*fi+100*rep)
    return [(''.join('1' if rng.random()<.02 else '0' for _ in range(n)),
             ''.join('1' if rng.random()<.02 else '0' for _ in range(n))) for _ in range(20000)]


def monte_carlo(binary,code,ell,errors):
    hx,hz,vx,vz=q.expansion(code['bx'],code['bz'],ell)
    xb=p.decoder.basis(list(map(p.decoder.rowmask,hx)));zb=p.decoder.basis(list(map(p.decoder.rowmask,hz)))
    xo=p.decoder.engine(binary,hz,code['n'],[(.02,x) for x,z in errors],50,.8)
    zo=p.decoder.engine(binary,hx,code['n'],[(.02,z) for x,z in errors],50,.8)
    fail, low_fail=[],0
    for (ex,ez),ox,oz in zip(errors,xo,zo):
        x,z=p.decoder.string_mask(ex),p.decoder.string_mask(ez)
        bad=not b.success(x ^ p.decoder.string_mask(ox[2]),z ^ p.decoder.string_mask(oz[2]),xb,zb)
        fail.append(bad)
        low_fail += bad and p.popcount(x|z)<=2
    return {'frames':20000,'failures':sum(fail),'fer':sum(fail)/20000,
            'low_weight_failures_observed':low_fail,'failure_bitmap_zlib_base64':p.pack(fail),
            'sample_sha256':hashlib.sha256(''.join(x+z for x,z in errors).encode()).hexdigest()}


def unpack(value,count):
    import base64,zlib
    return [int(c) for c in ''.join(f'{v:08b}' for v in zlib.decompress(base64.b64decode(value)))[:count]]


def contrasts(family):
    out=[]
    for pair in family['discordant_profile_pairs']:
        diffs,variances=[] ,[]
        for rep in range(2):
            c=family['profiles'][pair['cycle_preferred']]['representatives'][rep]['monte_carlo']
            a=family['profiles'][pair['absorbing_preferred']]['representatives'][rep]['monte_carlo']
            dc=[u-v for u,v in zip(unpack(c['failure_bitmap_zlib_base64'],20000),unpack(a['failure_bitmap_zlib_base64'],20000))]
            mean=sum(dc)/20000
            diffs.append(mean);variances.append(sum((v-mean)**2 for v in dc)/19999)
        delta=sum(diffs)/2;se=math.sqrt(sum(v/20000 for v in variances))/2
        out.append({**pair,'cycle_minus_absorbing_fer':delta,'representative_differences':diffs,
                    'ci95':[delta-1.95996398454*se,delta+1.95996398454*se],
                    'two_contrast_ci97_5':[delta-2.2414027276*se,delta+2.2414027276*se]})
    return out


def run():
    manifest=selection();families=[]
    with tempfile.TemporaryDirectory(prefix='p11-targeted-') as temp:
        binary=Path(temp)/'minsum'
        subprocess.run(['c++','-std=c++17','-O2',str(p.OLD/'minsum.cpp'),'-o',str(binary)],check=True)
        for family in manifest['families']:
            config=family['configuration'];fi=family['family_index']
            errors={rep:samples(fi,rep,config['n']) for rep in range(2)}
            profiles=[]
            for profile in family['profiles']:
                reps=[]
                for ri,record in enumerate(profile['representatives']):
                    code=record['code']
                    reps.append({'source_pool':record['pool_id'],'source_candidate':record['candidate_id'],
                        'low_weight':low_weight(binary,code,config['ell']),
                        'monte_carlo':monte_carlo(binary,code,config['ell'],errors[ri])})
                profiles.append({'id':profile['id'],'representatives':reps})
                print(f'targeted {config["family"]}: profile {profile["id"]+1}/{len(family["profiles"])}',flush=True)
            result={'configuration':config,'profiles':profiles,
                    'discordant_profile_pairs':family['discordant_profile_pairs']}
            result['contrasts']=contrasts(result);families.append(result)
    result={'status':'bounded_fixed_family_fixed_decoder_low_weight_and_disagreement_followup',
            'selection_sha256':hashlib.sha256((HERE/'targeted-selection.json').read_bytes()).hexdigest(),
            'families':families,'representatives':22,'fresh_independent_noise_frames':80000,
            'fresh_quantum_frame_evaluations':440000,'fresh_sector_decoder_executions':880000,
            'exact_binary_sector_responses':89324,'exact_pauli_pattern_evaluations':394486}
    (HERE/'targeted-results.json').write_text(json.dumps(result,indent=2)+'\n')
    for f in families:print(f['configuration']['family'],f['contrasts'],flush=True)


if __name__=='__main__':run()
