"""Independent differential Pauli-frame sampler for the 16-qubit source schedule.

Stim is used only by load_schedule to parse source syntax, and by main for the
comparison. sample uses only NumPy, direct pair parity and categorical events.
Ideal random gauge outcomes cancel in detector/observable parities; this does
not independently construct the ideal stabilizer state or source annotations.
"""
import sys,json,time
from pathlib import Path
import numpy as np
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root))

def load_schedule(basis):
    import stim
    from circuits import with_duration
    path=next((root/'inputs/bolza').glob(f'*_l=1_*basis={basis}*noise_model=SDEM3*'))
    c=with_duration(stim.Circuit(path.read_text()),48);ops=[]
    for ins in c.flattened():
        name=ins.name
        if name=='MPP':
            for pair in ins.target_groups():ops.append(('PAIR',[(t.value,'X' if t.is_x_target else 'Y' if t.is_y_target else 'Z') for t in pair]))
        elif name in ('R','H','M'):ops.append((name,[t.value for t in ins.targets_copy()]))
        elif name in ('DETECTOR','OBSERVABLE_INCLUDE'):ops.append((name,[t.value for t in ins.targets_copy()],int(ins.gate_args_copy()[0]) if name=='OBSERVABLE_INCLUDE' else None))
        elif name!='TICK':raise ValueError(name)
    return ops

def sample(ops,n,p,seed,forced=None):
    rng=np.random.default_rng(seed);x=np.zeros((n,16),dtype=np.uint8);z=x.copy();rec=[];det=[];obs=np.zeros((n,4),dtype=np.uint8)
    for index,op in enumerate(ops):
        name,args=op[:2]
        if name=='R':
            x[:,args]=0;z[:,args]=0;x[:,args]=rng.random((n,len(args)))<p/2
        elif name=='H':x[:,args],z[:,args]=z[:,args].copy(),x[:,args].copy()
        elif name=='PAIR':
            parity=np.zeros(n,dtype=np.uint8)
            for q,axis in args:
                if axis in ('X','Y'):parity^=z[:,q]
                if axis in ('Z','Y'):parity^=x[:,q]
            # Uniform five-bit event after parity extraction, equivalent to
            # the helper-based source channel. Includes the identity event.
            event=rng.integers(0,32,n,dtype=np.uint8);event*=rng.random(n)<p
            for j,(q,axis) in enumerate(args):
                x[:,q]^=(event>>(2*j))&1;z[:,q]^=(event>>(2*j+1))&1
            parity^=(event>>4)&1;rec.append(parity)
        elif name=='M':
            for q in args:rec.append(x[:,q]^(rng.random(n)<p/2))
        else:
            parity=np.zeros(n,dtype=np.uint8)
            for offset in args:parity^=rec[offset]
            if name=='DETECTOR':det.append(parity)
            elif name=='OBSERVABLE_INCLUDE':obs[:,op[2]]^=parity
            else:raise ValueError(name)
        if forced and index==forced[0]:
            (x if forced[2]=='X' else z)[:,forced[1]]^=1
    return np.array(det,dtype=np.uint8).T,obs

def to_stim(ops,forced):
    import stim
    c=stim.Circuit()
    for index,op in enumerate(ops):
        name,args=op[:2]
        if name=='PAIR':c.append('MPP',[getattr(stim,'target_'+axis.lower())(q) for q,axis in args[:1]]+[stim.target_combiner()]+[getattr(stim,'target_'+axis.lower())(q) for q,axis in args[1:]])
        elif name in ('R','H','M'):c.append(name,args)
        else:c.append(name,[stim.target_rec(v) for v in args],[] if name=='DETECTOR' else op[2])
        if index==forced[0]:c.append(forced[2]+'_ERROR',[forced[1]],1)
    return c

def main():
    import pymatching
    from circuits import bolza
    results=[]
    for b in ['X','Z']:
        ops=load_schedule(b);pair_ids=[i for i,o in enumerate(ops) if o[0]=='PAIR'];faults=[]
        for j in [0,7,100,len(pair_ids)-1]:
            for q in [0,1]:
                for axis in ['X','Z']:
                    f=(pair_ids[j],q,axis);a,o=sample(ops,4,0,1,f);dd,oo=to_stim(ops,f).compile_detector_sampler(seed=99).sample(4,separate_observables=True)
                    faults.append(dict(location=j,qubit=q,pauli=axis,detector_mismatches=int(np.count_nonzero(a!=dd)),observable_mismatches=int(np.count_nonzero(o!=oo))))
        c=bolza(root/'inputs/bolza',1,b,.001);m=pymatching.Matching.from_detector_error_model(c.detector_error_model(decompose_errors=True))
        t=time.monotonic();sample(ops,1000,.001,810);pilot=time.monotonic()-t
        f=nc=0
        for j in range(10):
            d,o=sample(ops,10000,.001,811+j);f+=int(np.any(m.decode_batch(d)!=o,axis=1).sum());nc+=int(np.any(o,axis=1).sum())
        d,o=c.compile_detector_sampler(seed=820).sample(100000,separate_observables=True);sf=int(np.any(m.decode_batch(d)!=o,axis=1).sum())
        r=dict(basis=b,shots=100000,independent_failures=f,stim_failures=sf,independent_uncorrected=nc,stim_uncorrected=int(np.any(o,axis=1).sum()),pilot_1000_seconds=pilot,elapsed_seconds=time.monotonic()-t,fault_checks=faults);results.append(r);print(r,flush=True)
    (Path(__file__).parent/'independent_frame_results.json').write_text(json.dumps(results,indent=2)+'\n')
if __name__=='__main__':main()
