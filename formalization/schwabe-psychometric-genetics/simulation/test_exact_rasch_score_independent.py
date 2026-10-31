"""Independent deterministic checks; no fitting, model compilation or sampling.

Primary oracle enumerates response patterns at 80-digit precision. A separate
binomial closed form covers J=250. These are not a second posterior engine.
"""
import itertools
import math
from pathlib import Path
import sys
import unittest
import mpmath as mp

sys.path.insert(0, str(Path(__file__).resolve().parent))
from exact_rasch_score import CalibratedRasch
from rasch_score_jags_adapter import prepare_scores, prepare_chapter2_case, chapter2_graph, PRIORS

mp.mp.dps = 80


def oracle_pattern(theta, b, y):
    t = mp.mpf(theta)
    return mp.fsum(-mp.log1p(mp.exp(-(t-mp.mpf(v)))) if z
                   else -mp.log1p(mp.exp(t-mp.mpf(v))) for v,z in zip(b,y))


def oracle_score(theta, b, score):
    logs = [oracle_pattern(theta,b,y) for y in itertools.product((0,1),repeat=len(b)) if sum(y)==score]
    peak = max(logs)
    return peak+mp.log(mp.fsum(mp.exp(x-peak) for x in logs))


class IndependentRaschTests(unittest.TestCase):
    def assertClose(self, x, y, tolerance=1e-10):
        self.assertLessEqual(abs(float(x)-float(y)), tolerance)

    def test_exhaustive_patterns_and_constants(self):
        b=(-1.2,-.3,.7,1.8)
        model=CalibratedRasch(b)
        for theta in (-9.,-1.,0.,.7,8.):
            for y in itertools.product((0,1),repeat=4):
                score=sum(y)
                self.assertClose(model.log_pattern_probability(theta,y),oracle_pattern(theta,b,y))
                self.assertClose(model.log_score_probability(theta,score),oracle_score(theta,b,score))
                self.assertClose(model.log_pattern_probability(theta,y)-model.log_score_probability(theta,score),model.log_pattern_given_score(y))

    def test_coefficients_by_subset_enumeration(self):
        for b in [(),(-3.,),(-2.,-.5,1.4,4.),(-10000.,-2.,500.,10000.)]:
            model=CalibratedRasch(b)
            for score in range(len(b)+1):
                terms=[mp.exp(mp.fsum(mp.mpf(model.anchor)-mp.mpf(b[j]) for j in ids))
                       for ids in itertools.combinations(range(len(b)),score)]
                self.assertClose(model.log_coefficients[score],mp.log(mp.fsum(terms)),2e-11)

    def test_extreme_score_probabilities(self):
        for b in [(-10000.,-2.,3.,10000.),(-1e6,0.,1e6),(999999.,1e6,1000001.)]:
            model=CalibratedRasch(b)
            for theta in (-1e6,-10000.,0.,10000.,1e6):
                actual=model.log_pmf(theta)
                self.assertTrue(all(math.isfinite(x) and x<=1e-12 for x in actual))
                self.assertClose(math.fsum(math.exp(x) for x in actual),1.,2e-12)
                for score in range(len(b)+1):
                    self.assertClose(actual[score],oracle_score(theta,b,score),2e-9)

    def test_large_binomial_closed_form(self):
        model=CalibratedRasch([0.]*250)
        for theta in (-10000.,-2.,0.,2.,10000.):
            actual=model.log_pmf(theta)
            self.assertClose(math.fsum(math.exp(x) for x in actual),1.,3e-12)
            for score in range(251):
                exact=mp.log(mp.binomial(250,score))+score*mp.mpf(theta)-250*mp.log1p(mp.exp(mp.mpf(theta)))
                self.assertClose(actual[score],exact,1e-8)

    def test_mask_and_empty_cases(self):
        b=(-2.,12.,.3,-7.,3.)
        mask=(True,False,True,False,True)
        model=CalibratedRasch(b,mask)
        reduced=CalibratedRasch((-2.,.3,3.))
        y=(1,None,0,'not observed',1)
        self.assertEqual(model.score(y),2)
        for theta in (-3.,0.,5.):
            self.assertEqual(model.log_pmf(theta),reduced.log_pmf(theta))
            self.assertEqual(model.log_pattern_probability(theta,y),reduced.log_pattern_probability(theta,(1,0,1)))
        for empty, responses in [(CalibratedRasch([]),()),(CalibratedRasch(b,[False]*5),(None,)*5)]:
            self.assertEqual(empty.log_pmf(13.),(0.,))
            self.assertEqual(empty.score(responses),0)
            self.assertEqual(empty.log_pattern_probability(13.,responses),0.)
            self.assertEqual(empty.canonical_log_kernel(13.,0),0.)
            self.assertEqual(empty.derivatives(13.,0),(0.,0.))

    def test_iterable_responses(self):
        model=CalibratedRasch([-1.,.3,2.])
        y=(1,0,1)
        self.assertEqual(model.log_pattern_probability(.8,iter(y)),model.log_pattern_probability(.8,y))
        self.assertEqual(model.log_pattern_given_score(iter(y)),model.log_pattern_given_score(y))

    def test_canonical_kernel_latent_target_contrasts(self):
        models=[CalibratedRasch([-1.,0.,2.]),CalibratedRasch([-2.,.5,3.],(True,False,True))]
        ys=[(0,1,1),(1,None,0)]
        states=[(-2.,.5,-.3,1.2),(.3,-1.,.7,.8),(2.,3.,-.4,2.)]
        differences=[]
        # Identical correlated latent Gaussian density and identical hyperprior
        # are included in both targets; no numerical integration is asserted.
        for t1,t2,mu,variance in states:
            prior=-.5*mu*mu/10.-variance-.5*((t1-mu)**2+(t2-mu)**2-.6*(t1-mu)*(t2-mu))/(variance*(1-.3**2))-math.log(variance)
            item=prior+sum(m.log_pattern_probability(t,y) for m,t,y in zip(models,(t1,t2),ys))
            score=prior+sum(m.log_score_probability(t,m.score(y)) for m,t,y in zip(models,(t1,t2),ys))
            canonical=prior+sum(m.canonical_log_kernel(t,m.score(y)) for m,t,y in zip(models,(t1,t2),ys))
            differences.append((item-score,canonical-score))
        for a,b in differences[1:]:
            self.assertClose(a,differences[0][0]);self.assertClose(b,differences[0][1])

    def test_permutation(self):
        b=(-2.,-.1,.5,3.);y=(1,0,1,0)
        ref=CalibratedRasch(b)
        for order in itertools.permutations(range(4)):
            m=CalibratedRasch([b[j] for j in order]);z=[y[j] for j in order]
            for a,c in zip(m.log_pmf(.8),ref.log_pmf(.8)):self.assertClose(a,c)
            self.assertClose(m.log_pattern_probability(.8,z),ref.log_pattern_probability(.8,y))

    def test_shift_invariance(self):
        b=(-3.,-.2,1.,4.)
        a=CalibratedRasch(b);c=CalibratedRasch([x+10000 for x in b])
        for x,y in zip(a.log_pmf(.7),c.log_pmf(10000.7)):self.assertClose(x,y,5e-12)

    def test_derivatives_high_precision(self):
        b=(-2.,0.,3.);model=CalibratedRasch(b)
        for score in range(4):
            for t in (-10.,-.2,0.,2.,10.):
                fn=lambda x:oracle_score(x,b,score)
                d1=mp.diff(fn,mp.mpf(t));d2=mp.diff(fn,mp.mpf(t),2)
                actual=model.derivatives(t,score)
                self.assertClose(actual[0],d1,2e-13);self.assertClose(actual[1],d2,2e-13)
                h=1e-4
                fd=(model.log_score_probability(t+h,score)-model.log_score_probability(t-h,score))/(2*h)
                self.assertClose(actual[0],fd,2e-8)

    def test_varying_calibration_is_not_equivalent(self):
        y=(1,0)
        first=CalibratedRasch((-1.,1.)).log_pattern_given_score(y)
        second=CalibratedRasch((1.,-1.)).log_pattern_given_score(y)
        self.assertGreater(abs(first-second),1.)

    def test_unlike_masks_cannot_be_discarded(self):
        a=CalibratedRasch((-3.,3.),(True,False))
        b=CalibratedRasch((-3.,3.),(False,True))
        self.assertGreater(abs(a.log_score_probability(0.,1)-b.log_score_probability(0.,1)),1.)

    def test_invalid_inputs(self):
        for x in (math.nan,math.inf,-math.inf):
            with self.assertRaises(ValueError):CalibratedRasch([x])
            with self.assertRaises(ValueError):CalibratedRasch([0.]).log_pmf(x)
        for mask in ([True], [1,0], [True,None]):
            with self.assertRaises(ValueError):CalibratedRasch([0.,1.],mask)
        model=CalibratedRasch([0.,1.])
        for score in (-1,3,1.,True):
            with self.assertRaises(ValueError):model.log_score_probability(0.,score)
        for y in [(1,), (1,2),(1,.5),(None,1)]:
            with self.assertRaises(ValueError):model.score(y)

    def test_overflow_is_rejected(self):
        with self.assertRaises(FloatingPointError):CalibratedRasch([-1e308]*4+[1e308]*4)
        model=CalibratedRasch([-1e308])
        with self.assertRaises(FloatingPointError):model.log_pmf(1e308)
        with self.assertRaises(FloatingPointError):model.derivatives(1e308,1)
        with self.assertRaises(FloatingPointError):model.log_pattern_probability(1e308,(1,))
        with self.assertRaises(FloatingPointError):model.canonical_log_kernel(1e308,1)

    def test_adapter_zero_trick_constant_with_masks(self):
        b=(-2.,.3,1.5)
        y=[[(0,1,1),(1,None,0)],[(1,0,None),(None,None,None)]]
        masks=[[(True,True,True),(True,False,True)],[(True,True,False),(False,False,False)]]
        prepared=prepare_chapter2_case(b,y,[1.,.5],masks)
        data=prepared['score_data'];audit=prepared['audit']
        constants=sum(sum(row) for row in audit['item_minus_canonical_log_constants'])
        for theta in [[[-2.,0.],[1.,4.]],[[3.,-.7],[.2,-9.]]]:
            item=mp.mpf(0);poisson=mp.mpf(0)
            for i in range(2):
                for t in range(2):
                    kept=[k for k in range(3) if masks[i][t][k]]
                    bb=[b[k] for k in kept];yy=[y[i][t][k] for k in kept]
                    cy=[data['canonical_y'][i][t][k] for k in kept]
                    item+=oracle_pattern(theta[i][t],bb,yy)
                    # log dpois(0,1-log p(canonical pattern)) = log p - 1.
                    poisson+=oracle_pattern(theta[i][t],bb,cy)-1
            self.assertClose(item-poisson,constants+4.,1e-11)
        self.assertEqual(data['canonical_y'][1][1],[0,0,0])
        self.assertEqual(data['observed'][1][1],[0,0,0])
        self.assertEqual(data['zeros'],[[0,0],[0,0]])
        self.assertFalse(audit['compiled']);self.assertFalse(audit['sampling_started'])

    def test_adapter_latent_prior_identity(self):
        root=Path(__file__).resolve().parents[1]
        frozen=(root/'production/jags-centered-extended-recovery-v1/prepared/model.jags').read_text()
        canonical=lambda s:''.join(s.split()).replace(';','')
        for line in PRIORS.splitlines():
            self.assertIn(canonical(line),canonical(frozen))
        for kind in ('items','score'):
            graph=chapter2_graph(500,140,kind)
            for formula in ['c[i] ~ dnorm(0,tc)','prec[i,t] <- exp(-beta0-beta1*a[i,t])',
                            'theta[i,t] ~ dnorm(mu+a[i,t]+c[i],prec[i,t])',
                            'a[i,1] ~ dnorm(0,ta)','a[i,2] <- a[i,1]',
                            'a[i,2] ~ dnorm(.5*a[i,1],ta/.75)']:
                self.assertIn(canonical(formula),canonical(graph))
                self.assertIn(canonical(formula),canonical(frozen))
        graph=chapter2_graph(500,140,'score')
        self.assertIn('lambda[i,t] <- 1+sum(loss[i,t,1:J])',graph)
        self.assertIn('zeros[i,t] ~ dpois(lambda[i,t])',graph)
        self.assertNotIn('y[i,t,k] ~ dbern',graph)

    def test_adapter_invalid_design(self):
        for n,m in [(0,0),(1,1),(2,0),(2,2),(True,1),(2,False)]:
            with self.assertRaises(ValueError):chapter2_graph(n,m)
        with self.assertRaises(ValueError):chapter2_graph(2,1,'gaussian_total')
        y=[[(0,1),(1,0)],[(1,1),(0,0)]]
        for rho in [(.5,1.),(1.,),(1.,.7),(1.,1.),(.5,.5)]:
            with self.assertRaises(ValueError):prepare_chapter2_case([0.,1.],y,rho)
        with self.assertRaises(ValueError):prepare_scores([],[[[],[]]])
        with self.assertRaises(ValueError):prepare_scores([0.,1.],[])
        with self.assertRaises(ValueError):prepare_scores([0.,1.],y,[])


if __name__=='__main__':
    unittest.main(verbosity=2)
