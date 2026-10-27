#!/usr/bin/env python3
"""Independent exhaustive small controls and sampled production-profile checks."""
import argparse
import json
from pathlib import Path
import random
import subprocess
import tempfile
from orbit_augmentation import augmentation


def rotate(x,h,P=16):
    return ((x<<h)|(x>>(P-h)))&((1<<P)-1) if h else x


def profile(f,I,P=16):
    # Explicit adjacency lists, independent of the generator's bit intersections.
    neighbors=[{i for i in range(P) if f>>((j-i)%P)&1 and I>>i&1} for j in range(P)]
    return sum(not n for n in neighbors),len(set().union(*(n for n in neighbors if len(n)==1)))


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--table-binary',type=Path,required=True);ap.add_argument('--masks',type=Path,required=True);ap.add_argument('--profiles',type=Path,required=True);args=ap.parse_args()
    checked=0
    with tempfile.TemporaryDirectory() as folder:
        source=Path(folder)/'patterns';out=Path(folder)/'result'
        for P in [3,4,5]:
            source.write_text('\n'.join(map(str,range(1<<P))))
            subprocess.run([str(args.table_binary),str(source),str(out),str(P)],check=True)
            for row in json.loads(out.read_text()):
                f=row['pattern'];expected=set()
                for I in range(1<<P):
                    for J in range(1<<P):
                        edges=[(i,j) for i in range(P) for j in range(P) if I>>i&1 and J>>j&1 and f>>((j-i)%P)&1]
                        if len({i for i,j in edges})==len(edges)==len({j for i,j in edges}):expected.add((I.bit_count(),J.bit_count(),len(edges)))
                assert expected==set(map(tuple,row['allowed'])),(P,f)
                checked+=1
    masks=list(map(int,args.masks.read_text().split()));assert len(masks)==4116 and len(set(masks))==4116
    assert {min(rotate(m,h) for h in range(16)) for m in range(65536)}==set(masks)
    rows=json.loads(args.profiles.read_text());rng=random.Random(20261027);samples=0
    for row in rows:
        assert len(row['zero'])==len(row['owners'])==len(masks)
        for k in rng.sample(range(len(masks)),8):
            f=row['pattern'];I=masks[k];wanted=profile(f,I)
            assert wanted==(row['zero'][k],row['owners'][k])
            for h in [1,3,8,15]:
                assert profile(rotate(f,h),I)==wanted
                assert profile(f,rotate(I,h))==wanted
            samples+=1
    # The projection A and repetition J obey A J=0, including all basis bits.
    for i in range(8):assert augmentation(65535<<(16*i))==0
    print(json.dumps({'status':'PASS','exhaustive_small_patterns':checked,'production_patterns':len(rows),'profile_samples':samples,'canonical_phase_subsets':len(masks),'evidence':'control tests, not a global obstruction'}))


if __name__=='__main__':main()
