"""Compile the established LaTeX manuscript and exact typographic proof listing."""
from pathlib import Path
import argparse,subprocess,re,json,hashlib
R=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--tectonic',required=True);a=p.parse_args()
for module in ['OddSupport','Question','Consumers']:
 s=(R.parent/(module+'.lean')).read_text()
 math={'∀':r'\forall','∃':r'\exists','→':r'\to','↔':r'\leftrightarrow','←':r'\leftarrow','∧':r'\land','∨':r'\lor','¬':r'\neg','≤':r'\le','≠':r'\ne','⟨':r'\langle','⟩':r'\rangle','·':r'\cdot','∈':r'\in','⟷':r'\leftrightarrow','⊆':r'\subseteq','×':r'\times'}
 math['α']=r'\alpha'
 for ch,tex in math.items():s=s.replace(ch,'(*@\\ensuremath{'+tex+'}@*)')
 assert all(ord(ch)<128 for ch in s)
 (R/(module+'-listing.txt')).write_text(s)
r=subprocess.run([a.tectonic,'--keep-logs','--outdir',str(R),str(R/'main.tex')],capture_output=True,text=True)
(R/'compiler-output.log').write_text(r.stdout+r.stderr)
assert r.returncode==0,r.stdout+r.stderr
log=(R/'main.log').read_text()
for failure in ['Missing character:','Overfull \\hbox','undefined references','LaTeX Error:']:
 assert failure not in log,failure
print('Paper compiled with no missing characters, overfull boxes or undefined references.')
