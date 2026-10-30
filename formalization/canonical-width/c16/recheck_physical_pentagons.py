#!/usr/bin/env python3
"""Bounded reuse of the existing coordinate-ascent gate at a named exact point."""
from pathlib import Path
import argparse,json,hashlib,subprocess,sys,time
import numpy as np
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--name',required=True);a=ap.parse_args();r=Path('coupling-results');base=r/(a.name+'-pentagon');assert not Path(str(base)+'-frozen.json').exists();summary=json.loads((r/(a.name+'-checks-summary.json')).read_text());assert summary['status']=='PASS_LISTED_RELAXATION'
 v=np.load(r/(a.name+'.npz'));p=np.r_[v['p'],v['p']];C={h:np.block([[v['S'+str(h)],v['T'+str(h)]],[v['T'+str(h)],v['S'+str(h)]]]) for h in range(9)};C.update({h:C[16-h].T for h in range(9,16)});inp=Path(str(base)+'-input.txt')
 with inp.open('w') as f:
  f.write('90 16\n'+' '.join(format(x,'.17g') for x in p)+'\n')
  for h in range(16):f.write(' '.join(format(x,'.17g') for x in C[h].ravel())+'\n')
 sources=[Path(__file__),Path('separate_integer_form_cuts.cpp'),Path('accept_physical_integer_forms.py'),Path('verify_physical_integer_forms.py'),r/(a.name+'.npz'),r/(a.name+'-rational.json.gz'),inp];binary=Path('/private/tmp/c16-integer-form-recheck');Path(str(base)+'-frozen.json').write_text(json.dumps({'status':'FROZEN_BEFORE_PENTAGON_RECHECK','source_C16_answered':False,'name':a.name,'source_hashes':{str(p):sha(p) for p in sources},'binary_sha256':sha(binary),'scope':'Existingbounded3000restart/20secondsearch;notcomplete5-eventfamily.'},indent=2)+'\n')
 raw=Path(str(base)+'-candidates.json');bank=Path(str(base)+'-bank.json');replay=Path(str(base)+'-independent.json')
 commands=[[str(binary),str(inp),str(raw)],[sys.executable,'accept_physical_integer_forms.py','--candidates',str(raw),'--point',str(r/(a.name+'-rational.json.gz')),'--output',str(bank)]]
 for i,c in enumerate(commands):
  with Path(str(base)+f'-stage{i}.log').open('w') as f:subprocess.run(c,stdout=f,stderr=subprocess.STDOUT,check=True,timeout=90)
 b=json.loads(bank.read_text())
 if b['cuts']:
  with Path(str(base)+'-consumer.log').open('w') as f:subprocess.run([sys.executable,'verify_physical_integer_forms.py','--bank',str(bank),'--point',str(r/(a.name+'-rational.json.gz')),'--output',str(replay)],stdout=f,stderr=subprocess.STDOUT,check=True,timeout=90)
 print({'name':a.name,'candidates':len(json.loads(raw.read_text())['cuts']),'unique_exact_positive':len(b['cuts']),'accepted':replay.exists()},flush=True)
if __name__=='__main__':main()
