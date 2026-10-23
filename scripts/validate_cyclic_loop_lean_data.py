"""Round-trip every generated balanced Lean table against independent replay data."""
from pathlib import Path
import json,re,sys
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';LEAN=ROOT/'formalization/dyadic-rank';sys.path.insert(0,str(HERE))
from develop_loop_mechanisms import codes
from merged_reference_states import graph,states
from loop_reference import interval_tail

def parse(text):
 tokens=re.findall(r'\.leaf|\.split|true|false|-?\d+|[(),\[\]]',text);pos=0
 def take(token=None):
  nonlocal pos
  value=tokens[pos];pos+=1
  if token is not None:assert value==token,(value,token)
  return value
 def literal():
  token=take()
  if token=='[':
   values=[]
   while tokens[pos]!=']':
    values.append(literal())
    if tokens[pos]==',':take(',')
   take(']');return values
  if token=='(':
   a=literal();take(',');z=literal();take(')');return a,z
  if token in ['true','false']:return token=='true'
  return int(token)
 def node():
  take('(');tag=take()
  if tag=='.leaf':out=('leaf',literal())
  else:
   assert tag=='.split';cut=int(take());left=node();right=node();out=('split',cut,left,right)
  take(')');return out
 result=node();assert pos==len(tokens);return result

def get(tree,index):
 while tree[0]!='leaf':tree=tree[2] if index<tree[1] else tree[3]
 return tree[1]
def tables(path):return {name:parse(value) for name,value in re.findall(r'^def (\w+) : Table [^\n]*? := (.*)$',path.read_text(),re.M)}

def run():
 cs=codes();common=(LEAN/'CyclicDecoderTubeData.lean').read_text();checks=0
 for name,base in [('previous_best','Previous'),('minimum_4','Minimum')]:
  text=common.split('namespace '+base+'\n',1)[1].split('end '+base,1)[0]
  ts={n:parse(v) for n,v in re.findall(r'^def (\w+) : Table [^\n]*? := (.*)$',text,re.M)};g=graph(cs[name]['merged'])
  expected={'checkData':g['ce'],'incidentData':g['ve'],'checkOf':[c for c,v in g['edge']],'variableOf':[v for c,v in g['edge']]}
  for field,values in expected.items():
   for i,value in enumerate(values):assert get(ts[field],i)==value;checks+=1
 old=json.loads((HERE/'loop-development-full-results.json').read_text());fresh=json.loads((HERE/'loop-holdout-results.json').read_text());ledger=json.loads((HERE/'loop-lean-witnesses.json').read_text());boxes=0
 for rec in ledger['records']:
  name=rec['design'];index=rec['index']
  if rec['source']=='Development':
   arm=next(r for r in old['records'] if r['design']==name and r['representation']=='merged');w=next(w for w in arm['witnesses'] if w['index']==index)
  else:w=next(e for e in fresh['examples'] if e['design']==name and e['index']==index)['details']['merged']
  ts=tables(LEAN/'CyclicDecoderTubeData'/(rec['namespace']+'.lean'));tube=interval_tail(cs[name]['merged'],w['error'],w['q75'])
  for e,x in enumerate(w['q75']):assert get(ts['qData'],e)-52428800==x;checks+=1
  for k,state in enumerate(tube['trace']):
   for e,(lo,hi) in enumerate(state['box']):
    a,z=get(ts['b'+str(k)],e);assert (a-52428800,z-52428800)==(lo,hi);checks+=2;boxes+=1
  print(rec['namespace'],'all entry and interval tables match direct equations',flush=True)
 prefix_checks=0
 for suffix,name,index in [('', 'previous_best',1804),('Minimum','minimum_4',2435)]:
  original=LEAN/('CyclicDecoderOriginal'+suffix+'.lean')
  if not original.exists():continue
  example=next(e for e in fresh['examples'] if e['design']==name and e['index']==index)
  for label,count in [('original',86 if suffix else 65),('merged',75)]:
   ts=tables(LEAN/'CyclicDecoderReachData'/(suffix+label.capitalize()+'.lean'));history,terminal=states(cs[name][label],example['error'])
   for k in range(1,count):
    for e,x in enumerate(history[k]['q']):assert get(ts['q'+str(k)],e)-52428800==x;checks+=1;prefix_checks+=1
   print(name,label,'all mathematical prefix inputs round-trip correctly',flush=True)
 result=dict(status='all_generated_balanced_lean_tables_round_trip',numeric_entries_checked=checks,interval_coordinates_checked=boxes,prefix_coordinates_checked=prefix_checks)
 (HERE/'loop-lean-data-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':run()
