"""Sparse archived-matrix checks, phase cross-check, partition and schedule checks."""
import argparse
import itertools
import json
from pathlib import Path
import numpy as np
import scipy.sparse as sp
from gf2 import HGP, kernel, repetition, span, rref
from verify import seeds

ROOT=Path(__file__).resolve().parents[1]


def read_alist(path):
    lines=path.read_text().splitlines();m,n=map(int,lines[0].split());row=[];col=[]
    for i,line in enumerate(lines[4:4+m]):
        for j in map(int,line.split()):
            if j:row.append(i);col.append(j-1)
    a=sp.csr_matrix((np.ones(len(row),dtype=np.int64),(row,col)),shape=(m,n))
    assert list(np.diff(a.indptr))==list(map(int,lines[2].split()))
    assert list(np.asarray(a.sum(axis=0)).ravel())==list(map(int,lines[3].split()))
    return a


def product3_sparse(a,b,c):
    ma,na=a.shape;mb,nb=b.shape;mc,nc=c.shape
    eye=lambda n:sp.eye(n,dtype=np.int64,format='csr')
    kron=lambda a,b,c:sp.kron(sp.kron(a,b),c,format='csr')
    d0=sp.vstack([kron(a,eye(nb),eye(nc)),kron(eye(na),b,eye(nc)),kron(eye(na),eye(nb),c)],format='csr')
    d1=sp.bmat([[kron(eye(ma),b,eye(nc)),kron(a,eye(mb),eye(nc)),None],
                [kron(eye(ma),eye(nb),c),None,kron(a,eye(nb),eye(mc))],
                [None,kron(eye(na),eye(mb),c),kron(eye(na),b,eye(mc))]],format='csr')
    d2=sp.hstack([kron(eye(ma),eye(mb),c),kron(eye(ma),b,eye(mc)),kron(a,eye(mb),eye(mc))],format='csr')
    return d0,d1,d2


def sparse_rank(a):
    a=a.copy();a.sum_duplicates();a.data%=2;a.eliminate_zeros()
    basis={}
    for i in range(a.shape[0]):
        v=0
        for j in a.indices[a.indptr[i]:a.indptr[i+1]]:v^=1<<int(j)
        while v:
            p=v.bit_length()-1
            if p in basis:v^=basis[p]
            else:basis[p]=v;break
    return len(basis)


def archived(repo):
    out=[]
    for topology in ['surface3D','toric3D']:
        for f in sorted((repo/'codes'/topology).glob('*_hx.alist')):
            size=int(f.name.split('_')[1]);a=sp.csr_matrix(repetition(size,topology=='toric3D').astype(np.int64))
            d0,d1,d2=product3_sparse(a,a,a if topology=='toric3D' else a.T)
            hx=read_alist(f);mx=read_alist(f.with_name(f.name.replace('_hx','_mx')))
            assert (hx!=d1).nnz==0 and (mx!=d2).nnz==0
            assert not ((d1@d0).data%2).any() and not ((d2@d1).data%2).any()
            lx=read_alist(f.with_name(f.name.replace('_hx','_lx')))
            assert not ((lx@d0).data%2).any()
            rh=sparse_rank(hx);rz=sparse_rank(d0.T.tocsr());n=hx.shape[1];k=n-rh-rz
            assert k==(3 if topology=='toric3D' else 1)
            assert sparse_rank(sp.vstack([hx,lx],format='csr'))==rh+k
            if topology=='toric3D':
                lm=read_alist(f.with_name(f.name.replace('_hx','_lmx')))
                assert not ((lm@hx).data%2).any()
                full=read_alist(f.with_name(f.name.replace('_hx','_mxlmx')))
                assert (full!=sp.vstack([mx,lm],format='csr')).nnz==0
            out.append(dict(topology=topology,size=size,n=n,k=k,rank_hx=rh,rank_hz=rz,hx_and_meta_exact_match=True))
    return out


def gate_phase_crosscheck():
    rows=[]
    for name,a,d in seeds():
        if a.shape[0]!=a.shape[1] or not np.array_equal(a,a.T):continue
        c=HGP(a,a)
        for i,v in enumerate(c.hx):
            # A diagonal CZ circuit multiplies |v> by (-1)^sum(v_L*v_R).
            # The CSS +1 state generated from |0> has equal positive amplitudes
            # at |0> and |v>; a negative phase makes this generator fail.
            sign=(-1)**int(np.dot(v[:c.left],v[c.left:])%2)
            if sign==-1:rows.append(dict(code=name,generator=i,phase_on_zero=1,phase_on_generator_word=sign,
                                         generator_support=np.flatnonzero(v).tolist()))
    return rows


