"""Literal repeated-witness boundary with negative final mass if unclamped."""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse,hashlib,json
from singleton_basis_exchange_repair import ExactRepair
from verify_basis_exchange_repair_lemma import rank,marginal
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
 V=[1,3,2,3,1];E=list(range(5));B=(0,2);C=(1,4);w={B:Q(1,3),C:Q(2,3)};x=marginal(E,w);q=dict(x);q[0]-=Q(1,4);q[3]+=Q(1,4)
 path=[(0,1,B),(1,2,C),(2,3,B)];counts=Counter(W for i,j,W in path);new=[tuple(sorted(set(W)-{i}|{j})) for i,j,W in path]
 assert all(rank(V[j] for j in W)==2 for W in [B,C]+new)
 assert all(W not in w for W in new)
 unsafe=Q(1,4);bad=Counter(w)
 for W,m in counts.items():bad[W]-=m*unsafe
 for W in new:bad[W]+=unsafe
 assert bad[B]==-Q(1,6) and sum(bad.values())==1
 obj=ExactRepair(V,E,q,w,2);delta,multiple=obj.update(path)
 assert delta==Q(1,6) and multiple==2 and all(z>0 for z in obj.w.values()) and sum(obj.w.values())==1
 assert obj.x==marginal(E,obj.w) and obj.error()==Q(1,12)
 out={'status':'PASS_LITERAL_MULTIPLICITY_BOUNDARY','source_C16_answered':False,'binary_vectors':V,'path':[(i,j,list(W)) for i,j,W in path],'original_weights':{str(B):'1/3',str(C):'2/3'},'safe_delta':'1/6','unclamped_delta':'1/4','unclamped_final_basis_weight':'-1/6','new_bases':new,'source_hashes':{p:sha(ROOT/p) for p in ['singleton_basis_exchange_repair.py','verify_basis_exchange_repair_lemma.py']},'consumer_sha256':sha(Path(__file__))}
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
if __name__=='__main__':main()
