#!/usr/bin/env python3
"""Independent physical direct-owner/CNF reconstruction and clause replay."""
from pathlib import Path
from itertools import product
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time,collections
from verify_algebraic_model import physical
from verify_mandatory_closure import ClosureConsumer
from verify_mixed_rank_cover_cuts import check as check_rank
from verify_full_span_frame import check_row
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--instance',type=Path,required=True);p.add_argument('--theory-log',type=Path);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();d=json.loads(a.instance.read_text());assert d['dimension']==128 and d['native_matching_required'];X,Z,A=physical();col=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)];owner=lambda s,i:1+i+720*s;rows=[]
    for side,masks in enumerate([A,col]):
        for i,m in enumerate(masks):rows.append([-owner(side,i)]+[owner(1-side,j) for j in range(720) if m>>j&1])
    if d['anchor']:
        x,z=d['anchor'];assert A[x]>>z&1;rows.extend([[owner(0,x)],[owner(1,z)]])
        rows.extend([[-owner(0,i)] for i in range(720) if i!=x and A[i]>>z&1]);rows.extend([[-owner(1,j)] for j in range(720) if j!=z and A[x]>>j&1])
    # Reconstruct all Boolean equivalences from independently specified truth tables.
    variables=1440;gate_count=0;truth_rows=0
    def next_gate(args,operation):
        nonlocal variables,gate_count,truth_rows
        variables+=1;gate_count+=1;output=variables
        for assignment in product(range(2),repeat=len(args)):
            truth=operation(assignment);rows.append([v if not b else -v for v,b in zip(args,assignment)]+[output if truth else -output]);truth_rows+=1
        return output
    level=[(i,) for i in range(1,721)]
    while len(level)>1:
        combined=[]
        for offset in range(0,len(level),2):
            if offset+1==len(level):combined.append(level[offset]);continue
            left,right=level[offset:offset+2];summed=[];carry=0
            for bit in range(max(map(len,[left,right]))):
                operands=[]
                if bit<len(left):operands.append(left[bit])
                if bit<len(right):operands.append(right[bit])
                if carry:operands.append(carry)
                if len(operands)==1:summed.append(operands[0]);carry=0
                else:
                    summed.append(next_gate(operands,lambda a:sum(a)&1));carry=next_gate(operands,(lambda a:a[0] and a[1]) if len(operands)==2 else (lambda a:sum(a)>=2))
            if carry:summed.append(carry)
            combined.append(tuple(summed))
        level=combined
    assert list(level[0])==d['details']['sum_bits'] and gate_count==d['details']['adder_gates'];rows.append([level[0][7]])
    for mask in A:rows.append([owner(1,j) for j in range(720) if mask>>j&1])
    for mask in col:rows.append([owner(0,i) for i in range(720) if mask>>i&1])
    consumer=ClosureConsumer(X,Z,A);extras=set();seed_count=0
    for dep in d['seed_dependencies']:
        path=ROOT/dep['c16_path'];assert sha(path)==dep['sha256']
        for c in json.loads(path.read_text())['cuts']:
            if c['kind']=='forced_propagation':
                req=[[],[]];req[c['sector']]=c['indices'];assert not consumer.replay(*req)['possible']
            elif c['kind']=='z_zero':
                U,V=(X,Z) if c['sector']==0 else (Z,X);check_rank(U,V,c['indices'],int(c['annihilator'],16))
            else:assert c['kind']=='joint_forced_propagation' and not consumer.replay(c['required_X'],c['required_Z'])['possible']
            seed_count+=1
            for shift in range(16):
                if c['kind']=='joint_forced_propagation':
                    sides=[[16*(i//16)+(i%16+shift)%16 for i in c[k]] for k in ['required_X','required_Z']];patterns=[sides,sides[::-1]]
                else:
                    ids=[16*(i//16)+(i%16+shift)%16 for i in c['indices']];patterns=[[ids,[]],[[],ids]]
                for sides in patterns:extras.add(tuple(sorted(-owner(s,i) for s,ids in enumerate(sides) for i in ids)))
    phase_receipt=None
    if d['phase_profiles_c16_path']:
        path=ROOT/d['phase_profiles_c16_path'];assert sha(path)==d['phase_profiles_sha256']
        with tempfile.TemporaryDirectory(prefix='owner-phase-replay-') as temp:
            op=Path(temp)/'replay.json';run=subprocess.run([sys.executable,str(ROOT/'verify_orbit_rank_profiles.py'),'--certificate',str(path),'--output',str(op)],capture_output=True,text=True,timeout=180)
            assert run.returncode==0,run.stderr;phase_receipt=json.loads(op.read_text());assert phase_receipt['status']=='PASS'
        data=json.loads(gzip.decompress(path.read_bytes()));assert data.get('conditioned_on_anchor') is None and data.get('conditioned_on_X_index') is None
        for record in data['records']:
            for cut in record['minimal_bad_certificates']:
                ids=[16*record['orbit']+bit for bit in range(16) if cut['mask']>>bit&1]
                for sector in (0,1):extras.add(tuple(-owner(sector,i) for i in ids))
    rows.extend([list(c) for c in sorted(extras)]);raw=(f'p cnf {variables} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();assert raw==gzip.decompress((a.instance.parent/d['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==d['input_sha256'] and variables==d['variables'] and len(rows)==d['clauses']
    counts=collections.Counter()
    if a.theory_log:
        for line in a.theory_log.open():
            c=json.loads(line);counts[c['kind']]+=1
            if c['kind']=='conditional_matching_at_most_one':
                side=c['side'];i=c['owner_index'];j,k=c['opposite_indices'];assert side in [0,1] and 0<=i<720 and 0<=j<720 and 0<=k<720 and j!=k;mask=(A,col)[side][i];assert mask>>j&1 and mask>>k&1;assert c['clause']==[-owner(side,i),-owner(1-side,j),-owner(1-side,k)]
            else:check_row(X,Z,A,c,col)
    out={'status':'PASS','source_C16_answered':False,'source_full_frame_size':128,'projection_model':False,'physical_pairings_rebuilt':518400,'edge_variables':0,'owner_variables':1440,'variables':variables,'clauses':len(rows),'adder_gates_checked':gate_count,'adder_truth_table_rows_checked':truth_rows,'seed_certificates_checked':seed_count,'phase_receipt':phase_receipt,'input_sha256':d['input_sha256'],'theory_counts':dict(counts),'theory_file_sha256':sha(a.theory_log) if a.theory_log else None,'elapsed_seconds':time.monotonic()-start,'scope':'Exact full-source model and all supplied clauses replayed. Matching constraints are mandatory and supplied dynamically. No satisfiability conclusion is inferred.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='phase_receipt'},flush=True)
if __name__=='__main__':main()
