#!/usr/bin/env python3
"""Physical consumer for the rank-cover pilot; imports no discovery encoders.

SAT is checked by a complete assignment, not by trusting solver status.  Rank
clauses are decoded back to physical indices and a replayed rank obstruction.
"""
from pathlib import Path
from itertools import combinations
import argparse,gzip,hashlib,json,time
from verify_anchored_cover_chain import physical,canonical,independent_signature_amo
from verify_signature_cover import independent_cnf
from verify_algebraic_model import physical as vectors
from small_conditional_rank_cuts import verify
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def assignment_ok(model,n,rows):
    chosen=set(model)
    return (len(model)==n and {abs(v) for v in model}==set(range(1,n+1))
            and all(any(v in chosen for v in row) for row in rows))

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--folder',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--refined',action='store_true');a=ap.parse_args();start=time.monotonic()
    A,C,pos,sig=physical();X,Z,AA=vectors();assert A==AA
    cp=ROOT/'algebraic-results/small-conditional-original.json.gz';cuts=json.loads(gzip.decompress(cp.read_bytes()))['cuts'];assert len(cuts)==4102
    forbidden=set()
    for cut in cuts:
        verify(X,Z,A,cut)
        original=[cut['anchor_X_index'],*cut['other_X_indices']]
        for phase in range(16):
            perm={i:16*(i//16)+(i%16+phase)%16 for i in original}
            forbidden.add(tuple(sorted(perm.values())))
    assert len(forbidden)==64096
    bad=dict(cuts[0]);bad['original_annihilator_hex']='0'
    try:verify(X,Z,A,bad)
    except AssertionError:pass
    else:raise AssertionError('zero rank witness accepted')
    def violation(pairs):
        for side in (0,1):
            selected=sorted(p[side] for p in pairs)
            for size in range(2,min(len(selected),max(map(len,forbidden)))+1):
                if any(t in forbidden for t in combinations(selected,size)):return True
        return False
    def physical_pairs(pairs,trial=None):
        value=0
        for k,(i,j) in enumerate(pairs):
            assert sig.get((i,j),0)
            if trial is not None:assert canonical(i,j) in trial
            value^=sig[i,j]
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
        assert value==65535
    chainpath=ROOT/'algebraic-results/exchange/chain.json';chain=json.loads(chainpath.read_text());R=set(map(tuple,chain['removed_case_tuples']));assert len(R)==100 and len(C)-len(R)==418
    audit=json.loads((a.folder/'witness-audit.json').read_text());assert audit['chain_sha256']==sha(chainpath) and audit['rank_certificate_sha256']==sha(cp)
    old={}
    for pairs in chain['seed_witnesses']+[r['counterexample_edges'] for r in chain['records'] if r['answer'] is True]:
        physical_pairs(pairs);key=tuple(sorted({pos[canonical(i,j)] for i,j in pairs}));old.setdefault(key,pairs)
    assert len(old)==2552 and len(audit['records'])==len(old)
    candidates=set();rejected=0
    for r,(support,pairs) in zip(audit['records'],sorted(old.items())):
        assert r['support_class_indices']==list(support) and r['pairs']==pairs
        invalid=violation(pairs);assert invalid==(r['rank_violation'] is not None)
        if invalid:
            rejected+=1;extra={C[k] for k in support}-R
            if len(extra)==1:candidates|=extra
    assert rejected==40 and len(candidates)==28
    def domain(c):
        x,z=16*c[0],16*c[1]+c[2];trial=R|{c}
        free=[(i,j,s,0) for (i,j),s in sig.items() if s and canonical(i,j) in trial and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1]
        return x,z,trial,free
    extra_sha=None
    if a.refined:
        from verify_mixed_rank_cover_cuts import check
        ep=a.folder/'mixed-rank-cuts.json';extra=json.loads(ep.read_text());extra_sha=sha(ep)
        for cut in extra['cuts']:
            U,V=(X,Z) if cut['sector']==0 else (Z,X);check(U,V,cut['indices'],int(cut['annihilator'],16))
            for phase in range(16):forbidden.add(tuple(sorted(16*(i//16)+(i%16+phase)%16 for i in cut['indices'])))
    ordered=sorted(candidates,key=lambda c:(len(domain(c)[3]),c));checked=[];allcases=[];controls=False
    groups=[(a.folder/'refined',ordered)] if a.refined else [(a.folder,ordered[:8]),(a.folder/'remaining',ordered[8:])]
    for sub,expected in groups:
        frozen=json.loads((sub/'frozen-targets.json').read_text());summary=json.loads((sub/'comparison.json').read_text())
        assert frozen['parent_chain_sha256']==sha(chainpath) and frozen['audit_sha256']==sha(a.folder/'witness-audit.json') and frozen['rank_certificate_sha256']==sha(cp)
        if a.refined:assert frozen['extra_cuts_sha256']==extra_sha
        assert [tuple(r['case']) for r in frozen['cases']]==expected and len(summary['records'])==len(expected)
        for index,c in enumerate(expected):
            x,z,trial,free=domain(c);target=65535^sig[x,z];base,n,_,_=independent_cnf(A,[0],free,True,target=target);n,_=independent_signature_amo(base,n,free)
            base_set={tuple(sorted(row)) for row in base};m=len(free);left=sorted({e[0] for e in free});right=sorted({e[1] for e in free});decode={m+k+1:(0,i) for k,i in enumerate(left)};decode.update({m+len(left)+k+1:(1,j) for k,j in enumerate(right)})
            entry=summary['records'][index];assert tuple(entry['case'])==c and entry['free_edges']==len(free)
            for call in entry['calls']:
                meta=json.loads((sub/call['metadata_file']).read_text());isrank=call['mode']=='rank'
                assert tuple(meta['case'])==c and meta['anchor']==[x,z] and meta['trial_removed']==[list(t) for t in sorted(trial)]
                assert meta['free_edges']==len(free)==frozen['cases'][index]['free_edges']
                assert meta['rank_cut_certificate_sha256']==sha(cp) and meta['rank_strengthened']==isrank and meta['free_target_signature']==target
                raw=gzip.decompress((sub/meta['cnf_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['cnf_sha256']
                lines=raw.decode().splitlines();assert lines[0]==f"p cnf {n} {meta['clauses']}"
                rows=[]
                for line in lines[1:]:
                    nums=list(map(int,line.split()));assert nums[-1]==0 and all(0<abs(v)<=n for v in nums[:-1]);rows.append(nums[:-1])
                assert rows[:len(base)]==base and meta['variables']==n and meta['base_clauses']==len(base) and len(rows)==meta['clauses']
                tail=rows[len(base):];assert len(tail)==meta['appended_clauses']
                if not isrank:assert not tail
                seen=set()
                for clause in tail:
                    assert clause and all(v<0 and -v in decode for v in clause)
                    decoded=[decode[-v] for v in clause];side=decoded[0][0];assert all(s==side for s,i in decoded)
                    selected={i for s,i in decoded}
                    assert tuple(sorted(selected)) in forbidden or tuple(sorted(selected|{(x,z)[side]})) in forbidden
                    key=tuple(sorted(clause));assert key not in base_set and key not in seen;seen.add(key)
                if isrank:
                    owners=[{},{}]
                    for variable,(side,i) in decode.items():owners[side][i]=variable
                    expected_tail=set()
                    for pattern in forbidden:
                        for side,owner in enumerate(owners):
                            rest=[i for i in pattern if i!=(x,z)[side]]
                            if all(i in owner for i in rest):expected_tail.add(tuple(sorted(-owner[i] for i in rest)))
                    assert seen==expected_tail-base_set
                assert meta['answer']==call['answer']
                if meta['answer'] is True:
                    model=meta['model'];assert assignment_ok(model,n,rows);chosen=set(model)
                    pairs=[[x,z]]+[[i,j] for k,(i,j,s,cl) in enumerate(free,1) if k in chosen];assert pairs==meta['partial_pairs'];physical_pairs(pairs,trial)
                    if isrank:assert not violation(pairs)
                    if not controls:
                        assert not assignment_ok(model[:-1],n,rows);controls=True
                elif meta['answer'] is None:assert meta['status']=='UNKNOWN_WALL_LIMIT'
                else:raise AssertionError('UNSAT requires a separate DRAT consumer before acceptance')
                checked.append({'case':c,'rank':isrank,'answer':meta['answer'],'input_sha256':meta['cnf_sha256'],'appended_rank_clauses':len(tail),'elapsed_seconds':meta['elapsed_seconds']})
            allcases.append(c)
    assert allcases==ordered and len(checked)==56 and controls
    out={'status':'PASS','source_C16_answered':False,'cover_before':418,'cover_after':418,'physical_pairings_rebuilt':518400,'rank_witnesses_replayed':len(cuts),'translated_X_nogoods':len(forbidden),'extra_cuts_sha256':extra_sha,'old_witness_supports_replayed':len(old),'rejected_saved_witnesses':rejected,'candidate_classes':len(ordered),'matched_oracle_calls':len(checked),'SAT_calls':sum(r['answer'] is True for r in checked),'UNKNOWN_calls':sum(r['answer'] is None for r in checked),'UNSAT_calls':0,'zero_rank_witness_rejected':True,'incomplete_assignment_rejected':controls,'rank_certificate_sha256':sha(cp),'parent_chain_sha256':sha(chainpath),'records':checked,'elapsed_seconds':time.monotonic()-start,'scope':'Every SAT assignment and physical partial matching replayed; every appended clause decoded to a replayed physical rank obstruction. UNKNOWN supplies no exclusion. No original full anchor is solved, and SAT partial matchings do not certify full frames.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'},flush=True)
if __name__=='__main__':main()
