#!/usr/bin/env python3
"""Integer source-row and PSD consumer for a joint thin-family obstruction.

The numerical model, canonicalization, solver and dual-recovery programs are
not imported. The source graph's cyclic/sector symmetries justify moment
averaging, not an invariant selected frame. All linear terms must belong to
independently generated source-valid rows in the exchange quotient layout.
"""
from pathlib import Path
from collections import defaultdict, Counter
from itertools import product
import argparse
import gzip
import hashlib
import json
from flint import fmpq
from block_moment_dual import source_constraints, layout
from verify_pool_inverse_structure import simple, phase

ROOT=Path(__file__).resolve().parent


def read(p):
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())


def norm(terms,rhs,kind,zero=None):
    d=defaultdict(int)
    for j,v in terms:
        if j!=zero:d[j]+=v
    coeff=tuple(sorted((j,v) for j,v in d.items() if v))
    if kind=='eq' and coeff and coeff[0][1]<0:
        coeff=tuple((j,-v) for j,v in coeff);rhs=-rhs
    return coeff,int(rhs)


def coordinates(q):
    # Certificate coordinate contract: p, then S_h, then T_h. Symmetric
    # phases0/8 use upper-triangle row order; others use column order.
    keys=[('p',i) for i in range(q)]
    for kind in ['S','T']:
        for h in range(9):
            keys.extend((kind,h,i,j) for i,j in
                        ([(i,j) for i in range(q) for j in range(i,q)] if h in [0,8]
                         else [(i,j) for j in range(q) for i in range(q)]))
    ids={key:i for i,key in enumerate(keys)}
    def pair(kind,h,i,j):
        if h>8:h,i,j=16-h,j,i
        if h in [0,8] and i>j:i,j=j,i
        return ids[kind,h,i,j]
    p=[ids['p',i] for i in range(q)]
    S={h:[[pair('S',h,i,j) for j in range(q)] for i in range(q)] for h in range(16)}
    T={h:[[pair('T',h,i,j) for j in range(q)] for i in range(q)] for h in range(16)}
    C={h:[S[h][i]+T[h][i] for i in range(q)]+[T[h][i]+S[h][i] for i in range(q)] for h in range(16)}
    return p,S,T,p+p,C,len(keys)


def binary_rank(values):
    piv={}
    for v in values:
        while v:
            k=v.bit_length()-1
            if k not in piv:piv[k]=v;break
            v^=piv[k]
    return len(piv)


