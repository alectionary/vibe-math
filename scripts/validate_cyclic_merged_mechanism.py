"""Rebuild onset groups and independently replay retained full message states."""
from collections import Counter
from pathlib import Path
import base64,hashlib,json,random,struct,sys,tempfile,zlib
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b
from merged_reference_states import states,graph,local_data,local_decisions,check
from merged_probe import compile_probe,probe


def flags(encoded,n):
    raw=zlib.decompress(base64.b64decode(encoded));return bytearray(bool(raw[i//8]&(1<<(i%8))) for i in range(n))


main=json.loads((S/'merged-million-results.json').read_text())
d=json.loads((S/'merged-mechanism-results.json').read_text())
v=json.loads((S/'degree-preserving-results.json').read_text())
source=json.loads((S/'distance-matched-selection.json').read_text())
for rel,digest in d['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
assert d['new_noise_patterns']==0 and d['replayed_code_error_pairs']==41181
assert d['primary_cpp_decoder_replays']==82362 and d['prior_selected_history_stock_replays']==90
codes={};targets={};cases=[];matrices=[]
for rec in d['records']:
    name=rec['design'];meta=source['codes'][name];hx,hz,_=b.construction(meta['B'],14)
    merged=next(r for r in v['records'] if r['design']==name)
    n=rec['cases'];fields={key:struct.unpack('<'+str(n)+'H',zlib.decompress(base64.b64decode(value))) for key,value in rec['fields_uint16_le_zlib_base64'].items()}
    originals=next(r for r in main['results'] if r['design']==name and r['representation']=='original')
    merges=next(r for r in main['results'] if r['design']==name and r['representation']=='merged')
    oldsyn=flags(originals['syndrome_flags_zlib_base64'],1000000);newsyn=flags(merges['syndrome_flags_zlib_base64'],1000000)
    assert rec['indices']==[i for i,(a,z) in enumerate(zip(oldsyn,newsyn)) if a!=z]
    first_hard=zlib.decompress(base64.b64decode(main['trajectory_cohort'][name]['first_plus_one_zlib_base64']))
    initial=zlib.decompress(base64.b64decode(main['trajectory_cohort'][name]['source_bits_zlib_base64']))
    assert all(len(values)==n for values in fields.values())
    groups={};seen=set();wanted={};old_indices={t['index'] for t in main['traces'] if t['design']==name}
    for j,index in enumerate(rec['indices']):
        direction='lost_syndrome_match' if not oldsyn[index] else 'gained_syndrome_match'
        onset={1:'sign_only',2:'attenuation_only',3:'mixed'}[fields['onset'][j]]
        assert fields['onset'][j]==(3 if fields['sign_edges'][j] and fields['attenuation_edges'][j] else 1 if fields['sign_edges'][j] else 2)
        assert 1<=fields['first_message'][j]<=fields['first_hard'][j]==first_hard[index]-1
        if initial[index]:
            assert fields['first_message'][j]==1 and fields['onset'][j]==1
            assert fields['sign_edges'][j]==(12 if initial[index]==3 else 6)
        else:assert fields['first_message'][j]>1
        assert not fields['original_acceptance_destroyed'][j] or direction=='lost_syndrome_match'
        assert not fields['merged_acceptance_requires_coupling'][j] or direction=='gained_syndrome_match'
        group=groups.setdefault(direction,dict(cases=0,onsets=Counter(),first_message=Counter(),original_acceptance_destroyed=0,
                                               merged_acceptance_requires_coupling=0,original_path_merge_would_accept=0,
                                               merged_path_split_would_accept=0,harmful_coupling_present=0,beneficial_coupling_present=0))
        group['cases']+=1;group['onsets'][onset]+=1;group['first_message'][fields['first_message'][j]]+=1
        for key in ['original_acceptance_destroyed','merged_acceptance_requires_coupling']:group[key]+=bool(fields[key][j])
        for key in ['original_path_merge_would_accept','merged_path_split_would_accept']:group[key]+=fields[key+'_first'][j]>0
        group['harmful_coupling_present']+=fields['harmful_coupling_rounds'][j]>0
        group['beneficial_coupling_present']+=fields['beneficial_coupling_rounds'][j]>0
        reasons=[]
        for key,enabled in [(direction+'/'+onset,True),('original_acceptance_destroyed',fields['original_acceptance_destroyed'][j]),
                            ('merged_acceptance_requires_coupling',fields['merged_acceptance_requires_coupling'][j]),
                            ('original_path_merge_would_accept',fields['original_path_merge_would_accept_first'][j]>0),
                            ('merged_path_split_would_accept',fields['merged_path_split_would_accept_first'][j]>0)]:
            if enabled and key not in seen:seen.add(key);reasons.append('first_'+key)
        if index in old_indices:reasons.append('previously_fixed_history')
        if reasons:wanted[index]=reasons
    encoded=json.loads(json.dumps(groups));assert encoded==rec['groups']
    assert [(e['index'],e['reasons']) for e in rec['examples']]==list(wanted.items())
    for e in rec['examples']:targets[name,e['index']]=e
    original_obstruction=next((j,index) for j,index in enumerate(rec['indices']) if fields['original_acceptance_destroyed'][j])
    actual_obstruction=next((j,index) for j,index in enumerate(rec['indices']) if not oldsyn[index] and fields['merged_path_split_would_accept_first'][j]>0)
    for kind,(j,index) in [('original_acceptance_destroyed',original_obstruction),('actual_merged_state_blocks_acceptance',actual_obstruction)]:
        cases.append(dict(design=name,kind=kind,index=index,
                          iteration=(fields['merged_path_split_would_accept_first'][j] if kind.startswith('actual') else None)))
        targets.setdefault((name,index),None)
    codes[name]=dict(original=hx,merged=merged['hx_rows'],pair=merged['representative_pair'],hz=hz,
                     original_basis=b.basis(list(map(b.rowmask,hx))),z_basis=b.basis(hz),B=meta['B'])
    matrices.append(dict(design=name,B=meta['B'],r=14,original=hx,merged=merged['hx_rows'],pair=merged['representative_pair']))
    print(name,'PASS: all onset and same-state-acceptance counts, both directions and deterministic example selection reconstructed',flush=True)
selection=dict(status='deterministic_first_obstructions_selected_before_supplementary_probes',cases=cases,
               sha256={str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for p in
                       [Path(__file__),S/'merged_reference_states.py',S/'merged_probe.py',S/'merged_state_probe.cpp',S/'merged-mechanism-results.json']})
(S/'merged-mechanism-witness-selection.json').write_text(json.dumps(selection,indent=2)+'\n')
errors={};rng=random.Random(main['seed']);digest=hashlib.sha256()
for i in range(1000000):
    error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
    if i:digest.update(b'\n')
    digest.update(error.encode())
    for name in codes:
        if (name,i) in targets:errors[name,i]=error
assert digest.hexdigest()==main['error_stream_sha256'] and len(errors)==len(targets)
checked_probes=0;checked_local_rows=0;witnesses=[]
with tempfile.TemporaryDirectory(prefix='merged-state-validator-') as tmp:
    binary=Path(tmp)/'probe';compile_probe(binary)
    for (name,index),record in sorted(targets.items()):
        c=codes[name];error=errors[name,index];word=b.string_mask(error)
        if record is not None:assert record['error']==error
        histories={};terminal={}
        for label in ['original','merged']:
            history,last=states(c[label],error);histories[label]=history;terminal[label]=last
            requested=set()
            if record is not None:
                assert tuple(record[label])==last;requested.add(record['first_message'])
                if record['acceptance_witness']:
                    w=record['acceptance_witness']
                    if (label=='original')==bool(w['from_original_state']):requested.add(w['iteration'])
            for case in cases:
                if (case['design'],case['index'])!=(name,index):continue
                if case['kind'].startswith('actual') and label=='merged':requested.add(case['iteration'])
                if case['kind'].startswith('original') and label=='original':requested.add(last[0]);case['iteration']=last[0]
            requested=sorted(requested)
            captured=probe(binary,c[label],error,requested);assert tuple(captured['terminal'])==last
            for row in captured['states']:
                ref=history[row['iteration']-1]
                assert row['q']==ref['q'] and row['r']==ref['r'] and row['estimate']==ref['estimate'];checked_probes+=1
        if record is not None:
            step=record['first_message'];og,mg=graph(c['original']),graph(c['merged']);a,z=c['pair']
            mapping=[mg['lookup'][a if row==z else row-1 if row>z else row,v] for row,v in og['edge']]
            old,new=histories['original'][step-1],histories['merged'][step-1]
            assert all(old['q'][e]==new['q'][f] for e,f in enumerate(mapping))
            locals=local_data(c['original'],c['merged'],c['pair'],error,old,True)
            assert record['onset_witness'] in locals
            signs=sum(w['split_message']*w['merged_message']<0 for w in locals)
            atten=sum(abs(w['merged_message'])<abs(w['split_message']) for w in locals)
            assert signs==record['sign_edges'] and atten==record['attenuation_edges']
            checked_local_rows+=len(locals)
            if record['acceptance_witness']:
                w=record['acceptance_witness'];label='original' if w['from_original_state'] else 'merged'
                state=histories[label][w['iteration']-1]
                locals=local_data(c['original'],c['merged'],c['pair'],error,state,bool(w['from_original_state']))
                assert locals==w['locals']
                split,merged=local_decisions(state,locals)
                assert (split,merged)==(w['split_decision'],w['merged_decision']);checked_local_rows+=len(locals)
        for case in cases:
            if (case['design'],case['index'])!=(name,index):continue
            label='merged' if case['kind'].startswith('actual') else 'original'
            state=histories[label][case['iteration']-1]
            locals=local_data(c['original'],c['merged'],c['pair'],error,state,label=='original')
            split,merged=local_decisions(state,locals);xm=list(map(b.rowmask,c['original']))
            assert not any(b.syndrome(xm,word^b.string_mask(split))) and any(b.syndrome(xm,word^b.string_mask(merged)))
            assert terminal['original'][1] and not terminal['merged'][1]
            change=b.string_mask(split)^b.string_mask(merged)
            odd_check=next(i for i,row in enumerate(xm) if b.popcount(row&change)%2)
            witnesses.append(dict(**case,error=error,error_support=[v for v in range(252) if word>>v&1],
                                  state_source=label,split_decision=split,merged_decision=merged,
                                  split_support=[v for v,ch in enumerate(split) if ch=='1'],merged_support=[v for v,ch in enumerate(merged) if ch=='1'],
                                  changed_variables=[v for v in range(252) if change>>v&1],odd_check=odd_check,locals=locals,
                                  original_terminal=terminal['original'],merged_terminal=terminal['merged'],
                                  probed_state_sha256=hashlib.sha256(json.dumps(dict(q=state['q'],r=state['r'],estimate=state['estimate']),sort_keys=True).encode()).hexdigest()))
            checked_local_rows+=len(locals)
        print(name,index,'PASS independent messages, state probes and retained local equations',flush=True)
out=dict(status='independently_replayed_local_acceptance_obstructions',matrices=matrices,witnesses=witnesses,
         cpp_state_probes=checked_probes,local_source_update_rows_checked=checked_local_rows,
         source_selection_sha256=hashlib.sha256((S/'merged-mechanism-witness-selection.json').read_bytes()).hexdigest())
(S/'merged-mechanism-witnesses.json').write_text(json.dumps(out,indent=2)+'\n')
print(f'PASS: all 41181 syndrome-discordant summaries reconstructed; {checked_probes} C++ q/r states match direct Python equations; {checked_local_rows} retained source updates; four first acceptance obstructions exported. No new noise or decoder settings.')
