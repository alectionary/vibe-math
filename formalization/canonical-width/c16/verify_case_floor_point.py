#!/usr/bin/env python3
"""Exact point/floor and selected-Boolean coverage consumer.

A trial multiplier below one is an intermediate weaker necessary condition.
Only satisfaction of the true selected-pair floor closes this extra condition
for a listed moment relaxation; no accepted moment point is a source frame.
"""
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path
import argparse
import copy
import json
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, point_owner, coordinate


def values(command,flag):
    k=command.index(flag)+1;j=k
    while j<len(command) and not command[j].startswith('--'):j+=1
    return command[k:j]


def geometry(case,record,X,Z):
    i,j,h=case;assert 0<=i<45 and 0<=j<45 and 0<=h<16
    x,z=16*i,16*j+h;assert (X[x]&Z[z]).bit_count()&1
    def move(a,r):return 16*(a//16)+(a%16+r)%16
    images=[(move(z,r),move(x,r)) if swap else (move(x,r),move(z,r)) for swap in range(2) for r in range(16)]
    orbit=len(set(images));stabilizer=sum(pair==(x,z) for pair in images)
    assert orbit in (16,32) and orbit*stabilizer==32
    literal=sum(int(16*i+t==x and 16*j+(t+h)%16==z)+int(16*i+t==z and 16*j+(t+h)%16==x) for t in range(16))
    floor=Q(literal,32);assert floor==Q(stabilizer,32)==Q(1,orbit)
    hh,ii,jj=(16-h,j,i) if h>8 else (h,i,j)
    if hh in (0,8) and ii>jj:ii,jj=jj,ii
    column=45+9*2025+hh*2025+45*ii+jj
    assert column==coordinate('T',h,i,j)
    assert record['case']==list(case) and record['X_index']==x and record['Z_index']==z
    assert record['edge_orbit_size']==orbit and record['edge_stabilizer_size']==stabilizer
    assert Q(record['necessary_floor'])==floor and record['owner_coordinate']==column
    assert record['owner_inequality']==dict(indices=[column],coefficients=[-orbit],rhs=-1)
    return dict(X_index=x,Z_index=z,owner_coordinate=column,folded_T_coordinate=[hh,ii,jj],edge_orbit_size=orbit,edge_stabilizer_size=stabilizer,literal_32_action_numerator=literal),floor


def selected_terms(cut):
    events=cut['events'];assert len(events)==3 and all(type(e)is int and 0<=e<1440 for e in events) and len(set(events))==3
    a,b,c=events;row=Counter()
    def marginal(e):return (e%720)//16
    def pair(e,f):
        s,i=divmod(e,720);t,j=divmod(f,720)
        return coordinate('S' if s==t else 'T',(j%16-i%16)%16,i//16,j//16)
    if cut['kind']=='triangle':
        row[marginal(a)]-=1;row[pair(a,b)]+=1;row[pair(a,c)]+=1;row[pair(b,c)]-=1;rhs=0
    else:
        assert cut['kind']=='union'
        for e in events:row[marginal(e)]+=1
        for e,f in [(a,b),(a,c),(b,c)]:row[pair(e,f)]-=1
        rhs=1
    return tuple(sorted((j,c) for j,c in row.items() if c)),rhs


def triangle_coverage(point,owner,frozen,summary_path):
    summary=read(summary_path);assert summary['status']=='PASS_LISTED_RELAXATION'
    stem=str(summary_path).removesuffix('-checks-summary.json')
    check_frozen=Path(stem+'-checks-frozen.json');assert summary['frozen_sha256']==sha(check_frozen)
    assert all(summary['sources_unchanged'].values())
    check_source=read(check_frozen)
    source_map=check_source.get('input_and_source_hashes',check_source.get('source_hashes'))
    if source_map is not None:assert all(sha(ROOT/p)==h for p,h in source_map.items())
    expected=['old-replay','unified-exact','projected-exact','basis-exact','global-moment-screen','all-triples','triple-distributions']
    assert [r['stage'] for r in summary['stages']]==expected
    receipts={}
    for r in summary['stages']:
        path=Path(stem+'-'+r['stage']+'.json');d=read(path)
        assert r['status']==d['status']=='PASS' and r['returncode']==0 and r['receipt_sha256']==sha(path)
        assert d.get('point_sha256',d.get('certificate_sha256'))==sha(point)
        if 'consumer_sha256' in d:
            names={'projected-exact':'verify_projected_profile_moment_rows.py','basis-exact':'verify_integer_coupling_rows.py','global-moment-screen':'check_global_conditioned_moments.py','all-triples':'complete_boolean_triples.py','triple-distributions':'verify_all_triple_distributions.py'}
            if r['stage'] in ('all-triples','triple-distributions'):assert d['consumer_sha256']==sha(ROOT/names[r['stage']])
        receipts[r['stage']]=dict(path=str(path),sha256=sha(path))
    triple=read(Path(stem+'-all-triples.json'));direct=read(Path(stem+'-triple-distributions.json'))
    assert triple['violated_rows']==0 and triple['all_rows_checked_including_symmetry_duplicates']==93117690
    assert direct['local_triple_distributions_including_symmetry_duplicates']==46558845 and direct['nonnegative_atom_checks']==372470760
    commands=frozen['command'];banks=values(commands,'--boolean-cuts');selected=[];unique=set()
    from complete_boolean_triples import terms
    for p in banks:
        path=ROOT/p;assert frozen['input_and_source_hashes'][p]==sha(path)
        for k,cut in enumerate(read(path)['cuts']):
            row,rhs=selected_terms(cut);assert (row,rhs)==terms(cut)
            a=cut['events'][0];sector,index=divmod(a,720);phase=index%16
            def action(e):
                s,j=divmod(e,720);return 720*(s^sector)+16*(j//16)+(j%16-phase)%16
            transformed=[action(e) for e in cut['events']];transformed[1:]=sorted(transformed[1:])
            assert transformed[0]==16*(index//16) and transformed[1]<transformed[2] and transformed[0] not in transformed[1:]
            assert selected_terms(dict(kind=cut['kind'],events=transformed))==(row,rhs)
            value=sum(c*owner[j] for j,c in row);slack=Q(rhs)-value;assert slack>=0
            selected.append(dict(bank=p,cut_index=k,kind=cut['kind'],events=cut['events'],screen_events=transformed,exact_slack=str(slack)))
            unique.add((row,rhs))
    return dict(status='PASS_ALL_SELECTED_BOOLEAN_ROWS_COVERED',checked_summary_sha256=sha(summary_path),checked_summary_frozen_sha256=sha(check_frozen),seven_stage_receipts=receipts,
        selected_banks={p:sha(ROOT/p) for p in banks},selected_rows_including_duplicates=len(selected),unique_owner_rows=len(unique),
        distinct_event_gate=True,cyclic_sector_action_to_complete_screen_replayed=True,all_selected_rows_also_evaluated_exactly=True,
        minimum_exact_selected_row_slack=str(min(Q(r['exact_slack']) for r in selected)),rows=selected,
        scope='All selected triangle/union cuts are among the complete physical three-distinct-event families after an explicit allowed symmetry. Separate exact triple distributions imply these rows, without requiring a common global distribution.')


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--bridge',type=Path,required=True);ap.add_argument('--bridge-replay',type=Path,required=True);ap.add_argument('--case',type=int,nargs=3,required=True);ap.add_argument('--floor-multiplier',required=True);ap.add_argument('--model-frozen',type=Path);ap.add_argument('--checks-summary',type=Path);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();multiplier=Q(a.floor_multiplier);assert 0<multiplier<=1
    bridge,replay=read(a.bridge),read(a.bridge_replay)
    assert bridge['status']=='PASS_SELECTED_PAIR_MOMENT_BRIDGE' and replay['status']=='PASS' and replay['bridge_sha256']==sha(a.bridge)
    assert replay['consumer_sha256']==sha(ROOT/'verify_cover_case_moment_bridge.py')
    assert all(sha(ROOT/p)==h for p,h in bridge['source_hashes'].items())
    coverpath=ROOT/'transfer-results/cover-405.json';bindingpath=ROOT/'transfer-results/cover-bindings.json';cover,bindings=read(coverpath),read(bindingpath)
    assert cover['status']==bindings['status']=='PASS' and bindings['cover_sha256']==sha(coverpath)
    assert len(cover['cases'])==len(bridge['records'])==replay['case_count']==405
    matches=[r for r in bridge['records'] if r['case']==a.case];assert len(matches)==1;record=matches[0]
    assert sum(r['orbit_tuple']==a.case for r in cover['cases'])==1
    X,Z,physical=physical_source();g,truefloor=geometry(a.case,record,X,Z)
    assert len(set(X))==len(set(Z))==720
    owner=point_owner(a.point);moment=owner[g['owner_coordinate']];trial=multiplier*truefloor;trialslack=moment-trial;trueslack=moment-truefloor
    assert trialslack>=0,('exact_trial_floor_violation',str(trialslack))
    frozen=None;execution=None;coverage=None
    if a.model_frozen:
        frozen=read(a.model_frozen);assert all(sha(ROOT/p)==h for p,h in frozen['input_and_source_hashes'].items())
        command=frozen['command'];assert list(map(int,values(command,'--case')))==a.case
        assert (ROOT/values(command,'--case-bridge')[0]).resolve()==a.bridge.resolve() and (ROOT/values(command,'--case-replay')[0]).resolve()==a.bridge_replay.resolve()
        actualmult=Q(values(command,'--floor-multiplier')[0]) if '--floor-multiplier' in command else Q(1)
        assert actualmult==multiplier
        if 'trial_floor_multiplier' in frozen:assert Q(str(frozen['trial_floor_multiplier']))==multiplier
        execution=dict(frozen_sha256=sha(a.model_frozen),source_bindings_checked=len(frozen['input_and_source_hashes']),effective_margins=frozen['effective_margins'],search_sufficient_only=any(v>0 for v in frozen['effective_margins'].values()))
    if a.checks_summary:
        assert frozen is not None;coverage=triangle_coverage(a.point,owner,frozen,a.checks_summary)
    controls=[]
    for key,value in [('owner_coordinate',g['owner_coordinate']+1),('necessary_floor',str(truefloor/2)),('edge_orbit_size',64)]:
        bad=copy.deepcopy(record);bad[key]=value
        try:geometry(a.case,bad,X,Z)
        except AssertionError:controls.append('corrupted_'+key)
        else:raise AssertionError('corrupted bridge field accepted')
    truepass=trueslack>=0
    out=dict(status='PASS_EXACT_TRUE_CASE_FLOOR' if truepass else 'PASS_EXACT_INTERMEDIATE_CASE_FLOOR',source_C16_answered=False,
        consumer_sha256=sha(__file__),point_sha256=sha(a.point),bridge_sha256=sha(a.bridge),bridge_replay_sha256=sha(a.bridge_replay),
        bridge_consumer_sha256=sha(ROOT/'verify_cover_case_moment_bridge.py'),bridge_source_hashes=bridge['source_hashes'],cover_sha256=sha(coverpath),cover_bindings_sha256=sha(bindingpath),
        case=a.case,physical_symmetry_bridge=physical,geometry=g,exact_point_moment=str(moment),floor_multiplier=str(multiplier),
        exact_trial_floor=str(trial),exact_true_source_floor=str(truefloor),exact_trial_floor_slack=str(trialslack),exact_true_floor_slack=str(trueslack),
        trial_floor_satisfied=True,true_source_floor_satisfied=truepass,trial_equals_true_floor=multiplier==1,
        model_execution=execution,selected_boolean_coverage=coverage,corruption_controls_rejected=controls,
        seven_listed_families_receipts_bound=coverage is not None,listed_weaker_case_relaxation_feasible=coverage is not None,
        listed_true_case_relaxation_feasible=coverage is not None and truepass,physical_source_frame_verified=False,source_case_excluded=False,
        dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','complete_boolean_triples.py']},
        scope=('The point satisfies the exact true selected-pair floor. Bound seven-family receipts, if supplied, give feasibility only of the stated moment relaxation plus that floor; no physical source frame or case exclusion follows.' if truepass else 'The point satisfies an intermediate weaker selected-case floor but fails the true source floor. Even with all seven listed families accepted, it is not a feasible point of the true-floor case relaxation. It is a continuation witness only; no source frame or case exclusion follows.'))
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['bridge_source_hashes','selected_boolean_coverage']},indent=2))

if __name__=='__main__':main()
