#!/usr/bin/env python3
"""Compile accepted1512-feature cuts alongside the preceding row families."""
import numpy as np
from scipy.sparse import vstack
from accepted_multi_orbit_rows import matrix as older_matrix,normalized
from verify_anchor_partner_projection import matrix as anchor_matrix,read


def matrix(banks,replays):
    assert banks and len(banks)==len(replays);matrices=[];bounds=[];metadata=[]
    for path,replay in zip(banks,replays):
        bank=read(path)
        if bank['status']=='EXACT_ANCHORED_SUPPORT_CUT_CANDIDATE':
            M,rhs,rows=anchor_matrix([path],[replay])
            rows=[{**row,'accepted_consumer':'verify_anchor_partner_projection.py'} for row in rows]
        else:M,rhs,rows=older_matrix([path],[replay])
        matrices.append(M);bounds.extend(map(int,rhs));metadata.extend(rows)
    return vstack(matrices,format='csr'),np.array(bounds,dtype=np.int64),metadata
