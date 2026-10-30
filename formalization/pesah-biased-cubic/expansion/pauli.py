"""General Pauli sampling, sharing the preserved stage-1 cubic/BP/OSD engine.

A single categorical draw per qubit preserves the X/Z correlation of Y errors.
Hadamard conjugation swaps the two binary components on the first axis.
"""
import sys,pathlib
import numpy as np
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'simulation'))
from engine import lattice,Decoder

def direction(axis,bias):
    if axis=='depolarizing':return np.full(3,1/3)
    if bias=='inf':return np.eye(3)[{'X':0,'Y':1,'Z':2}[axis]]
    eta=float(bias);r=np.full(3,1/(2*(eta+1)));r[{'X':0,'Y':1,'Z':2}[axis]]=eta/(eta+1);return r

def sample(rng,n,p,r,generator):
    u=rng.random(n) if generator=='numpy' else np.fromiter((rng.random() for _ in range(n)),float,count=n)
    # Order X,Y,Z,I; threshold representation identical for both independent RNGs.
    labels=np.searchsorted(np.cumsum(p*np.asarray(r)),u,side='right')
    return ((labels==0)|(labels==1)).astype(np.uint8),((labels==1)|(labels==2)).astype(np.uint8)

def make(graph,p,r,deformed,iterations=10):
    V,F,_,_=graph;n=V.shape[1];rx,ry,rz=r
    px=np.full(n,p*(rx+ry));pz=np.full(n,p*(rz+ry))
    if deformed:px[:n//3],pz[:n//3]=pz[:n//3].copy(),px[:n//3].copy()
    return Decoder(V,px,iterations),Decoder(F,pz,iterations)

def trial(decoders,graph,ex,ez,deformed):
    V,F,S,M=graph;n=V.shape[1];ex=ex.copy();ez=ez.copy()
    if deformed:ex[:n//3],ez[:n//3]=ez[:n//3].copy(),ex[:n//3].copy()
    cx,ox=decoders[0].decode(decoders[0].sparse@ex%2);cz,oz=decoders[1].decode(decoders[1].sparse@ez%2)
    rx=ex^cx;rz=ez^cz
    invalid=bool(np.any(decoders[0].sparse@rx%2) or np.any(decoders[1].sparse@rz%2))
    point=bool(np.any(M@rx%2));loop=bool(np.any(S@rz%2))
    return np.array([invalid or point or loop,point,loop,ox,oz,invalid],int)
