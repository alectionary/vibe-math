#!/usr/bin/env python3
"""Small integer flow master with shape and private-owner Hall separation.

Every integer master point is replayed with exact integer arithmetic. Solver
infeasibility remains pending an independently checked global certificate.
"""
import argparse
from collections import defaultdict
import hashlib
from itertools import combinations
import json
import math
from pathlib import Path
import subprocess
import sys
import time
import numpy as np
from scipy.optimize import Bounds,LinearConstraint,milp
from scipy.sparse import coo_array
from owner_hall import allocation,literal_owners
from orbit_benders import ShapeSeparation,canonical
from orbit_augmentation import augmentation
from rank_oracle import basis


def upper_planes(values):
    result=set()
    for a,b in combinations(range(len(values)),2):
        A=values[b]-values[a];B=b-a;D=B*values[a]-A*a
        if all(B*v-A*i<=D for i,v in enumerate(values)):
            g=math.gcd(A,B,D);result.add((-A//g,B//g,D//g))
    assert result
    return sorted(result)


class LinearMaster:
    def __init__(self):self.upper=[];self.rows=[];self.lo=[];self.hi=[]
    def var(self,upper=16):self.upper.append(upper);return len(self.upper)-1
    def add(self,row,lo=-np.inf,hi=np.inf):
        self.rows.append({i:c for i,c in row.items() if c});self.lo.append(lo);self.hi.append(hi)
    def disjunction(self,row,x,z,e):
        a=row['owner'];own=x if row['side']=='X' else z;opp=z if row['side']=='X' else x;c=row['count'];terms=[]
        def witness(expression,rhs,M):
            v=self.var(1);terms.append(v);r=dict(expression);r[v]=M;self.add(r,hi=rhs+M)
        if c>0:witness({own[a]:1},c-1,17-c)
        if c<16:witness({own[a]:-1},-c-1,c+1)
        for demand in row['demands']:
            b=demand['opposite'];flow=e[a][b] if row['side']=='X' else e[b][a]
            if demand['owners']:n=demand['owners'];witness({flow:1},n-1,17-n)
            if demand['zero']:d=demand['zero'];witness({opp[b]:1,flow:-1},d-1,17-d)
        self.add({v:1 for v in terms},lo=1)
    def solve(self,seconds,solver):
        if solver=='cp-sat':
            from ortools.sat.python import cp_model
            model=cp_model.CpModel();v=[model.new_int_var(0,b,f'v{i}') for i,b in enumerate(self.upper)]
            for row,lo,hi in zip(self.rows,self.lo,self.hi):
                expression=sum(c*v[i] for i,c in row.items())
                if np.isfinite(lo):model.add(expression>=int(lo))
                if np.isfinite(hi):model.add(expression<=int(hi))
            engine=cp_model.CpSolver();engine.parameters.max_time_in_seconds=seconds;engine.parameters.num_search_workers=1;status=engine.solve(model)
            if status in [cp_model.FEASIBLE,cp_model.OPTIMAL]:return 'FEASIBLE',np.array([engine.value(w) for w in v],dtype=np.int64),{'solver_seconds':engine.wall_time}
            return 'INFEASIBLE' if status==cp_model.INFEASIBLE else 'UNKNOWN',None,{'solver_seconds':engine.wall_time}
        rr=[];cc=[];dd=[]
        for j,row in enumerate(self.rows):
            for i,c in row.items():rr.append(j);cc.append(i);dd.append(c)
        A=coo_array((np.array(dd,dtype=float),(np.array(rr,dtype=np.int32),np.array(cc,dtype=np.int32))),shape=(len(self.rows),len(self.upper))).tocsc()
        start=time.monotonic();r=milp(np.zeros(len(self.upper)),integrality=np.ones(len(self.upper)),bounds=Bounds(np.zeros(len(self.upper)),self.upper),constraints=LinearConstraint(A,self.lo,self.hi),options={'time_limit':seconds,'mip_rel_gap':0})
        metadata={'solver_seconds':time.monotonic()-start,'message':r.message,'solver_status':r.status,'nodes':getattr(r,'mip_node_count',None)}
        if r.x is not None:
            point=np.rint(r.x).astype(np.int64)
            if np.max(abs(r.x-point))<1e-5:return 'FEASIBLE',point,metadata
        return 'INFEASIBLE' if r.status==2 else 'UNKNOWN',None,metadata
    def verify(self,point):
        assert len(point)==len(self.upper) and all(0<=int(v)<=u for v,u in zip(point,self.upper))
        for row,lo,hi in zip(self.rows,self.lo,self.hi):
            value=sum(int(point[i])*c for i,c in row.items());assert lo<=value<=hi,(value,lo,hi)


def build(folder,hall_envelopes=True):
    patterns=json.loads((folder/'mapping.json').read_text());hulls={r['pattern']:r['planes'] for r in json.loads((folder/'hulls.json').read_text())};masks=list(map(int,(folder/'masks.txt').read_text().split()));profiles=json.loads((folder/'profiles.json').read_text());sep=ShapeSeparation(masks,profiles);lookup={r['pattern']:r for r in profiles}
    master=LinearMaster();x=[master.var() for _ in range(45)];z=[master.var() for _ in range(45)];e=[[master.var() for b in range(45)] for a in range(45)]
    for a in range(45):
        master.add(dict([(x[a],-1)]+[(v,1) for v in e[a]]),0,0)
        for b in range(45):
            f=patterns['canonical_patterns'][a][b]
            if not f:master.add({e[a][b]:1},0,0)
            else:
                for u,v,w,rhs in hulls[f]:master.add({x[a]:u,z[b]:v,e[a][b]:w},hi=rhs)
    for b in range(45):master.add(dict([(z[b],-1)]+[(e[a][b],1) for a in range(45)]),0,0)
    master.add({v:1 for v in x},128,128);master.add({v:1 for v in z},128,128);master.upper[x[12]]=master.upper[z[12]]=11
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    ax=[augmentation(X[16*a]) for a in range(45)];az=[augmentation(Z[16*b]) for b in range(45)]
    for u in range(8):
        for v in range(8):
            half=master.var(64);r={e[a][b]:1 for a in range(45) for b in range(45) if ax[a]>>u&1 and az[b]>>v&1};r[half]=-2;master.add(r,0,0)
    for selected in combinations(range(45),3):
        rank=len(basis(X[16*a+h] for a in selected for h in range(16)))
        if rank<48:
            master.add({x[a]:1 for a in selected},hi=rank);master.add({z[a]:1 for a in selected},hi=rank)
    envelope_count=0
    if hall_envelopes:
        cache={}
        for a in range(45):
            groups=defaultdict(list)
            for b in range(45):groups[canonical(patterns['patterns'][a][b])].append(b)
            for f,bins in groups.items():
                if len(bins)<2 or f.bit_count()<=1:continue
                if f not in cache:
                    values=[max(lookup[f]['owners'][k] for k,m in enumerate(masks) if m.bit_count()==c) for c in range(17)];cache[f]=upper_planes(values)
                for A,B,D in cache[f]:
                    for side,own in [('X',x),('Z',z)]:
                        row={own[a]:A}
                        for b in bins:row[e[a][b] if side=='X' else e[b][a]]=B
                        master.add(row,hi=D);envelope_count+=1
    return master,x,z,e,patterns,sep,envelope_count


def hall_shapes(sep,patterns,row,possible):
    active=[r for r in row['demands'] if r['owners']];kept=[];certificates=[]
    while possible:
        bit=possible&-possible;possible^=bit;k=bit.bit_length()-1;I=sep.masks[k]
        own=[literal_owners(r['pattern'],I)[1] for r in active];answer=allocation(own,[r['owners'] for r in active])
        if answer['possible']:kept.append(I)
        else:
            bins=[active[b]['opposite'] for b in answer['bins']];certificates.append({'shape':I,'bins':bins,'required':answer['required'],'available_owners':answer['available_owners']})
    return kept,certificates


def main():
    ap=argparse.ArgumentParser();ap.add_argument('inputs',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--solver',choices=['highs','cp-sat'],default='highs');ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--step-seconds',type=float,default=120);ap.add_argument('--iterations',type=int,default=20);ap.add_argument('--no-hall-envelopes',action='store_true');ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS);args=ap.parse_args()
    if not args.child:
        child=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child']);expired=False
        try:child.wait(timeout=args.seconds)
        except subprocess.TimeoutExpired:
            expired=True;child.terminate()
            try:child.wait(timeout=3)
            except subprocess.TimeoutExpired:child.kill();child.wait()
        d=json.loads(args.output.read_text()) if args.output.exists() else {}
        if d.get('status') in [None,'RUNNING']:d['status']='PROCESS_TIME_LIMIT' if expired else 'ERROR'
        d.update(child_returncode=child.returncode,outer_limit_seconds=args.seconds);args.output.write_text(json.dumps(d,indent=2)+'\n');return
    start=time.monotonic();master,x,z,e,mapping,sep,envelopes=build(args.inputs,not args.no_hall_envelopes);seed=[json.loads(s) for s in (args.inputs/'old-shape-cuts.jsonl').read_text().splitlines()];seen=set()
    for row in seed:sep.check(row);master.disjunction(row,x,z,e);seen.add(json.dumps(row,sort_keys=True))
    result={'status':'RUNNING','scope':'necessary common-shape and owner-allocation flow master','physical_frame':False,'solver':args.solver,'seed_cuts':len(seed),'hall_envelope_inequalities':envelopes,'iterations':0,'new_shape_cuts':0,'new_hall_cuts':0};log=args.output.with_suffix('.cuts.jsonl').open('w')
    def save():result.update(wall_seconds=time.monotonic()-start,variables=len(master.upper),linear_constraints=len(master.rows));args.output.write_text(json.dumps(result,indent=2)+'\n')
    save();print(json.dumps(result),flush=True)
    for step in range(args.iterations):
        status,point,metadata=master.solve(args.step_seconds,args.solver);result.update(last_solver_status=status,last_solver_metadata=metadata,iterations=step+1)
        if status!='FEASIBLE':result['status']='INFEASIBLE_PENDING_CERTIFICATE' if status=='INFEASIBLE' else 'UNKNOWN_STEP';break
        master.verify(point);xc=[int(point[v]) for v in x];zc=[int(point[v]) for v in z];flow=[[int(point[v]) for v in r] for r in e];candidate={'X_counts':xc,'Z_counts':zc,'flow':flow};args.output.with_suffix('.last-flow.json').write_text(json.dumps(candidate)+'\n');added=0;shapes={'X':[],'Z':[]}
        for side,own,opp in [('X',xc,zc),('Z',zc,xc)]:
            for a in range(45):
                f=flow[a] if side=='X' else [flow[b][a] for b in range(45)];row,bits=sep.separate(mapping['patterns'],side,a,own[a],opp,f)
                if row is None:
                    demands=[{'opposite':b,'zero':opp[b]-f[b],'owners':f[b],'pattern':canonical(mapping['patterns'][a][b])} for b in range(45) if opp[b] or f[b]];test={'kind':'local_owner_hall','side':side,'owner':a,'count':own[a],'demands':demands};kept,certificates=hall_shapes(sep,mapping['patterns'],test,bits)
                    if kept:shapes[side].append(kept);continue
                    row=test;row['hall_failures']=certificates;result['new_hall_cuts']+=1
                else:result['new_shape_cuts']+=1
                key=json.dumps(row,sort_keys=True);assert key not in seen,'A certified disjunction failed to eliminate its point.';seen.add(key);master.disjunction(row,x,z,e);log.write(json.dumps(row)+'\n');log.flush();added+=1
        result['last_added_cuts']=added;save();print(json.dumps(result),flush=True)
        if not added:
            result['status']='RELAXATION_FEASIBLE';args.output.with_suffix('.shapes.json').write_text(json.dumps(shapes)+'\n');break
    else:result['status']='ITERATION_LIMIT'
    save();log.close();print(json.dumps(result),flush=True)


if __name__=='__main__':main()
