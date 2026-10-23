"""Check fixed-code trajectories, static local identities and concrete Lean source."""
from collections import Counter
from pathlib import Path
import hashlib,json,math,subprocess,sys,tempfile
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent
P=R/'formalization/dyadic-performance'
sys.path.insert(0,str(P/'search'))
import pilot as p
import quantum_css as q
import targeted as t
import trajectory as tr
import generate_trajectory_lean as gen


def reference_trace(h,error,keep):
    """Independent Python message definition, with all numerical states retained."""
    n=32;hm=list(map(p.decoder.rowmask,h));target=p.decoder.syndrome(hm,error)
    prior=4080869;cap=50*(1<<20);qq={(c,v):prior for c,row in enumerate(h) for v in row}
    bits=[];qs=[];rs=[];ps=[];clip=lambda x:max(-cap,min(cap,x))
    for it in range(1,51):
        rr={}
        for c,row in enumerate(h):
            for v in row:
                others=[qq[c,w] for w in row if w!=v]
                sign=(-1 if target[c] else 1)*(-1 if sum(x<0 for x in others)%2 else 1)
                rr[c,v]=clip(sign*((800*min(map(abs,others))+500)//1000))
        posterior=[prior+sum(rr[c,v] for c,row in enumerate(h) if v in row) for v in range(n)]
        word=sum((val<0)<<v for v,val in enumerate(posterior))
        qq={(c,v):clip(posterior[v]-rr[c,v]) for c,row in enumerate(h) for v in row}
        bits.append(hex(word));qs.append(list(qq.values()));rs.append(list(rr.values()));ps.append(posterior)
        if p.decoder.syndrome(hm,word)==target:break
    assert bits==keep['decisions_hex']
    assert qs==keep['q_after'] and rs==keep['check_messages'] and ps==keep['posteriors']
    assert keep['iterations']==len(bits)


d=json.loads((P/'search/trajectory-results.json').read_text())
s=json.loads((P/'search/targeted-selection.json').read_text())
old=json.loads((P/'search/targeted-results.json').read_text())
for name,sha in d['sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
assert len(d['records'])==8 and d['pairs']==3968 and d['codes_reused']==4 and d['new_noise_samples']==0
assert math.floor(math.log(49)*(1<<20)+.5)==4080869
assert d['settings']=={'p':.02,'alpha':.8,'iterations':50,'scale':1<<20,'prior':4080869,'saturation':50*(1<<20)}
patterns=t.binary_errors(32)[33:];total=witnesses=compiled_checks=0
with tempfile.TemporaryDirectory(prefix='p11-trajectories-validate-') as temp:
    binary=Path(temp)/'minsum'
    subprocess.run(['c++','-std=c++17','-O2',str(p.OLD/'minsum.cpp'),'-o',str(binary)],check=True)
    for rec in d['records']:
        pid,ri,sector=rec['profile'],rec['representative'],rec['sector']
        selected=s['families'][0]['profiles'][pid]['representatives'][ri];code=selected['code']
        assert rec['parameters']==code['parameters'] and rec['bx']==code['bx'] and rec['bz']==code['bz']
        hx,hz,vx,vz=q.expansion(code['bx'],code['bz'],2);h=hz if sector=='x' else hx
        assert rec['check_rows']==h
        stored=old['families'][0]['profiles'][pid]['representatives'][ri]['low_weight']['sector_'+sector]
        hm=list(map(p.decoder.rowmask,h));cache={};counts=Counter()
        compiled=p.decoder.engine(binary,h,32,[(.02,p.decoder.bit_string(e,32)) for e in patterns],50,.8)
        for index,(e,pair,out) in enumerate(zip(patterns,rec['pairs'],compiled),33):
            total+=1;compiled_checks+=1
            target=p.decoder.syndrome(hm,e)
            if target not in cache:cache[target]=tr.partition(h,32,target)
            part=cache[target];static=tr.certify(h,32,target,part)
            assert pair['partition_sha256']==hashlib.sha256(json.dumps(part,sort_keys=True).encode()).hexdigest()
            assert all(pair[key]==value for key,value in static.items())
            assert pair['support']==[v for v in range(32) if e>>v&1] and pair['error_hex']==hex(e)
            assert pair['target_syndrome_hex']==hex(sum(v<<c for c,v in enumerate(target)))
            assert pair['archived_status']==stored['status_codes'][index]
            trace=pair['trajectory']
            assert trace['iterations']==out[0] and trace['matched']==out[1]
            assert trace['estimate_hex']==hex(p.decoder.string_mask(out[2]))==stored['estimate_hex'][index]
            assert len(trace['decisions_hex'])==trace['iterations'] and trace['decisions_hex'][-1]==trace['estimate_hex']
            assert (pair['archived_status']=='2')==(not trace['matched'])
            if pair['syndrome_obstruction']:assert not trace['matched']
            counts[(pair['archived_status'],pair['syndrome_obstruction'])]+=1
            if 'partition' in pair:
                assert pair['partition']==part
                reference_trace(h,e,trace);witnesses+=1
            assert (trace['period']==0)==(trace['repeat_start']==-1)
        assert rec['counts']==[{'status':status,'obstruction':obs,'count':num} for (status,obs),num in sorted(counts.items())]
        want={('0',False):288,('1',False):48,('2',False):32,('2',True):128} if pid==0 else {('0',False):240,('1',False):80,('2',False):64,('2',True):112}
        assert dict(counts)==want
assert total==compiled_checks==3968 and witnesses==6
source=R/'formalization/dyadic-rank/DyadicMinSumTrajectory.lean'
assert source.read_text()==gen.data_source()+(P/'search/trajectory-proof-body.txt').read_text()
assert not any(token in source.read_text() for token in ('sorry','admit','native_decide','axiom '))
w=next(pair for rec in d['records'] if (rec['profile'],rec['representative'],rec['sector'])==(2,0,'x') for pair in rec['pairs'] if pair['error_hex']=='0x20001')
assert (w['q_class_count'],w['r_class_count'],w['posterior_class_count'])==(7,7,3)
assert set(w['posterior_syndrome_generators_hex'])=={'0x0'}
assert len(set(w['trajectory']['decisions_hex']))==2 and not w['trajectory']['matched']
print('PASS: 3968 fresh original-engine replay checks, all archived responses, local partition identities, six complete Python/C++ message traces, deterministic Lean graph-data generation and all census totals.')

analysis=json.loads((P/'search/trajectory-analysis.json').read_text())
for a in analysis:
    for rep in a['representatives']:
        masses=rep['masses'];den=int(rep['denominator'])
        assert den==50**64
        assert all(masses[k]==int(v)/den for k,v in rep['mass_numerators'].items())
        prior=old['families'][0]['profiles'][a['profile']]['representatives'][rep['representative']]['low_weight']
        assert sum(int(v) for k,v in rep['mass_numerators'].items() if k!='success')==int(prior['failure_mass_numerator'])
        assert sum(int(v) for v in rep['mass_numerators'].values())==int(prior['enumerated_mass_numerator'])
log=(P/'trajectory-lean-check.txt').read_text()
assert log.count('depends on axioms:')==12
assert not any(token in log for token in ('sorryAx','error:','warning:'))
print('PASS: all exact probability decomposition totals agree with the frozen archive; twelve Lean axiom reports contain standard foundations only.')
