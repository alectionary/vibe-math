"""Generate small Lean root certificates; generated numbers are checked by Lean.

This replaces a monolithic decide over all normalized roots by named proofs of
the actual proper-common-neighbor sets, followed by tiny missing-pair counts.
No generated number is accepted as an axiom or imported through native_decide.
"""
from itertools import product
from pathlib import Path
import json, hashlib

ROOT=Path(__file__).resolve().parent

def fs(xs):
    xs=sorted(xs)
    return '{'+','.join(f'({p},{a})' for p,a in xs)+'}' if xs else '∅'

def main():
    out=['import CyclicNormalization', 'import Mathlib.Data.ZMod.Basic',
         'set_option maxHeartbeats 0', 'set_option maxRecDepth 100000',
         'namespace GB48RootData', 'open CyclicNormalization PairFormula',
         'abbrev G := ZMod 24', 'abbrev V := Fin 2 × G', 'abbrev C := Fin 1 × G',
         'def socketsA (p : Fin 2) : Finset C :=',
         '  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,14)}',
         'def socketsB (p : Fin 2) : Finset C :=',
         '  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,8)}',
         'def HA : V → Finset C := incidence socketsA',
         'def HB : V → Finset C := incidence socketsB',
         'theorem cubic (s : Fin 2 → Finset C) (hs : ∀ p, (s p).card=3) :',
         '    ∀ v, (incidence s v).card=3 := by',
         '  intro v',
         '  rw [incidence, Finset.card_image_of_injective _ (shift (Fin 1) v.2).injective]',
         '  exact hs v.1',
         'theorem cubic_A : ∀ v, (HA v).card=3 := cubic socketsA (by decide)',
         'theorem cubic_B : ∀ v, (HB v).card=3 := cubic socketsB (by decide)',
         'theorem linear_from_normalized (s : Fin 2 → Finset C)',
         '    (hn : ∀ p q (d : G), (p,0) ≠ (q,d) →',
         '      (incidence s (p,0) ∩ incidence s (q,d)).card ≤ 1) :',
         '    ∀ u v, u ≠ v → (incidence s u ∩ incidence s v).card ≤ 1 := by',
         '  rintro ⟨p,a⟩ ⟨q,b⟩ huv',
         '  have he : (p,(0 : G)) ≠ (q,-a+b) := by',
         '    intro h',
         '    have hp := congrArg Prod.fst h',
         '    have hab := congrArg Prod.snd h',
         '    have hb : b=a := by',
         '      have hh := congrArg (fun x : G => a+x) hab',
         '      simpa only [add_zero, ← add_assoc, add_neg_cancel, zero_add] using hh.symm',
         '    exact huv (by simp only [hp,hb])',
         '  have h := hn p q (-a+b) he',
         '  have hi : incidence s (p,0) ∩ incidence s (q,-a+b) =',
         '      (incidence s (p,a) ∩ incidence s (q,b)).image (shift (Fin 1) (-a)) := by',
         '    rw [Finset.image_inter _ _ (shift (Fin 1) (-a)).injective]',
         '    rw [← incidence_shift, ← incidence_shift]',
         '    simp only [shift_apply, neg_add_cancel]',
         '  rw [hi, Finset.card_image_of_injective _ (shift (Fin 1) (-a)).injective] at h',
         '  exact h',
         'theorem linear_A : ∀ u v, u≠v → (HA u ∩ HA v).card ≤ 1 :=',
         '  linear_from_normalized socketsA (by decide)',
         'theorem linear_B : ∀ u v, u≠v → (HB u ∩ HB v).card ≤ 1 :=',
         '  linear_from_normalized socketsB (by decide)',
         '#check linear_A', '#check linear_B']
    records=[]
    for side,right,expected in [('A',[0,22,14],32),('B',[0,22,8],12)]:
        offsets=[[0,1,5],right]
        vertices=list(product(range(2),range(24)))
        H={v:frozenset((v[1]+e)%24 for e in offsets[v[0]]) for v in vertices}
        table={}
        for p,q,d in product(range(2),range(2),range(24)):
            u,v=(p,0),(q,d)
            central=u!=v and bool(H[u]&H[v])
            W={w for w in vertices if w!=u and w!=v and H[u]&H[w] and H[v]&H[w]
               and not H[u]&H[v]&H[w]} if central else set()
            value=sum(x!=y and not H[x]&H[y] for x,y in product(W,repeat=2)) if central else 0
            key=f'{p}_{q}_{d}';table[p,q,d]=value
            if central:
                out += [f'private theorem {side}_W_{key} :',
                        f'    properCommon H{side} ({p},0) ({q},{d}) = {fs(W)} := by decide',
                        f'private theorem {side}_root_{key} :',
                        f'    rootTerm H{side} ({p},0) ({q},{d}) = {value} := by',
                        f'  unfold rootTerm',f'  rw [{side}_W_{key}]','  decide']
            else:
                out += [f'private theorem {side}_root_{key} :',
                        f'    rootTerm H{side} ({p},0) ({q},{d}) = 0 := by decide']
            out += [f'#check {side}_root_{key}']
            records.append(dict(side=side,p=p,q=q,d=d,central=central,W=sorted(W),rootTerm=value))
        assert sum(table.values())==expected
        out += [f'def rootTable{side} (p q : Fin 2) (d : G) : ℕ :=',
                '  match p.val,q.val,d.val with']
        for (p,q,d),value in table.items():
            if value:out += [f'  | {p},{q},{d} => {value}']
        out += ['  | _,_,_ => 0',
                f'theorem root_{side}_eq_table (p q : Fin 2) (d : G) :',
                f'    rootTerm H{side} (p,0) (q,d) = rootTable{side} p q d := by',
                '  fin_cases p']
        for p in range(2):
            out += ['  · fin_cases q']
            for q in range(2):
                out += ['    · fin_cases d']
                for d in range(24):
                    out += [f'      · change rootTerm H{side} ({p},0) ({q},{d}) = {table[p,q,d]}',
                            f'        exact {side}_root_{p}_{q}_{d}']
        out += [f'theorem normalized_{side} : normalizedSum sockets{side} = {expected} := by',
                '  unfold normalizedSum',f'  simp_rw [show incidence sockets{side} = H{side} from rfl, root_{side}_eq_table]',
                '  decide',f'theorem count_{side} : GlobalCounting.count42 H{side} = {expected*6} := by',
                f'  have h := cyclic_count_identity sockets{side} cubic_{side} linear_{side}',
                f'  rw [normalized_{side}] at h',
                f'  change 4 * GlobalCounting.count42 H{side} = 24 * {expected} at h',
                '  omega',f'#print axioms count_{side}']
    out += ['end GB48RootData']
    p=ROOT/'GB48RootData.lean';p.write_text('\n'.join(out)+'\n')
    (ROOT/'gb48-root-certificates.json').write_text(json.dumps(dict(
        evidence='Generated candidates; only source-matched successful Lean builds certify these values.',
        rows=records, generator_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        lean_source_sha256=hashlib.sha256(p.read_bytes()).hexdigest()),indent=2)+'\n')
    print('Generated',len(records),'root certificates and',sum(r['central'] for r in records),'proper-neighbor certificates.')

if __name__=='__main__':main()
