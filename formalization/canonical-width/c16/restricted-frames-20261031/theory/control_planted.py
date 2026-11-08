"""Positive control: in the planted pools (la/gen_instance.py plant(1): 8 X orbits and 8 Z orbits
appended, forming a T-invariant frame with x_{720+k} paired to z_{720+k}), every planted orbit pair
must have a local frame AND a complement that admits a frame."""
import sys, importlib.util
from pathlib import Path
here = Path(__file__).resolve().parent
sys.path.insert(0, str(here))
spec = importlib.util.spec_from_file_location('gi', here.parent / 'la' / 'gen_instance.py')
src = (here.parent / 'la' / 'gen_instance.py').read_text().split("if __name__ == '__main__':")[0]
g = {'__file__': str(here.parent / 'la' / 'gen_instance.py')}; exec(src, g)
A, Zd = g['plant'](1)
import common
common.X.extend(A); common.Z.extend(Zd)
import subspace_frames as sf
print('pools now', len(sf.X), len(sf.Z))
for k in (45, 46):
    r = sf.local_and_complement([k], [k], f'ctl{k}', knuth_cap=1e8)
    print(k, r, flush=True)
