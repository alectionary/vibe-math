#!/usr/bin/env python3
"""Rebuild the source anchor, owner permutation, seeds and mixed-sign clauses."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
from verify_algebraic_model import physical
from verify_mandatory_closure import ClosureConsumer
from verify_mixed_rank_cover_cuts import check as rank_cut
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def outside(v,rows):
    piv={}
    for x in rows:
        while x:
            b=x&-x
            if b not in piv:piv[b]=x;break
            x^=piv[b]
    while v:
        b=v&-v
        if b not in piv:return True
        v^=piv[b]
    return False
def check_row(X,Z,A,row,columns=None):
    side=row['side'];assert side in (0,1);V=(X,Z)[side];opposite=(Z,X)[side];owner=lambda s,i:i+1+(len(X) if s else 0)
    if row['kind']=='basis_circuit':
        ids=row['indices'];assert ids and len(ids)==len(set(ids)) and all(0<=i<len(V) for i in ids);value=0
        for i in ids:value^=V[i]
        assert value==0;expected=[-owner(side,i) for i in ids]
    else:
        assert row['kind'] in ['conditional_span','conditional_private_partner'];ids=row['mandatory_opposite'];assert len(ids)==len(set(ids)) and all(0<=i<len(opposite) for i in ids);w=int(row['annihilator_hex'],16);assert 0<w<1<<128 and outside(w,[opposite[i] for i in ids]);mask=sum(1<<i for i in ids)
        if side==0:pairings=A
        else:pairings=columns if columns is not None else [sum(((A[i]>>j)&1)<<i for i in range(len(X))) for j in range(len(Z))]
        support=[i for i,v in enumerate(V) if not pairings[i]&mask and (v&w).bit_count()%2];assert support==row['positive_support']
        if row['kind']=='conditional_private_partner':
            omitted=row['omitted_positive_index'];assert omitted in support;partners=[j for j,z in enumerate(opposite) if not outside(w^z,[opposite[i] for i in ids])];assert partners==row['possible_partners'];expected=[-owner(1-side,j) for j in ids]+[owner(side,i) for i in support if i!=omitted]+[owner(1-side,j) for j in partners]
        else:expected=[-owner(1-side,j) for j in ids]+[owner(side,i) for i in support]
    assert expected==row['clause'];return expected
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--instance',type=Path,required=True);ap.add_argument('--theory-log',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.instance.read_text());bp=ROOT/d['base_metadata_c16_path'];assert sha(bp)==d['base_metadata_sha256'];base=json.loads(bp.read_text());assert base['input_sha256']==d['base_XNF_sha256'] and not base['equation_uv_hex'];X,Z,A=physical();ax,az=d['anchor'];assert [ax,az]==base['anchor']
    with tempfile.TemporaryDirectory(prefix='c16-full-span-source-') as temp:
        op=Path(temp)/'base.json';run=subprocess.run([sys.executable,str(ROOT/'verify_full_anchor_model.py'),'--metadata',str(bp),'--output',str(op)],capture_output=True,text=True,timeout=180);assert run.returncode==0,run.stderr;source_replay=json.loads(op.read_text());assert source_replay['status']=='PASS'
    oldraw=gzip.decompress((bp.parent/base['input_file']).read_bytes());assert hashlib.sha256(oldraw).hexdigest()==d['base_XNF_sha256'];lines=oldraw.decode().splitlines();header=lines.pop(0).split();oldn=int(header[2]);E=[(i,j) for i in range(720) for j in range(720) if i!=ax and j!=az and not A[i]>>az&1 and not A[ax]>>j&1 and A[i]>>j&1];m=len(E);left=sorted({i for i,j in E});right=sorted({j for i,j in E});end=m+len(left)+len(right);special={m+k+1:i+1 for k,i in enumerate(left)};special.update({m+len(left)+k+1:721+j for k,j in enumerate(right)})
    def mapped(v):return 1440+v if v<=m else (special[v] if v<=end else 1440+m+v-end)
    rows=[]
    for line in lines:
        vals=list(map(int,line.split()));assert vals[-1]==0;rows.append([mapped(abs(v))*(1 if v>0 else -1) for v in vals[:-1]])
    for side,present,fixed in [(0,set(left),ax),(1,set(right),az)]:
        for i in range(720):
            if i in present:continue
            if i!=fixed:
                assert (A[i]>>az&1 or not any(A[i]>>j&1 for j in right)) if side==0 else (A[ax]>>i&1 or not any(A[j]>>i&1 for j in left))
            rows.append([(1 if i==fixed else -1)*(i+1+720*side)])
    closure=ClosureConsumer(X,Z,A);seedrows=set();seed_checks=0
    for source in d['source_cut_dependencies']:
        p=ROOT/source['c16_path'];assert sha(p)==source['sha256'];cuts=json.loads(p.read_text())['cuts']
        for cut in cuts:
            if cut['kind']=='forced_propagation':
                req=[[],[]];req[cut['sector']]=cut['indices'];assert not closure.replay(*req)['possible']
            elif cut['kind']=='z_zero':
                U,V=(X,Z) if cut['sector']==0 else (Z,X);rank_cut(U,V,cut['indices'],int(cut['annihilator'],16))
            else:assert cut['kind']=='joint_forced_propagation' and not closure.replay(cut['required_X'],cut['required_Z'])['possible']
            seed_checks+=1
            for h in range(16):
                if cut['kind']=='joint_forced_propagation':
                    shifted=[[16*(i//16)+(i%16+h)%16 for i in cut[key]] for key in ['required_X','required_Z']];patterns=[shifted,shifted[::-1]]
                else:
                    ids=[16*(i//16)+(i%16+h)%16 for i in cut['indices']];patterns=[[ids,[]],[[],ids]]
                for pattern in patterns:seedrows.add(tuple(sorted(-(1+i+720*side) for side,ids in enumerate(pattern) for i in ids)))
    rows += [list(c) for c in sorted(seedrows)];n=1440+m+oldn-end;raw=(f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();saved=gzip.decompress((a.instance.parent/d['input_file']).read_bytes());assert raw==saved and hashlib.sha256(raw).hexdigest()==d['input_sha256'] and n==d['variables'] and len(rows)==d['clauses'];theory=0;positive=0
    if a.theory_log:
        columns=[sum(((A[i]>>j)&1)<<i for i in range(len(X))) for j in range(len(Z))]
        for line in a.theory_log.read_text().splitlines():
            row=json.loads(line);check_row(X,Z,A,row,columns);theory+=1;positive+=row['kind'] in ['conditional_span','conditional_private_partner']
    out={'status':'PASS','source_C16_answered':False,'anchor':d['anchor'],'full_source_model':True,'source_full_frame_size':128,'projection_model':False,'physical_pairings_rebuilt':518400,'physical_base_replay':source_replay,'owner_mapping_checked':True,'old_variables':oldn,'variables':n,'clauses':len(rows),'free_edges':len(E),'source_seed_certificates_checked':seed_checks,'source_seed_clauses':len(seedrows),'theory_certificates_checked':theory,'conditional_span_certificates_checked':positive,'input_sha256':d['input_sha256'],'theory_file_sha256':sha(a.theory_log) if a.theory_log else None,'elapsed_seconds':time.monotonic()-start,'scope':'Source model and every supplied theory clause are checked; no satisfiability conclusion is inferred. Conditional positive clauses are valid for full bases and are not hereditary projection constraints.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='physical_base_replay'},flush=True)
if __name__=='__main__':main()
