"""Bounded exact basis-mixture repair by directed physical basis exchanges.

No polynomial termination claim. Success is exact equality; a closed reachable
set gives an independently replayable rank cut. Timeout preserves exact state.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter,deque
import argparse,hashlib,json,time
from verify_projected_profile_moment_rows import point_vector
from full_partner_projection_features import moment_target
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rank(values):
    piv={}
    for v in values:
        while v:
            p=v.bit_length()-1
            if p in piv:v^=piv[p]
            else:piv[p]=v;break
    return len(piv)

class ExactRepair:
    def __init__(self,vectors,ground,target,mixture,rank_required):
        self.V=vectors;self.E=tuple(sorted(ground));self.q={j:Q(target[j]) for j in self.E};self.r=rank_required;self.w={};self.cache={};self.rounds=[]
        for B,w in mixture.items():
            B=tuple(sorted(B));w=Q(w);assert w>=0 and len(B)==len(set(B))==self.r and set(B)<=set(self.E) and rank(vectors[j] for j in B)==self.r
            if w:self.w[B]=self.w.get(B,Q(0))+w
        assert sum(self.w.values())==1 and sum(self.q.values())==self.r and all(0<=v<=1 for v in self.q.values());self.x=self.marginal();self.initial_error=self.error();self.last_reachable=None
    def marginal(self):
        x={j:Q(0) for j in self.E}
        for B,w in self.w.items():
            for j in B:x[j]+=w
        return x
    def error(self):return sum(max(Q(0),self.q[j]-self.x[j]) for j in self.E)
    def model(self,B):
        if B not in self.cache:
            piv={}
            for i,j in enumerate(B):
                v=self.V[j];c=1<<i
                while v:
                    p=v.bit_length()-1
                    if p in piv:vv,cc=piv[p];v^=vv;c^=cc
                    else:piv[p]=(v,c);break
                assert v
            self.cache[B]=(set(B),{j:i for i,j in enumerate(B)},piv,{})
        return self.cache[B]
    def circuit(self,B,j):
        S,pos,piv,cache=self.model(B)
        if j not in cache:
            v=self.V[j];c=0
            while v:
                p=v.bit_length()-1;assert p in piv,'ground vector outside basis span';vv,cc=piv[p];v^=vv;c^=cc
            cache[j]=c
        return cache[j]
    def direct(self,surplus,deficit,ordered,deadline):
        for B in ordered:
            if time.monotonic()>=deadline:return None,'TIME_LIMIT_DURING_DIRECT_SEARCH'
            S,pos,_,_=self.model(B);bits=sum(1<<pos[i] for i in surplus if i in S)
            if not bits:continue
            for j in deficit:
                if j in S:continue
                possible=self.circuit(B,j)&bits
                if possible:
                    bit=possible&-possible;i=B[bit.bit_length()-1]
                    return [(i,j,B)],None
        return None,None
    def path(self,surplus,deficit,ordered,deadline):
        wanted=set(deficit);parent={i:None for i in surplus};queue=deque(surplus)
        while queue:
            i=queue.popleft()
            for B in ordered:
                if time.monotonic()>=deadline:return None,None,'TIME_LIMIT_DURING_REACHABILITY'
                S,pos,_,_=self.model(B)
                if i not in S:continue
                bit=1<<pos[i]
                for j in self.E:
                    if j in S or j in parent:continue
                    if self.circuit(B,j)&bit:
                        parent[j]=(i,B)
                        if j in wanted:
                            out=[];v=j
                            while parent[v] is not None:u,witness=parent[v];out.append((u,v,witness));v=u
                            return list(reversed(out)),set(parent),None
                        queue.append(j)
        return None,set(parent),None
    def update(self,path):
        assert path and all(path[k][1]==path[k+1][0] for k in range(len(path)-1));start,end=path[0][0],path[-1][1];multiplicity=Counter(B for i,j,B in path)
        delta=min(self.x[start]-self.q[start],self.q[end]-self.x[end],*(self.w[B]/m for B,m in multiplicity.items()));assert delta>0;change=Counter();new=[]
        for i,j,B in path:
            S,pos,_,_=self.model(B);assert i in S and j not in S and self.circuit(B,j)&(1<<pos[i]);C=tuple(sorted((S-{i})|{j}));assert rank(self.V[k] for k in C)==self.r;new.append(C);change[i]-=1;change[j]+=1
        assert {j:v for j,v in change.items() if v}=={start:-1,end:1}
        for B,m in multiplicity.items():
            self.w[B]-=m*delta;assert self.w[B]>=0
            if not self.w[B]:del self.w[B]
        for C in new:self.w[C]=self.w.get(C,Q(0))+delta
        self.x[start]-=delta;self.x[end]+=delta;assert sum(self.w.values())==1 and all(w>0 for w in self.w.values())
        return delta,max(multiplicity.values())
    def run(self,seconds=480,max_iterations=10000):
        start=time.monotonic();deadline=start+seconds;reason='ITERATION_LIMIT'
        for iteration in range(max_iterations):
            if time.monotonic()>=deadline:reason='TIME_LIMIT';break
            surplus=sorted((j for j in self.E if self.x[j]>self.q[j]),key=lambda j:(self.q[j]-self.x[j],j));deficit=sorted((j for j in self.E if self.x[j]<self.q[j]),key=lambda j:(self.x[j]-self.q[j],j))
            if not surplus:assert not deficit;reason='EXACT_MARGINAL_EQUALITY';break
            assert deficit;ordered=sorted(self.w,key=lambda B:(-self.w[B],B));path,failure=self.direct(surplus,deficit,ordered,deadline);used_reachability=False
            if failure:reason=failure;break
            if path is None:
                used_reachability=True;path,R,failure=self.path(surplus,deficit,ordered,deadline)
                if failure:reason=failure;break
                if path is None:
                    C=sorted(set(self.E)-R);bound=rank(self.V[j] for j in C);xc=sum(self.x[j] for j in C);qc=sum(self.q[j] for j in C);assert all(len(set(B)&set(C))==bound for B in self.w);assert xc==bound<qc;self.last_reachable=R;self.cut={'indices':C,'bound':bound,'conditional_violation':str(qc-bound),'reachable':sorted(R),'exact_mixture_mass_on_complement':str(xc)};reason='EXACT_REACHABILITY_RANK_CUT';break
            old=self.error();delta,multiple=self.update(path);assert self.error()==old-delta
            record={'iteration':iteration,'path_length':len(path),'maximum_basis_multiplicity':multiple,'delta':str(delta),'positive_error':str(self.error()),'active_bases':len(self.w),'used_reachability':used_reachability,'elapsed_seconds':time.monotonic()-start};self.rounds.append(record)
            if iteration%25==0:assert self.x==self.marginal();print(json.dumps(record),flush=True)
        assert self.x==self.marginal();return reason,time.monotonic()-start

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--orbit',type=int,required=True);ap.add_argument('--seed',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=480);a=ap.parse_args();assert not a.output.exists() and 0<a.seconds<=900 and 0<=a.orbit<45;start=time.monotonic();seed=json.loads(a.seed.read_text());assert seed['point_sha256']==sha(a.point) and seed['anchor_orbit']==a.orbit
    owner=point_vector(a.point);p=owner[a.orbit];assert 0<p<1;q=[v/(16*p) for v in moment_target(owner,a.orbit)[55:]];X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];zero=[j for j in range(720) if (X[16*a.orbit]&Z[j]).bit_count()%2==0];units=[j for j in range(720) if j not in set(zero)];ground=[j for j in zero if q[j]>0];assert sum(q[j] for j in zero)==127 and sum(q[j] for j in units)==1
    weights=[Q(float(w)) for w in seed['final_numeric_weights']];assert min(weights)>=0;mass=sum(weights);mixture={}
    for i,w in zip(seed['final_numeric_active_columns'],weights):
        B=tuple(seed['numerical_basis_archive'][i]);mixture[B]=mixture.get(B,Q(0))+w/mass
    paths=['singleton_basis_exchange_repair.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','verify_projected_profile_moment_rows.py','full_partner_projection_features.py'];hashes={p:sha(ROOT/p) for p in paths};frozen={'status':'FROZEN_EXACT_SINGLETON_EXCHANGE_REPAIR','source_C16_answered':False,'point_sha256':sha(a.point),'seed_sha256':sha(a.seed),'source_hashes':hashes,'producer_sha256':sha(Path(__file__)),'anchor_orbit':a.orbit,'seconds':a.seconds,'conditional_probability':str(p),'ground_indices':ground,'initial_binary_rational_weight_mass_before_normalization':str(mass),'scope':'Exactmixtureexchanges onpositive-q zero ground. Noapproximateconvergencecredit and no polynomialterminationclaim.'};fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n');repair=ExactRepair(Z,ground,{j:q[j] for j in ground},mixture,127);reason,seconds=repair.run(a.seconds)
    out={**frozen,'frozen_sha256':sha(fp),'status':'BOUNDED_EXCHANGE_REPAIR_INCONCLUSIVE','physical_full_frame':False,'stopping_reason':reason,'rounds':repair.rounds,'initial_positive_error':str(repair.initial_error),'final_positive_error':str(repair.error()),'zero_bases':[{'indices':list(B),'weight':str(w)} for B,w in sorted(repair.w.items())],'unit_probabilities':[{'index':j,'probability':str(q[j])} for j in units if q[j]],'conditional_target':list(map(str,q)),'active_bases':len(repair.w),'repair_seconds':seconds,'elapsed_seconds':time.monotonic()-start}
    if reason=='EXACT_MARGINAL_EQUALITY':out['status']='EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE'
    elif reason=='EXACT_REACHABILITY_RANK_CUT':
        cut=repair.cut;out.update(status='EXACT_CONDITIONAL_RANK_CUT_CANDIDATE',cut={'sector':'T','anchor_orbit':a.orbit,'mandatory_index':None,'indices':cut['indices'],'bound':cut['bound'],'exact_violation':str(Q(cut['conditional_violation'])*p)},reachability_cut=repair.cut)
    assert all(sha(ROOT/p)==v for p,v in hashes.items());a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:out[k] for k in ('status','stopping_reason','active_bases','initial_positive_error','final_positive_error','repair_seconds','elapsed_seconds')},flush=True)
if __name__=='__main__':main()