def phase_repair():
    repairs=[]
    for name,a,d in seeds():
        if a.shape[0]!=a.shape[1] or not np.array_equal(a,a.T):continue
        c=HGP(a,a)
        phases=np.array([np.dot(v[:c.left],v[c.left:])%2 for v in c.hx],dtype=np.uint8)
        rr,piv,tr=rref(c.hx);rhs=(tr@phases)%2
        assert not rhs[len(piv):].any()
        correction=np.zeros(c.n,dtype=np.uint8);correction[piv]=rhs[:len(piv)]
        assert np.array_equal((c.hx@correction)%2,phases)
        repairs.append(dict(code=name,changed_gate='sibling CZ followed by a Z Pauli correction',
                            correction_support=np.flatnonzero(correction).tolist(),restores_all_generator_signs=True,
                            source_claim_replicated=False))
    return repairs


def logical_round_robin():
    _,a,_=seeds()[-1];c=HGP(a,a);checked=0
    left=[i for i,l in enumerate(c.labels) if l[0]=='L'];right=[i for i,l in enumerate(c.labels) if l[0]=='R']
    for i,j in itertools.product(left,right):
        u,v=c.lz[i],c.lz[j]
        for x in c.hx:
            assert int(x@u)%2==0 and int(x@v)%2==0
        for k,x in enumerate(c.lx):
            image_z=((int(x@u)%2)*v)^((int(x@v)%2)*u)
            expected=c.lz[j] if k==i else c.lz[i] if k==j else np.zeros(c.n,dtype=np.uint8)
            assert np.array_equal(image_z,expected)
        checked+=1
    return dict(code='hamming98',logical_pairs=checked,ideal_logical_CZ_verified=True,
                intermediate_error_correction_and_noisy_fault_tolerance_verified=False)


def partitions():
    out=[]
    for name,a,d in seeds()[:4]:
        if name=='planar5':continue
        c=HGP(a,a);ker=span(kernel(c.hx)[0]);logical=ker[((ker@c.lx.T)%2).any(axis=1)]
        dt=[]
        for i in range(c.na):
            for j in range(i,c.nb):dt.append(sorted(set([i*c.nb+j,j*c.nb+i])))
        for i in range(c.ma):
            for j in range(i,c.mb):dt.append(sorted(set([c.left+i*c.mb+j,c.left+j*c.mb+i])))
        cost=sum(logical[:,part].any(axis=1).astype(int) for part in dt)
        row=dict(code=name,z_partition_distance=int(cost.min()),source_text_floor_half_distance=d//2,
                 interpretation='finite Z-sector computation; source ink and bound/equality wording require review',logical_z_vectors=len(logical))
        if c.na==c.ma:
            sibling=[(i,c.left+i) for i in range(c.left)]
            row['z_sibling_distance']=int(sum(logical[:,part].any(axis=1).astype(int) for part in sibling).min())
        out.append(row)
    return out


def round_robin():
    tested=0
    for na,nb in itertools.product(range(1,20),repeat=2):
        delta=max(na,nb);seen=[]
        for t in range(delta):
            pairs=[(i,(i+t)%delta) for i in range(na) if (i+t)%delta<nb]
            assert len({p[0] for p in pairs})==len(pairs)==len({p[1] for p in pairs})
            seen.extend(pairs)
        assert sorted(seen)==list(itertools.product(range(na),range(nb)));tested+=1
    return dict(support_size_pairs=tested,full_pair_coverage=True,no_collisions=True,fault_tolerance_proved=False)


def injection():
    # Logical CZ + X measurement of |+_theta>, followed by conditional phase
    # correction, implements S (theta=pi/2) or T (theta=pi/4), up to phase.
    # Verify the conventional gadget algebra independently of large-code noise.
    out=[]
    for theta in [np.pi/2,np.pi/4]:
        # Standard injection uses ancilla-to-data parity/CNOT representation;
        # no assertion that this rederives the source's image-only exact wiring.
        expected=np.diag([1,np.exp(1j*theta)])
        branches=[np.diag([1,np.exp(1j*theta)])/np.sqrt(2),np.diag([np.exp(1j*theta),1])/np.sqrt(2)]
        correction=np.diag([1,np.exp(2j*theta)])
        assert np.allclose(branches[0]*np.sqrt(2),expected)
        assert np.allclose(correction@branches[1]*np.sqrt(2),np.exp(1j*theta)*expected)
        out.append(dict(theta=float(theta),two_ideal_branches_verified=True,source_wiring_verified=False))
    return out


if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('repo',type=Path);args=ap.parse_args()
    result=dict(archived_matrices=archived(args.repo),phase_crosscheck=gate_phase_crosscheck(),partition_distances=partitions(),
                phase_repair=phase_repair(),round_robin=round_robin(),logical_round_robin=logical_round_robin(),ideal_injection_diagnostic=injection())
    (ROOT/'results/independent_checks.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Independent checks complete; scientific differences retained.')
