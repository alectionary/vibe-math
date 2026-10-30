import importlib.util,sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from contrast_checks import contrast,source_band,validate_inventory
from checks import numerical_verdict
class Contrasts(unittest.TestCase):
 def row(self):
  return dict(role='headline',claim='failure risk',kind='contrast',definition='Bolza minus planar; positive is higher risk',source_contrast=.7343980176-.7415826580,ours_contrast=.749409-.7404045647,source_point_direction='negative',our_point_direction='positive',point_reversal=True,numerical='mismatch',scope='limited',uncertainty_decision='source uncertainty unknown')
 def test_reversal(self):
  r=self.row();self.assertTrue(contrast(r['source_contrast'],r['ours_contrast'],r['definition'])['point_reversal']);self.assertEqual(validate_inventory([r]),[])
 def test_ambiguous_direction(self):
  r=self.row();r['our_point_direction']='Higher';self.assertTrue(validate_inventory([r]))
 def test_missing_reversal(self):
  r=self.row();r['point_reversal']=False;self.assertTrue(validate_inventory([r]))
 def test_bolza_outside(self):
  r=source_band(.003818057218,.000243674069,.000055374485,10);self.assertEqual(r['adjusted_status'],'outside');self.assertAlmostEqual(r['adjusted_halfwidth'],.0007393758,places=9);self.assertTrue(r['conditional'])
 def test_planar_inside(self):
  r=source_band(-.000516657290,.000461829135,.000053664487,10);self.assertEqual(r['two_se_status'],'inside');self.assertEqual(r['adjusted_status'],'inside');self.assertAlmostEqual(r['adjusted_halfwidth'],.0013500345,places=9)
 def test_families_not_interchangeable(self):
  a=source_band(.004,.001,0,5);b=source_band(.004,.001,0,32);self.assertLess(a['adjusted_halfwidth'],b['adjusted_halfwidth'])
 def test_missing_source_does_not_become_zero(self):
  self.assertTrue(source_band(.001,.001,0,10)['conditional']);self.assertFalse(source_band(.001,.001,0,10,source_se=0)['conditional'])
 def test_close_not_statistical_or_exploratory(self):
  for criterion in ['two_se','exploratory_002']:
   r=self.row();r.update(numerical='close',numerical_criterion=criterion);self.assertTrue(validate_inventory([r]))
 def test_support_cannot_replace_headline(self):
  r=self.row();r['role']='supporting';self.assertTrue(validate_inventory([r]))
 def test_rounded_agreement_unchanged(self):
  self.assertEqual(numerical_verdict(.86,.8602,2),'match')
 def test_zero_is_not_reversal(self):self.assertFalse(contrast(0,.01,'A minus B')['point_reversal'])
 def test_invalid_family(self):
  for n in [0,-1,True,1.5]:
   with self.assertRaises(ValueError):source_band(0,.1,0,n)

class Coverage(unittest.TestCase):
 def test_baseline_condition_cannot_be_omitted(self):
  from contrast_checks import validate_contrast_coverage
  expected=[('baseline','.007943'),('confirmation','.01')]
  rows=[dict(analysis='confirmation',condition='.01')]
  self.assertTrue(validate_contrast_coverage(rows,expected))
  rows.append(dict(analysis='baseline',condition='.007943'));self.assertEqual(validate_contrast_coverage(rows,expected),[])
 def test_duplicate_condition(self):
  from contrast_checks import validate_contrast_coverage
  r=dict(analysis='baseline',condition='.01');self.assertTrue(validate_contrast_coverage([r,r],[('baseline','.01')]))
