from pathlib import Path
import gzip,hashlib,json
ROOT=Path(__file__).resolve().parents[1];D=ROOT/'coupling-results/full-basis-sourcecase32-pilot-v2'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):return json.loads(gzip.decompress(Path(p).read_bytes()))
f=load(D/'frozen.json.gz');original=load(D/'baseline-model.json.gz');values={abs(v):v>0 for v in original}
def val(lit):return values[abs(lit)] if lit>0 else not values[abs(lit)]
for kind,x,y,z in f['gates']:
 a,b=val(x),val(y);assert z not in values;values[z]=(a and b) if kind=='and' else ((a!=b) if kind=='xor' else (a or b))
assert set(values)==set(range(1,f['augmented_top']+1));raw=gzip.decompress((D/'small64.cnf.gz').read_bytes());checked=0
for line in raw.decode().splitlines()[1:]:
 c=list(map(int,line.split()));assert c[-1]==0 and any(val(v) for v in c[:-1]);checked+=1
model=[i if values[i] else -i for i in sorted(values)];p=D/'baseline-extended-to-small64-model.json.gz';assert not p.exists();p.write_bytes(gzip.compress((json.dumps(model)+'\n').encode(),mtime=0))
out={'status':'PASS_SAME_BASELINE_WITNESS_EXTENDS_TO_AUGMENTED_CNF','source_C16_answered':False,'script_sha256':sha(__file__),'baseline_model_sha256':sha(D/'baseline-model.json.gz'),'extended_model_sha256':sha(p),'frozen_sha256':sha(D/'frozen.json.gz'),'augmented_CNF_raw_sha256':hashlib.sha256(raw).hexdigest(),'literal_clauses_checked':checked,'original_variables_unchanged':all(values[abs(v)]==(v>0) for v in original),'solver_calls':0,'scope':'The addedcutdoesnoteliminate theactualsavedbaselineBooleanmodel. This isnota fullsourceframe.'};(D/'baseline-extension-independent.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
