"""Unmodified decoder replay of all fresh confirmation errors and outcomes.

Uses a separately implemented low-pivot stabilizer elimination and direct
original-check parity test. No new channel samples or decoder settings.
"""
from pathlib import Path
import base64,hashlib,json,random,struct,subprocess,sys,tempfile,time,zlib
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';sys.path.insert(0,str(HERE))
import benchmark_decoding as b
from develop_loop_mechanisms import codes

def unpack(s):
 raw=zlib.decompress(base64.b64decode(s));return struct.unpack('<'+str(len(raw)//2)+'H',raw)
def word(s):return sum(1<<i for i,x in enumerate(s) if x=='1')
def rowmask(row):return sum(1<<v for v in row)
def low_basis(rows):
 pivots={}
 for x in rows:
  while x:
   low=x&-x
   if low in pivots:x^=pivots[low]
   else:pivots[low]=x;break
 return pivots
def in_span(x,pivots):
 while x:
  low=x&-x
  if low not in pivots:return False
  x^=pivots[low]
 return True

def run():
 start=time.monotonic();result=json.loads((HERE/'entry-confirm-results.json').read_text());checked=0
 with tempfile.TemporaryDirectory(prefix='entry-all-stock-') as tmp:
  stock=Path(tmp)/'stock';subprocess.run(['c++','-O3','-std=c++17',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for rec in result['records']:
   name=rec['design'];c=codes()[name];arms={l:{k.replace('_uint16_le_zlib_base64',''):unpack(v) for k,v in a.items()} for l,a in rec['arms'].items()};rng=random.Random(rec['seed']);stream=hashlib.sha256();pivots=low_basis(c['hz']);checks=list(map(rowmask,c['original']))
   for offset in range(0,1000000,10000):
    errors=[''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for j in range(10000)];payload='\n'.join(errors).encode()
    if offset:stream.update(b'\n')
    stream.update(payload)
    for label in arms:
     terminal=b.engine(stock,c[label],252,[(.04,e) for e in errors],100,.8)
     for j,(iterations,matched,estimate) in enumerate(terminal):
      i=offset+j;residual=word(errors[j])^word(estimate);valid=not any(bin(residual&row).count('1')%2 for row in checks);assert matched==valid
      ok=in_span(residual,pivots);assert not ok or valid
      kind=0 if not residual else 1 if ok else 2 if not valid else 3
      assert kind==arms[label]['kinds'][i] and iterations==arms[label]['iterations'][i],(name,label,i)
      checked+=1
    if offset%100000==0:print(name,offset+10000,'all-stock paired replays PASS; elapsed',round(time.monotonic()-start,1),flush=True)
   assert stream.hexdigest()==rec['error_stream_sha256']
 out=dict(status='every_fresh_terminal_outcome_reproduced_by_unmodified_decoder',decoder_runs_checked=checked,independent_error_patterns_regenerated=2000000,independent_scoring='direct parity and separately implemented low-pivot stabilizer elimination',new_noise_patterns=0,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-stock-replay-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':run()
