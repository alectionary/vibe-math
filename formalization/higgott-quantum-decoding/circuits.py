"""Reconstruct EM3 channels from thesis section 7.2.5.1; preserve source schedule."""
import math
from pathlib import Path
import stim

def with_duration(c, subrounds):
    assert subrounds in (48,96)
    out=stim.Circuit(); repeats=0
    for ins in c:
        if isinstance(ins,stim.CircuitRepeatBlock):
            repeats+=1
            assert ins.repeat_count==15
            out+=ins.body_copy()*(subrounds//6-1)
        else:out.append(ins)
    assert repeats==1
    assert sum(i.name=='MPP' for i in out.flattened())==subrounds
    return out

def em3(c,p,rounded=False):
    """Each MPP product is replaced by a noiseless helper and 31 correlated errors.

    q maps independent binary generators to the uniform five-bit mixture.
    Helper qubits are simulation bookkeeping, not EM3 physical qubits.
    """
    helper=c.num_qubits;out=stim.Circuit()
    q=-math.expm1(math.log1p(-p)/16)/2
    if rounded:q=float(f'{q:.6g}')
    def apply(part):
        result=stim.Circuit()
        for ins in part:
            if isinstance(ins,stim.CircuitRepeatBlock):
                result+=apply(ins.body_copy())*ins.repeat_count;continue
            if ins.name=='MPP':
                for pair in ins.target_groups():
                    assert len(pair)==2
                    result.append('R',[helper])
                    for t in pair:
                        gate='XCX' if t.is_x_target else 'YCX' if t.is_y_target else 'CX'
                        result.append(gate,[t.value,helper])
                    for a in range(4):
                        for b in range(4):
                            for flip in range(2):
                                terms=[]
                                for pauli,t in zip([a,b],pair):
                                    if pauli:terms.append([None,stim.target_x,stim.target_y,stim.target_z][pauli](t.value))
                                if flip:terms.append(stim.target_x(helper))
                                if terms and p:result.append('E',terms,q)
                    result.append('M',[helper])
            elif ins.name=='R':
                result.append(ins)
                if p:result.append('X_ERROR',ins.targets_copy(),p/2)
            elif ins.name=='M':
                if p:result.append('X_ERROR',ins.targets_copy(),p/2)
                result.append(ins)
            else:result.append(ins)
        return result
    return apply(c)

def bolza(source,l,basis,p,subrounds=48):
    path=next(Path(source).glob(f'*_l={l}_*basis={basis}*noise_model=SDEM3*'))
    return em3(with_duration(stim.Circuit(path.read_text()),subrounds),p)

def planar(distance,basis,p,subrounds=48,noise_model='EM3_v2'):
    from hcb.codes.honeycomb.layout import HoneycombLayout
    layout=HoneycombLayout(data_width=2*distance,data_height=3*distance,rounds=subrounds//3,
        noise_level=p,noisy_gate_set=noise_model,tested_observable=basis)
    return layout.noisy_circuit()
