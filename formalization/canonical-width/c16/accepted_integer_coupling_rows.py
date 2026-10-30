#!/usr/bin/env python3
"""Compile accepted full-basis and universal physical integer-form rows."""
import numpy as np
from scipy.sparse import vstack
from accepted_anchor_coupling_rows import matrix as older_matrix,normalized
from verify_physical_integer_forms import matrix as integer_matrix
from verify_full_partner_projection import read

def matrix(banks,replays):
 assert banks and len(banks)==len(replays);matrices=[];bounds=[];metadata=[]
 for path,replay in zip(banks,replays):
  bank=read(path)
  if bank['status']=='EXACT_PHYSICAL_INTEGER_FORM_CANDIDATE':M,rhs,rows=integer_matrix([path],[replay])
  else:M,rhs,rows=older_matrix([path],[replay])
  matrices.append(M);bounds.extend(map(int,rhs));metadata.extend(rows)
 return vstack(matrices,format='csr'),np.array(bounds,dtype=np.int64),metadata
