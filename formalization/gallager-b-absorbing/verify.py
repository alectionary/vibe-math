"""Independent literal-matrix verifier; no imports from search.py or Lean generator."""
from pathlib import Path
from itertools import product
import hashlib,json
ROOT=Path(__file__).resolve().parent
# Coordinate order is v=1,...,7; strings list columns from left to right.
M=['1010101','0110011','1100110','0001111','1011010','0111100','1101001']
H=[[int(v) for v in r] for r in M]
assert len(H)==7 and all(len(r)==7 for r in H)
def syndrome(e):return [sum(x*y for x,y in zip(row,e))%2 for row in H]
def majority(xs):return int(sum(xs)*2>len(xs))
def xor(a,b):return [x^y for x,y in zip(a,b)]
def space(rows):
 return {tuple(sum(a*b for a,b in zip(coeff,col))%2 for col in zip(*rows)) for coeff in product((0,1),repeat=len(rows))}
K=[H[0],H[1],H[3],[1]*7]
S=space(K);R=space([H[0],H[1],H[3]])
assert len(S)==16 and len(R)==8
assert S=={e for e in product((0,1),repeat=7) if syndrome(e)==[0]*7}
assert all(sum(row)==4 for row in H)
assert all(sum(row[v] for row in H)==4 for v in range(7))
assert all(sum(x*y for x,y in zip(a,b))%2==0 for a in H for b in K)
records=[]
for error in product((0,1),repeat=7):
 s=syndrome(error)
 # The initial zero V-to-C messages make each check output its input syndrome.
 y=[[s[c] if H[c][v] else 0 for v in range(7)] for c in range(7)]
 hard=[majority([y[c][v] for c in range(7) if H[c][v]]) for v in range(7)]
 extrinsic=[[majority([y[d][v] for d in range(7) if H[d][v] and d!=c]) if H[c][v] else 0 for v in range(7)] for c in range(7)]
 edge=[sum(extrinsic[c])%2 for c in range(7)]
 assert syndrome(hard)==s and edge==s
 terminal=hard if any(s) else [0]*7
 assert tuple(xor(error,terminal)) in S
 records.append(dict(error=list(error),syndrome=s,hard=hard,extrinsic=extrinsic,edge_syndrome=edge,terminal=terminal,residual=xor(error,terminal)))
# Full actual CSS pair: 14 decoded X checks, seven opposite Z generators.
HX=[r+[0]*7 for r in H]+[[0]*7+r for r in H]
HZ=[r+[0]*7 for r in K]+[[0]*7+r for r in [H[0],H[1],H[3]]]
assert all(sum(x*y for x,y in zip(a,b))%2==0 for a in HX for b in HZ)
assert len(space(HX))==64 and len(space(HZ))==128
logical=tuple([0]*7+[1]*7)
assert all(sum(x*y for x,y in zip(a,logical))%2==0 for a in HX)
assert logical not in space(HZ)
# Complete first-block quantum success against the entire HZ row span.
fullspan=space(HZ)
for r in records: assert tuple(r['residual']+[0]*7) in fullspan
payload=dict(schema=1,matrix=H,HX=HX,HZ=HZ,all_128_errors=records,
 summary=dict(errors=128,syndromes=8,zero_syndrome_errors=16,first_iteration_matches=112,
              hard_mismatches=0,edge_mismatches=0,quantum_failures_first_block=0,
              rank_HX=6,rank_HZ=7,encoded_qubits=1),logical_witness=list(logical))
output=ROOT/'certificate.json'
serialized=json.dumps(payload,indent=2)+'\n'
if __name__=='__main__':
 import argparse
 p=argparse.ArgumentParser();p.add_argument('--check',action='store_true');a=p.parse_args()
 if a.check:assert output.read_text()==serialized,'certificate differs from independent regeneration'
 else:output.write_text(serialized)
 print(json.dumps(payload['summary'],sort_keys=True))
 print('certificate SHA256',hashlib.sha256(serialized.encode()).hexdigest())
