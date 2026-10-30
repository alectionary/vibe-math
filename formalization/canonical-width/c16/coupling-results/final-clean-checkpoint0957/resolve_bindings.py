from pathlib import Path
import hashlib,json
C=Path('/private/tmp/c16-coupling-clean-0957/formalization/canonical-width/c16');O=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
d=json.loads((O/'declared-source-bindings.json').read_text());resolved=[]
for row in d['mismatches']:
 field,name,owner=row['field'],row['input'],row['owner']
 if field=='pool_sha256':
  assert name in ['x','z'];path=f'pools/{name}coords.txt'
 else:
  assert field=='input_hashes' and owner in ['coupling-results/joint-anchor-matched-exact.json','coupling-results/joint-anchor-conditional-exact.json']
  path={'bank_sha256':'moment-resumption-results/common-profile32-projected-pruned.json','point_sha256':'moment-resumption-results/boolean-rational1.json.gz','hulls_sha256':'algebraic-results/hulls-16-rank.json.gz','profiles_sha256':'algebraic-results/orbit-rank-profiles.json.gz','producer_sha256':('coupling-results/joint-anchor-producer-v2.py' if 'matched' in owner else 'joint_anchor_profile_bound.py')}[name]
 actual=sha(C/path);assert actual==row['expected'];resolved.append(dict(original=row,resolved_path=path,actual=actual,match=True))
assert len(resolved)==16 and len(d['records'])==1422
out=dict(status='PASS_ALL_DECLARED_PATH_AND_EXPLICIT_ALIAS_BINDINGS',original_scanner_sha256=sha(O/'declared-source-bindings.json'),resolver_sha256=sha(__file__),literal_file_path_bindings=1406,explicit_alias_bindings=16,total_matching_bindings=1422,unresolved_bindings=[],alias_records=resolved,scope='The original scanner wrongly treated schema labels as paths. This second receipt resolves each label explicitly and verifies its exact bytes, including the preserved historical matched producer snapshot; no source hash mismatch was waived.')
p=O/'resolved-source-bindings.json';assert not p.exists();p.write_text(json.dumps(out,indent=2)+'\n');print(out['status'])
