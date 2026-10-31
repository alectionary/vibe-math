"""Independent harmless process fixtures only; never R/JAGS/sampling."""
import json, os, pathlib, signal, subprocess, sys, tempfile, time, unittest
from unittest.mock import patch
import dispatch_score_a0 as m

class GuardReview(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.root=pathlib.Path(self.tmp.name)
        self.caps=dict(m.CAPS,chain_seconds=3,summed_seconds=8,all_seconds=10,elapsed_seconds=5,grace=.03,poll=.01,rss=10**8,total_rss=4*10**8,reserve=1,output=10**7,log=10**6)
    def tearDown(self):self.tmp.cleanup()
    def cmd(self,source):return [sys.executable,'-c',source]
    def runit(self,commands,**kw):
        return m.run_guarded(commands,self.root/'stage',self.caps,memory_probe=kw.pop('memory_probe',lambda:{'available_bytes':10**10}),rss_probe=kw.pop('rss_probe',lambda pid:0),**kw)
    def test_success_denominator(self):
        r=self.runit([self.cmd('print(1)')]*4);self.assertTrue(r['ok']);self.assertEqual(len(r['outcomes']),4)
        self.assertEqual(json.loads((self.root/'stage/outcomes.json').read_text())['requested'],4)
    def test_no_overwrite(self):
        (self.root/'stage').mkdir();(self.root/'stage/keep').write_text('preserve')
        with self.assertRaises(FileExistsError):self.runit([self.cmd('pass')])
        self.assertEqual((self.root/'stage/keep').read_text(),'preserve')
    def test_headroom_prevents_launch(self):
        r=self.runit([self.cmd('pass')]*4,memory_probe=lambda:{'available_bytes':0})
        self.assertFalse(r['ok']);self.assertTrue(all(x['state']=='not_launched' for x in r['outcomes']))
    def test_memory_probe_failure_closed(self):
        def probe():raise PermissionError('fixture')
        r=self.runit([self.cmd('pass')]*4,memory_probe=probe)
        self.assertIn('PermissionError',r['error']);self.assertTrue(all(x['state']=='not_launched' for x in r['outcomes']))
    def test_timeout_cleanup(self):
        self.caps['chain_seconds']=.1;r=self.runit([self.cmd('import time;time.sleep(5)')]*2)
        self.assertFalse(r['ok']);self.assertIn('wall cap',r['error']);self.assertTrue(all(x['state']=='cancelled' for x in r['outcomes']))
        for x in r['outcomes']:
            with self.assertRaises(ProcessLookupError):os.kill(x['pid'],0)
    def test_summed_budget(self):
        self.caps['summed_seconds']=.18;r=self.runit([self.cmd('import time;time.sleep(5)')]*2)
        self.assertIn('Summed',r['error']);self.assertLess(r['spent'],.35)
    def test_rss_cap(self):
        r=self.runit([self.cmd('import time;time.sleep(5)')],rss_probe=lambda pid:10**9)
        self.assertIn('RSS cap',r['error'])
    def test_total_rss_cap(self):
        self.caps['total_rss']=5;r=self.runit([self.cmd('import time;time.sleep(5)')]*2,rss_probe=lambda pid:4)
        self.assertIn('RSS cap',r['error'])
    def test_log_cap(self):
        self.caps['log']=100;r=self.runit([self.cmd("import time;print('x'*5000,flush=True);time.sleep(5)")])
        self.assertIn('Log cap',r['error'])
    def test_output_cap(self):
        self.caps['output']=100
        r=self.runit([self.cmd('import time;time.sleep(5)')]);self.assertIn('output cap',r['error'])
    def test_failure_preserved(self):
        r=self.runit([self.cmd('raise SystemExit(7)'),self.cmd('import time;time.sleep(5)')])
        self.assertFalse(r['ok']);self.assertEqual(r['outcomes'][0]['returncode'],7);self.assertEqual(len(r['outcomes']),2)
    def test_cancellation_signal(self):
        r=self.runit([self.cmd('import os,signal,time;os.kill(os.getppid(),signal.SIGTERM);time.sleep(5)')])
        self.assertIn('InterruptedError',r['error']);self.assertEqual(r['outcomes'][0]['state'],'cancelled')
    def test_descendant_cleanup_after_leader_exit(self):
        marker=self.root/'child-pid'
        code="import os,time;pid=os.fork();\nif pid==0: time.sleep(5)\nelse: open("+repr(str(marker))+",'w').write(str(pid))"
        r=self.runit([self.cmd(code)]);self.assertTrue(r['ok'])
        pid=int(marker.read_text());path=pathlib.Path('/proc')/str(pid)/'stat'
        for _ in range(30):
            if not path.exists() or path.read_text().rsplit(') ',1)[1].split()[0]=='Z':break
            time.sleep(.01)
        else:self.fail('Owned descendant survives successful leader')
    def test_incomplete_identity_rejected(self):
        manifest=self.root/'manifest.json'
        manifest.write_text(json.dumps({'caps':m.CAPS,'files':{},'runtime':{},'prepared':{}}))
        with patch.object(m,'MANIFEST',manifest),patch.object(m,'NAMESPACE',self.root/'unused'),patch.object(m,'cpu_capacity',return_value={'effective_capacity':4}),patch.object(m,'blocked_processes',return_value=[]),patch.object(m,'memory_headroom',return_value={'available_bytes':10**12}):
            with self.assertRaises((RuntimeError,KeyError)):m.validate()
    def test_memory_ancestor_limit(self):
        cg=self.root/'cg';leaf=cg/'nested';leaf.mkdir(parents=True)
        (cg/'memory.max').write_text('1000');(cg/'memory.current').write_text('900')
        (leaf/'memory.max').write_text('10000');(leaf/'memory.current').write_text('1')
        membership=self.root/'membership';membership.write_text('0::/nested\n')
        self.assertEqual(m.memory_headroom(cg,membership)['available_bytes'],100)
    def test_idle_guard_preserves_denominator(self):
        r=self.runit([self.cmd('pass')]*4,idle_probe=lambda excluded:[{'pid':999999}])
        self.assertIn('Competing',r['error']);self.assertTrue(all(x['state']=='not_launched' for x in r['outcomes']))
    def test_expired_stage_never_launches(self):
        marker=self.root/'should-not-exist'
        r=self.runit([self.cmd(f"from pathlib import Path;Path({str(marker)!r}).touch()")],start=time.monotonic()-20)
        self.assertTrue(all(x['state']=='not_launched' for x in r['outcomes']))
    def test_spent_stage_never_launches(self):
        r=self.runit([self.cmd('pass')],charged=100)
        self.assertTrue(all(x['state']=='not_launched' for x in r['outcomes']))

if __name__=='__main__':unittest.main(verbosity=2)
