#!/usr/bin/env python3
"""Separate necessary common-phase-shape conditions from a small flow master.

The master uses exactly verified supporting planes of the pairwise cardinality
tables. At a feasible flow, each orbit must admit one phase shape satisfying all
zero/private-owner demands. Empty shape intersections yield independently
replayable monotone disjunctions. Feasibility remains a relaxation of a frame.
"""
import argparse
from datetime import datetime,timezone
import hashlib
from itertools import combinations
import json
from pathlib import Path
import signal
import subprocess
import sys
import time
import numpy as np
from ortools.sat.python import cp_model
from rank_oracle import basis


def rotate(f,h):return ((f<<h)|(f>>(16-h)))&65535 if h else f
def canonical(f):return min(rotate(f,h) for h in range(16))


class ShapeSeparation:
    def __init__(self,masks,profiles):
        self.masks=masks;self.weights=np.array([v.bit_count() for v in masks]);self.profiles={r['pattern']:(np.array(r['zero']),np.array(r['owners'])) for r in profiles};self.cache={}
        self.weight_bits={w:self.bits(self.weights==w) for w in range(17)}
    @staticmethod
    def bits(test):return int.from_bytes(np.packbits(test,bitorder='little').tobytes(),'little')
    def admissible(self,f,d,n):
        key=(f,d,n)
        if key not in self.cache:
            zero,own=self.profiles[f];self.cache[key]=self.bits((zero>=d)&(own>=n))
        return self.cache[key]
    def separate(self,patterns,side,owner,count,opposite,flows):
        tests=[];remaining=self.weight_bits[count]
        for b in range(45):
            n=flows[b];d=opposite[b]-n;assert min(d,n)>=0
            if not (d or n):continue
            f=canonical(patterns[owner][b]);allowed=self.admissible(f,d,n);tests.append((b,d,n,f,allowed));remaining&=allowed
        if remaining:return None,remaining
        core=tests.copy()
        for test in tests:
            rest=self.weight_bits[count]
            for row in core:
                if row is not test:rest&=row[4]
            if not rest:core.remove(test)
        assert core
        row={'kind':'local_shape','side':side,'owner':owner,'count':count,'demands':[{'opposite':b,'zero':d,'owners':n,'pattern':f} for b,d,n,f,allowed in core]}
        self.check(row);return row,0
    def check(self,row):
        remaining=self.weight_bits[row['count']]
        for r in row['demands']:remaining&=self.admissible(r['pattern'],r['zero'],r['owners'])
        assert remaining==0


