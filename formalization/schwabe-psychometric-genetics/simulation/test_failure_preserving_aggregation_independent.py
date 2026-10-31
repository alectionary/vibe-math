"""Independent fixtures; binomial-tail inversion does not use beta quantiles."""
import math
import unittest
from failure_preserving_aggregation import aggregate


def valid(i, decision=None, mean=0., sd=1.):
    return dict(id=i, gate_valid=True, posterior_mean=mean, posterior_sd=sd,
                stable_hpd_decision=decision)


def binomial_cdf(k, n, p):
    return sum(math.comb(n,j)*p**j*(1-p)**(n-j) for j in range(k+1))


def invert_cdf(k,n,target):
    lo,hi=0.,1.
    for _ in range(100):
        mid=(lo+hi)/2
        if binomial_cdf(k,n,mid)>target: lo=mid
        else: hi=mid
    return (lo+hi)/2


class IndependentAggregationTests(unittest.TestCase):
    def test_missing_and_failed_not_dropped(self):
        out=aggregate(range(100), [valid(0,'positive'),valid(1,'includes_zero'),
            dict(id=2,gate_valid=False,stable_hpd_decision='negative')])
        self.assertEqual((out['requested'],out['recorded'],out['missing']),(100,3,97))
        self.assertEqual((out['classified_detections'],out['classified_nondetections'],out['unclassified']),(1,1,98))
        self.assertEqual(out['realized_detection_bounds'],[.01,.99])
        self.assertFalse(out['complete_recovery'])
    def test_all_missing_250(self):
        out=aggregate(range(250),[])
        self.assertEqual(out['unclassified'],250)
        self.assertEqual(out['binomial_interval'],[0.,1.])
        self.assertEqual(out['familywise_interval'],[0.,1.])
        self.assertIsNone(out['provisional_mean_posterior_mean'])
        self.assertIsNone(out['provisional_sd_posterior_means'])
    def test_zero_and_all_detection_boundaries(self):
        n=100
        zero=aggregate(range(n),[valid(i,'includes_zero') for i in range(n)])
        all_=aggregate(range(n),[valid(i,'negative') for i in range(n)])
        self.assertAlmostEqual(zero['binomial_interval'][1],1-.025**(1/n),13)
        self.assertAlmostEqual(all_['binomial_interval'][0],.025**(1/n),13)
        self.assertEqual(zero['binomial_interval'][0],0.)
        self.assertEqual(all_['binomial_interval'][1],1.)
    def test_partial_cp_independent_binomial_inversion(self):
        n=20; d=5; u=3
        rows=[valid(i,'positive' if i<d else 'includes_zero') for i in range(n-u)]
        out=aggregate(range(n),rows)
        for field,a in [('binomial_interval',.05),('familywise_interval',.05/12)]:
            self.assertAlmostEqual(out[field][0],invert_cdf(d-1,n,1-a/2),12)
            self.assertAlmostEqual(out[field][1],invert_cdf(d+u,n,a/2),12)
        self.assertLess(out['familywise_interval'][0],out['binomial_interval'][0])
        self.assertGreater(out['familywise_interval'][1],out['binomial_interval'][1])
    def test_family_one_and_record_order(self):
        rows=[valid(0,'positive'), valid(1,'includes_zero')]
        a=aggregate(range(2),rows,family_size=1)
        self.assertEqual(a,aggregate(range(2),list(reversed(rows)),family_size=1))
        self.assertEqual(a['familywise_interval'],a['binomial_interval'])
    def test_provisional_recovery_and_unclassified_hpd(self):
        out=aggregate(range(3),[valid(0,None,1.,2.),valid(1,'positive',3.,4.)])
        self.assertEqual(out['valid_recovery'],2)
        self.assertEqual(out['unclassified'],2)
        self.assertEqual(out['provisional_mean_posterior_mean'],2.)
        self.assertAlmostEqual(out['provisional_sd_posterior_means'],math.sqrt(2))
        self.assertEqual(out['provisional_mean_posterior_sd'],3.)
        self.assertFalse(out['complete_recovery'])
        one=aggregate([0],[valid(0,None,1.,0.)])
        self.assertTrue(one['complete_recovery'])
        self.assertEqual(one['unclassified'],1)
        self.assertIsNone(one['provisional_sd_posterior_means'])
    def test_invalid_ids(self):
        for ids,rows in [([],[]),([1,1],[]),([1],[valid(2)]),([1],[valid(1),valid(1)])]:
            with self.subTest(ids=ids,rows=rows),self.assertRaises(ValueError): aggregate(ids,rows)
    def test_invalid_interval_settings(self):
        for kwargs in [dict(alpha=0),dict(alpha=1),dict(alpha=float('nan')),
                       dict(family_size=0),dict(family_size=True),dict(family_size=1.2)]:
            with self.subTest(kwargs=kwargs),self.assertRaises(ValueError): aggregate([0],[],**kwargs)
    def test_invalid_valid_records(self):
        for key,value in [('posterior_mean',float('nan')),('posterior_mean',float('inf')),
                          ('posterior_mean',True),('posterior_sd',-1.),('posterior_sd',float('inf')),
                          ('posterior_sd','1'),('stable_hpd_decision','significant')]:
            row=valid(0);row[key]=value
            with self.subTest(key=key,value=value),self.assertRaises(ValueError): aggregate([0],[row])
    def test_invalid_gate_never_counted_as_success(self):
        rows=[dict(id=i,gate_valid=g,posterior_mean=float('nan'),stable_hpd_decision='positive')
              for i,g in enumerate([False,1,'True',None])]
        out=aggregate(range(4),rows)
        self.assertEqual(out['valid_recovery'],0)
        self.assertEqual(out['unclassified'],4)

if __name__=='__main__': unittest.main(verbosity=2)
