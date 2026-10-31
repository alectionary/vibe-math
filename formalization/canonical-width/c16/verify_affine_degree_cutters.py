#!/usr/bin/env python3
"""Check whether existing affine consequences strengthen degree-two NulLA.

Physical replay of the affine consequences is required first. Their implication
may have higher original degree; here they are admitted as new generators.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import domain,replay
from verify_anchored_cover_chain import physical,canonical
from verify_affine_signature_closure import replay as affine_replay
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();A,C,pos,sig=physical();results=[]
 for name in ['control','hard']:
  dp=ROOT/f'algebraic-results/{name}.json';fp=ROOT/f'theory-loop-results/affine-{name}.json.gz';d=json.loads(dp.read_text());f=json.loads(gzip.decompress(fp.read_bytes()));assert f['anchor']==d['anchor'] and sorted(f['removed_classes'])==sorted(d['removed_classes']);aff=affine_replay(A,sig,f);AA,E,t,r=domain(d);assert AA==A and t==f['free_target_signature'];x,z=d['anchor'];R=set(map(tuple,d['removed_classes']));EE=[(i,j,s) for (i,j),s in sig.items() if s and canonical(i,j) in R and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1];assert E==EE;variants=[]
  for suffix in ['', '-amo']:
   qp=ROOT/f'algebraic-results/quadratic-{name}{suffix}.json';q=json.loads(qp.read_text());old=replay(A,E,t,r,q);assert old['all_degree_two_variable_multipliers'];ones=set(q['formal_moment_ones']);violations=[]
   for step in f['proof']:
    if step[0]==1:mon=step[1]+1
    else:
     _,i,j,w=step;mon=((max(i,j)+1)<<32)|(min(i,j)+1)
    if mon in ones:violations.append(step[:3])
   variants.append({'signature_AMO':bool(suffix),'formal_moment_sha256':hashlib.sha256(qp.read_bytes()).hexdigest(),'affine_generators_violated_by_old_moments':len(violations),'degree_two_still_feasible_after_all_added_generators':not violations})
  result={'domain':name,'physical_domain_sha256':d['input_sha256'],'affine_certificate_sha256':hashlib.sha256(fp.read_bytes()).hexdigest(),'node_generators':aff['node_certificates_checked'],'pair_generators':aff['pair_certificates_checked'],'variants':variants}
  if name=='control':
   deleted={step[1] for step in f['proof'] if step[0]==1};assert deleted==set(range(len(E)));bit=next(k for k in range(r) if t>>k&1);assert all(i in deleted for i,e in enumerate(E) if e[2]>>bit&1);result['augmented_degree_one_contradiction']={'parity_equation_bit':bit,'node_zero_generators_used':[i for i,e in enumerate(E) if e[2]>>bit&1],'identity':'The selected parity polynomial XOR the listed node-zero generators is1.'}
  else:assert all(v['degree_two_still_feasible_after_all_added_generators'] for v in variants)
  results.append(result)
 out={'status':'PASS','source_C16_answered':False,'scope':'Adding the checked affine equations as new generators gives a degree-one contradiction on the378-edge control, but both1252-edge formal degree-two witnesses satisfy all4816 additional quadratic generators. No claim about degree-three certificates or full anchors.','results':results,'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='results'})
if __name__=='__main__':main()
