#!/usr/bin/env python3
"""One guarded compiler for original, generic-orbit, and priced basis cuts."""
from fractions import Fraction
import numpy as np
from scipy.sparse import vstack
from accepted_full_partner_rows import matrix as original_matrix, normalized
from verify_full_partner_projection import read, sha, ROOT
from verify_full_partner_projection_generic import matrix as generic_matrix
from verify_full_partner_orbit_cap_lagrange import matrix as priced_matrix


def matrix(banks, replays):
    banks,replays=list(banks),list(replays)
    assert banks and len(banks)==len(replays)
    matrices=[];bounds=[];metadata=[]
    for bank_path,replay_path in zip(banks,replays):
        bank,receipt=read(bank_path),read(replay_path)
        if bank['status']=='EXACT_PRICED_SUPPORT_CANDIDATE':
            consumer='verify_full_partner_orbit_cap_lagrange.py'
            M,rhs,rows=priced_matrix([bank_path],[replay_path])
        elif bank['status']=='EXACT_SUPPORT_CUT_CANDIDATE' and 'orbit' in receipt:
            consumer='verify_full_partner_projection_generic.py'
            M,rhs,rows=generic_matrix([bank_path],[replay_path])
            for k,result in enumerate(receipt['results']):
                first,last=M.indptr[k:k+2]
                assert {int(j):Fraction(int(c)) for j,c in zip(M.indices[first:last],M.data[first:last])}=={j:Fraction(c) for j,c in result['compiled_owner_row']}
                assert Fraction(int(rhs[k]))==Fraction(result['owner_rhs'])
        else:
            assert bank['status']=='EXACT_SUPPORT_CUT_CANDIDATE' and bank['orbit']==32
            consumer='verify_full_partner_projection.py'
            M,rhs,rows=original_matrix([bank_path],[replay_path])
        assert receipt['consumer_sha256']==sha(ROOT/consumer)
        assert all(sha(ROOT/p)==digest for p,digest in receipt['dependencies'].items())
        matrices.append(M);bounds.extend(map(int,rhs));metadata.extend([{**row,'accepted_consumer':consumer} for row in rows])
    return vstack(matrices,format='csr'),np.array(bounds,dtype=np.int64),metadata
