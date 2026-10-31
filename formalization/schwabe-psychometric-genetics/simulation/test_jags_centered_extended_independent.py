"""Final length-experiment checks; no model launch or posterior sampling."""
import importlib.util,unittest,json,hashlib,ast
from pathlib import Path
from decimal import Decimal
ROOT=Path(__file__).resolve().parents[1]
def load(n,p):
 s=importlib.util.spec_from_file_location(n,p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
prior=load('centered_review_tests',ROOT/'simulation/test_jags_centered_independent.py')
m=load('extended_dispatch',ROOT/'simulation/dispatch_jags_centered_extended.py');prior.m=m;prior.prior.m=m
class ExtendedTests(prior.CenteredReviewTests):
 def test_centered_pins(self):
  p=m.validate();old=json.loads((ROOT/'provenance/jags-centered-dispatch-protocol.json').read_text())
  for k in ['expected_data_sha256','expected_model_sha256','pinned_runtime','memory_policy']:self.assertEqual(p[k],old[k])
  self.assertEqual(p['per_chain_wall_seconds'],1370);self.assertEqual(p['planned_worker_seconds'],5480)
 def test_centered_budget(self):
  spent=Decimal(0)
  for ns in ['jags-long-gate-v1','jags-long-gate-recovery-v1','jags-centered-gate-v1']:
   x=json.loads((ROOT/f'production/{ns}/chains/outcomes.json').read_text());self.assertEqual(len(x['outcomes']),4)
   spent+=sum(Decimal(str(y['elapsed_seconds']))for y in x['outcomes'])
  self.assertLess(spent+Decimal(5500),Decimal(12000))
 def test_scientific_wrapper_exact_allowed_diff(self):
  old=(ROOT/'simulation/jags_centered_gate.R').read_text();new=(ROOT/'simulation/jags_centered_extended_gate.R').read_text()
  expected=old.replace('jags_centered_gate.R','jags_centered_extended_gate.R').replace('diagnose_jags_centered_gate.R','diagnose_jags_centered_extended_gate.R').replace('timeout 1800s','timeout 1370s').replace("7000,12000,'unused'","7000,28000,'unused'").replace('retained=12000L','retained=28000L').replace('for(chunk in 1:3)','for(chunk in 1:7)')
  self.assertEqual(new,expected)
 def test_diagnostic_exact_allowed_diff(self):
  old=(ROOT/'simulation/diagnose_jags_centered_gate.R').read_text();new=(ROOT/'simulation/diagnose_jags_centered_extended_gate.R').read_text()
  expected=old.replace('jags_centered_gate.R','jags_centered_extended_gate.R').replace('diagnose_jags_centered_gate.R','diagnose_jags_centered_extended_gate.R').replace('retained!=12000L','retained!=28000L').replace('x[1:6000,i]','x[1:14000,i]').replace('x[6001:12000,i]','x[14001:28000,i]')
  self.assertEqual(new,expected)
 def test_extended_actual_model_detected(self):self.assertEqual(len(self.scan(['R','--file=simulation/jags_centered_extended_gate.R'])),1)
if __name__=='__main__':unittest.main()
