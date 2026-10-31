#!/usr/bin/env python3
"""Bind accepted full-basis rows to their independent consumer and exact rows.

Numerical normalization changes no necessary half-space. Exact acceptance must
always use the original integer matrix, not its floating normalized copy.
"""
from fractions import Fraction
import numpy as np
from scipy.sparse import diags
from verify_full_partner_projection import ROOT, matrix as raw_matrix, read, sha


def matrix(certificates, replays):
    certificates, replays = list(certificates), list(replays)
    result, rhs, metadata = raw_matrix(certificates, replays)
    row_index = 0
    for certificate, replay_path in zip(certificates, replays):
        bank, receipt = read(certificate), read(replay_path)
        assert receipt['consumer_sha256'] == sha(ROOT/'verify_full_partner_projection.py')
        assert all(sha(ROOT/p) == digest for p, digest in receipt['dependencies'].items())
        assert receipt['profile_weights_fixed_in_separation'] is False
        assert receipt['point_sha256'] == bank['point_sha256']
        assert receipt['allowed_masks_independently_enumerated'] == bank['allowed_masks']
        assert receipt['representatives_independently_rebuilt'] == len(bank['representatives'])
        for accepted in receipt['results']:
            start, end = result.indptr[row_index:row_index+2]
            actual = {int(j): Fraction(int(c)) for j, c in zip(result.indices[start:end], result.data[start:end])}
            expected = {j: Fraction(c) for j, c in accepted['compiled_owner_row']}
            assert actual == expected and len(expected) == accepted['owner_row_nonzeros']
            assert Fraction(int(rhs[row_index])) == Fraction(accepted['owner_rhs'])
            row_index += 1
    assert row_index == result.shape[0]
    return result, rhs, metadata


def normalized(result, rhs):
    scales = np.array([max(1, abs(int(rhs[k])), *(abs(int(v)) for v in result.data[result.indptr[k]:result.indptr[k+1]])) for k in range(result.shape[0])], dtype=np.float64)
    assert np.all(np.isfinite(scales)) and np.all(scales > 0)
    return diags(1/scales) @ result.astype(np.float64), rhs.astype(np.float64)/scales, scales
