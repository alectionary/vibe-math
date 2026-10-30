#!/usr/bin/env python3
"""Independent physical exchange/cost/forest replay and exhaustive tiny controls."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse,copy,gzip,hashlib,json,math,time
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data
from verify_singleton_exchange_terminal import rank
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())

def low_edges(V,E,B,u,v,existing):
    D=math.lcm(u.denominator,*(v[j].denominator for j in E));w={j:int(v[j]*D) for j in E};cost=int(u*D)+sum(w[j] for j in B)
    assert cost<0;rows={}
    for j in B:
        value=V[j];expression=1<<j
        while value:
            pivot=value&-value
            if pivot in rows:a,b=rows[pivot];value^=a;expression^=b
            else:rows[pivot]=(value,expression);break
        assert value
    out=[];total=negative=duplicates=0
    for f in sorted(set(E)-set(B)):
        value=V[f];expression=0
        while value:
            pivot=value&-value;assert pivot in rows;a,b=rows[pivot];value^=a;expression^=b
        assert expression&sum(1<<j for j in B)==expression
        while expression:
            bit=expression&-expression;expression^=bit;e=bit.bit_length()-1
            delta=w[f]-w[e];assert delta>=0;total+=1
            if cost+delta>=0:continue
            negative+=1;C=tuple(sorted((set(B)-{e})|{f}))
            if C in existing:duplicates+=1;continue
            out.append((delta,e,f,cost+delta))
    out.sort()
    return out,D,dict(fundamental_exchange_count=total,strictly_negative_exchange_count=negative,
                       existing_duplicate_count=duplicates,eligible_new_exchange_count=len(out),
                       zero_cost_new_exchange_count=sum(d==0 for d,_,_,_ in out))

def independent_forest(edges,limit):
    graph={};selected=[]
    for edge in edges:
        _,e,f,_=edge;seen={e};todo=[e]
        while todo:
            j=todo.pop()
            for k in graph.get(j,()):
                if k not in seen:seen.add(k);todo.append(k)
        if f in seen:continue
        graph.setdefault(e,set()).add(f);graph.setdefault(f,set()).add(e);selected.append(edge)
        if len(selected)==limit:break
    return selected
def difference_rank(edges):
    rows={}
    for e,f in edges:
        row={e:Q(-1),f:Q(1)}
        while row:
            j=min(row);factor=row[j]
            if j not in rows:rows[j]={k:v/factor for k,v in row.items()};break
            for k,v in rows[j].items():
                row[k]=row.get(k,Q(0))-factor*v
                if not row[k]:del row[k]
    return len(rows)

def tiny_controls():
    from singleton_negative_exchange_batch import candidates,forest_select
    cohorts=exhaustive_edges=selected_checks=0
    for V in ([1,2,3],[0,1,2,3],[1,2,4,3,5,6,7],[1,2,4,3,3,0,5],[1,2,4,8]):
        E=list(range(len(V)));r=rank(V);bases=[tuple(B) for B in combinations(E,r) if rank(V[j] for j in B)==r]
        costs=[[Q(0)]*len(V),[Q(j%3-1) for j in E],[Q((-1)**j*(j+1),3) for j in E],
               [Q((j%2)*2-1,2**101+1) for j in E],[Q((2**101)*(j%3-1)) for j in E]]
        for values in costs:
            v=dict(enumerate(values));minimum=min(sum(v[j] for j in B) for B in bases)
            for B in bases:
                if sum(v[j] for j in B)!=minimum:continue
                for margin in (Q(1,2),Q(7,2)):
                    u=-minimum-margin;existing={B}
                    if len(bases)>1:existing.add(bases[-1])
                    expected=[]
                    for e in B:
                        for f in set(E)-set(B):
                            C=tuple(sorted((set(B)-{e})|{f}));exhaustive_edges+=1
                            if rank(V[j] for j in C)!=r or C in existing:continue
                            value=u+sum(v[j] for j in C)
                            if value<0:expected.append((v[f]-v[e],e,f,value))
                    high,D,stats=candidates(V,E,B,u,v,existing);low,DD,other=low_edges(V,E,B,u,v,existing)
                    assert D==DD and high==low and stats==other
                    assert [(Q(d,D),e,f,Q(c,D)) for d,e,f,c in high]==sorted(expected)
                    for limit in (1,2,64):
                        picked=forest_select(high,E,limit);assert picked==independent_forest(low,limit)
                        assert difference_rank([(e,f) for _,e,f,_ in picked])==len(picked)
                        for _,e,f,c in picked:
                            C=(set(B)-{e})|{f};assert rank(V[j] for j in C)==r and Q(c,D)<0;selected_checks+=1
                    cohorts+=1
    # Four valid exchange directions can form a cycle and have only rank3.
    cycle=[(0,2),(1,2),(1,3),(0,3)];assert difference_rank(cycle)==3
    assert difference_rank(cycle[:3])==3
    return dict(tiny_basis_cost_cohorts=cohorts,literal_exchange_rank_checks=exhaustive_edges,
                selected_tiny_bases_checked=selected_checks,cycle_rank_control=3,large_denominator_bits=102)

def context(d):
    assert d['status']=='EXACT_NEGATIVE_PHYSICAL_EXCHANGE_BATCH_REQUIRES_REPLAY'
    assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items())
    p=read(d['pricing']);pr=read(d['pricing_receipt']);g=read(d['gate'])
    assert sha(d['pricing'])==d['pricing_sha256']==pr['pricing_sha256'] and sha(d['pricing_receipt'])==d['pricing_receipt_sha256']
    assert pr['status']=='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING' and pr['consumer_sha256']==sha(ROOT/'verify_singleton_exact_pricing.py') and pr['missing_archive_column']
    assert sha(d['gate'])==d['gate_sha256'] and g['stop_reason']=='MAXIMUM_20_ROUNDS'
    m=read(p['manifest']);s=read(m['semantic']);ray=read(p['farkas_receipt'])
    assert sha(p['manifest'])==p['manifest_sha256']==ray['manifest_sha256'] and sha(m['semantic'])==m['semantic_sha256']
    assert sha(p['farkas_receipt'])==p['farkas_receipt_sha256'] and ray['status']=='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY'
    assert ray['consumer_sha256']==sha(ROOT/'verify_singleton_archive_cg.py')
    X,Z,_=physical();k=d['anchor_orbit'];assert k==15==s['anchor_orbit'];owner,target=point_data(s['point'],k);q=[v/(16*owner[k]) for v in target[55:]]
    assert sha(s['point'])==d['point_sha256']==p['point_sha256']
    E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0];assert E==s['physical_zero_ground_indices'] and rank(Z[j] for j in E)==sum(q[j] for j in E)==127
    w={name:Q(value) for name,value in ray['proof']['multipliers'].items()};u=w.get('mass',Q(0));v={j:w.get('q'+str(j),Q(0)) for j in E}
    archive=s['physical_bases'];B=p['minimizing_physical_basis'];assert B==d['base_basis'] and B==sorted(set(B)) and len(B)==rank(Z[j] for j in B)==127
    assert u+sum(v[j] for j in B)==Q(p['minimum_affine_value'])==Q(d['base_exact_affine_cost'])<0
    assert u+sum(v[j]*q[j] for j in E)==-Q(ray['proof']['exact_gap'])<0
    assert all(u+sum(v[j] for j in b)==w.get('n'+str(i),Q(0))>=0 for i,b in enumerate(archive))
    existing=set(map(tuple,archive));assert tuple(B) not in existing
    assert len(archive)==d['last_solved_archive_count']==3160 and g['final_columns']==d['prior_discovered_count']==3161
    existing.add(tuple(B));return Z,E,B,u,v,existing

def replay(d,data):
    Z,E,B,u,v,existing=data;edges,D,stats=low_edges(Z,E,B,u,v,existing)
    assert d['statistics']==stats and 1<=d['selection_limit']<=64
    expected=independent_forest(edges,d['selection_limit']);records=d['columns']
    assert d['selected_count']==len(records)==len(expected)<=64
    assert d['forest_direction_rank']==difference_rank([(r['removed'],r['added']) for r in records])==len(records)
    seen=set()
    for record,(delta,e,f,cost) in zip(records,expected):
        assert record['removed']==e and record['added']==f and e in B and f in set(E)-set(B)
        C=sorted((set(B)-{e})|{f});assert record['indices']==C and tuple(C) not in existing|seen;seen.add(tuple(C))
        assert record['physical_rank']==rank(Z[j] for j in C)==len(C)==127
        exact=u+sum(v[j] for j in C);assert exact==Q(cost,D)==Q(record['exact_affine_cost'])<0
        assert Q(record['exact_cost_change'])==Q(delta,D) and record['same_minimum_face']==(delta==0)
    assert d['same_minimum_face_count']==sum(r['same_minimum_face'] for r in records)
    assert d['independent_modulo_existing_archive_not_claimed'] and not d['new_lp_performed']
    return dict(selected_columns_checked=len(records),exact_affine_direction_rank=len(records),
                same_minimum_face_columns=d['same_minimum_face_count'],eligible_new_exchanges=len(edges),
                minimum_selected_affine_cost=str(min(Q(r['exact_affine_cost']) for r in records)) if records else None,
                maximum_selected_affine_cost=str(max(Q(r['exact_affine_cost']) for r in records)) if records else None)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();assert not a.output.exists()
    d=read(a.bank);data=context(d);out=replay(d,data);controls=tiny_controls();mutants=[]
    if d['columns']:
        bad=copy.deepcopy(d);bad['columns'][0]['exact_affine_cost']=str(Q(bad['columns'][0]['exact_affine_cost'])+1);mutants.append(('wrong_cost',bad))
        bad=copy.deepcopy(d);bad['columns'][0]['indices'].pop();mutants.append(('nonbasis',bad))
        bad=copy.deepcopy(d);bad['forest_direction_rank']+=1;mutants.append(('false_direction_rank',bad))
        bad=copy.deepcopy(d);bad['columns'].append(copy.deepcopy(bad['columns'][0]));bad['selected_count']+=1;mutants.append(('duplicate_column',bad))
    rejected=[]
    for name,bad in mutants:
        try:replay(bad,data)
        except (AssertionError,ValueError):rejected.append(name)
        else:raise AssertionError('Accepted '+name)
    out.update(status='PASS_EXACT_NEGATIVE_PHYSICAL_EXCHANGE_BATCH',bank=str(a.bank),bank_sha256=sha(a.bank),
               consumer_sha256=sha(__file__),source_hashes=d['source_hashes'],point_sha256=d['point_sha256'],anchor_orbit=15,
               tiny_controls=controls,corruptions_rejected=rejected,new_lp_performed=False,source_C16_answered=False,
               scope='Valid negative-priced basis columns with independent within-batch directions; no new rank relative to old archive, membership or global cut claim.',
               elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
