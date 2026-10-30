"""Independent count aggregation and scalar likelihood checks (shared raw data)."""
import pathlib,json,math,hashlib,collections,subprocess,os
R=pathlib.Path(__file__).resolve().parent
records=[];seeds=set()
for name in ['cubic-Z-eta5-U','rhombic-X-eta100-U','cubic-Z-eta100-D']:
 d=json.loads((R/(name+'.json')).read_text());a=json.loads((R/(name+'-analysis.json')).read_text())
 assert d['complete'];groups=collections.defaultdict(list)
 for r in d['rows']:
  key=r['generator'],r['seed'];assert key not in seeds;seeds.add(key)
  assert r['invalid']==0;groups[r['L'],r['p']].append(r)
 for r in a['rows']:
  raw=groups[r['L'],r['p']];assert len(raw)==2
  for k in ['shots','failures','point_failures','loop_failures','invalid']:assert sum(x[k] for x in raw)==r[k]
  assert 0<=r['point_failures']+r['loop_failures']-r['failures']<=min(r['point_failures'],r['loop_failures'])
 rec={'name':name,'trials':sum(x['shots'] for x in d['rows']),'invalid':0,'raw_sha256':hashlib.sha256((R/(name+'.json')).read_bytes()).hexdigest(),'analysis_sha256':hashlib.sha256((R/(name+'-analysis.json')).read_bytes()).hexdigest()}
 if 'logistic' in a:
  t,nu,intercept,b=a['logistic']['parameters'];ps=sorted({r['p'] for r in a['rows']});scale=ps[len(ps)//2];dev=0
  for r in a['rows']:
   mu=1/(1+math.exp(-(intercept+b*(r['p']-t)/scale*(r['L']/6)**(1/nu))));k=r['failures'];n=r['shots']
   if k:dev+=2*k*math.log(k/(n*mu))
   if k<n:dev+=2*(n-k)*math.log((n-k)/(n*(1-mu)))
  assert abs(dev-a['logistic']['deviance'])<1e-8
  assert all(x['deviance']>=dev-1e-7 for x in a['profile'])
  rec['independent_scalar_deviance']=dev
 records.append(rec)
assert sum(x['trials'] for x in records)==112000
result={'checks':records,'unique_generator_seed_pairs':len(seeds),'errors':[],'independence':'Separate scalar implementation and raw aggregation; shared raw data and model definition. Does not independently simulate the physics.'}
(R/'validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
