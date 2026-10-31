"""Independent centered guard race/pinning tests; never starts a model."""
import importlib.util, unittest, errno, json, hashlib, ast, tempfile
from decimal import Decimal
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def load(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
prior=load('independent_prior_tests',ROOT/'simulation/test_jags_recovery_independent.py')
m=load('centered_dispatch',ROOT/'simulation/dispatch_jags_centered_gate.py');prior.m=m
class FixtureEntry:
 name='7654321'
 def __init__(self,error):self.error=error
 def __truediv__(self,other):return self
 def read_bytes(self):raise self.error
class FixtureRoot:
 def __init__(self,error):self.error=error
 def iterdir(self):return iter([FixtureEntry(self.error)])
class CenteredReviewTests(prior.ReviewTests):
 def test_preserved_resource_functions(self):
  old=ast.parse((ROOT/'simulation/dispatch_jags_long_recovery.py').read_text());new=ast.parse((ROOT/'simulation/dispatch_jags_centered_gate.py').read_text())
  def f(tree,name):return next(n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name==name)
  for name in ['cpu_capacity','memory_headroom','require_memory','process_tree_rss','terminate_group','run_batch']:
   a,b=f(old,name),f(new,name)
   if name=='run_batch':
    handler=next(n for n in ast.walk(b)if isinstance(n,ast.ExceptHandler)and isinstance(n.type,ast.Name)and n.type.id=='BaseException')
    self.assertEqual(len(handler.body),2)
    self.assertEqual(ast.unparse(handler.body[1]),"(directory / 'error-traceback.txt').write_text(traceback.format_exc())")
    handler.body=handler.body[:1]
   self.assertEqual(ast.dump(a,include_attributes=False),ast.dump(b,include_attributes=False))
 def test_traceback_on_prelaunch_guard_failure(self):
  def fail(excluded):raise RuntimeError('independent synthetic guard failure')
  with tempfile.TemporaryDirectory()as tmp:
   out=Path(tmp)/'batch'
   self.assertFalse(m.run_batch([['never-executed']],out,1,0,guard=fail))
   self.assertIn('independent synthetic guard failure',(out/'error-traceback.txt').read_text())
   record=json.loads((out/'outcomes.json').read_text())
   self.assertEqual(record['outcomes'][0]['state'],'not_launched')
 def test_disappearing_process_races(self):
  for err in [FileNotFoundError(errno.ENOENT,'gone'),ProcessLookupError(errno.ESRCH,'gone')]:
   with self.subTest(error=type(err).__name__):self.assertEqual(m.blocked_processes(proc_root=FixtureRoot(err)),[])
 def test_permission_denied_fails_closed(self):
  with self.assertRaisesRegex(RuntimeError,'Cannot inspect process table safely'):
   m.blocked_processes(proc_root=FixtureRoot(PermissionError(errno.EACCES,'denied')))
 def test_other_oserror_not_swallowed(self):
  with self.assertRaises(OSError):m.blocked_processes(proc_root=FixtureRoot(OSError(errno.EIO,'io error')))
 def test_centered_model_detected(self):self.assertEqual(len(self.scan(['R','--file=simulation/jags_centered_gate.R'])),1)
 def test_centered_reader_ignored(self):self.assertEqual(self.scan(['python','read.py','simulation/jags_centered_gate.R']),[])
 def test_centered_pins(self):
  p=m.validate();pre=Path('/tmp/schwabe-centered-preflight-v1')
  for f,k in [('data.rds','expected_data_sha256'),('model.jags','expected_model_sha256')]:
   self.assertEqual(hashlib.sha256((pre/f).read_bytes()).hexdigest(),p[k])
  self.assertEqual(p['per_chain_wall_seconds'],1800);self.assertEqual(p['planned_worker_seconds'],7200)
 def test_centered_budget(self):
  spent=Decimal(0)
  for ns in ['jags-long-gate-v1','jags-long-gate-recovery-v1']:
   x=json.loads((ROOT/f'production/{ns}/chains/outcomes.json').read_text());self.assertEqual(len(x['outcomes']),4)
   self.assertTrue(all(y['state']=='cancelled'for y in x['outcomes']))
   spent+=sum(Decimal(str(y['elapsed_seconds']))for y in x['outcomes'])
  self.assertLess(spent+Decimal(7220),Decimal(12000))
if __name__=='__main__':unittest.main()
