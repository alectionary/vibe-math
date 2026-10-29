from pathlib import Path
import sys,unittest,json
import numpy as np
import pandas as pd
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'scripts'))
from fit_sem import Model

class SemTests(unittest.TestCase):
 def test_degrees_of_freedom(self):
  specs=[('unrefined',False,181),('refined',False,178),('general',False,179),('refined',True,326),('all',True,536),('held',True,311),('implied_structure',True,327),('implied_indicators',True,326)]
  for name,ext,df in specs:self.assertEqual(Model(name,ext).df,df)
 def test_held_has_no_core_residual_covariances(self):
  m=Model('held',True)
  self.assertFalse(any(t=='theta' and i!=j for t,i,j,_ in m.parameters))
 def test_covariance_fixture(self):
  m=Model('refined',True);S=m.matrices(m.start)[0]
  F,g=m.objective(m.start,S)
  self.assertLess(abs(F),1e-12);self.assertLess(abs(g).max(),1e-12)
 def test_main_fits_admissible_and_optimizer_agreement(self):
  result=json.loads((ROOT/'outputs/sem_fits.json').read_text())
  for r in result['models']:
   self.assertTrue(r['success']);self.assertGreater(r['min_eigen_theta'],0);self.assertGreater(r['min_eigen_sigma'],0);self.assertLess(r['max_abs_gradient'],1e-5)
  for r in result['verification']:self.assertLess(r['delta_F'],1e-9)
 def test_rounding_diagnostic_scope(self):
  r=json.loads((ROOT/'outputs/rounding_sensitivity.json').read_text())
  self.assertEqual(r['seed'],201005);self.assertEqual(r['completed'],200);self.assertFalse(r['optimizer_failures'])
  self.assertTrue(all(n==0 for n in r['ranking_reversals'].values()))
if __name__=='__main__':unittest.main()
