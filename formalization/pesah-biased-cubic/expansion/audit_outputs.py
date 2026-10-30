"""Inventory-integrity audit, not a substitute for scientific review."""
import json,collections,pathlib
from analyze_families import R
files=[]
for plan in ['families-plan.json','broad-plan.json','confirmation-plan.json']:
 files.extend(n.replace('-config.json','.json') for n in json.loads((R/plan).read_text())['configs'])
files += [f'pure-z-L{L}.json' for L in [4,6,8,10]]+[f'sweep-{a}.json' for a in ['X','Z','depolarizing']]
seen=collections.defaultdict(list);records=[];errors=[]
for name in files:
 d=json.loads((R/name).read_text());rows=d['rows'];expected=2*len(d['config']['conditions']);keys=[(x['generator'],x['seed']) for x in rows]
 if not d['complete'] or len(rows)!=expected or len(set(keys))!=len(keys):errors.append(name+' completion/cardinality/seed integrity')
 for x in rows:
  for k in ['failures','point_failures','loop_failures','invalid']:
   if not 0<=x[k]<=x['shots']:errors.append(name+' invalid count '+k)
  if x['failures']<max(x['point_failures'],x['loop_failures']):errors.append(name+' total/sector inequality')
  seen[x['generator'],x['seed']].append(name)
 records.append(dict(file=name,complete=d['complete'],trials=sum(x['shots'] for x in rows),invalid=sum(x['invalid'] for x in rows),row_seconds=sum(x['seconds'] for x in rows)))
shared=[dict(generator=k[0],seed=k[1],files=v) for k,v in seen.items() if len(v)>1]
result=dict(errors=errors,records=records,total_trials=sum(r['trials'] for r in records),shared_seed_keys=len(shared),shared=shared,limit='All trials are independent within each simulation family. Some separately reported families reuse generator/seed keys; they must not be pooled as independent evidence. Bonferroni does not require cross-test independence. Cross-code ranking seeds were separately checked disjoint; bootstrap model and source uncertainty remain separate limitations.')
(R/'output-audit.json').write_text(json.dumps(result,indent=2)+'\n');print('errors',errors,'trials',result['total_trials'],'shared',len(shared));assert not errors
