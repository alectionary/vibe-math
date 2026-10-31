"""Independent synthetic-process and accounting checks; never launches R or models."""
import importlib.util,json,tempfile,unittest,ast
from pathlib import Path
from decimal import Decimal
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('recovery',ROOT/'simulation/dispatch_jags_long_recovery.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class ReviewTests(unittest.TestCase):
 def scan(self,args,exclude=()):
  with tempfile.TemporaryDirectory()as tmp:
   d=Path(tmp)/'7654321';d.mkdir();(d/'cmdline').write_bytes(('\0'.join(args)+'\0').encode())
   return m.blocked_processes(exclude,Path(tmp))
 def test_readonly_tools(self):
  for exe in ['rg','cat','sed','head','sha256sum']:
   with self.subTest(exe=exe):self.assertEqual(self.scan([exe,'simulation/jags_long_gate.R']),[])
 def test_actual_interpreters(self):
  for args in [['/runtime/R','--vanilla','--file=simulation/jags_long_gate.R','--args','run'],['Rscript','simulation/jags_long_gate.R','run'],['Rscript','--vanilla','simulation/jags_long_gate.R'],['R','--file','simulation/jags_long_gate.R'],['R','-f','simulation/jags_long_gate.R'],['python3.12','simulation/production_runner.py'],['python','-u','simulation/production_supervisor.py']]:
   with self.subTest(args=args):self.assertEqual(len(self.scan(args)),1)
 def test_interpreter_reader_arguments(self):
  for args in [['python3','audit.py','simulation/jags_long_gate.R'],['python3','-','simulation/production_runner.py'],['R','-e','print(1)','--args','--file=simulation/jags_long_gate.R'],['python','-c','print(1)','simulation/production_runner.py'],['Rscript','audit.R','simulation/jags_long_gate.R'],['R','--file=audit.R','--args','simulation/jags_long_gate.R']]:
   with self.subTest(args=args):self.assertEqual(self.scan(args),[])
 def test_owned_pid_exclusion(self):self.assertEqual(self.scan(['R','--file=simulation/jags_long_gate.R'],exclude=[7654321]),[])
 def test_other_process_not_excluded(self):self.assertEqual(len(self.scan(['R','--file=simulation/jags_long_gate.R'],exclude=[7654322])),1)
 def test_noisy_or_empty_process(self):
  self.assertEqual(self.scan(['']),[]);self.assertEqual(self.scan(['unrelated','simulation/production_runner.py']),[])
 def test_preserved_resource_functions(self):
  old=ast.parse((ROOT/'simulation/dispatch_jags_long_gate.py').read_text());new=ast.parse((ROOT/'simulation/dispatch_jags_long_recovery.py').read_text())
  def f(tree,name):return ast.dump(next(n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name==name),include_attributes=False)
  for name in ['cpu_capacity','memory_headroom','require_memory','process_tree_rss','terminate_group','run_batch']:
   with self.subTest(name=name):self.assertEqual(f(old,name),f(new,name))
 def test_budget_and_prior_outcomes(self):
  old=json.loads((ROOT/'production/jags-long-gate-v1/chains/outcomes.json').read_text());plan=json.loads((ROOT/'provenance/jags-long-gate-abort-and-recovery-plan.json').read_text());protocol=json.loads((ROOT/'provenance/jags-long-recovery-protocol.json').read_text())
  self.assertEqual(old['outcomes'],plan['prior_outcomes']);self.assertEqual(len(old['outcomes']),4)
  spent=sum(Decimal(str(v['elapsed_seconds']))for v in old['outcomes'])
  budget=Decimal(protocol['planned_worker_seconds'])+Decimal(4*protocol['termination_grace_seconds'])
  self.assertEqual(protocol['planned_worker_seconds'],4*protocol['per_chain_wall_seconds']);self.assertLess(spent+budget,Decimal(12000))
  self.assertTrue(all(v['state']=='cancelled'for v in old['outcomes']))
if __name__=='__main__':unittest.main()
