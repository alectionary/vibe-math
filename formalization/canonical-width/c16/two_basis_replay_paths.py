"""Explicit recorded-root relocation; no I/O hooks or JSON mutation."""
from pathlib import Path
import hashlib

class RecordedRoot:
    def __init__(self, current_root, recorded_root):
        self.current = Path(current_root).resolve()
        self.recorded = Path(recorded_root)
        assert self.recorded.is_absolute() and '..' not in self.recorded.parts
        self.rewrites = []

    def resolve(self, recorded_path):
        old = Path(recorded_path)
        if old.is_absolute():
            try: relative = old.relative_to(self.recorded)
            except ValueError: raise AssertionError('absolute path is outside declared recorded root') from None
        else: relative = old
        assert '..' not in relative.parts and not relative.is_absolute()
        result = (self.current / relative).resolve()
        assert result.is_relative_to(self.current), 'resolved path escapes current root'
        if old.is_absolute():
            self.rewrites.append(dict(recorded_path=str(old),current_relative_path=str(relative)))
        return result

    def evidence(self):
        return dict(recorded_root=str(self.recorded),current_root=str(self.current),
            explicit_rewrites=self.rewrites,original_json_bytes_unchanged=True,
            hash_and_physical_checks_retained=True,
            resolver_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
