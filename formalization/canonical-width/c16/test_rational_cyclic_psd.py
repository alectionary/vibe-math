#!/usr/bin/env python3
"""Ground-truth identity and indefinite controls for integer cyclic PSD replay."""
from pathlib import Path
import argparse,json,copy
from rational_cyclic_psd import dyadic_blocks,matrix_hash,verify,read


def main():
    ap=argparse.ArgumentParser();ap.add_argument('dual',type=Path);ap.add_argument('preconditioners',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    identity={'period':16,'denominator':1,'constant':1,'mean':[0,0],'D':{str(h):[[int(h==0 and i==j) for j in range(2)] for i in range(2)] for h in range(9)}}
    blocks,_=dyadic_blocks(identity);cert={'source_dual_matrix_SHA256':matrix_hash(identity),'preconditioner_denominator':1,'preconditioners':[[[int(i==j) for j in range(B.nrows())] for i in range(B.nrows())] for B in blocks]};verify(identity,cert)
    bad=copy.deepcopy(identity);bad['D']['0'][0][0]=-1;badcert=copy.deepcopy(cert);badcert['source_dual_matrix_SHA256']=matrix_hash(bad)
    try:verify(bad,badcert)
    except AssertionError:pass
    else:raise AssertionError('Indefinite matrix accepted')
    # Independent direct integer congruence of a nontrivial known Gram matrix.
    from flint import fmpz_mat
    N=2;P=16;A={0:[[1,2],[0,1]],1:[[0,1],[-1,0]],3:[[2,0],[1,-1]]}
    K=fmpz_mat([[A.get((s-r)%P,[[0,0],[0,0]])[i][j] for s in range(P) for j in range(N)] for r in range(P) for i in range(N)])
    G=K.transpose()*K+fmpz_mat([[int(i==j) for j in range(32)] for i in range(32)])
    d={'period':16,'denominator':1,'constant':3,'mean':[0,0],'D':{str(h):[[int(G[i,h*N+j]) for j in range(N)] for i in range(N)] for h in range(9)}}
    B,_=dyadic_blocks(d);Y=fmpz_mat([[3]+[0]*32]+[[0]+[int(G[i,j]) for j in range(32)] for i in range(32)])
    vectors=[[1]*16]+[[1 if h%(2*k)==j else -1 if h%(2*k)==j+k else 0 for h in range(16)] for k in [1,2,4,8] for j in range(k)]
    E=[[0]*33 for _ in range(33)];E[0][0]=1
    for k,v in enumerate(vectors):
        for i in range(2):
            for h,a0 in enumerate(v):E[1+h*2+i][1+k*2+i]=a0
    E=fmpz_mat(E);T=E.transpose()*Y*E;offset=0;expected=fmpz_mat(33,33)
    for block in B:
        for i in range(block.nrows()):
            for j in range(block.nrows()):expected[offset+i,offset+j]=block[i,j]
        offset+=block.nrows()
    assert T==expected
    data=read(a.dual);real=read(a.preconditioners);rejected=[]
    for kind in ['wrong_matrix_hash','zero_preconditioner_row','negative_denominator']:
        c=copy.deepcopy(real)
        if kind=='wrong_matrix_hash':c['source_dual_matrix_SHA256']='0'*64
        if kind=='zero_preconditioner_row':c['preconditioners'][0][0]=[0]*len(c['preconditioners'][0][0])
        if kind=='negative_denominator':c['preconditioner_denominator']=-1
        try:verify(data,c)
        except AssertionError:rejected.append(kind)
        else:raise AssertionError('Corruption accepted: '+kind)
    result={'status':'PASS','explicit_identity_dual_dimension':33,'indefinite_identity_mutation_rejected':True,'certificate_corruptions_rejected':rejected,'direct_known_Gram_congruence_entries':1089,'floating_point_operations_in_consumer':0};a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
