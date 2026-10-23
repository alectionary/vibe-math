"""Fresh, fixed-pair comparison after certifying equal quantum distance."""
from pathlib import Path
import hashlib,json,subprocess,tempfile
import benchmark_decoding as b
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]


def selection():
 prior=json.loads((HERE/'benchmark-confirmation.json').read_text())
 distances=json.loads((HERE/'exact-distance-results.json').read_text())
 validation=json.loads((HERE/'exact-distance-validation.json').read_text())
 assert validation['status']=='independent_cycle_seeded_exclusion_passed'
 codes={}
 for name in ['previous_best','minimum_4']:
  assert [r['distance'] for r in distances['records'] if r['name']==name]==[10,10]
  assert [r['excluded_through'] for r in validation['records'] if r['name']==name]==[8,8]
  codes[name]={**prior['designs'][name],'d_x':10,'d_z':10}
 assert [r['distance'] for r in distances['records'] if r['name']=='minimum_2']==[12,12]
 paths=[Path(__file__),HERE/'benchmark_decoding.py',HERE/'minsum.cpp',HERE/'exact-distance-results.json',
        HERE/'exact-distance-validation.json',HERE/'benchmark-confirmation.json',HERE.parent/'DISTANCE-MATCHED-PROTOCOL.md']
 out={'status':'fixed_pair_and_settings_saved_before_fresh_decoding','codes':codes,
      'excluded_distance_twelve_code':'minimum_2','seed':20261024,'trials_per_probability':100000,
      'probabilities':[.01,.02,.04],'primary_probability':.04,'iterations':100,'alpha':.8,
      'primary_contrast':'minimum_4 minus previous_best',
      'sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
 (HERE/'distance-matched-selection.json').write_text(json.dumps(out,indent=2)+'\n')
 return out


def run():
 frozen=selection();selected={}
 for name,meta in frozen['codes'].items():
  hx,hz,checked=b.construction(meta['B'],meta['r'])
  assert {k:meta[k] for k in checked}==checked
  # The historical helper calls its reference arm "baseline". Relabel output
  # explicitly so it cannot be confused with the old distance-six baseline.
  selected['baseline' if name=='previous_best' else name]=(hx,hz,checked)
 with tempfile.TemporaryDirectory(prefix='cyclic-distance-matched-') as temp:
  binary=Path(temp)/'minsum'
  subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(binary)],check=True)
  checks=b.validate(binary,selected)
  result=b.run(binary,100000,20261024,selected,[.01,.02,.04],100,.8)
 for entry in result['results']:
  if entry['design']=='baseline':entry['design']='previous_best'
 for contrast in result['paired_comparisons']:
  contrast['reference_design']='previous_best'
  contrast['same_exact_quantum_distance_as_reference']=True
 result.update({'status':'fresh_fixed_distance_matched_one_sector_comparison',
   'selection_sha256':hashlib.sha256((HERE/'distance-matched-selection.json').read_bytes()).hexdigest(),
   'primary_probability':.04,'independent_noise_patterns':300000,'decoder_executions':600000,
   'scope':'One Pauli sector, independent Bernoulli noise and perfect syndrome; exact [[252,10,10]] for both codes.',
   'decoder_checks':checks,'seed_selection_note':'New seed fixed in protocol before decoding; no matrices or settings selected from new outcomes.'})
 (HERE/'distance-matched-results.json').write_text(json.dumps(result,indent=2)+'\n')

if __name__=='__main__':run()
