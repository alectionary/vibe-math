#!/usr/bin/env python3
"""One exact full-selector anchorcase, baseline versus accepted small64row."""
from pathlib import Path
import argparse,gzip,hashlib,json,sys,time
from frame_sat import SharedCounters
from pysat.card import CardEnc,EncType
from verify_algebraic_model import physical
from full_basis_boolean_sat_pilot import compile_cut,save_cnf
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output-dir',type=Path,required=True);a=ap.parse_args();D=a.output_dir;assert not D.exists();D.mkdir();t0=time.monotonic();X,Z,A=physical();bankpath=ROOT/'coupling-results/native775-witness9-gauge-rounded.json.gz';replaypath=ROOT/'coupling-results/native775-witness9-gauge-rounded-independent.json';bank,replay=read(bankpath),read(replaypath);assert replay['status']=='PASS' and replay['bank_sha256']==sha(bankpath);cut=bank['cuts'][0]
 counter=SharedCounters(1440);clauses=counter.clauses;roots=[]
 for i,row in enumerate(A):
  z1,z2=counter.count(row,720);x1,x2=counter.count(row,0);clauses.extend([[z1],[x1]])
  if z2:clauses.append([-i-1,-z2])
  if x2:clauses.append([-721-i,-x2])
  roots.append([z1,z2,x1,x2])
 kernel_top=counter.top;kernel_clauses=len(clauses);top=kernel_top;cards=[]
 for base in [0,720]:
  before=top;enc=CardEnc.equals(list(range(base+1,base+721)),128,top_id=top,encoding=EncType.kmtotalizer);top=enc.nv;clauses+=enc.clauses;cards.append(dict(base=base,top_before=before,top_after=top,clauses=len(enc.clauses)))
 units=[[513],[1233]]+[[-i-1] for i in range(720) if i!=512 and A[i]>>512&1]+[[-721-j] for j in range(720) if j!=512 and A[512]>>j&1];clauses+=units;P=list(range(513,529));Q=list(range(721,1441));baseline_top=top;baseline_clauses=len(clauses)
 circuit,translation=compile_cut(cut['coefficients'],cut['upper_bound'],P,Q,top);aug=clauses+circuit.clauses;bsha=save_cnf(D/'baseline.cnf.gz',clauses,baseline_top);asha=save_cnf(D/'small64.cnf.gz',aug,circuit.top)
 prior=ROOT/'coupling-results/full-basis-sourcecase32-pilot-v2';paths=[bankpath,replaypath,prior/'frozen.json.gz',prior/'bridge-controls.json',prior/'baseline.cnf.gz',prior/'small64.cnf.gz',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']
 f={'status':'FROZEN_EXACT_FULL_SELECTOR_BEFORE_CONTROLS_AND_TRIALS','source_C16_answered':False,'case':[32,32,0],'anchor':[512,512],'selector_X_variables':list(range(1,721)),'selector_Z_variables':Q,'fullP_variables':P,'fullQ_variables':Q,'source_equivalence':'Exactly128selectors ineachsector; allselectedrowandcolumndegrees1; selectedpairingmatrix ispermutation128x128,hencephysicaldualframe. Fullpoolpositivecover isredundantnecessary.', 'kernel':'frame_sat.SharedCounters','kernel_top':kernel_top,'kernel_clauses':kernel_clauses,'kernel_roots':roots,'shared_counter_nodes':len(counter.cache),'cardinality_encoders':cards,'fixed_anchor_units':units,'coefficients':cut['coefficients'],'bound':cut['upper_bound'],'cut_index':0,'bank_sha256':sha(bankpath),'bank_receipt_sha256':sha(replaypath),'baseline_top':baseline_top,'augmented_top':circuit.top,'baseline_clauses':baseline_clauses,'augmented_clauses':len(aug),'baseline_raw_sha256':bsha,'augmented_raw_sha256':asha,'PB_reference_directory':str(prior.relative_to(ROOT)),'translation':translation,'gates':circuit.gates,'source_hashes':{str(Path(m.__file__).resolve().relative_to(ROOT)):sha(m.__file__) for m in list(sys.modules.values()) if getattr(m,'__file__',None) and Path(m.__file__).resolve().is_relative_to(ROOT) and Path(m.__file__).suffix=='.py'},'input_hashes':{str(p.relative_to(ROOT)):sha(p) for p in paths},'trial_seconds_each':120,'prior_identical_fullselector_small64_trial_found':False,'setup_seconds':time.monotonic()-t0}
 (D/'frozen.json.gz').write_bytes(gzip.compress((json.dumps(f)+'\n').encode(),mtime=0));print(json.dumps({k:f[k] for k in ['baseline_top','augmented_top','baseline_clauses','augmented_clauses','shared_counter_nodes','setup_seconds']}),flush=True)
if __name__=='__main__':main()
