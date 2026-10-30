"""Complete eight-event law sharing the immutable owner-capacity variables."""
from fractions import Fraction as Q
from two_basis_owner_star_capacity import ROOT,sha,read,decode,empty,term,plus,cell
from physical_integer_form_rows import coordinate
XX=[614,281];ZZ=[51,83]
def pair_variable(M,m,side):return term(1,len(M['variables'])+2*m+(side=='Z'))
def edge(M,m,x,z):
    p=M['owner_flow_extension']['physical_pairs'];return cell(M,m,p.index([x,z]))
def center_atoms(M,m):
    sx=pair_variable(M,m,'X');sz=pair_variable(M,m,'Z')
    y=[M['sectors']['X']['allocations'][m][x] for x in XX]+[M['sectors']['Z']['allocations'][m][z] for z in ZZ]
    t={(i,j+2):edge(M,m,x,z) for i,x in enumerate(XX) for j,z in enumerate(ZZ)}
    atoms={3:sx,12:sz}
    for (i,j),v in t.items():atoms[(1<<i)|(1<<j)]=v
    for i in range(4):
        e=plus(y[i],sx if i<2 else sz,-1)
        for ij,v in t.items():
            if i in ij:e=plus(e,v,-1)
        atoms[1<<i]=e
    e=M['lambda_expressions'][m]
    for v in y:e=plus(e,v,-1)
    for v in t.values():e=plus(e,v)
    atoms[0]=plus(plus(e,sx),sz)
    assert len(atoms)==11
    total=empty()
    for v in atoms.values():total=plus(total,v)
    assert total==M['lambda_expressions'][m]
    return atoms
def appended_rows(M,allowed_masks):
    assert M['X_anchors']==[80,512] and M['Z_anchors']==[186,433]
    assert len(M['variables'])==22481
    rows=[]
    for side,events in [('X',XX),('Z',[720+z for z in ZZ])]:
        e=term(0,coordinate(*events)+1,-1)
        for m in range(16):e=plus(e,pair_variable(M,m,side))
        rows.append(dict(name='k22_sum_'+side,relation='=',expression=e,kind='global_same_sector_pair',side=side))
    for m in range(16):
        atoms=center_atoms(M,m)
        # Cross-pair nonnegativity already exists in the parent flow model.
        for c in [3,12,1,2,4,8,0]:
            rows.append(dict(name=f'k22_atom_{m}_{c}',relation='<=',expression=plus(empty(),atoms[c],-1),kind='center_atom_nonnegative',mask=m,center_mask=c))
    for m in range(16):
        for c,e in sorted(center_atoms(M,m).items()):
            if m|(c<<4) not in set(allowed_masks):
                rows.append(dict(name=f'k22_forbidden_{m}_{c}',relation='=',expression=e,kind='forbidden_eight_event_atom',mask=m,center_mask=c,full_mask=m|(c<<4)))
    return rows
def pack(e):return [[[j,str(v)] for j,v in sorted(d.items())] for d in e]
def unpack(e):return tuple({int(j):Q(v) for j,v in d} for d in e)
def evaluate(e,features,parameters):
    return sum((v*features[j] for j,v in e[0].items()),Q(0))+sum((v*parameters[j] for j,v in e[1].items()),Q(0))
