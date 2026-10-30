import unittest,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parent))
from comparisons import build,display_verdict
class Comparisons(unittest.TestCase):
 @classmethod
 def setUpClass(cls):cls.d=build()
 def test_family_sizes_and_counts(self):
  self.assertEqual(self.d['families'],dict(baseline_source=32,confirmation_source=10,reconstructed_contrasts=5))
  self.assertEqual(sum(r['adjusted_status']=='outside' for r in self.d['confirmation']),6)
  self.assertEqual(sum(r['adjusted_status']=='outside' for r in self.d['baseline']),16)
 def test_low_noise_conditional_intervals(self):
  b,p=self.d['confirmation'][:2];self.assertAlmostEqual(b['adjusted_halfwidth'],.0007393758256485661);self.assertAlmostEqual(p['adjusted_halfwidth'],.001350034465693566)
  self.assertGreater(b['adjusted_endpoints'][0],0);self.assertLess(p['adjusted_endpoints'][0],0);self.assertGreater(p['adjusted_endpoints'][1],0)
 def test_reversal_and_contrast_family(self):
  rs=[r for r in self.d['contrasts'] if r['reversal']];self.assertEqual(len(rs),1);r=rs[0];self.assertEqual(r['p'],.01);self.assertAlmostEqual(r['ours_contrast'],.00900443529495809);self.assertAlmostEqual(r['adjusted_halfwidth'],.0014341941496198106)
  self.assertTrue(all(r['adjusted_endpoints'][0]>0 for r in self.d['contrasts']))
 def test_full_baseline_contrast_inventory(self):
  r=self.d['baseline_contrasts'];self.assertEqual(len(r),16);rev=[x for x in r if x['reversal']];self.assertEqual(len(rev),2);self.assertAlmostEqual(rev[0]['p'],.007943279059138478);self.assertAlmostEqual(rev[0]['ours_contrast'],.010748195137774474)
 def test_rounding_and_band_decisions_are_separate(self):
  p=self.d['confirmation'][1];self.assertEqual(p['numerical'],'mismatch');self.assertEqual(p['adjusted_status'],'inside');self.assertEqual(display_verdict(.86,.8602,2),'match')
