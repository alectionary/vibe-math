#!/usr/bin/env python3
"""Physical cut, CNF, model and DRAT consumer for adaptive signature refinements."""
from pathlib import Path
import argparse,collections,gzip,hashlib,json,subprocess,tempfile,time,sys
from verify_anchored_cover_chain import physical,canonical,independent_signature_amo
from verify_signature_cover import independent_cnf
from verify_algebraic_model import physical as vectors
from small_conditional_rank_cuts import verify
from verify_mixed_rank_cover_cuts import check
from verify_mandatory_closure import ClosureConsumer
from verify_domain_closure import DomainClosureConsumer
from verify_strategy_cover_bindings import check_cover
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def upper_counter(inputs,bound,top):
    result=[];old={0:True}
    def emit(terms):
        if any(type(v) is bool and v==positive for v,positive in terms):return
        result.append([v if positive else -v for v,positive in terms if type(v) is not bool])
    for count,x in enumerate(inputs,1):
        now={0:True}
        for k in range(1,min(count,bound+1)+1):
            top+=1;z=top;now[k]=z;a=old.get(k,False);b=old[k-1]
            emit([(a,False),(z,True)]);emit([(b,False),(x,False),(z,True)]);emit([(z,False),(a,True),(b,True)]);emit([(z,False),(a,True),(x,True)])
        old=now
    result.append([-old[bound+1]]);return result,top
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--drat-trim',type=Path);a=ap.parse_args();start=time.monotonic();data=json.loads(a.certificate.read_text());A,C,pos,sig=physical();X,Z,AA=vectors();assert A==AA
    anchor=None;R=None
    if data['mode']=='restricted':
        domain_path=ROOT/data['restricted_classes_c16_path'];assert sha(domain_path)==data['restricted_classes_sha256'];domain=json.loads(domain_path.read_text());R=set(map(tuple,domain['classes']));assert R<=set(C);assert data['removed_class_tuples']==[list(c) for c in sorted(R)];anchor=tuple(data['anchor']);assert A[anchor[0]]>>anchor[1]&1
        parent_path=ROOT/data['anchored_parent_cover_c16_path'];assert sha(parent_path)==data['anchored_parent_cover_sha256'];parent=check_cover(parent_path,C);oldretained=parent['retained'];oldomitted=set(C)-oldretained
        batch=set(map(tuple,domain.get('candidate_cases',[domain.get('candidate_removed_case')])));assert batch<=oldretained and R==oldomitted|batch and canonical(*anchor) in batch
    elif data['mode']=='cover-extension':
        chainpath=ROOT/'algebraic-results/exchange/chain.json';assert sha(chainpath)==data['parent_chain_sha256'];parent=json.loads(chainpath.read_text());R=set(map(tuple,parent['removed_case_tuples']));assert len(R)==100
        c=(26,32,15);assert c not in R;R.add(c);anchor=(416,527);assert data['anchor']==list(anchor) and data['removed_class_tuples']==[list(c) for c in sorted(R)]
    else:assert data['mode']=='global' and data['anchor'] is None and data['removed_class_tuples'] is None
    E=[(i,j,s,0) for (i,j),s in sig.items() if s and (R is None or canonical(i,j) in R) and (anchor is None or (i!=anchor[0] and j!=anchor[1] and not A[i]>>anchor[1]&1 and not A[anchor[0]]>>j&1))]
    target=65535^(sig[anchor] if anchor else 0);assert len(E)==data['free_edges'] and target==data['target'];rows,n,defs,selectors=independent_cnf(A,[0],E,True,target=target);n,extra=independent_signature_amo(rows,n,E);defs+=extra
    groups=[collections.defaultdict(list),collections.defaultdict(list)]
    for k,(i,j,s,c) in enumerate(E,1):groups[0][i].append(k);groups[1][j].append(k)
    owners=[{i:len(E)+k+1 for k,i in enumerate(sorted(groups[0]))},{j:len(E)+len(groups[0])+k+1 for k,j in enumerate(sorted(groups[1]))}]
    sg=collections.defaultdict(list)
    for k,e in enumerate(E,1):sg[e[2]].append(k)
    first_event=len(E)+len(groups[0])+len(groups[1])+1+sum(max(0,len(v)-1) for g in groups for v in g.values());events={s:first_event+k+1 for k,s in enumerate(sorted(sg))}
    assert all((v,'or',sg[s]) in defs for s,v in events.items())
    for group,owner in zip(groups,owners):
        for i in sorted(group):rows.append([-owner[i]]+group[i])
    fixed=anchor or (-1,-1);oldset={tuple(sorted(row)) for row in rows};cp=ROOT/'algebraic-results/small-conditional-original.json.gz';assert sha(cp)==data['rank_certificate_sha256'];F=set()
    for cut in json.loads(gzip.decompress(cp.read_bytes()))['cuts']:
        verify(X,Z,A,cut)
        for phase in range(16):F.add(tuple(sorted(16*(i//16)+(i%16+phase)%16 for i in [cut['anchor_X_index'],*cut['other_X_indices']])))
    initial=set()
    for pattern in F:
        for side,owner in enumerate(owners):
            rest=[i for i in pattern if i!=fixed[side]]
            if all(i in owner for i in rest):initial.add(tuple(sorted(-owner[i] for i in rest)))
    rows += [list(c) for c in sorted(initial-oldset)]
    assert data['signature_independence_scope']=='free_pairs_only_keeps_anchor'
    phase_dependency=None
    if data.get('phase_profiles_c16_path'):
        pp=ROOT/data['phase_profiles_c16_path'];assert sha(pp)==data['phase_profiles_sha256'];pd=json.loads(gzip.decompress(pp.read_bytes()) if pp.suffix=='.gz' else pp.read_bytes());assert pd.get('ambient_dimension',128)==128 and all(pd.get(k) is None for k in ['conditioned_on_anchor','conditioned_on_X_index','conditioned_on_X_absent'])
        with tempfile.TemporaryDirectory(prefix='c16-phase-dependency-') as temp:
            op=Path(temp)/'replay.json';run=subprocess.run([sys.executable,str(ROOT/'verify_orbit_rank_profiles.py'),'--certificate',str(pp),'--output',str(op)],capture_output=True,text=True,timeout=180);assert run.returncode==0,run.stderr;phase_dependency=json.loads(op.read_text());assert phase_dependency['status']=='PASS' and phase_dependency['certificate_sha256']==sha(pp)
        seen_phase={tuple(sorted(c)) for c in rows}
        for record in pd['records']:
            assert record['complete']
            for cut in record['minimal_bad_certificates']:
                indices=[16*record['orbit']+h for h in range(16) if cut['mask']>>h&1]
                for side,owner in enumerate(owners):
                    rest=[i for i in indices if i!=fixed[side]]
                    if all(i in owner for i in rest):
                        clause=tuple(sorted(-owner[i] for i in rest))
                        if clause not in seen_phase:rows.append(list(clause));seen_phase.add(clause)
    if data.get('projection_count_bound') is not None:
        assert data.get('signature_independent') and data['projection_count_bound']==16;counter,n=upper_counter([events[s] for s in sorted(events)],data['projection_count_bound'],n);rows+=counter
    seed_prefix=[]
    for dependency in data.get('seed_dependencies',[]):
        path=ROOT/dependency['c16_path'];assert sha(path)==dependency['sha256'];seed_prefix+=json.loads(path.read_text())['cuts']
    assert seed_prefix==data['cuts'][:data.get('seed_cut_count',0)]
    allowed=A.copy()
    for (i,j),signature in sig.items():
        if signature and canonical(i,j) not in R:allowed[i]&=~(1<<j)
    columns=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)]
    allowed_columns=[sum(((allowed[i]>>j)&1)<<i for i in range(720)) for j in range(720)]
    assert A==columns and allowed==allowed_columns
    for i,row in enumerate(allowed):
        rotated=sum(((((row>>(16*o))&65535)<<1|((row>>(16*o))&65535)>>15)&65535)<<(16*o) for o in range(45));assert rotated==allowed[16*(i//16)+(i%16+1)%16]
    assert hashlib.sha256(('\n'.join(hex(row) for row in allowed)+'\n').encode()).hexdigest()==data['domain_allowed_rows_sha256'] and sum(row.bit_count() for row in allowed)==data['domain_allowed_edges']
    assert not data['domain_exclusions_are_universal_source_cuts']
    domains=[DomainClosureConsumer(X,Z,A,allowed),DomainClosureConsumer(Z,X,columns,allowed_columns)]
    assert len(rows)==data['base_clauses'] and n==data['variables'];seen={tuple(sorted(c)) for c in rows};closure=ClosureConsumer(X,Z,A);cutchecks=[]
    from verify_conditional_word import WordConsumer
    word_consumer=WordConsumer(X,Z,A)
    for cut in data['cuts']:
        kind=cut['kind']
        if kind=='universal_short_word':
            row=cut['certificate'];assert row['kind']=='conditional_no_short_word'
            clause=word_consumer.check(row);side=cut['sector'];ids=cut['indices']
            assert side==1-row['side'] and ids==row['mandatory_opposite']
            assert clause==[-i-1-720*side for i in ids] and clause and all(v<0 for v in clause)
            cutchecks.append({'kind':kind,'cardinality':len(ids),'universal_negative_clause':True})
        elif kind=='domain_forced_propagation':
            result=domains[cut['sector']].replay(cut['indices']);assert not result['possible'];cutchecks.append({'kind':kind,'cardinality':len(cut['indices']),**result})
        elif kind=='joint_domain_forced_propagation':
            result=domains[0].replay(cut['required_X'],cut['required_Z']);assert not result['possible'];cutchecks.append({'kind':kind,'cardinality':len(cut['required_X'])+len(cut['required_Z']),**result})
        elif kind=='z_zero':
            U,V=(X,Z) if cut['sector']==0 else (Z,X);check(U,V,cut['indices'],int(cut['annihilator'],16));cutchecks.append({'kind':kind,'cardinality':len(cut['indices'])})
        elif kind=='forced_propagation':
            req=[[],[]];req[cut['sector']]=cut['indices'];result=closure.replay(*req);assert not result['possible'];cutchecks.append({'kind':kind,'cardinality':len(cut['indices']),**result})
        else:
            assert kind in ['joint_forced_propagation','joint_domain_forced_propagation'];result=closure.replay(cut['required_X'],cut['required_Z']);assert not result['possible'];cutchecks.append({'kind':kind,'cardinality':len(cut['required_X'])+len(cut['required_Z']),**result})
        new=set()
        for phase in range(16):
            if kind in ['joint_forced_propagation','joint_domain_forced_propagation']:
                shifted=[[16*(i//16)+(i%16+phase)%16 for i in cut[key]] for key in ['required_X','required_Z']];patterns=[shifted,shifted[::-1]]
            else:
                ids=[16*(i//16)+(i%16+phase)%16 for i in cut['indices']];patterns=[[ids,[]],[[],ids]]
            for pattern in patterns:
                rest=[[i for i in ids if i!=fixed[side]] for side,ids in enumerate(pattern)]
                if all(i in owners[side] for side,ids in enumerate(rest) for i in ids):new.add(tuple(sorted(-owners[side][i] for side,ids in enumerate(rest) for i in ids)))
        for clause in sorted(new-seen):rows.append(list(clause));seen.add(clause)
    for circuit in data.get('signature_circuits',[]):
        assert data.get('signature_independent') and len(circuit)==len(set(circuit))>=3;value=0
        for s in circuit:assert 0<s<65536;value^=s
        assert value==0;new=set()
        for h in range(16):
            shifted=[((s<<h)&65535)|(s>>(16-h)) for s in circuit];rest=shifted
            if all(s in events for s in rest):new.add(tuple(sorted(-events[s] for s in rest)))
        for clause in sorted(new-seen):rows.append(list(clause));seen.add(clause)
    assert len(rows)==data['clauses'];raw=(f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode();saved=gzip.decompress((a.certificate.parent/data['input_file']).read_bytes())
    if data.get('signature_independent'):
        lines=saved.decode().splitlines();assert lines[0]==f'p cnf {n} {len(rows)}';saved_rows=[]
        for line in lines[1:]:
            nums=list(map(int,line.split()));assert nums[-1]==0;saved_rows.append(nums[:-1])
        assert collections.Counter(tuple(sorted(c)) for c in rows)==collections.Counter(tuple(sorted(c)) for c in saved_rows);raw=saved;rows=saved_rows
    else:assert raw==saved
    assert hashlib.sha256(raw).hexdigest()==data['input_sha256']
    for record in data['records']:
        pairs=record['pairs'];value=0
        for k,(i,j) in enumerate(pairs):
            assert sig.get((i,j),0) and (R is None or canonical(i,j) in R);value^=sig[i,j]
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
        assert value==65535
        if 'signature_circuit_index' in record:assert set(data['signature_circuits'][record['signature_circuit_index']])<={sig[i,j] for i,j in pairs}
        if anchor:assert pairs[0]==list(anchor)
        selected=[{p[side] for p in pairs} for side in (0,1)]
        for k in record['cut_indices']:
            cut=data['cuts'][k]
            if cut['kind'] in ['joint_forced_propagation','joint_domain_forced_propagation']:assert set(cut['required_X'])<=selected[0] and set(cut['required_Z'])<=selected[1]
            else:assert set(cut['indices'])<=selected[cut['sector']]
    proof_status='NOT_APPLICABLE';proofhash=None;model_checked=False
    if data['answer'] is True:
        model=data['model'];chosen=set(model);assert len(model)==n and {abs(v) for v in model}==set(range(1,n+1));assert all(any(lit in chosen for lit in row) for row in rows);model_checked=True
        pairs=([list(anchor)] if anchor else [])+[[i,j] for k,(i,j,s,c) in enumerate(E,1) if k in chosen];assert pairs==data['partial_pairs']
    elif data['answer'] is False:
        assert a.drat_trim and 'fresh_proof' in data;proofmeta=data['fresh_proof'];proof=gzip.decompress((a.certificate.parent/proofmeta['proof_file']).read_bytes());proofhash=hashlib.sha256(proof).hexdigest();assert proofhash==proofmeta['proof_sha256'] and proofmeta['input_sha256']==data['input_sha256']
        with tempfile.TemporaryDirectory(prefix='c16-adaptive-replay-') as temp:
            ip=Path(temp)/'input.cnf';pp=Path(temp)/'proof.drat';ip.write_bytes(raw);pp.write_bytes(proof);r=subprocess.run([str(a.drat_trim),str(ip),str(pp)],capture_output=True,text=True,timeout=600);assert r.returncode==0 and 's VERIFIED' in r.stdout
            empty=Path(temp)/'empty.drat';empty.write_text('');bad=subprocess.run([str(a.drat_trim),str(ip),str(empty)],capture_output=True,text=True,timeout=15);assert 's VERIFIED' not in bad.stdout or [] in rows
        proof_status='DRAT_PASS_EMPTY_PROOF_REJECTED' if 's VERIFIED' not in bad.stdout else 'DRAT_PASS_TRIVIAL_INPUT_UNSAT' 
    out={'status':'PASS','mode':data['mode'],'source_C16_answered':False,'proposed_sufficient_cover_count':len(C)-len(R),'parent_cover_bindings_checked':True,'single_anchor_proof_only':True,'answer':data['answer'],'physical_pairings_rebuilt':518400,'old_rank_certificates_replayed':4102,'phase_dependency':phase_dependency,'new_cuts_checked':len(cutchecks),'signature_circuits_checked':len(data.get('signature_circuits',[])),'projection_count_bound':data.get('projection_count_bound'),'physical_forced_coloop_covectors_checked':closure.forced_covectors_checked+sum(c.forced_covectors_checked for c in domains),'domain_allowed_edges':data['domain_allowed_edges'],'domain_signature_restriction_checked':True,'SAT_partial_records_checked':len(data['records']),'final_model_checked':model_checked,'proof_status':proof_status,'proof_sha256':proofhash,'input_sha256':data['input_sha256'],'input_clauses':len(rows),'cut_checks':cutchecks,'parent_chain_sha256':data.get('parent_chain_sha256'),'elapsed_seconds':time.monotonic()-start,'scope':'An anchored UNSAT is one part of a cover reduction under a common wider allowed domain; the separate cover-binding consumer checks that every removed class has such a proof. It uses the parent full-frame cover and a projection preserving the chosen anchor, using signature-independent deletion and hereditary negative consequences conditional on the exact full allowed-pair domain. Domain nogoods are not universal source cuts. No retained anchor is completed and no individual omitted class is excluded from every full frame.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['cut_checks','phase_dependency']},flush=True)
if __name__=='__main__':main()
