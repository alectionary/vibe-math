#!/usr/bin/env python3
"""Recover integral supporting planes of the exact block-cardinality tables.

Floating-point hull discovery is followed by exact integer verification of
every inequality on every original allowed triple. Hence any retained plane
is a necessary constraint even if numerical hull discovery were incomplete.
"""
import argparse
import json
import math
from pathlib import Path
import numpy as np
from scipy.spatial import ConvexHull


def supporting_planes(points):
    assert points and all(len(p)==3 for p in points)
    hull=ConvexHull(np.array(points,dtype=float));planes=set()
    for triangle in hull.simplices:
        p,q,r=[points[int(k)] for k in triangle];u=[q[i]-p[i] for i in range(3)];v=[r[i]-p[i] for i in range(3)]
        n=[u[1]*v[2]-u[2]*v[1],u[2]*v[0]-u[0]*v[2],u[0]*v[1]-u[1]*v[0]]
        assert any(n);b=sum(n[i]*p[i] for i in range(3));values=[sum(n[i]*s[i] for i in range(3))-b for s in points]
        if max(values)>0:n=[-a for a in n];b=-b;values=[-a for a in values]
        assert max(values)<=0 and min(values)<0
        g=math.gcd(*n,b);assert g>0;planes.add(tuple(a//g for a in n+[b]))
    assert all(sum(a*v for a,v in zip(row[:3],point))<=row[3] for row in planes for point in points)
    return sorted(planes)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('tables',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();rows=[]
    for row in json.loads(args.tables.read_text()):
        if row['pattern']==0:continue
        planes=supporting_planes(row['allowed']);rows.append({'pattern':row['pattern'],'planes':planes})
    args.output.write_text(json.dumps(rows)+'\n');print(json.dumps({'status':'PASS','patterns':len(rows),'planes':sum(len(r['planes']) for r in rows),'maximum_planes':max(len(r['planes']) for r in rows),'evidence':'every plane checked on all original integer triples'}))


if __name__=='__main__':main()
