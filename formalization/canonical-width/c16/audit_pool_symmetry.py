#!/usr/bin/env python3
"""Certify that the pairing graph's sector-preserving group is just C16.

Color refinement fixes each of the90 sector/orbit blocks setwise. Perfect
matching blocks connect84 of them; an odd-offset cycle forces their phase
permutations to be one common cyclic shift. The six remaining blocks have
distinct neighborhoods into those fixed vertices. Sector exchange doubles
the full bipartition-preserving-or-exchanging group to32 elements.
This classifies symmetry of the finite pairing graph, not existence of a frame.
"""
import argparse
from collections import Counter
import json
from pathlib import Path


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();root=Path(__file__).parent
    X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    A=[{j for j,z in enumerate(Z) if (x&z).bit_count()%2} for x in X]
    assert all((j in A[i])==(i in A[j]) for i in range(720) for j in range(720))
    assert all((j in A[i])==((j//16*16+(j%16+1)%16) in A[i//16*16+(i%16+1)%16]) for i in range(720) for j in range(720))
    neighbors=[[720+j for j in row] for row in A]+[list(row) for row in A];colors=[0]*720+[1]*720;counts=[]
    reached={0};todo=[0]
    while todo:
        for v in neighbors[todo.pop()]:
            if v not in reached:reached.add(v);todo.append(v)
    assert len(reached)==1440
    for step in range(10):
        signatures=[(colors[i],tuple(sorted(Counter(colors[j] for j in row).items()))) for i,row in enumerate(neighbors)];labels={v:k for k,v in enumerate(sorted(set(signatures)))};new=[labels[s] for s in signatures];counts.append(len(labels));colors=new
        if len(labels)==90:break
    assert len(set(colors))==90 and set(Counter(colors).values())=={16}
    assert all(len(set(colors[16*a:16*a+16]))==1 for a in range(90))
    # A monomial circulant block is a perfect matching j=i+h.
    graph=[[] for _ in range(90)];patterns=[]
    for a in range(45):
        row=[]
        for b in range(45):
            f=sum((16*b+h in A[16*a])<<h for h in range(16));row.append(f)
            if f.bit_count()==1:
                h=f.bit_length()-1;graph[a].append((45+b,h));graph[45+b].append((a,-h))
        patterns.append(row)
    potential={0:0};todo=[0];cycles=[];tree=[]
    while todo:
        u=todo.pop()
        for v,h in graph[u]:
            value=(potential[u]+h)%16
            if v in potential:cycles.append((value-potential[v])%16)
            else:potential[v]=value;todo.append(v);tree.append([u,v,h])
    anchors=set(potential);assert len(anchors)==84 and any(h%2 for h in cycles)
    others=sorted(set(range(90))-anchors);assert others==[17,20,32,62,65,77]
    uniqueness=[]
    for u in others:
        signatures=[]
        if u<45:
            for h in range(16):signatures.append(tuple(sorted(j for j in A[16*u+h] if 45+j//16 in anchors)))
        else:
            for h in range(16):signatures.append(tuple(sorted(i for i in A[16*(u-45)+h] if i//16 in anchors)))
        assert len(set(signatures))==16;uniqueness.append({'orbit_vertex':u,'distinct_anchor_neighborhoods':16})
    result={'status':'PASS','scope':'symmetry of the complete720-by720 pairing graph','frame_existence_answered':False,'refinement_class_counts':counts,'sector_orbit_colors':[colors[16*a] for a in range(90)],'matching_component_vertices':sorted(anchors),'matching_tree':tree,'cycle_offsets':sorted(set(cycles)),'remaining_orbits':uniqueness,'sector_preserving_automorphisms':16,'with_sector_exchange':32,'evidence':'finite certificate plus the implication argument in this script docstring'}
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ['matching_tree','sector_orbit_colors','matching_component_vertices']}))


if __name__=='__main__':main()
