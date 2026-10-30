"""Replay the supplied EM3 event and logical-basis algebra audits."""
import json,math
from pathlib import Path
import stim,numpy as np
from code_parameters import basis
root=Path(__file__).parent;source=root/'inputs'/'bolza';events=[];logicals=[]
for p in sorted(source.glob('*_l=1_*noise_model=EM3*')):
    blocks=[];es=[]
    for ins in stim.Circuit(p.read_text()).flattened():
        if ins.name=='E':es.append(ins);continue
        if not es:continue
        assert ins.name=='M'
        qubits=sorted({t.value for e in es for t in e.targets_copy()});assert qubits[-1]==16 and len(qubits)==3
        vals=[]
        for e in es:
            v=0
            for t in e.targets_copy():
                j=qubits.index(t.value)
                if j==2:
                    assert t.is_x_target;v^=16
                else:
                    if t.is_x_target or t.is_y_target:v^=1<<(2*j)
                    if t.is_z_target or t.is_y_target:v^=1<<(2*j+1)
            vals.append(v)
        assert sorted(vals)==list(range(1,32))
        probs={e.gate_args_copy()[0] for e in es};assert len(probs)==1
        q=probs.pop();blocks.append(q);es=[]
    assert not es
    events.append(dict(file=p.name,blocks=len(blocks),verified_all_31_nonzero_generators_in_every_block=True,
        stored_q_values=sorted(set(blocks)),implied_p_values=sorted({-math.expm1(16*math.log1p(-2*q)) for q in blocks})))
for l in [1,2]:
    regs={}
    for b in ['X','Z']:
        p=next(source.glob(f'*_l={l}_*basis={b}*noise_model=SDEM3*'))
        regs[b]=stim.Circuit(p.read_text()).detecting_regions(targets=['L'],ticks=[7])
    x=[regs['X'][stim.target_logical_observable_id(i)][7] for i in range(4)]
    z=[regs['Z'][stim.target_logical_observable_id(i)][7] for i in range(4)]
    cross=[[int(not a.commutes(b)) for b in z] for a in x]
    rank=len(basis([sum(v<<j for j,v in enumerate(row)) for row in cross]))
    assert rank==4
    logicals.append(dict(l=l,tick=7,X=[str(a) for a in x],Z=[str(a) for a in z],
        X_commute=all(a.commutes(b) for a in x for b in x),Z_commute=all(a.commutes(b) for a in z for b in z),
        cross_commutation_matrix=cross,cross_rank=rank))
for name,data in [('em3_generator_audit',events),('logical_basis_audit',logicals)]:
    (root/'provenance'/f'{name}.json').write_text(json.dumps(data,indent=2)+'\n')
