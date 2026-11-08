#!/usr/bin/env python3
"""Exact degree-two consequences of every saved global source obstruction.

The immutable global physical/CNF replay is a source-proof dependency. This
consumer evaluates the independent direct conditional Boolean inequality,
including mixed-sector forbidden sets, at a saved exact rational moment point.
"""
from pathlib import Path
from fractions import Fraction
from collections import Counter
import argparse,gzip,hashlib,json,math,time
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--global-certificate',type=Path,required=True);ap.add_argument('--global-replay',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.global_certificate.read_text());receipt=json.loads(a.global_replay.read_text());assert receipt['status']=='PASS' and receipt['all_source_pairs_allowed'] and receipt['no_fixed_anchor'] and receipt['input_sha256']==d['input_sha256'] and receipt['new_cuts_checked']==len(d['cuts']);hulls=json.loads(gzip.decompress((ROOT/'algebraic-results/hulls-16-rank.json.gz').read_bytes()));names,index,m=layout(hulls);point=json.loads(gzip.decompress(a.point.read_bytes()));v=list(map(Fraction,point['values']));D=math.lcm(*(x.denominator for x in v[:32535]));values=[x.numerator*(D//x.denominator) if D%x.denominator==0 else x*D for x in v];checks=0;violated=[];minimum=None;kinds=Counter()
 initial_path=ROOT/'algebraic-results/small-conditional-original.json.gz';assert hashlib.sha256(initial_path.read_bytes()).hexdigest()==d['rank_certificate_sha256'];initial=json.loads(gzip.decompress(initial_path.read_bytes()))['cuts'];all_cuts=d['cuts']+[{'kind':'initial_rank','sector':0,'indices':[r['anchor_X_index'],*r['other_X_indices']]} for r in initial]
 for k,cut in enumerate(all_cuts):
  if cut['kind'] in ('joint_forced_propagation','joint_domain_forced_propagation'):events=[(0,i) for i in cut['required_X']]+[(1,i) for i in cut['required_Z']]
  else:events=[(cut['sector'],i) for i in cut['indices']]
  assert len(events)>=2 and len(set(events))==len(events)
  for side,anchor in events:
   lhs=sum(values[m('S' if s==side else 'T',(j-anchor)%16,anchor//16,j//16)] for s,j in events if (s,j)!=(side,anchor));rhs=(len(events)-2)*values[index['p',anchor//16]];slack=rhs-lhs;checks+=1;kinds[cut['kind']]+=1
   minimum=slack if minimum is None else min(minimum,slack)
   if slack<0:violated.append({'source_cut_index':k,'anchor_sector':side,'anchor_index':anchor,'events':events,'slack':str(Fraction(slack,D))})
 out={'status':'PASS' if not violated else 'SEPARATED','source_C16_answered':False,'source_obstruction_sets':len(all_cuts),'adaptive_and_seed_sets':len(d['cuts']),'initial_rank_sets':len(initial),'initial_rank_sha256':hashlib.sha256(initial_path.read_bytes()).hexdigest(),'conditional_rows_including_duplicates':checks,'rows_by_source_kind':dict(kinds),'violated_rows':len(violated),'violations':violated,'minimum_exact_slack':str(Fraction(minimum,D)),'point_sha256':hashlib.sha256(a.point.read_bytes()).hexdigest(),'global_certificate_sha256':hashlib.sha256(a.global_certificate.read_bytes()).hexdigest(),'global_replay_sha256':hashlib.sha256(a.global_replay.read_bytes()).hexdigest(),'global_immutable_provenance_commit':'a423fbe913ea02a7fa536e6994151fe65100f9d6','consumer_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Exact conditional Boolean consequences of all26735 adaptive/seed source obstructions and4102initial rank obstructions in the previously independently replayed full-domain global run. This is an exact point screen; no full-frame construction or infeasibility proof.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='violations'},flush=True)
if __name__=='__main__':main()
