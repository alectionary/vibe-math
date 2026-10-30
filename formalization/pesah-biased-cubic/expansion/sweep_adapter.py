"""Historical sweep code plus modern PyMatching2.3.1; explicitly limited scope.

Historical source is imported externally. The only matching API adaptation is
spacelike_weights -> weights and removal of obsolete num_neighbours=None.
"""
import pathlib,sys
import numpy as np
np.product=np.prod
from pymatching import Matching

def load(source):
 sys.path.insert(0,str(source))
 from bn3d.tc3d import ToricCode3D,SweepMatchDecoder
 from bn3d.deform import DeformedSweepMatchDecoder
 from bn3d.noise import PauliErrorModel
 return ToricCode3D,SweepMatchDecoder,DeformedSweepMatchDecoder,PauliErrorModel

class Matcher:
 def __init__(self,H,weights=None):self.matching=Matching(H,weights=weights)
 def decode(self,syndrome,**kwargs):return self.matching.decode(syndrome)

def build(source,L,p,r,deformed,seed):
 C,S,D,E=load(source);code=C(L);decoder=D(E(*r),p) if deformed else S();decoder._sweeper._rng=np.random.default_rng(seed)
 nfaces=3*L**3;decoder._matcher._n_faces[code.label]=nfaces
 weights=decoder._matcher.get_deformed_weights(code) if deformed else None
 decoder._matcher._matchers[code.label]=Matcher(code.Hx,weights)
 return code,decoder
