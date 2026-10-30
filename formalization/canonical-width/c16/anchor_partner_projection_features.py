#!/usr/bin/env python3
"""1512 features for one phase profile and one opposite anchor event.

The old775 invariant features retain their factor16 in expectations. The added
737 features are q_a, q_a P_t, q_a Q_jb and have no such factor. A fixed phase
anchor destroys the291-class support reduction: every4597 allowed mask must
be covered, with both anchor states. This module translates but proves no bound.
"""
from collections import Counter
from fractions import Fraction
from full_partner_projection_features import column_features as old_features, moment_target as old_target, moment_row as old_row, candidate_weights, mask_score
from projected_profile_moment_matrix import owner_coordinate

FEATURES=1512
LAYOUT='old775; q_a; q_a*P[16]; q_a*Q[45,16].ravel(C)'


def column_features(mask, selected, anchor=80):
    selected=tuple(map(int,selected));old=old_features(mask,selected);chosen=set(selected);qa=int(anchor in chosen)
    return (*old,qa,*(qa*int(mask>>t&1) for t in range(16)),*(qa*int(j in chosen) for j in range(720)))


def moment_target(owner, orbit=32, anchor=80):
    assert 0<=anchor<720 and anchor%16==0
    a=anchor//16
    return (*old_target(owner,orbit),owner[a],*(owner[owner_coordinate('T',t,a,orbit)] for t in range(16)),*(owner[owner_coordinate('S',b,a,j)] for j in range(45) for b in range(16)))


def moment_row(c, bound, orbit=32, anchor=80):
    assert len(c)==FEATURES and anchor%16==0
    row,rhs=old_row(c[:775],bound,orbit);row=Counter(row);a=anchor//16
    row[a]+=c[775]
    for t in range(16):row[owner_coordinate('T',t,a,orbit)]+=c[776+t]
    for j in range(45):
        for b in range(16):row[owner_coordinate('S',b,a,j)]+=c[792+16*j+b]
    return dict(sorted((j,Fraction(v)) for j,v in row.items() if v)),rhs


def local_score(mask, state, c):
    assert len(c)==FEATURES
    return mask_score(mask,c[:775])+int(state)*(c[775]+sum(c[776+t] for t in range(16) if mask>>t&1))


def branch_weights(mask, state, c):
    assert len(c)==FEATURES
    return tuple(v+int(state)*c[792+j] for j,v in enumerate(candidate_weights(mask,c[:775])))
