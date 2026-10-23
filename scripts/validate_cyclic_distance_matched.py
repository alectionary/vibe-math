"""Audit exact matching, fresh noise, paired outcomes and saved decoder categories."""
from pathlib import Path
import base64,hashlib,json,math,random,subprocess,sys,tempfile,zlib
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S));import benchmark_decoding as b

def flags(s,n):
 raw=zlib.decompress(base64.b64decode(s));assert len(raw)==(n+7)//8
 return [bool(raw[i//8]&(1<<(i%8))) for i in range(n)]

s=json.loads((S/'distance-matched-selection.json').read_text());d=json.loads((S/'distance-matched-results.json').read_text())
assert s['status']=='fixed_pair_and_settings_saved_before_fresh_decoding'
assert d['selection_sha256']==hashlib.sha256((S/'distance-matched-selection.json').read_bytes()).hexdigest()
for name,sha in s['sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
assert list(s['codes'])==['previous_best','minimum_4']
assert s['seed']==d['seed']==20261024 and d['trials_per_probability']==100000
assert d['probabilities']==[.01,.02,.04] and d['alpha']==.8 and d['max_iterations']==100
assert d['independent_noise_patterns']==300000 and d['decoder_executions']==600000
assert d['decoder_checks']['engine_reference_cases']==128 and d['decoder_checks']['total_decoder_checks']==638
reference_checks=0
with tempfile.TemporaryDirectory(prefix='matched-validate-') as temp:
 exe=Path(temp)/'minsum';subprocess.run(['c++','-std=c++17','-O3',str(S/'minsum.cpp'),'-o',str(exe)],check=True)
 for pi,prob in enumerate(d['probabilities']):
  rng=random.Random(20261024+1000003*pi)
  errors=[''.join('1' if rng.random()<prob else '0' for _ in range(252)) for _ in range(100000)]
  digest=hashlib.sha256('\n'.join(errors).encode()).hexdigest();outcomes={}
  for name,meta in s['codes'].items():
   assert (meta['n'],meta['k'],meta['d_x'],meta['d_z'])==(252,10,10,10)
   hx,hz,geometry=b.construction(meta['B'],meta['r']);assert all(meta[k]==v for k,v in geometry.items())
   a=next(r for r in d['results'] if (r['design'],r['p'])==(name,prob));f=flags(a['failure_flags_zlib_base64'],100000);sf=flags(a['syndrome_failure_flags_zlib_base64'],100000)
   assert a['error_stream_sha256']==digest
   assert sum(f)==a['failure_count']==a['syndrome_failure']+a['matched_logical_failure']
   assert sum(sf)==a['syndrome_failure'] and all(not x or y for x,y in zip(sf,f))
   assert a['exact_recovery']+a['stabilizer_equivalent_success']+a['failure_count']==100000
   assert a['failure_rate']==sum(f)/100000 and a['wilson_95_interval']==b.wilson(sum(f),100000)
   assert 0<=a['mean_iterations']<=100
   # Recheck actual fresh-noise inputs, not only hand-selected toy patterns.
   trials=[(prob,e) for e in errors[:12]];out=b.engine(exe,hx,252,trials,100,.8)
   zb=b.basis(hz)
   for i,((p,e),result) in enumerate(zip(trials,out)):
    assert result==b.reference_decode(hx,252,e,p,100,.8)
    residual=b.string_mask(e)^b.string_mask(result[2])
    assert f[i]==(not b.in_span(residual,zb)) and sf[i]==(not result[1])
    reference_checks+=1
   outcomes[name]=f
  c=next(c for c in d['paired_comparisons'] if c['p']==prob);left,right=outcomes['previous_best'],outcomes['minimum_4']
  better=sum(a and not z for a,z in zip(left,right));worse=sum(z and not a for a,z in zip(left,right))
  delta=(worse-better)/100000;se=math.sqrt(max(0,(better+worse)-100000*delta**2)/(100000*99999))
  assert c['baseline_failed_design_succeeded']==better and c['baseline_succeeded_design_failed']==worse
  assert c['failure_rate_difference_design_minus_baseline']==delta
  assert c['paired_normal_95_interval']==[delta-1.959963984540054*se,delta+1.959963984540054*se]
assert reference_checks==72
primary=next(c for c in d['paired_comparisons'] if c['p']==.04)
assert primary['paired_normal_95_interval'][0]<0<primary['paired_normal_95_interval'][1]
print('PASS: two exact [[252,10,10]] codes, 300000 fresh shared patterns, 600000 outcome flags, all paired intervals and category totals; 72 additional C++/Python fresh-stream comparisons. Primary interval includes zero.')
