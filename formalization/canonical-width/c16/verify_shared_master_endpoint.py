#!/usr/bin/env python3
"""Exact restricted shared-master primal/dual proof; no full-domain pricing."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,time
from verify_shared_master_common import *
from verify_shared_master_preparation import context,controls,DEPS
from read_soplex_exact_output_v2 import read_named_rational
from verify_owner_k22_capacity_extension import atom_values
from verify_global_eight_probe_law import EVENTS,target,features

def law_and_links(data,L,values):
    M=data['M'];f=data['f'];parent=values[:22513]
    lam=[value(e,f,parent) for e in M['lambda_expressions']]
    assert all(v>=0 for v in lam) and sum(lam)==1
    low=[0,1,2,4,8,3,5,9,6,10,12];high=[7,11,13,14,15]
    fmap=M['source_feature_to_owner_target'][:11]
    for h,j in zip(low,fmap):assert sum(lam[m] for m in range(16) if m&h==h)==f[j]
    for i,h in enumerate(high):assert sum(lam[m] for m in range(16) if m&h==h)==parent[i]
    Y={s:[[value(e,f,parent) for e in row] for row in M['sectors'][s]['allocations']] for s in 'XZ'}
    mixture={s:[[Q(0)]*720 for m in range(16)] for s in 'XZ'}
    mass={(s,m):Q(0) for m in range(16) for s in 'XZ'};positive=0
    for k,col in enumerate(L['columns']):
        w=values[L['weight_start']+k];assert w>=0;s,m=col['side'],col['mask'];mass[s,m]+=w
        if w:
            positive+=1
            for j in col['indices']:mixture[s][m][j]+=w
    error=Q(0);positive_errors=0
    for m in range(16):
        for s in 'XZ':
            assert mass[s,m]==lam[m] and sum(Y[s][m])==128*lam[m]
            for j in range(720):
                assert 0<=Y[s][m][j]<=lam[m]
                q=link_index(s,m,j);ep,em=values[L['plus_start']+q],values[L['minus_start']+q]
                assert ep>=0 and em>=0 and mixture[s][m][j]+ep-em==Y[s][m][j]
                assert ep==0 or em==0,'Optimal L1 errors cannot overlap'
                assert ep+em==abs(mixture[s][m][j]-Y[s][m][j]);error+=ep+em;positive_errors+=ep+em>0
    return lam,Y,mixture,error,positive,positive_errors

def glued_law(data,parent,lam,Y):
    M=data['M'];pairs={tuple(p):i for i,p in enumerate(M['owner_flow_extension']['physical_pairs'])}
    allowed=set(data['allowed']);law={m:Q(0) for m in allowed};forbidden=0
    for m in range(16):
        y=[Y['X'][m][j] for j in (614,281)]+[Y['Z'][m][j] for j in (51,83)]
        t={(i,j+2):parent[13393+568*m+pairs[x,z]] for i,x in enumerate((614,281)) for j,z in enumerate((51,83))}
        sx,sz=parent[22481+2*m:22483+2*m];atoms=atom_values(lam[m],y,t,sx,sz)
        assert len(atoms)==11 and min(atoms.values())>=0 and sum(atoms.values())==lam[m]
        for b,w in atoms.items():
            full=m|(b<<4)
            if full in allowed:law[full]+=w
            else:assert w==0;forbidden+=1
    assert forbidden==24 and sum(law.values())==1
    wanted,coords,owner=target(resolve(data['manifest']['point']),EVENTS);actual=[Q(0)]*37
    assert [Q(1),*owner]==data['f']
    for m,w in law.items():
        for j,bit in enumerate(features(m)):actual[j]+=w*bit
    assert actual==wanted
    return dict(conditional_atom_slots_checked=176,forbidden_eight_atoms_checked=24,global_features_checked=37,
                positive_global_atoms=sum(w>0 for w in law.values()),zero_tau_pins_required=False)

def solver_context(a,d):
    frozen=read(a.solver_frozen)
    for key,expected in [('manifest_sha256',sha(a.manifest)),('preparation_receipt_sha256',sha(a.preparation_receipt)),
                         ('semantic_sha256',d['semantic_sha256']),('lp_sha256',d['lp_sha256']),('seed_sha256',d['seed_sha256']),
                         ('geometry_bank_sha256',d['geometry_bank_sha256'])]:assert frozen[key]==expected,key
    assert frozen['zero_tau_pins'] is False and frozen['all_sixteen_patterns'] is True
    assert frozen['variable_count']==d['variable_count'] and frozen['row_count']==d['row_count'] and frozen['basis_count']==d['basis_count']
    assert frozen['consumer_sha256']==sha('verify_shared_master_preparation.py')
    bindings(frozen['source_hashes'])
    command=frozen['command'];assert isinstance(command,list)
    assert '-X='+str(resolve(a.primal)) in command and '-Y='+str(resolve(a.dual)) in command
    assert str(resolve(d['lp'])) in command
    return frozen

def main():
    guard();ap=argparse.ArgumentParser()
    for key in ('manifest','preparation-receipt','primal','dual','solver-frozen','output'):ap.add_argument('--'+key,required=True)
    a=ap.parse_args();start=time.monotonic();outpath=resolve(a.output);assert not outpath.exists()
    data,L,semantic=context(a.manifest,a.preparation_receipt,check_columns=False);d=data['manifest']
    frozen=solver_context(a,d);N=L['variable_count'];rows=list(expected_rows(data,L));cost=objective(L)
    assert len(rows)==d['row_count'] and len({r[0] for r in rows})==len(rows)
    px=read_named_rational(resolve(a.primal),['x'+str(j) for j in range(N)])
    rawdual=read_named_rational(resolve(a.dual),[r[0] for r in rows],'dual')
    values=[px['x'+str(j)] for j in range(N)]
    obj,count,slack=check_primal(rows,data['f'],values,cost)
    assert obj>=0 and count==d['row_count']
    sign,dual,dualvalue=exact_dual(rows,data['f'],N,cost,rawdual,obj)
    for m in range(16):
        for s in 'XZ':
            for j in range(720):assert -1<=dual[f'sm_link_{s}_{m}_{j}']<=1
    lam,Y,mix,error,positive,positive_errors=law_and_links(data,L,values)
    assert error==obj;law=glued_law(data,values[:22513],lam,Y)
    tests=controls()
    sparse=[[name,str(dual[name])] for name,e,rel in rows if dual[name]]
    out=dict(status='PASS_EXACT_RESTRICTED_SHARED_MASTER_PHASE_ONE_OPTIMUM',manifest=str(a.manifest),manifest_sha256=sha(a.manifest),
        preparation_receipt=str(a.preparation_receipt),preparation_receipt_sha256=sha(a.preparation_receipt),
        semantic_sha256=d['semantic_sha256'],lp_sha256=d['lp_sha256'],seed_sha256=d['seed_sha256'],geometry_bank_sha256=d['geometry_bank_sha256'],
        primal=str(a.primal),primal_sha256=sha(a.primal),dual=str(a.dual),dual_sha256=sha(a.dual),
        solver_frozen=str(a.solver_frozen),solver_frozen_sha256=sha(a.solver_frozen),consumer_sha256=sha(Path(__file__).name),
        parser_sha256=sha('read_soplex_exact_output_v2.py'),point_sha256=d['point_sha256'],variables=N,rows_checked=count,
        full_finite_variable_prefix=22513,physical_column_count=L['nB'],basis_weight_mass_rows=32,exact_link_rows=23040,
        positive_basis_weights=positive,positive_error_coordinates=positive_errors,exact_objective=str(obj),exact_dual_objective=str(dualvalue),
        dual_sign=sign,normalized_dual_row_weights=sparse,omitted_dual_rows_are_zero=True,inequality_dual_convention='nonpositive for min LP rows <= rhs',
        all_variable_stationarity_checked=N,exact_primal_dual_equality=True,bounded_link_duals_checked=23040,
        full_parameters=list(map(str,values[:22513])),lambda_masses=list(map(str,lam)),higher_joint_moments=list(map(str,values[:5])),
        exact_allocations={s:[list(map(str,row)) for row in Y[s]] for s in 'XZ'},complete_eight_law=law,
        positive_basis_records=[dict(column_index=k,side=c['side'],mask=c['mask'],indices=c['indices'],weight=str(values[L['weight_start']+k]))
                                for k,c in enumerate(L['columns']) if values[L['weight_start']+k]>0],
        restricted_basis_hull_membership=obj==0,full_shared_relaxation_membership=obj==0,global_target_exclusion_proved=False,
        all32_physical_pricing_performed=False,zero_tau_pins=False,full_source_frame=False,source_C16_answered=False,
        minimum_primal_inequality_slack=str(slack),controls=tests,source_hashes=d['source_hashes'],
        dependencies={p:sha(p) for p in DEPS+['verify_shared_master_preparation.py','verify_global_eight_probe_law.py','read_soplex_exact_output_v2.py']},
        nice=19,threads=1,elapsed_seconds=time.monotonic()-start,
        scope='Exact optimum of this unrestricted-law restricted-column master. Positive artificial error alone proves neither a full-hull obstruction nor a source-case exclusion.')
    outpath.parent.mkdir(parents=True,exist_ok=True);outpath.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','dependencies','normalized_dual_row_weights','full_parameters','exact_allocations','positive_basis_records')}),flush=True)
if __name__=='__main__':main()
