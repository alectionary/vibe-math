#!/usr/bin/env python3
"""Exhaustive small-instance control of circuit coverage and all reported words."""
import argparse
import json
from pathlib import Path
import random
import subprocess
import tempfile


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--binary',type=Path,required=True);args=ap.parse_args()
    rng=random.Random(2610);total=0
    with tempfile.TemporaryDirectory() as directory:
        folder=Path(directory)
        for trial in range(24):
            n=10;r=4;columns=[rng.randrange(1,1<<r) for _ in range(n)]
            rows=[[q for q,c in enumerate(columns) if c>>j&1] for j in range(r)]
            source=folder/'input.txt';dest=folder/'output.json'
            source.write_text(f'{n} {r} {n} 1\n'+''.join(str(len(row))+' '+' '.join(map(str,row))+'\n' for row in rows)+''.join(f'1 {i}\n' for i in range(n)))
            run=subprocess.run([str(args.binary.resolve()),str(source),str(dest),'10','0',str(n),'20'],capture_output=True,text=True)
            assert run.returncode==0
            data=json.loads(dest.read_text());assert data['complete'];found={int(v,16) for v in data['masks_hex']};kernel=set()
            for word in range(1,1<<n):
                syndrome=0
                for q in range(n):
                    if word>>q&1:syndrome^=columns[q]
                if syndrome==0:kernel.add(word)
            circuits=[]
            for word in sorted(kernel,key=int.bit_count):
                if not any(c&word==c for c in circuits):circuits.append(word)
            # The traversal must cover every support-minimal word. It may
            # additionally visit reducible kernel words; these remain valid.
            assert set(circuits)<=found<=kernel
            total+=len(circuits)
    print(f'PASS: all {total} binary-matroid circuits covered in 24 exhaustive controls.')


if __name__=='__main__':main()
