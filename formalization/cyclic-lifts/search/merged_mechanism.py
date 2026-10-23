"""Replay the fixed syndrome-discordant cohort with read-only message hooks."""
from collections import Counter
from pathlib import Path
import base64,hashlib,json,random,struct,subprocess,tempfile,zlib
import benchmark_decoding as b
from merged_state_engine import compile_engine,data
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
FIELDS=['first_message','first_hard','onset','sign_edges','attenuation_edges',
        'original_acceptance_destroyed','merged_acceptance_requires_coupling',
        'original_path_merge_would_accept_first','merged_path_split_would_accept_first',
        'harmful_coupling_rounds','beneficial_coupling_rounds',
        'harmful_coupling_variable_events','beneficial_coupling_variable_events']


def unpack_bits(encoded,n):
    raw=zlib.decompress(base64.b64decode(encoded));return bytearray(bool(raw[i//8]&(1<<(i%8))) for i in range(n))


def pack16(values):return base64.b64encode(zlib.compress(struct.pack('<'+str(len(values))+'H',*values),9)).decode()


def run():
    main=json.loads((HERE/'merged-million-results.json').read_text())
    constructions=json.loads((HERE/'degree-preserving-results.json').read_text())
    paths=[Path(__file__),HERE/'merged_state_engine.py',HERE/'merged_mechanism.cpp',HERE/'minsum.cpp',
           HERE/'benchmark_decoding.py',HERE/'merged-million-results.json',HERE/'degree-preserving-results.json',
           HERE/'distance-matched-selection.json',HERE.parent/'MERGED-MECHANISM-PROTOCOL.md']
    hashes={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    (HERE/'merged-mechanism-selection.json').write_text(json.dumps(dict(status='fixed_message_analysis_before_state_extraction',sha256=hashes),indent=2)+'\n')
    n=main['independent_noise_patterns'];codes={};arms={};selected={}
    source=json.loads((HERE/'distance-matched-selection.json').read_text())
    for name,meta in source['codes'].items():
        hx,hz,_=b.construction(meta['B'],14);rec=next(r for r in constructions['records'] if r['design']==name)
        codes[name]=dict(original=hx,merged=rec['hx_rows'],pair=rec['representative_pair'],xm=list(map(b.rowmask,hx)),zp=b.basis(hz))
        selected[name]=[]
        for label in ['original','merged']:
            r=next(r for r in main['results'] if r['design']==name and r['representation']==label)
            arms[name,label]=dict(fail=unpack_bits(r['failure_flags_zlib_base64'],n),
                                  syn=unpack_bits(r['syndrome_flags_zlib_base64'],n),
                                  stab=unpack_bits(r['stabilizer_flags_zlib_base64'],n),
                                  iters=zlib.decompress(base64.b64decode(r['iterations_zlib_base64'])))
    rng=random.Random(main['seed']);stream=hashlib.sha256()
    for index in range(n):
        error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
        if index:stream.update(b'\n')
        stream.update(error.encode())
        for name in codes:
            if arms[name,'original']['syn'][index]!=arms[name,'merged']['syn'][index]:selected[name].append((index,error))
    assert stream.hexdigest()==main['error_stream_sha256']
    assert [len(selected[name]) for name in codes]==[20683,20498]
    results=[]
    with tempfile.TemporaryDirectory(prefix='merged-messages-') as tmp:
        binary=Path(tmp)/'messages';stock=Path(tmp)/'stock';compile_engine(binary)
        subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
        stock_replays=0
        for name,c in codes.items():
            traces=[t for t in main['traces'] if t['design']==name]
            old_first=zlib.decompress(base64.b64decode(main['trajectory_cohort'][name]['first_plus_one_zlib_base64']))
            for label in ['original','merged']:
                out=b.engine(stock,c[label],252,[(.04,t['error']) for t in traces],100,.8)
                assert out==[tuple(t['summary'][label]) for t in traces];stock_replays+=len(traces)
            columns={key:[] for key in FIELDS};indices=[];examples={};seen=set();groups={};digest=hashlib.sha256()
            old_trace_indices={t['index'] for t in traces}
            for start in range(0,len(selected[name]),256):
                batch=selected[name][start:start+256]
                proc=subprocess.run([str(binary)],input=data(c['original'],c['merged'],c['pair'],batch),text=True,capture_output=True,check=True)
                assert not proc.stderr;digest.update(proc.stdout.encode());parsed=[json.loads(line) for line in proc.stdout.splitlines()]
                assert len(parsed)==len(batch)
                for (index,error),record in zip(batch,parsed):
                    assert record['index']==index;word=b.string_mask(error)
                    for label in ['original','merged']:
                        it,matched,estimate=record[label];a=arms[name,label]
                        residual=word^b.string_mask(estimate)
                        assert bool(matched)==(not any(b.syndrome(c['xm'],residual)))==(not a['syn'][index])
                        ok=b.in_span(residual,c['zp']);assert (not ok)==bool(a['fail'][index])
                        assert (ok and residual!=0)==bool(a['stab'][index]) and it==a['iters'][index]
                    expected_first=old_first[index]-1
                    assert record['first_hard']==expected_first
                    direction='lost_syndrome_match' if record['original'][1] else 'gained_syndrome_match'
                    onset={1:'sign_only',2:'attenuation_only',3:'mixed'}[record['onset']]
                    group=groups.setdefault(direction,dict(cases=0,onsets=Counter(),first_message=Counter(),
                                                           original_acceptance_destroyed=0,merged_acceptance_requires_coupling=0,
                                                           original_path_merge_would_accept=0,merged_path_split_would_accept=0,
                                                           harmful_coupling_present=0,beneficial_coupling_present=0))
                    group['cases']+=1;group['onsets'][onset]+=1;group['first_message'][record['first_message']]+=1
                    for key in ['original_acceptance_destroyed','merged_acceptance_requires_coupling']:group[key]+=bool(record[key])
                    for key in ['original_path_merge_would_accept','merged_path_split_would_accept']:group[key]+=record[key+'_first']>0
                    group['harmful_coupling_present']+=record['harmful_coupling_rounds']>0
                    group['beneficial_coupling_present']+=record['beneficial_coupling_rounds']>0
                    reasons=[]
                    for criterion,enabled in [(direction+'/'+onset,True),('original_acceptance_destroyed',record['original_acceptance_destroyed']),
                                              ('merged_acceptance_requires_coupling',record['merged_acceptance_requires_coupling']),
                                              ('original_path_merge_would_accept',record['original_path_merge_would_accept_first']>0),
                                              ('merged_path_split_would_accept',record['merged_path_split_would_accept_first']>0)]:
                        if enabled and criterion not in seen:seen.add(criterion);reasons.append('first_'+criterion)
                    if index in old_trace_indices:reasons.append('previously_fixed_history')
                    if reasons:examples[index]=dict(error=error,direction=direction,reasons=reasons,**record)
                    indices.append(index)
                    for key in FIELDS:columns[key].append(record[key])
                if start%2048==0:print(name,start+len(batch),'/',len(selected[name]),'message pairs checked',flush=True)
            results.append(dict(design=name,cases=len(indices),indices=indices,
                                fields_uint16_le_zlib_base64={key:pack16(values) for key,values in columns.items()},
                                groups=groups,examples=[examples[i] for i in sorted(examples)],raw_replay_stdout_sha256=digest.hexdigest()))
    for rel,h in hashes.items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==h,rel
    out=dict(status='all_fixed_sample_syndrome_discordances_message_replayed',new_noise_patterns=0,
             replayed_code_error_pairs=sum(len(x) for x in selected.values()),primary_cpp_decoder_replays=2*sum(len(x) for x in selected.values()),
             prior_selected_history_stock_replays=stock_replays,original_error_stream_sha256=stream.hexdigest(),records=results,sha256=hashes)
    (HERE/'merged-mechanism-results.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps([dict(design=r['design'],groups=r['groups']) for r in results],indent=2),flush=True)


if __name__=='__main__':run()