def prepare_source(source,families):
    X=[int(s,16) for s in (ROOT/'pools/xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (ROOT/'pools/zcoords.txt').read_text().split()]
    def rotate(v,h):
        if not h:return v
        out=0
        for i in range(8):
            block=(v>>(16*i))&65535
            out|=(((block<<h)|(block>>(16-h)))&65535)<<(16*i)
        return out
    assert all(v[16*i+h]==rotate(v[16*i],h) for v in [X,Z] for i in range(45) for h in range(16))
    # This literal involution of the bipartite pairing graph is enough for
    # sector-exchange averaging of every hypothetical frame in the case.
    assert all((x&z).bit_count()%2==(X[j]&Z[i]).bit_count()%2 for i,x in enumerate(X) for j,z in enumerate(Z))
    qd=source['dictionary'];maps=[]
    for side in ['X','Z']:
        lookup={tuple(map(tuple,v)):i for i,v in enumerate(source['tensor'][side+'_tensor_coordinates'])}
        out=[]
        for c in range(5):
            for t in range(9):
                for h in range(16):
                    v=simple([phase(w,h) for w in qd['X_left_dictionary'][t]],qd['X_right_factors'][c]) if side=='X' else simple(qd['Z_left_factors'][c],[phase(w,h) for w in qd['Z_right_dictionary'][t]])
                    out.append(lookup[tuple(map(tuple,v))])
        assert len(set(out))==720
        maps.append(out)
    selected=[9*c+i for c in families for i in range(9)]
    active=[{maps[s][16*i]//16 for i in selected} for s in [0,1]]
    assert active[0]==active[1]
    active=sorted(active[0]);q=len(active);lookup={v:i for i,v in enumerate(active)}
    p,S,T,fullp,fullC,V=coordinates(q);zero=V
    roots=[(side,)+divmod(maps[side][16*i],16) for side in [0,1] for i in range(45)]
    np=[p[lookup[a]] if a in lookup else zero for _,a,_ in roots]
    Cn={}
    for h in range(16):
        Cn[h]=[]
        for side,a,ha in roots:
            row=[]
            for other,b,hb in roots:
                row.append((S if side==other else T)[(hb+h-ha)%16][lookup[a]][lookup[b]] if a in lookup and b in lookup else zero)
            Cn[h].append(row)
    normal_vectors=[[raw[i] for i in ids] for raw,ids in zip([X,Z],maps)]
    patterns=[[sum(((normal_vectors[0][16*i]&normal_vectors[1][16*j+h]).bit_count()%2)<<h for h in range(16)) for j in range(45)] for i in range(45)]
    original_patterns=[[sum(((X[16*i]&Z[16*j+h]).bit_count()%2)<<h for h in range(16)) for j in active] for i in active]
    return active,p,S,T,fullp,fullC,V,np,Cn,patterns,normal_vectors,original_patterns


def source_rows(source,families):
    active,p,S,T,fp,C,V,np,Cn,patterns,vectors,orig_patterns=prepare_source(source,families)
    q=len(active);valid={};counts=Counter()
    def add(kind,terms,rhs=0,proof=('base',)):
        key=(kind,norm(terms,rhs,kind,V))
        if key not in valid:valid[key]=proof
    # Project the general source equations/bounds onto shared exchange moments.
    eq,ineq,(op,oc,_) = source_constraints(orig_patterns,16,128)
    rel={op[i]:fp[i] for i in range(2*q)}
    for h in range(16):
        for i,j in product(range(2*q),repeat=2):
            old,new=oc[h][i][j],C[h][i][j]
            assert old not in rel or rel[old]==new
            rel[old]=new
    for kind,rows in [('eq',eq),('ineq',ineq)]:
        for coeff,rhs in rows:add(kind,[(rel[j],v) for j,v in coeff],rhs)
    folder=ROOT/'inverse-four-hour-results'
    selected={(r['sector'],r['thin_mask'],r['thick_mask']) for r in read(folder/'lattice-source-rankcuts.json.gz')}
    for side in ['X','Z']:
        offset=0 if side=='X' else 45
        for cut in read(folder/('rank-rectangle-'+side+'.json')):
            cols=[offset+9*c+i for c in range(5) if cut['thin_mask']>>c&1 for i in range(9) if cut['thick_mask']>>i&1]
            proof=('rank',side,tuple(cols),cut['rank'])
            add('ineq',[(np[j],16) for j in cols],cut['rank'],proof)
            if (side,cut['thin_mask'],cut['thick_mask']) in selected:
                for i in range(90):add('ineq',[(Cn[h][i][j],1) for h in range(16) for j in cols]+[(np[i],-cut['rank'])],0,proof)
    from moment_triangle_cuts import constraint as triangle,literal_control
    from moment_integer_form_cuts import coefficients as form
    from moment_owner_cuts import coefficients as owner,neighbor_polynomials
    literal_control()
    for cut in read(folder/'lattice-source-triangles.json.gz'):
        coeff,rhs=triangle(cut,np,Cn,16);add('ineq',coeff,rhs,('triangle',))
    for cut in read(folder/'lattice-source-integer-forms.json.gz'):
        coeff,rhs=form(cut,np,Cn,16);add('ineq',coeff,rhs,('form',tuple(cut['events']),tuple(cut['weights']),cut['constant']))
    neighbors=neighbor_polynomials(patterns,16)
    for cut in read(folder/'all-owner-cuts.json.gz'):
        coeff,rhs=owner(cut,patterns,np,Cn,16,neighbors)
        add('ineq',coeff,rhs,('owner',cut['i'],cut['k'],cut['l']))
    for cut in read(folder/'lattice-source-circuits.json.gz'):
        offset=0 if cut['sector']=='X' else 45
        terms=[]
        for v in cut['circuit']:
            h=(v%16+cut['phase'])%16;j=offset+v//16;i=cut['anchor']
            terms.append((np[i] if h==0 and i==j else Cn[h][i][j],1))
        add('ineq',terms+[(np[cut['anchor']],-(len(cut['circuit'])-1))],0,('circuit',cut['sector'],tuple(cut['circuit'])))
    # Monomial-count caps are deliberately absent. This consumer does not
    # inherit their large enumeration as an unstated premise.
    return valid,(active,fp,C,V,np,Cn,patterns,vectors)


def verify(data,psd,source):
    families=data['X_thin_families']
    assert families==data['Z_thin_families']==sorted(set(families))
    assert set(families)<=set(range(5)) and data['target']==128 and data['period']==16
    valid,ctx=source_rows(source,families)
    active,fp,C,V,np,Cn,patterns,vectors=ctx
    assert active==data['original_active_orbits']
    r=[0]*V;b=data['constant'];proofs=set();counts=Counter()
    assert data['denominator']>0 and type(b) is int
    for term in data['linear_terms']:
        kind=term['kind'];assert kind in ['eq','ineq']
        assert type(term['rhs']) is int and type(term['multiplier']) is int
        assert all(type(j) is int and type(v) is int and 0<=j<V for j,v in term['coeff'])
        key=(kind,norm(term['coeff'],term['rhs'],kind))
        assert key in valid,('unknown_source_row',key)
        if kind=='ineq':assert term['multiplier']>=0
        proofs.add(valid[key]);counts[valid[key][0]]+=1
        b+=term['rhs']*term['multiplier']
        for j,v in term['coeff']:r[j]+=v*term['multiplier']
    rank_cases=0;circuits=0;owners=0;forms=0
    # Semantically check the non-Boolean rows actually used by the dual.
    neighbor_masks=None
    if any(p[0]=='owner' for p in proofs):
        neighbor_masks=[]
        for side in [0,1]:
            neighbor_masks.extend(sum(((x&z).bit_count()%2)<<j for j,z in enumerate(vectors[1-side])) for x in vectors[side])
    from moment_owner_cuts import common_events
    from itertools import product as assignments
    for proof in proofs:
        if proof[0]=='rank':
            _,side,cols,bound=proof;offset=0 if side=='X' else 45
            available=[c-offset for c in cols if np[c]!=V]
            assert bound>=0 and binary_rank(vectors[side=='Z'][16*c+h] for c in available for h in range(16))<=bound
            rank_cases+=1
        elif proof[0]=='circuit':
            _,side,circuit=proof
            assert binary_rank(vectors[side=='Z'][v] for v in circuit)<len(circuit)
            circuits+=1
        elif proof[0]=='owner':
            _,i,k,l=proof;cut={'i':i,'k':k,'l':l}
            expected=neighbor_masks[16*i]&neighbor_masks[16*k+l]
            observed=sum(1<<((j%45)*16+h) for j,h in common_events(cut,patterns,16))
            assert observed==expected;owners+=1
        elif proof[0]=='form':
            _,events,weights,constant=proof
            assert len(events)==len(weights) and all(type(v) is int for v in weights) and type(constant) is int
            for x in assignments([0,1],repeat=len(events)):
                s=constant+sum(a*b for a,b in zip(weights,x));assert s*(s-1)>=0
            forms+=1
    N=len(fp);P=16;D={int(h):M for h,M in data['D'].items()}
    for h in range(9,16):D[h]=list(map(list,zip(*D[16-h])))
    assert len(data['mean'])==N
    for i in range(N):r[fp[i]]-=2*P*data['mean'][i]
    for h in range(P):
        for i,j in product(range(N),repeat=2):r[C[h][i][j]]-=P*D[h][i][j]
    lower=sum(min(0,v) for v in r);gap=b-lower
    assert gap<0 and gap==data['box_gap_numerator']
    from rational_cyclic_psd import verify as verify_psd
    result=verify_psd(data,psd)
    return {'status':'PASS','theorem':'No full original-pool frame with both thin-family supports contained in '+str(families),
            'X_thin_families':families,'Z_thin_families':families,
            'source_C16_answered':families==list(range(5)),
            'moment_symmetry':'Only moments averaged under verified cyclic translation and sector exchange; no frame symmetry assumed.',
            'critical_monomial_cap_used':False,'moment_variables':V,'linear_terms':len(data['linear_terms']),
            'source_row_types':dict(counts),'rank_cases_checked':rank_cases,'circuit_cases_checked':circuits,
            'literal_owner_intersections_checked':owners,'integer_forms_checked':forms,
            'strict_box_corrected_gap_numerator':gap,'strict_gap':str(fmpq(gap,data['denominator'])),
            'PSD':result,'floating_point_operations_in_consumer':0}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('dual',type=Path);ap.add_argument('--psd',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    source=read(ROOT/'inversion-results/normal-form.json');result=verify(read(a.dual),read(a.psd),source)
    result['dual_sha256']=hashlib.sha256(a.dual.read_bytes()).hexdigest()
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['status','theorem','linear_terms','strict_gap','source_C16_answered']}),flush=True)


if __name__=='__main__':main()
