#!/usr/bin/env python3
"""Independently rebuild exact cardinalities, labels and hereditary source cuts."""
from pathlib import Path
from itertools import product
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
from verify_algebraic_model import physical
from verify_mandatory_closure import ClosureConsumer
from verify_mixed_rank_cover_cuts import check as check_rank
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--instance',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();d=json.loads(a.instance.read_text());assert 1<=d['selected_pairs']<=128 and d['full_frame_projection_necessary'] and not d['positive_full_basis_constraints_imported'];X,Z,A=physical();columns=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)];assert columns==A
    for i,row in enumerate(A):
        rotated=sum(((((row>>(16*o))&65535)<<1|((row>>(16*o))&65535)>>15)&65535)<<(16*o) for o in range(45));assert rotated==A[16*(i//16)+(i%16+1)%16]
    rows=[];owner=lambda s,i:1+i+720*s
    for side,masks in enumerate([A,columns]):
        for i,m in enumerate(masks):rows.append([-owner(side,i)]+[owner(1-side,j) for j in range(720) if m>>j&1])
    n=1440;gates=0;truth_rows=0
    def gate(args,op):
        nonlocal n,gates,truth_rows
        n+=1;gates+=1;output=n
        for assignment in product((0,1),repeat=len(args)):
            rows.append([v if not b else -v for v,b in zip(args,assignment)]+[output if op(assignment) else -output]);truth_rows+=1
        return output
    for side in [0,1]:
        level=[(owner(side,i),) for i in range(720)]
        while len(level)>1:
            new=[]
            for k in range(0,len(level),2):
                if k+1==len(level):new.append(level[k]);continue
                left,right=level[k:k+2];bits=[];carry=None
                for bit in range(max(len(left),len(right))):
                    inputs=([left[bit]] if bit<len(left) else [])+([right[bit]] if bit<len(right) else [])+([carry] if carry else [])
                    if len(inputs)==1:bits.append(inputs[0]);carry=None
                    else:bits.append(gate(inputs,lambda a:sum(a)%2));carry=gate(inputs,(lambda a:all(a)) if len(inputs)==2 else (lambda a:sum(a)>1))
                if carry:bits.append(carry)
                new.append(tuple(bits))
            level=new
        for bit,v in enumerate(level[0]):rows.append([v if d['selected_pairs']//2**bit%2 else -v])
    slot_count=0;slot_clauses=0
    for i in range(720):
        neighbors=[j for j in range(720) if A[i]>>j&1];width=(len(neighbors)-1).bit_length() if neighbors else 0;labels=list(range(n+1,n+1+width));n+=width;slot_count+=width
        for code,j in enumerate(neighbors):
            for bit,v in enumerate(labels):rows.append([-owner(0,i),-owner(1,j),v if code//2**bit%2 else -v]);slot_clauses+=1
    extras=set();seed_count=0;consumer=ClosureConsumer(X,Z,A)
    for dep in d['seed_dependencies']:
        path=ROOT/dep['c16_path'];assert sha(path)==dep['sha256']
        for c in json.loads(path.read_text())['cuts']:
            if c['kind']=='forced_propagation':
                req=[[],[]];req[c['sector']]=c['indices'];assert not consumer.replay(*req)['possible']
            elif c['kind']=='z_zero':
                U,V=(X,Z) if c['sector']==0 else (Z,X);check_rank(U,V,c['indices'],int(c['annihilator'],16))
            else:assert c['kind']=='joint_forced_propagation' and not consumer.replay(c['required_X'],c['required_Z'])['possible']
            seed_count+=1
            for h in range(16):
                if c['kind']=='joint_forced_propagation':
                    r=[[16*(i//16)+(i%16+h)%16 for i in c[key]] for key in ['required_X','required_Z']];patterns=[r,r[::-1]]
                else:
                    r=[16*(i//16)+(i%16+h)%16 for i in c['indices']];patterns=[[r,[]],[[],r]]
                for pattern in patterns:extras.add(tuple(sorted(-owner(s,i) for s,indices in enumerate(pattern) for i in indices)))
    phase_receipt=None
    if d['phase_profiles_c16_path']:
        path=ROOT/d['phase_profiles_c16_path'];assert sha(path)==d['phase_profiles_sha256'];data=json.loads(gzip.decompress(path.read_bytes()));assert data.get('conditioned_on_anchor') is None and data.get('conditioned_on_X_index') is None
        with tempfile.TemporaryDirectory(prefix='projection-phase-replay-') as temp:
            op=Path(temp)/'receipt.json';run=subprocess.run([sys.executable,str(ROOT/'verify_orbit_rank_profiles.py'),'--certificate',str(path),'--output',str(op)],capture_output=True,text=True,timeout=180);assert run.returncode==0,run.stderr;phase_receipt=json.loads(op.read_text());assert phase_receipt['status']=='PASS'
        for record in data['records']:
            for cut in record['minimal_bad_certificates']:
                ids=[16*record['orbit']+h for h in range(16) if cut['mask']>>h&1]
                for side in [0,1]:extras.add(tuple(-owner(side,i) for i in ids))
    assert all(all(v<0 for v in c) for c in extras);rows.extend([list(c) for c in sorted(extras)]);raw=(f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();assert raw==gzip.decompress((a.instance.parent/d['input_file']).read_bytes()) and hashlib.sha256(raw).hexdigest()==d['input_sha256'];assert n==d['variables'] and len(rows)==d['clauses'];assert gates==d['details']['adder_gates'] and slot_count==d['details']['partner_label_variables'] and slot_clauses==d['details']['partner_clauses'] and len(extras)==d['details']['source_negative_clauses']
    out={'status':'PASS','source_C16_answered':False,'selected_pairs':d['selected_pairs'],'source_full_frame_size':128,'physical_pairings_rebuilt':518400,'source_symmetry_graph_generators_checked':True,'variables':n,'clauses':len(rows),'exact_sector_cardinalities_checked':2,'adder_gates_checked':gates,'adder_truth_table_rows_checked':truth_rows,'binary_partner_label_variables_checked':slot_count,'source_seed_certificates_checked':seed_count,'all_imported_source_clauses_negative':True,'imported_negative_clauses':len(extras),'phase_receipt':phase_receipt,'input_sha256':d['input_sha256'],'elapsed_seconds':time.monotonic()-start,'scope':'Exact partial matching CNF and all hereditary source restrictions checked. A128-pair full frame yields a selected k-pair subframe by deletion. No full-basis positive or signature-independence constraint is imported, and no satisfiability conclusion is inferred.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='phase_receipt'},flush=True)
if __name__=='__main__':main()
