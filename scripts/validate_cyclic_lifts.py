"""Check cyclic-lift artifact provenance and scope; Lean commands perform proof verification."""
from pathlib import Path
import hashlib,importlib.util,json,re
from urllib.parse import urlparse
R=Path(__file__).resolve().parent.parent;P=R/'formalization/cyclic-lifts';L=R/'formalization/dyadic-rank'
v=json.loads((P/'verification.json').read_text())
assert v['build_exit_code']==v['consumer_exit_code']==0
assert v['full_target_statement_formalized'] and v['general_girth_eight_problem_proved']
assert v['general_simple_eight_cycle_verified']
assert v['theorem_count']==len(v['declaration_axioms'])==75
assert v['symbolic_girth_eight_family_verified']
assert v['six_cycle_characterization_complete'] and v['three_by_three_girth_eight_verified']
assert {'CyclicLift.hasSixCycle_iff_hexagon','CyclicLift.xGraph_native_sixCycle_iff',
        'CyclicLift.sevenBase_matrix_girth','CyclicLift.mixedEight_isCycle',
        'CyclicLift.matrixTanner_hX_girth_characterization',
        'CyclicLift.xGraph_girth_eq_eight_iff_rectangles'} <= set(v['declaration_axioms'])
assert 'CyclicLift.normalizedTwo_matrix_girth' in v['declaration_axioms']
assert all(set(a)<={'propext','Classical.choice','Quot.sound'} for a in v['declaration_axioms'].values())
assert hashlib.sha256((P/'verification.log').read_bytes()).hexdigest()==v['log_sha256']
for name,sha in v['sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
for path in list((L/'CyclicLift').glob('*.lean'))+[L/'CyclicLift.lean',L/'CyclicChecks.lean']:
 t=path.read_text()
 assert not re.search(r'\b(sorry|admit|native_decide|sorryAx)\b',t),path
 assert not re.search(r'^\s*(axiom|unsafe)\b',t,re.M),path
# Every theorem in the library is represented in both the consumer and axiom report.
names=set()
for path in (L/'CyclicLift').glob('*.lean'):
 for name in re.findall(r"^(?:@\[[^\n]*\]\s*)?theorem\s+([\w.']+)",path.read_text(),re.M):
  names.add('CyclicLift.'+name)
assert names==set(v['declaration_axioms'])
consumer=(L/'CyclicChecks.lean').read_text()
assert names==set(re.findall(r'^#print axioms (\S+)',consumer,re.M))
log=(P/'verification.log').read_text()
reported={}
for name,axioms,empty in re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|(does not depend on any axioms))",log):
 reported[name]=[] if empty else [x.strip() for x in axioms.split(',') if x.strip()]
assert reported==v['declaration_axioms']
# Original proof source/configuration hashes remain unchanged.
original=json.loads((L/'verification.json').read_text())
for name,sha in original['sha256'].items():assert hashlib.sha256((L/name).read_bytes()).hexdigest()==sha,name
results=json.loads((P/'search/results.json').read_text());assert results['case_count']==len(results['cases'])==v['python_case_count']==432
assert results['girth_histogram']=={'4':351,'8':67,'6':14}
# Independently reconstruct the particular formalized witness using the finite checker.
spec=importlib.util.spec_from_file_location('cyclic_scan',P/'search/scan.py');scan=importlib.util.module_from_spec(spec);spec.loader.exec_module(scan)
B=[[0,0,0],[0,1,2],[0,2,1]];g=scan.matrix_graph(B,3)
assert g==scan.voltage_graph(B,3) and scan.direct_counts(g)==(0,108)
assert scan.voltage_six_count(B,3)==108
cycle=[('c',0,0,0),('l',0,0,0),('c',1,0,0),('l',1,0,2),('c',2,0,1),('l',2,0,0)]
assert len(set(cycle))==6 and all(b in g[a] for a,b in zip(cycle,cycle[1:]+cycle[:1]))
# Independently compare the newly proved entrywise six-cycle test with all old finite cases.
from itertools import permutations
for case in results['cases']:
 B=case['B'];r=case['lift_size'];m,n=len(B),len(B[0])
 has_hexagon=any((B[i0][j0]-B[i0][j1]+B[i1][j1]-B[i1][j2]+B[i2][j2]-B[i2][j0])%r==0
  for i0,i1,i2 in permutations(range(m),3) for j0,j1,j2 in permutations(range(n),3))
 assert has_hexagon==(case['six_cycles']>0),case
 assert (case['girth']==8)==(case['zero_base_rectangles']==0 and not has_hexagon),case
# Independent matrix expansion, direct short-cycle counts, and the new eight-cycle witness.
B=[[0,0,0],[0,1,2],[0,3,6]];g=scan.matrix_graph(B,7)
assert g==scan.voltage_graph(B,7) and len(g)==189
assert sum(map(len,g.values()))//2==378 and scan.direct_counts(g)==(0,0) and scan.girth(g)==8
cycle=[('c',0,0,0),('l',0,0,0),('c',1,0,0),('r',1,0,0),
       ('c',1,1,0),('l',0,1,0),('c',0,1,0),('r',0,0,0)]
assert len(set(cycle))==8 and all(b in g[a] for a,b in zip(cycle,cycle[1:]+cycle[:1]))
# An unnormalized rectangular matrix over a composite modulus tests the general witness indexing.
B=[[2,5,1,4],[3,0,5,2],[1,3,2,0]];r=6;i0,i1,j0,j1,k,l=0,2,1,3,2,1
a0,a1,d0,d1=B[i0][k],B[i1][k],B[l][j0],B[l][j1]
cycle=[('c',i0,j0,(a0-d0)%r),('l',k,j0,(-d0)%r),('c',i1,j0,(a1-d0)%r),
       ('r',i1,l,a1%r),('c',i1,j1,(a1-d1)%r),('l',k,j1,(-d1)%r),
       ('c',i0,j1,(a0-d1)%r),('r',i0,l,a0%r)]
g=scan.matrix_graph(B,r)
assert len(set(cycle))==8 and all(b in g[a] for a,b in zip(cycle,cycle[1:]+cycle[:1]))
row=next(r for r in json.loads((R/'literature/open-problems.json').read_text()) if r['id']==v['target_id'])
assert row['lean_proof_status']=='verified_complete_lean_proof'
assert row['verified_artifact']['statement_declaration']=='CyclicLift.matrixTanner_hX_girth_characterization'
summary=json.loads((R/'literature/open-problem-summary.json').read_text())
# Later projects may increase current coverage beyond this artifact's two-target milestone.
assert summary['eligible_verified_lean_proofs']>=2 and summary['eligible_targets']==108
for href in re.findall(r'\]\(([^)]+)\)',(P/'README.md').read_text()):
 u=urlparse(href)
 if not u.scheme and u.path:assert (P/u.path).exists(),href
print('Validated 75 checked theorems, general simple eight-cycle and full girth-eight characterization, matrix theorem, and finite regressions, source hashes, unchanged dyadic artifact, 432 finite cases and the explicit no-four/six-cycle obstruction. Recorded girth target is verified; priority and other graph properties remain separate.')
