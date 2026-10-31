#!/usr/bin/env python3
"""Unconditioned775-feature support by union of two exact anchor branches.

For a fixed selected X mask every opposite full basis either contains a fixed
Z anchor or does not. Therefore max of the two anchored supports equals the
unconditioned support for any signed objective. No rotation reduction is used
by this adapter; callers choose and justify their own input mask domain.
Ties prefer the absent branch; a different optimal basis order is harmless.
The frozen anchor backend retains its exact overflow/rational fallback.
"""
from pathlib import Path
import numpy as np
from full_partner_anchor_native import NativeAnchorBatch

ROOT=Path(__file__).resolve().parent

class NativeFullPartnerBatch:
    def __init__(self,masks,orbit=32,anchor=80,library=ROOT/'coupling-results/anchor-native-accepted.dylib'):
        self.masks=list(masks);self.orbit=orbit;self.anchor=anchor
        self.batch=NativeAnchorBatch(self.masks,anchor=anchor,orbit=orbit,library=library)
        self.branch_rows=[[] for _ in self.masks]
        for row,flat in enumerate(self.batch.feasible_indices):
            self.branch_rows[int(flat)//2].append(row)
        if any(not rows for rows in self.branch_rows):
            self.batch.close()
            raise ValueError('Unconditioned support requires at least one feasible anchor branch per input mask')

    def price(self,coefficients):
        if len(coefficients)!=775:raise ValueError('Expected775 coefficients')
        result=self.batch.price(list(coefficients)+[0]*737)
        pick=np.array([max(rows,key=lambda row:result['values'][row]) for rows in self.branch_rows],dtype=np.int32)
        return {'values':result['values'][pick],'full_values':result['full_values'][pick],
                'bases':result['bases'][pick],'selected_anchor':np.array([self.batch.branches[row][1] for row in pick],dtype=bool),
                'backend':result['backend']}

    def close(self):self.batch.close()
