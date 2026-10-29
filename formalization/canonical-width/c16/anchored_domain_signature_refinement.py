#!/usr/bin/env python3
"""Bounded compact-signature refinement by physical full-basis rank witnesses.

Restricted-domain UNSAT gives a sufficient case cover only after physical cut/CNF/DRAT replay.
SAT is a partial necessity witness unless it has128 physical canonical pairs.
"""
from pathlib import Path
from itertools import combinations
import argparse,collections,gzip,hashlib,json,subprocess,sys,time
from signature_cover import logical_data,encode,canonical
from anchored_cover_chain import parity_chains
from exchange_anchored_cover import signature_amo
from rank_cover_cuts import family,clauses,CUTS
from rank_oracle import basis,zero_exclusion
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def setup(mode,signature_independent=False,phase_profiles=None,projection_count=False,restricted_classes=None,fixed_anchor=None):
    A,C,E=logical_data();anchor=None;removed=None
    if mode=='restricted':
        assert restricted_classes;removed=set(map(tuple,json.loads(restricted_classes.read_text())['classes']));assert removed<=set(C)
    if mode=='cover-extension':
        d=json.loads((ROOT/'algebraic-results/exchange/chain.json').read_text());removed=set(map(tuple,d['removed_case_tuples']))|{(26,32,15)};anchor=(416,527)
        E=[(i,j,s,0) for i,j,s,k in E if C[k] in removed and i!=anchor[0] and j!=anchor[1] and not A[i]>>anchor[1]&1 and not A[anchor[0]]>>j&1]
        assert len(E)==1292
    else:E=[(i,j,s,0) for i,j,s,k in E if removed is None or C[k] in removed]
    if fixed_anchor is not None:
        anchor=tuple(fixed_anchor);assert any((i,j)==anchor for i,j,s,k in E)
        E=[e for e in E if e[0]!=anchor[0] and e[1]!=anchor[1] and not A[e[0]]>>anchor[1]&1 and not A[anchor[0]]>>e[1]&1]
    target=65535
    if anchor:
        x,z=anchor;X,Z=[[int(v,16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']];sx=sum(((X[x]&Z[608+h]).bit_count()%2)<<h for h in range(16));sz=sum(((X[608+h]&Z[z]).bit_count()%2)<<h for h in range(16));target^=sx&sz
    cnf,n,_,events=encode(A,[0],E,with_xor=False,compress_signatures=True);n=parity_chains(cnf,n,events,target);n=signature_amo(cnf,n,E)
    # Exact owner definitions remove gratuitously true flags during rank tests.
    left=collections.defaultdict(list);right=collections.defaultdict(list)
    for k,(i,j,s,c) in enumerate(E,1):left[i].append(k);right[j].append(k)
    owners=[{i:len(E)+k+1 for k,i in enumerate(sorted(left))},{j:len(E)+len(left)+k+1 for k,j in enumerate(sorted(right))}]
    for group,owner in [(left,owners[0]),(right,owners[1])]:
        for i in sorted(group):cnf.append([-owner[i]]+group[i])
    F=family();base_set={tuple(sorted(c)) for c in cnf}
    fixed=anchor if anchor else (-1,-1)
    cnf += [list(row) for row in clauses(E,fixed,F) if row not in base_set]
    if signature_independent and anchor:
        anchor_sig=65535^target
        for variable,s in events:
            if s==anchor_sig:cnf.append([-variable])
    if phase_profiles:
        raw=phase_profiles.read_bytes();profiles=json.loads(gzip.decompress(raw) if phase_profiles.suffix=='.gz' else raw);assert profiles.get('ambient_dimension',128)==128 and profiles.get('conditioned_on_anchor') is None and profiles.get('conditioned_on_X_index') is None;seen={tuple(sorted(c)) for c in cnf}
        for record in profiles['records']:
            assert record['complete']
            for cut in record['minimal_bad_certificates']:
                ids=[16*record['orbit']+h for h in range(16) if cut['mask']>>h&1]
                for side,owner in enumerate(owners):
                    rest=[i for i in ids if i!=fixed[side]]
                    if all(i in owner for i in rest):
                        clause=tuple(sorted(-owner[i] for i in rest))
                        if clause not in seen:cnf.append(list(clause));seen.add(clause)
    if projection_count:
        assert signature_independent
        from full_anchor_model import at_least_network
        counter,n=at_least_network([v for v,s in events],16 if anchor else 17,n);counter[-1]=[-counter[-1][0]];cnf+=counter
    return A,C,E,anchor,removed,target,cnf,n,owners,events

def signature_circuit(pairs,sig):
    piv={}
    for k,pair in enumerate(pairs):
        value=sig[tuple(pair)];tag=1<<k
        while value:
            p=value.bit_length()-1
            if p not in piv:piv[p]=(value,tag);break
            v,t=piv[p];value^=v;tag^=t
        if not value:return sorted(sig[tuple(pair)] for j,pair in enumerate(pairs) if tag>>j&1)
    return None

def expand_circuit(circuit,events,anchor_sig):
    owner={s:v for v,s in events};out=set()
    assert len(circuit)==len(set(circuit)) and __import__('functools').reduce(int.__xor__,circuit,0)==0
    for h in range(16):
        shifted=[((s<<h)&65535)|(s>>(16-h)) for s in circuit];rest=[s for s in shifted if s!=anchor_sig]
        if all(s in owner for s in rest):out.add(tuple(sorted(-owner[s] for s in rest)))
    return out

def expand(cut,owners,anchor):
    out=set();fixed=anchor if anchor else (-1,-1)
    if cut['kind'] in ['joint_forced_propagation','joint_domain_forced_propagation']:
        for h in range(16):
            shifted=[[16*(i//16)+(i%16+h)%16 for i in cut[key]] for key in ['required_X','required_Z']]
            for sides in [shifted,shifted[::-1]]:
                if any(i!=fixed[side] and i not in owners[side] for side,ids in enumerate(sides) for i in ids):continue
                out.add(tuple(sorted(-owners[side][i] for side,ids in enumerate(sides) for i in ids if i!=fixed[side])))
        return out
    for h in range(16):
        ids=[16*(i//16)+(i%16+h)%16 for i in cut['indices']]
        for side,owner in enumerate(owners):
            if any(i!=fixed[side] and i not in owner for i in ids):continue
            out.add(tuple(sorted(-owner[i] for i in ids if i!=fixed[side])))
    return out

def make_cuts(X,Z,pairs):
    found=[];diagnostics=[]
    for side in (0,1):
        U,V=(X,Z) if side==0 else (Z,X);ids=[p[side] for p in pairs];assert len(basis(U[i] for i in ids))==len(ids)
        degrees=[sum(((U[i]&v).bit_count()%2)<<k for k,i in enumerate(ids)) for v in V];zero=basis(v for v,mask in zip(V,degrees) if not mask);need=128-len(ids);diagnostics.append({'sector':side,'zero_rank':len(zero),'required':need})
        if len(zero)>=need:continue
        core=ids.copy();az=[sum(((u&v).bit_count()%2)<<i for i,u in enumerate(U)) for v in V]
        for i in reversed(ids):
            trial=[j for j in core if j!=i];bits=sum(1<<j for j in trial);span=basis(v for v,mask in zip(V,az) if not mask&bits)
            if len(span)<128-len(trial):core=trial
        bits=sum(1<<j for j in core);span=basis(v for v,mask in zip(V,az) if not mask&bits);found.append({'sector':side,**zero_exclusion(U,V,az,core,bits,span)})
    return found,diagnostics

def dump_input(path,n,cnf):
    raw=(f'p cnf {n} {len(cnf)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in cnf)).encode();path.write_bytes(gzip.compress(raw,mtime=0));return hashlib.sha256(raw).hexdigest()

def run(a):
    from pysat.solvers import Solver
    start=time.monotonic();A,C,E,anchor,R,target,cnf,n,owners,events=setup(a.mode,a.signature_independent,a.phase_profiles,a.projection_count,a.restricted_classes,a.anchor);X,Z,AA=physical();assert A==AA
    result={'status':'RUNNING','source_C16_answered':False,'mode':a.mode,'anchor':anchor,'removed_class_tuples':sorted(R) if R else None,'free_edges':len(E),'variables':n,'base_clauses':len(cnf),'target':target,'rank_certificate_sha256':hashlib.sha256(CUTS.read_bytes()).hexdigest(),'cuts':[],'records':[],'answer':None,'round_limit':a.rounds,'outer_wall_seconds':a.seconds}
    result['anchored_parent_cover_c16_path']=str(a.parent_cover.resolve().relative_to(ROOT));result['anchored_parent_cover_sha256']=hashlib.sha256(a.parent_cover.read_bytes()).hexdigest();result['parent_chain_sha256']=None;result['restricted_classes_c16_path']=str(a.restricted_classes.resolve().relative_to(ROOT));result['restricted_classes_sha256']=hashlib.sha256(a.restricted_classes.read_bytes()).hexdigest();result['seed_dependencies']=[]
    result['signature_independent']=a.signature_independent;result['signature_circuits']=[];sig={e[:2]:e[2] for e in E}
    result['projection_count_bound']=(15 if anchor else 16) if a.projection_count else None;result['phase_profiles_c16_path']=str(a.phase_profiles.resolve().relative_to(ROOT)) if a.phase_profiles else None;result['phase_profiles_sha256']=hashlib.sha256(a.phase_profiles.read_bytes()).hexdigest() if a.phase_profiles else None
    if anchor:sig[anchor]=65535^target
    result['separator']=a.separator;native=None
    if a.separator=='closure':
        from native_domain_forced_propagation import NativeDomainForcedPropagation
        from verify_domain_closure import DomainClosureConsumer
        allowed=A.copy()
        for i,j,signature,k in logical_data()[2]:
            if C[k] not in R:allowed[i]&=~(1<<j)
        columns=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)]
        allowed_columns=[sum(((allowed[i]>>j)&1)<<i for i in range(720)) for j in range(720)]
        domain_consumers=[DomainClosureConsumer(X,Z,A,allowed),DomainClosureConsumer(Z,X,columns,allowed_columns)]
        result['domain_allowed_edges']=sum(row.bit_count() for row in allowed)
        result['domain_allowed_rows_sha256']=hashlib.sha256(('\n'.join(hex(row) for row in allowed)+'\n').encode()).hexdigest()
        result['domain_exclusions_are_universal_source_cuts']=False
        assert a.native_library and a.native_library.exists();native=[NativeDomainForcedPropagation(X,Z,allowed,a.native_library),NativeDomainForcedPropagation(Z,X,allowed_columns,a.native_library)]
        ax=[{j for j in range(720) if A[i]>>j&1} for i in range(720)];az=[{i for i in range(720) if A[i]>>j&1} for j in range(720)];result['native_library_sha256']=hashlib.sha256(a.native_library.read_bytes()).hexdigest()
    base_set={tuple(sorted(c)) for c in cnf};added=set()
    for path in a.seed_cuts:
        result['seed_dependencies'].append({'c16_path':str(path.resolve().relative_to(ROOT)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
        for cut in json.loads(path.read_text())['cuts']:
            result['cuts'].append(cut)
            for clause in sorted(expand(cut,owners,anchor)-base_set-added):cnf.append(list(clause));added.add(clause)
    result['seed_cut_count']=len(result['cuts']);solver=Solver(name='cadical195',bootstrap_with=cnf)
    def checkpoint():
        result['elapsed_seconds']=time.monotonic()-start;result['clauses']=len(cnf);result['added_clauses']=len(added);temp=a.output.with_suffix('.checkpoint.tmp');temp.write_text(json.dumps(result,indent=2)+'\n');temp.replace(a.output)
    checkpoint()
    for iteration in range(a.rounds):
        t=time.monotonic();answer=solver.solve();solve_time=time.monotonic()-t
        if not answer:result.update(status='UNSAT_REQUIRES_FRESH_PROOF_AND_INDEPENDENT_REPLAY',answer=False);break
        model=solver.get_model();true=set(model);pairs=([anchor] if anchor else [])+[e[:2] for k,e in enumerate(E,1) if k in true]
        assert all(any(v in true for v in row) for row in cnf)
        for k,(i,j) in enumerate(pairs):
            assert A[i]>>j&1
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
        if a.signature_independent:
            circuit=signature_circuit(pairs,sig)
            if circuit:
                fresh=expand_circuit(circuit,events,(65535^target) if anchor else None)-base_set-added;assert fresh
                for clause in sorted(fresh):cnf.append(list(clause));solver.add_clause(list(clause));added.add(clause)
                index=len(result['signature_circuits']);result['signature_circuits'].append(circuit);result['records'].append({'iteration':iteration,'pairs':pairs,'solve_seconds':solve_time,'rank_checks':[],'cut_indices':[],'signature_circuit_index':index});checkpoint()
                if iteration%10==0:print('SIGNATURE CIRCUIT',a.mode,iteration,'pairs',len(pairs),'circuits',len(result['signature_circuits']),'seconds',round(result['elapsed_seconds'],2),flush=True)
                continue
        if native:
            new=[];diag=[]
            for side in (0,1):
                ids=[p[side] for p in pairs];core=native[side].exclusion(sum(1<<i for i in ids))
                if core is None:continue
                check=domain_consumers[side].replay(core);assert not check['possible']
                new.append({'sector':side,'kind':'domain_forced_propagation','indices':core,'clause':[-i-1 for i in core],'closure_reason':check['reason'],'closure_rounds':check['rounds']})
            if not new:
                required=[[p[side] for p in pairs] for side in (0,1)];check=domain_consumers[0].replay(*required)
                if not check['possible']:
                    for side in (0,1):
                        for i in required[side].copy():
                            trial=[v.copy() for v in required];trial[side].remove(i)
                            if not domain_consumers[0].replay(*trial)['possible']:required=trial
                    check=domain_consumers[0].replay(*required);assert not check['possible'];new=[{'kind':'joint_domain_forced_propagation','required_X':required[0],'required_Z':required[1],'closure_reason':check['reason'],'closure_rounds':check['rounds']}]
            diag=[{'necessary_closure_fixed_point':not bool(new)}]
        else:new,diag=make_cuts(X,Z,pairs)
        record={'iteration':iteration,'pairs':pairs,'solve_seconds':solve_time,'rank_checks':diag,'cut_indices':[]}
        if not new:
            status='FULL_FRAME_CANDIDATE_REQUIRES_PHYSICAL_REPLAY' if len(pairs)==128 else ('CLOSURE_FIXED_POINT_PARTIAL_WITNESS_REQUIRES_REPLAY' if native else 'RANK_COMPATIBLE_PARTIAL_WITNESS_REQUIRES_REPLAY');result['records'].append(record);result.update(status=status,answer=True,model=model,partial_pairs=pairs);break
        before=len(added)
        for cut in new:
            record['cut_indices'].append(len(result['cuts']));result['cuts'].append(cut)
            for clause in sorted(expand(cut,owners,anchor)-base_set-added):
                cnf.append(list(clause));solver.add_clause(list(clause));added.add(clause)
        assert len(added)>before
        result['records'].append(record);checkpoint()
        if iteration%10==0:print('RANK REFINEMENT',a.mode,iteration,'pairs',len(pairs),'cuts',len(result['cuts']),'clauses',len(added),'seconds',round(result['elapsed_seconds'],2),flush=True)
    else:result['status']='UNKNOWN_REFINEMENT_LIMIT'
    result['input_file']=a.output.with_suffix('.cnf.gz').name;result['input_sha256']=dump_input(a.output.with_suffix('.cnf.gz'),n,cnf);checkpoint();solver.delete();print('RANK END',a.mode,result['status'],len(result['records']),flush=True)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--mode',choices=['restricted'],required=True);ap.add_argument('--anchor',type=int,nargs=2,required=True);ap.add_argument('--parent-cover',type=Path,required=True);ap.add_argument('--restricted-classes',type=Path,required=True);ap.add_argument('--seed-cuts',type=Path,nargs='*',default=[]);ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--rounds',type=int,default=500);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--separator',choices=['rank','closure'],default='rank');ap.add_argument('--native-library',type=Path);ap.add_argument('--signature-independent',action='store_true');ap.add_argument('--projection-count',action='store_true');ap.add_argument('--phase-profiles',type=Path);ap.add_argument('--child',action='store_true');a=ap.parse_args();a.output.parent.mkdir(exist_ok=True)
    if a.child:run(a);return
    child=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child']);expired=False
    try:child.wait(timeout=a.seconds)
    except subprocess.TimeoutExpired:expired=True;child.terminate();child.wait(timeout=10)
    d=json.loads(a.output.read_text()) if a.output.exists() else {'status':'ERROR_BEFORE_CHECKPOINT','cuts':[]}
    if expired:
        d.update(status='UNKNOWN_OUTER_WALL_LIMIT',answer=None);A,C,E,anchor,R,target,cnf,n,owners,events=setup(a.mode,a.signature_independent,a.phase_profiles,a.projection_count,a.restricted_classes,a.anchor);seen={tuple(sorted(c)) for c in cnf}
        for cut in d['cuts']:
            for clause in sorted(expand(cut,owners,anchor)-seen):cnf.append(list(clause));seen.add(clause)
        for circuit in d.get('signature_circuits',[]):
            for clause in sorted(expand_circuit(circuit,events,(65535^target) if anchor else None)-seen):cnf.append(list(clause));seen.add(clause)
        d['input_file']=a.output.with_suffix('.cnf.gz').name;d['input_sha256']=dump_input(a.output.with_suffix('.cnf.gz'),n,cnf);d['clauses']=len(cnf)
    d.update(child_returncode=child.returncode,outer_wall_expired=expired);a.output.write_text(json.dumps(d,indent=2)+'\n');print('PARENT END',a.mode,d['status'],flush=True)
if __name__=='__main__':main()
