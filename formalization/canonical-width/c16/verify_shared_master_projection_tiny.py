"""Exact tiny min-LP dual/source projection controls; no optimization."""
from pathlib import Path
from fractions import Fraction as Q
import hashlib
import json
import os
import time
from shared_master_price_algebra import reconstruct, pattern_cost, check_minorant, owner_projection, LOW

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def tiny(pi_target=Q(1)):
    # y=q, mass w=1, link 0*w+ep-em-y=0, q=1/2. A positive
    # restricted L1 optimum=1/2 is feasible with w=1, ep=1/2.
    # Dual parent=+1, link=+1, mass=0, wbound=0, epbound=0,
    # embound=-2; all stationarity identities hold exactly.
    rows=[('target', '=', ({1: Q(-1)}, {0: Q(1)}))]
    lambdas=[({0: Q(1)}, {})]
    allocations={'X': [[({}, {0: Q(1)})]]}
    dual=dict(target=pi_target, sm_mass_X_0=Q(0), sm_link_X_0_0=Q(1),
              sm_nonneg_1=Q(0), sm_nonneg_2=Q(0), sm_nonneg_3=Q(-2))
    columns=[dict(side='X', mask=0, indices=[], variable_index=1)]
    errors=[dict(side='X', mask=0, index=0, plus_variable=2, minus_variable=3)]
    return rows,lambdas,allocations,dual,[dict(kind='allocation')],columns,errors


def main():
    start=time.monotonic()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    keys=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
    assert all(os.environ.get(k)=='1' for k in keys)
    out=ROOT/'shared-master-results/shared-master-projection-tiny.json'
    assert not out.exists();out.parent.mkdir(exist_ok=True)
    args=tiny();p=reconstruct(*args)
    assert p['owner_coefficients']=={1:Q(1)} and not p['tau_residual']
    assert p['blocks'][0]['constant']==0 and p['blocks'][0]['weights']==[-1]
    # Adding the previously missing physical toy column {0} yields minimum
    # -1 and full projected value q-1=-1/2, despite restricted value+1/2.
    minimum=p['blocks'][0]['constant']+p['blocks'][0]['weights'][0]
    assert minimum==-1 and Q(1,2)+minimum==Q(-1,2)
    rejected=[]
    def must_reject(label, fn):
        try:fn()
        except (AssertionError,KeyError,ValueError):rejected.append(label)
        else:raise AssertionError(label)
    must_reject('wrong_parent_dual_sign',lambda:reconstruct(*tiny(Q(-1))))
    bad=list(tiny());bad[3]=dict(bad[3],sm_nonneg_1=Q(1))
    must_reject('positive_inequality_dual',lambda:reconstruct(*bad))
    bad=list(tiny());bad[3]=dict(bad[3],sm_nonneg_3=Q(-1))
    must_reject('wrong_error_stationarity',lambda:reconstruct(*bad))
    bad=list(tiny());bad[5]=[dict(side='X',mask=0,indices=[0],variable_index=1)]
    must_reject('missing_column_not_in_archive',lambda:reconstruct(*bad))
    # Explicit pin convention: normalized pi_pin=+2 means source multiplier
    # -2. Removing that row leaves +2*tau, the negative of its multiplier.
    pin_rows=[('base','=', ({}, {0:Q(-2)})),('zero_tau0','=', ({}, {0:Q(1)}))]
    pin_dual=dict(base=Q(1),zero_tau0=Q(2))
    pin=reconstruct(pin_rows,[],{},pin_dual,[dict(kind='tau',mask=7)],[],[],['zero_tau0'])
    assert pin['tau_residual']=={7:Q(2)}
    assert pin['removed_pin_source_multipliers']=={'zero_tau0':'-2'}
    full=reconstruct(pin_rows,[],{},pin_dual,[dict(kind='tau',mask=7)],[],[])
    assert not full['tau_residual']
    minima={(s,m):Q(-1+3*(m&1)) if s=='X' else Q(0) for s in ('X','Z') for m in range(16)}
    residual={7:Q(2),11:Q(-3),13:Q(5),14:Q(-7),15:Q(11)}
    costs,rho=pattern_cost(minima,residual)
    assert rho[15]==8 and rho[7]==2 and rho[11]==-3
    def wrong_atom_map():
        assert rho[15]==residual[15]
    must_reject('tau_atom_shortcut',wrong_atom_map)
    costs,_=pattern_cost(minima,{})
    minor=[Q(-1),Q(3)]+[Q(0)]*9
    assert check_minorant(costs,minor)==costs
    must_reject('minorant_above_pattern',lambda:check_minorant(costs,[Q(0),Q(3)]+[Q(0)]*9))
    projected=owner_projection({2:Q(1,3)},list(range(11)),minor)
    assert projected['integer_rhs']==3
    assert projected['integer_owner_coefficients']==[[0,9],[1,1]]
    law=[Q(3,4),Q(1,4)]+[Q(0)]*14
    q=[sum((law[m] for m in range(16) if m&h==h),Q(0)) for h in LOW]
    assert sum(a*b for a,b in zip(q,minor))==Q(-1,4)>min(costs)
    # Independently literal all-unit and rational-law checks of every high moment.
    laws=[[Q(m==k) for m in range(16)] for k in range(16)]+[law,[Q(1,16)]*16]
    for lam in laws:
        assert sum(rho[m]*lam[m] for m in range(16))==sum(
            coefficient*sum(lam[m] for m in range(16) if m&h==h) for h,coefficient in residual.items())
    data=dict(status='PASS_EXACT_SHARED_MASTER_DUAL_PROJECTION_TINY_CONTROLS',
              source_sha256=sha(ROOT/'shared_master_price_algebra.py'),consumer_sha256=sha(__file__),
              exact_dual_source_cases=3,all_pattern_high_moment_laws=len(laws),
              rejected_mutants=rejected,negative_full_price_despite_positive_restricted_objective=True,
              illustrative_minorant='-1/4',constant_minimum='-1',
              scope='Tiny algebra only; no optimization, physical oracle, or C16 source claim.',
              elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    out.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(dict(status=data['status'],receipt=str(out.relative_to(ROOT)),sha256=sha(out))))


if __name__=='__main__':main()