def main():
    ap=argparse.ArgumentParser();ap.add_argument('mapping',type=Path);ap.add_argument('hulls',type=Path);ap.add_argument('masks',type=Path);ap.add_argument('profiles',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=3600);ap.add_argument('--step-seconds',type=float,default=60);ap.add_argument('--deadline-utc');ap.add_argument('--hint',type=Path);ap.add_argument('--workers',type=int,default=1);ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS);args=ap.parse_args()
    if not args.child:
        allowance=args.seconds
        if args.deadline_utc:allowance=min(allowance,max(0,(datetime.fromisoformat(args.deadline_utc.replace('Z','+00:00'))-datetime.now(timezone.utc)).total_seconds()))
        child=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child']);expired=False
        try:child.wait(timeout=allowance)
        except subprocess.TimeoutExpired:
            expired=True;child.terminate()
            try:child.wait(timeout=3)
            except subprocess.TimeoutExpired:child.kill();child.wait()
        result=json.loads(args.output.read_text()) if args.output.exists() else {}
        if result.get('status') in [None,'RUNNING']:result['status']='PROCESS_TIME_LIMIT' if expired else 'ERROR'
        result.update(child_returncode=child.returncode,outer_wall_limit=allowance);args.output.write_text(json.dumps(result,indent=2)+'\n');return
    mapping=json.loads(args.mapping.read_text());patterns=mapping['patterns'];hulls={r['pattern']:r['planes'] for r in json.loads(args.hulls.read_text())};masks=list(map(int,args.masks.read_text().split()));sep=ShapeSeparation(masks,json.loads(args.profiles.read_text()))
    assert len(masks)==4116;model=cp_model.CpModel();x=[model.new_int_var(0,16,f'x{a}') for a in range(45)];z=[model.new_int_var(0,16,f'z{b}') for b in range(45)];e=[[model.new_int_var(0,16,f'e{a}_{b}') for b in range(45)] for a in range(45)]
    for a in range(45):
        model.add(sum(e[a])==x[a])
        for b in range(45):
            f=mapping['canonical_patterns'][a][b]
            if not f:model.add(e[a][b]==0)
            else:
                for u,v,w,rhs in hulls[f]:model.add(u*x[a]+v*z[b]+w*e[a][b]<=rhs)
    for b in range(45):model.add(sum(e[a][b] for a in range(45))==z[b])
    model.add(sum(x)==128);model.add(sum(z)==128);model.add(x[12]<=11);model.add(z[12]<=11)
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    from orbit_augmentation import add_augmentation_constraints
    add_augmentation_constraints(model,e,X,Z)
    for selected in combinations(range(45),3):
        rank=len(basis(X[16*a+h] for a in selected for h in range(16)))
        if rank<48:model.add(sum(x[a] for a in selected)<=rank);model.add(sum(z[a] for a in selected)<=rank)
    memo={}
    def relation(key,expression,kind,value):
        if key in memo:return memo[key]
        lit=model.new_bool_var('condition'+str(len(memo)));memo[key]=lit
        if kind=='equal':model.add(expression==value).only_enforce_if(lit);model.add(expression!=value).only_enforce_if(~lit)
        else:model.add(expression>=value).only_enforce_if(lit);model.add(expression<value).only_enforce_if(~lit)
        return lit
    def insert(row):
        side=row['side'];a=row['owner'];own=x if side=='X' else z;opp=z if side=='X' else x
        conditions=[relation(('count',side,a,row['count']),own[a],'equal',row['count'])]
        for demand in row['demands']:
            b=demand['opposite'];flow=e[a][b] if side=='X' else e[b][a]
            if demand['owners']:conditions.append(relation(('flow',side,a,b,demand['owners']),flow,'atleast',demand['owners']))
            if demand['zero']:conditions.append(relation(('zero',side,a,b,demand['zero']),opp[b]-flow,'atleast',demand['zero']))
        model.add_bool_or([~v for v in conditions])
    hint=json.loads(args.hint.read_text()) if args.hint else None
    result={'status':'RUNNING','scope':'necessary orbit-flow/common-shape relaxation','physical_frame':False,'iterations':0,'cut_classes':0,'workers':args.workers,'inputs_sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [args.mapping,args.hulls,args.masks,args.profiles]}};start=time.monotonic();log=args.output.with_suffix('.cuts.jsonl').open('w');seen=set()
    def snapshot():result['wall_seconds']=time.monotonic()-start;args.output.write_text(json.dumps(result,indent=2)+'\n')
    snapshot();print(json.dumps(result),flush=True)
    solver=cp_model.CpSolver();solver.parameters.max_time_in_seconds=args.step_seconds;solver.parameters.num_search_workers=args.workers
    while True:
        model.clear_hints()
        if hint:
            for V,values in [(x,hint['X_counts']),(z,hint['Z_counts'])]:
                for v,value in zip(V,values):model.add_hint(v,value)
            for a in range(45):
                for b in range(45):model.add_hint(e[a][b],hint['flow'][a][b])
        status=solver.solve(model);result['iterations']+=1;result['last_solver_status']=solver.status_name(status);result['last_solver_seconds']=solver.wall_time
        if status==cp_model.INFEASIBLE:result['status']='INFEASIBLE_PENDING_CERTIFICATE';break
        if status not in [cp_model.FEASIBLE,cp_model.OPTIMAL]:result['status']='UNKNOWN_STEP';break
        hint={'X_counts':[solver.value(v) for v in x],'Z_counts':[solver.value(v) for v in z],'flow':[[solver.value(v) for v in row] for row in e]};args.output.with_suffix('.last-flow.json').write_text(json.dumps(hint)+'\n');added=0;shapes={'X':[],'Z':[]}
        for side,own,opp in [('X',hint['X_counts'],hint['Z_counts']),('Z',hint['Z_counts'],hint['X_counts'])]:
            for a in range(45):
                flow=hint['flow'][a] if side=='X' else [hint['flow'][b][a] for b in range(45)]
                row,allowed=sep.separate(patterns,side,a,own[a],opp,flow)
                if row is None:shapes[side].append(masks[(allowed&-allowed).bit_length()-1]);continue
                key=json.dumps(row,sort_keys=True)
                if key in seen:raise RuntimeError('A forbidden local-shape demand recurred.')
                seen.add(key);insert(row);log.write(json.dumps(row)+'\n');log.flush();added+=1
        result['cut_classes']+=added;result['last_new_cuts']=added;snapshot();print(json.dumps(result),flush=True)
        if not added:
            result.update(status='RELAXATION_FEASIBLE',X_shapes=shapes['X'],Z_shapes=shapes['Z']);break
    log.close();model.export_to_file(str(args.output.with_suffix('.pbtxt')));snapshot();print(json.dumps({k:v for k,v in result.items() if k not in ['X_shapes','Z_shapes']}),flush=True)


if __name__=='__main__':main()
