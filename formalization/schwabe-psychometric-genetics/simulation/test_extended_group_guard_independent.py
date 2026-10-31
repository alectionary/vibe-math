"""Independent synthetic process-table regression; never launches a model."""
import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

PATH = Path(__file__).with_name('dispatch_jags_centered_extended_guarded.py')
spec = importlib.util.spec_from_file_location('guarded', PATH)
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)

class OwnershipReview(unittest.TestCase):
    def scan(self, group, exclude=(101832,)):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'102152').mkdir()
            (root/'102152'/'cmdline').write_bytes(b'R\0--file=simulation/jags_centered_extended_gate.R\0--args\0run\0')
            with patch.object(m.os, 'getpgid', side_effect=group if isinstance(group, Exception) else None, return_value=group):
                return m.blocked_processes(exclude, root)
    def test_owned_fork_inherits_r_argv(self):
        self.assertEqual(self.scan(101832), [])
    def test_unrelated_group_remains_blocked(self):
        self.assertEqual([x['pid'] for x in self.scan(123456)], [102152])
    def test_idle_scan_has_no_owned_groups(self):
        self.assertEqual(len(self.scan(101832, ())), 1)
    def test_vanished_process_ignored(self):
        self.assertEqual(self.scan(ProcessLookupError()), [])
    def test_unreadable_group_fails_closed(self):
        with self.assertRaisesRegex(RuntimeError, 'Cannot inspect process table safely'):
            self.scan(PermissionError())
    def test_only_guard_changed(self):
        old = PATH.with_name('dispatch_jags_centered_extended.py').read_text()
        added = '''            # Each worker is launched with start_new_session=True: its PID is
            # the owned process-group/session ID. Hashing children can briefly
            # inherit R argv before exec; they are not competing model workers.
            if os.getpgid(int(entry.name)) in set(exclude):
                continue
'''
        self.assertEqual(PATH.read_text().replace(added, ''), old)

if __name__ == '__main__':
    unittest.main()
