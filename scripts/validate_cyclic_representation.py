"""Independent row-space and irregular absorbing-support enumeration checks."""
from pathlib import Path
from collections import Counter
from itertools import combinations
import hashlib
import json
import random
import subprocess
import sys
import tempfile
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b


def low_basis(rows):
    pivots={}
    for word in rows:
        while word:
            low=word&-word
            if low in pivots:word^=pivots[low]
            else:pivots[low]=word;break
    return pivots


def member(word,pivots):
    while word:
        low=word&-word
        if low not in pivots:return False
        word^=pivots[low]
    return True


def run_counter(binary,rows,n):
    data=[f'{n} {len(rows)}']+[str(len(row))+' '+' '.join(map(str,row)) for row in rows]
    return json.loads(subprocess.run([str(binary)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True).stdout)


def brute(rows,n):
    incident=[[set(row) for row in rows if v in row] for v in range(n)]
    return [list(s) for s in combinations(range(n),4)
            if all(sum(1 if len(row.intersection(s))%2==0 else -1 for row in incident[v])>0 for v in s)]


d=json.loads((S/'representation-results.json').read_text())
selection=json.loads((S/'representation-selection.json').read_text())
assert d['sha256']==selection['sha256']
for rel,digest in d['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
assert d['new_noise_patterns']==0 and len(d['records'])==12
reference_checks=0;small=0
with tempfile.TemporaryDirectory(prefix='representation-independent-') as tmp:
    independent=Path(tmp)/'independent';exhaustive=Path(tmp)/'exhaustive'
    for source,out in [('representation_count_independent.cpp',independent),('representation_count.cpp',exhaustive)]:
        subprocess.run(['c++','-std=c++17','-O3',str(S/source),'-o',str(out)],check=True)
    rng=random.Random(473021)
    for n in range(4,11):
        for _ in range(8):
            rows=[sorted(rng.sample(range(n),rng.randrange(1,n+1))) for _ in range(rng.randrange(1,12))]
            expected=brute(rows,n)
            assert run_counter(exhaustive,rows,n)==run_counter(independent,rows,n)==expected
            small+=1
    for rec in d['records']:
        name,label=rec['design'],rec['representation']
        original=next(r for r in d['records'] if r['design']==name and r['representation']=='original')
        masks=list(map(b.rowmask,rec['hx_rows']));base=list(map(b.rowmask,original['hx_rows']))
        p,q=low_basis(masks),low_basis(base)
        assert len(p)==len(q)==rec['rank_hx']==121
        assert all(member(w,p) for w in base) and all(member(w,q) for w in masks)
        found=run_counter(independent,rec['hx_rows'],252)
        assert found==rec['supports'] and len(found)==rec['absorbing_count']
        orig={tuple(s) for s in original['supports']};actual={tuple(s) for s in found}
        assert len(orig-actual)==rec['lost_original_supports'] and len(actual-orig)==rec['gained_supports']
        histogram=Counter()
        for support in found:
            word=b.rowmask(support)
            histogram[sum(b.popcount(w&word)%2 for w in masks)]+=1
        assert dict(sorted(histogram.items()))=={int(k):v for k,v in rec['syndrome_weight_histogram'].items()}
        assert sum(map(len,rec['hx_rows']))==rec['edges']
        assert dict(Counter(map(len,rec['hx_rows'])))=={int(k):v for k,v in rec['row_degree_histogram'].items()}
        if label=='row_order_control':
            assert found==original['supports'] and masks==list(reversed(base))
        if label=='delete_one':
            assert not actual-orig and rec['girth']==8
        reference_checks+=rec['decoder_reference_cases']
        print(name,label,'PASS',len(found),'absorbing supports',flush=True)
assert small==56 and reference_checks==180
print('PASS: 12 representations, both CSS codes, opposite-pivot span equality; two complete enumeration algorithms agree; 56 irregular toy graphs also match exhaustive Python; 180 decoder reference cases archived. No fresh noise or performance claim.')
