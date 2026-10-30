#!/usr/bin/env python3
"""Transfer existing circuit/rank results, recheck physically, screen new point."""
from pathlib import Path
from functools import reduce
from operator import xor
import collections,hashlib,json,time
import numpy as np
from moment_circuit_cuts import source_vectors
from verify_inverse_lift import mp
from verify_algebraic_model import physical
from verify_mixed_rank_cover_cuts import echelon
from physical_circuit_moment_matrix import matrix
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();sourcepath=ROOT/'inversion-results/normal-form.json';source=json.loads(sourcepath.read_text());X,Z,A=physical();vectors={'X':X,'Z':Z};mapping={};orbits={}
    for side in ('X','Z'):
        old=source_vectors(source,side);physical_tensor=list(map(mp,source['tensor'][side+'_tensor_coordinates']));lookup={v:i for i,v in enumerate(physical_tensor)};assert len(lookup)==720;mapping[side]=[lookup[v] for v in old];assert sorted(mapping[side])==list(range(720))
        for i in range(720):assert mapping[side][16*(i//16)+(i%16+1)%16]==16*(mapping[side][i]//16)+(mapping[side][i]%16+1)%16
        orbits[side]=[mapping[side][16*i]//16 for i in range(45)];assert sorted(orbits[side])==list(range(45))
    cp=ROOT/'inverse-four-hour-results/structured-circuits6.json';oldcircuits=json.loads(cp.read_text());circuits=set();source_count=0
    for side,items in oldcircuits.items():
        for C in items:
            D=[mapping[side][i] for i in C];canonical=min(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in D)) for h in range(16));circuits.add(canonical);source_count+=1
    circuits=sorted(circuits,key=lambda C:(len(C),C));assert source_count==160
    for C in circuits:
        for U in (X,Z):assert reduce(xor,(U[i] for i in C),0)==0 and len(echelon(U[i] for i in C))==len(C)-1
    M,rows,meta=matrix(circuits);point=ROOT/'moment-resumption-results/owner-combined-necessary.npz';z=np.load(point);flat=np.concatenate([z['p']]+[z[f'{side}{h}'].ravel() for side in ('S','T') for h in range(9)]);viol=M@flat;selected=sorted(np.flatnonzero(viol>1e-7),key=lambda k:(-viol[k],k))[:4096]
    chosen=[{'metadata':meta[k],'coefficients':rows[k],'numeric_violation':float(viol[k])} for k in selected]
    # Source rectangles are discovery candidates only. Every retained bound is
    # recomputed in the actual physical pool before becoming a constraint.
    rectangles=[];rectangle_scans=0
    for side in ('X','Z'):
        rp=ROOT/f'inverse-four-hour-results/rank-rectangle-{side}.json'
        for c in json.loads(rp.read_text()):
            old_orbits=[9*t+i for t in range(5) if c['thin_mask']>>t&1 for i in range(9) if c['thick_mask']>>i&1];physical_orbits=sorted(orbits[side][i] for i in old_orbits);gap=16*sum(float(z['p'][i]) for i in physical_orbits)-c['rank'];rectangle_scans+=1
            if gap<=1e-7:continue
            physical_indices=[16*i+h for i in physical_orbits for h in range(16)];ranks=[len(echelon(U[i] for i in physical_indices)) for U in (X,Z)];assert ranks==[c['rank'],c['rank']]
            rectangles.append({'physical_orbits':physical_orbits,'rank':c['rank'],'numeric_violation':gap,'origin':{'c16_path':str(rp.relative_to(ROOT)),'thin_mask':c['thin_mask'],'thick_mask':c['thick_mask']}})
    unique={tuple(c['physical_orbits']):c for c in rectangles};rectangles=sorted(unique.values(),key=lambda c:(-c['numeric_violation'],c['physical_orbits']))
    bank={'status':'PHYSICALLY_CHECKED_SOURCE_RANK_ROWS','source_C16_answered':False,'physical_circuits':[list(C) for C in circuits],'selected_circuit_rows':chosen,'violated_rank_rectangles':rectangles,'inputs':{str(p.relative_to(ROOT)):sha(p) for p in [sourcepath,cp,point,ROOT/'inverse-four-hour-results/rank-rectangle-X.json',ROOT/'inverse-four-hour-results/rank-rectangle-Z.json']},'mapping':mapping,'scope':'Previously established circuit/rank methods, newly translated into the physical profile layout. Each used circuit and rectangle rank is independently recomputed in both actual source pools. Selection is by numerical violation, never by an unverified source exclusion.'}
    bp=ROOT/'moment-resumption-results/physical-rank-moment-bank.json';bp.write_text(json.dumps(bank,indent=2)+'\n')
    result={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(bp),'old_circuit_classes':source_count,'physical_sector_folded_circuit_classes':len(circuits),'distinct_conditioned_circuit_rows':len(rows),'numerically_violated_circuit_rows':int(sum(viol>1e-7)),'selected_rows':len(chosen),'maximum_numeric_circuit_violation':float(max(viol)),'rectangle_candidates_screened':rectangle_scans,'retained_physically_checked_rectangle_rows':len(rectangles),'maximum_numeric_rectangle_violation':max([r['numeric_violation'] for r in rectangles],default=0),'source_hashes':{p:sha(ROOT/p) for p in ['prepare_physical_circuit_moments.py','physical_circuit_moment_matrix.py']},'elapsed_seconds':time.monotonic()-start,'scope':'Exact source circuit/rank validation and numerical candidate separation. No new obstruction or complete feasible-point certificate.'}
    (ROOT/'moment-resumption-results/physical-rank-preparation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
