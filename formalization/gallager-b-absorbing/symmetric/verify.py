"""Independent finite semantic checks of the general theorem's hypotheses.

These fixed boundary examples do not search for even-support decoder candidates.
The arbitrary-length theorem is proved in Lean, not by this finite replay.
"""
from pathlib import Path
import argparse,hashlib,json
R=Path(__file__).resolve().parent
source=json.loads((R/'verification-inputs.json').read_text())
def span(rows):
 out={0}
 for r in rows:out|={w^r for w in out}
 return out
def dot(x,y):return (x&y).bit_count()%2
def syndrome(rows,e):return tuple(dot(r,e) for r in rows)
cases=[('empty_length',0,[],[],True),('empty_checks_one_coordinate',1,[],[],True),('bell_pair_redundant_presentation',2,[3],[3,3],True),('one_isolated_coordinate',3,[3],[3],True),('zero_and_duplicate_checks',3,[3],[0,3,3],True),('different_distinct_generating_lists',4,[3,12],[3,12,15],True),('seven_variable_simplex',7,source['simplex'],source['simplex'],True),('permutation_only_symmetry',6,[7],[56],False),('published_asymmetric_example',15,source['connected_HX'],source['connected_HZ'],False)]
records=[];word_checks=0;output_checks=0
for name,n,hx,hz,same in cases:
 assert all(0<=r<2**n for r in hx+hz)
 assert all(dot(x,z)==0 for x in hx for z in hz)
 sx,sz=span(hx),span(hz);assert (sx==sz)==same
 oddlogical=[]
 if same:
  assert all(w.bit_count()%2==0 for w in sz)
  for a in range(2**n):
   word_checks+=1
   if a.bit_count()%2==1 and not any(syndrome(hx,a)):
    assert a not in sz;oddlogical.append(a)
    assert syndrome(hx,a)==syndrome(hx,0)
    for estimate in range(2**n):
     output_checks+=1
     assert not (estimate in sz and (a^estimate) in sz)
 records.append(dict(name=name,n=n,X_rows=hx,Z_rows=hz,equal_row_spaces=same,X_span=sorted(sx),Z_span=sorted(sz),odd_zero_syndrome_logical_words=oddlogical))
# Necessary parity and row-space-equality hypotheses each have a concrete guard.
assert 3 in span([3]) and not any(syndrome([3],3))  # even zero-syndrome stabilizer
assert 56 in span([56]) and (56).bit_count()%2==1 and not any(syndrome([7],56))
swap=lambda w:sum(((w>>((i+3)%6))&1)<<i for i in range(6))
assert swap(7)==56 and swap(56)==7
A=source['connected_support'];assert A.bit_count()==7
assert not any(syndrome(source['connected_HX'],A)) and A in span(source['connected_HZ'])
assert source['connected_source_sha256']=='4246e81e237e4231abdf575972766819970733dc4bfa79274ae35699a05ac1a0'
# Actual(a,b) incidence counts for the seven-variable consumer.
H=source['simplex'];selected=127
assert all(dot(r,selected)==0 for r in H)
for i in range(7):
 odd=sum(((r>>i)&1) and dot(r,selected) for r in H)
 even=sum(((r>>i)&1) and not dot(r,selected) for r in H)
 assert odd==0 and even==4
payload=dict(schema=1,scope='Fixed boundary/consumer families only; no enumeration or search of even-support construction candidates.',even_support_construction_search_performed=False,families=records,summary=dict(families=len(records),equal_space_families=sum(c[-1] for c in cases),all_words_checked_under_equal_spaces=word_checks,possible_shared_zero_syndrome_outputs_checked=output_checks,odd_zero_syndrome_cases=sum(len(r['odd_zero_syndrome_logical_words']) for r in records),hypothesis_guards=['oddness','equality_of_entire_stabilizer_spaces','equality_is_stronger_than_permutation_exchange'],simplex_parameters=[7,0],simplex_selected_degrees=[4]*7))
s=json.dumps(payload,indent=2)+'\n';p=argparse.ArgumentParser();p.add_argument('--check',action='store_true');a=p.parse_args()
if a.check:assert (R/'certificate.json').read_text()==s
else:(R/'certificate.json').write_text(s)
print(json.dumps(payload['summary'],sort_keys=True));print('certificate SHA256',hashlib.sha256(s.encode()).hexdigest())
