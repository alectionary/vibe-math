"""Export exact matrix/linear-combination and local-update certificates to Lean."""
from pathlib import Path
import base64,hashlib,json,zlib
import benchmark_decoding as b
HERE=Path(__file__).resolve().parent;PROJECT=HERE.parents[1]/'dyadic-rank'
data=json.loads((HERE/'merged-mechanism-witnesses.json').read_text())
main=json.loads((HERE/'merged-million-results.json').read_text())
analysis=json.loads((HERE/'merged-mechanism-results.json').read_text())


def lean(value):
    if isinstance(value,bool):return 'true' if value else 'false'
    if isinstance(value,list):return '['+', '.join(map(lean,value))+']'
    return str(value)


def certificate(words,word):
    pivots={}
    for i,w in words:
        coeff=1<<i
        while w:
            p=w.bit_length()-1
            if p in pivots:w^=pivots[p][0];coeff^=pivots[p][1]
            else:pivots[p]=(w,coeff);break
    coeff=0
    while word:
        p=word.bit_length()-1;word^=pivots[p][0];coeff^=pivots[p][1]
    return [i for i in range(125) if coeff>>i&1]


text='''import CyclicMergedMessages
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.Algebra.BigOperators.Ring.Finset

/-! Generated exact matrix and local-state certificates. Local integer inputs
come from independently cross-checked C++/Python replays. Kernel checks below
certify matrix kernels and the stated local transition, not that C++ executes
these entire 100-step trajectories. Regenerate with generate_merged_mechanism_lean.py. -/
set_option maxRecDepth 50000
set_option maxHeartbeats 20000000
set_option linter.unusedSimpArgs false
namespace CyclicMergedWitnesses
open CyclicMergedMessages
open scoped BigOperators
abbrev F := ZMod 2
abbrev W := Fin 252 → F

def rowSet {m : Nat} (data : List (List Nat)) (i : Fin m) : Finset (Fin 252) :=
  ((data.getD i.val []).map (Fin.ofNat 252)).toFinset

def rowVector {m : Nat} (data : List (List Nat)) (i : Fin m) : W :=
  fun v => if v ∈ rowSet data i then 1 else 0

theorem row_eq_of_lists_equal {m n : Nat} (left right : List (List Nat))
    (i : Fin m) (j : Fin n) (h : left.getD i.val [] = right.getD j.val []) :
    rowVector left i = rowVector right j := by
  exact congrArg (fun ns : List Nat => fun v : Fin 252 =>
    if v ∈ (ns.map (Fin.ofNat 252)).toFinset then (1 : F) else 0) h

def dot (x : W) : W →ₗ[F] F where
  toFun r := ∑ v : Fin 252, r v * x v
  map_add' r s := by simp [Pi.add_apply, add_mul, Finset.sum_add_distrib]
  map_smul' a r := by simp [Pi.smul_apply, smul_eq_mul, mul_assoc, Finset.mul_sum]

theorem dot_row {m : Nat} (data : List (List Nat)) (i : Fin m) (x : W) :
    dot x (rowVector data i) = parity (rowSet data i) x := by
  change (∑ v : Fin 252, (if v ∈ rowSet data i then (1 : F) else 0) * x v) = _
  calc
    _ = ∑ v ∈ rowSet data i, (if v ∈ rowSet data i then (1 : F) else 0) * x v := by
      symm
      apply Finset.sum_subset (Finset.subset_univ _)
      intro v hv hnot
      simp [hnot]
    _ = parity (rowSet data i) x := by
      apply Finset.sum_congr rfl
      intro v hv
      simp [hv]

theorem zero_of_row_combinations {m n : Nat}
    (original : Fin m → W) (new : Fin n → W) (coeff : Fin m → Finset (Fin n))
    (hrows : ∀ i, original i = ∑ j ∈ coeff i, new j) (x : W)
    (hzero : ∀ j, dot x (new j) = 0) : ∀ i, dot x (original i) = 0 := by
  intro i
  rw [hrows i, map_sum]
  exact Finset.sum_eq_zero (fun j _ => hzero j)

def expandedX (B : List (List Nat)) (i : Fin 126) : List Nat :=
  let a := i.val % 14
  let u := i.val / 42
  let v := i.val / 14 % 3
  (List.range 3).map (fun k => (3*k+v)*14 + ((a+14-(B.getD u []).getD k 0)%14)) ++
  (List.range 3).map (fun k => 126+(3*u+k)*14 + ((a+(B.getD k []).getD v 0)%14))

def expandedZ (B : List (List Nat)) (i : Fin 126) : List Nat :=
  let a := i.val % 14
  let u := i.val / 42
  let v := i.val / 14 % 3
  (List.range 3).map (fun k => (3*u+k)*14 + ((a+14-(B.getD v []).getD k 0)%14)) ++
  (List.range 3).map (fun k => 126+(3*k+v)*14 + ((a+(B.getD k []).getD u 0)%14))

def word (support : List Nat) : W := fun v => if v.val ∈ support then 1 else 0

theorem binary_cancellation : ∀ a b : F, a + (a + b) = b := by decide +kernel

structure LocalInput where
  vertex : Fin 252
  ownCheck : Fin 126
  sa : Bool
  sb : Bool
  xs : List Int
  ys : List Int
  otherMessages : List Int
  observedSplitMessage : Int
  observedMergedMessage : Int
  observedSplitPost : Int
  observedMergedPost : Int
deriving Inhabited

def splitPost (w : LocalInput) : Int := prior + w.otherMessages.sum + check w.sa w.xs
def mergedPost (w : LocalInput) : Int := prior + w.otherMessages.sum + check (w.sa ^^ w.sb) (w.xs ++ w.ys)

'''
names={'previous_best':'Previous','minimum_4':'Minimum'}
for matrix in data['matrices']:
    name=matrix['design'];ns=names[name];old=list(map(b.rowmask,matrix['original']));new=list(map(b.rowmask,matrix['merged']))
    a,z=matrix['pair']
    _,hz,_=b.construction(matrix['B'],14)
    zdata=[[v for v in range(252) if row>>v&1] for row in hz]
    remaining=[(c if c<z else c-1,w) for c,w in enumerate(old) if c not in (a,z)]
    ca=certificate(remaining,old[a]);cz=certificate(remaining,old[z])
    forward=[ca if i==a else cz if i==z else [i if i<z else i-1] for i in range(126)]
    reverse=[[a,z] if i==a else [i if i<z else i+1] for i in range(125)]
    for original,coeffs,rows in [(old,forward,new),(new,reverse,old)]:
        for w,coeff in zip(original,coeffs):
            value=0
            for c in coeff:value^=rows[c]
            assert value==w
    text+=f'''namespace {ns}
def B : List (List Nat) := {lean(matrix['B'])}
def originalData : List (List Nat) := {lean(matrix['original'])}
def mergedData : List (List Nat) := {lean(matrix['merged'])}
def zData : List (List Nat) := {lean(zdata)}
def oldFromNew : List (List Nat) := {lean(forward)}
def newFromOld : List (List Nat) := {lean(reverse)}
def originalRow (i : Fin 126) : W := rowVector originalData i
def mergedRow (i : Fin 125) : W := rowVector mergedData i
def oldIndex (i : Fin 126) : Fin 125 := Fin.ofNat 125 (if i.val < {z} then i.val else i.val-1)
def newIndex (i : Fin 125) : Fin 126 := Fin.ofNat 126 (if i.val < {z} then i.val else i.val+1)
def oldCoeffs (i : Fin 126) : Finset (Fin 125) :=
  if i = {a} then (({lean(ca)} : List Nat).map (Fin.ofNat 125)).toFinset
  else if i = {z} then (({lean(cz)} : List Nat).map (Fin.ofNat 125)).toFinset
  else {{oldIndex i}}
def newCoeffs (i : Fin 125) : Finset (Fin 126) :=
  if i = {a} then {{{a}, {z}}} else {{newIndex i}}
def stabilizers : Submodule F W := Submodule.span F (Set.range (fun i : Fin 126 => word (zData.getD i.val [])))

theorem matrix_data_well_formed :
    originalData.length = 126 ∧ mergedData.length = 125 ∧ zData.length = 126 ∧
    (originalData ++ mergedData ++ zData).all
      (fun row => decide row.Nodup && row.all (fun v => decide (v < 252))) = true := by decide +kernel

theorem expansion_bridge : ∀ i : Fin 126, originalData.getD i.val [] = expandedX B i := by decide +kernel
theorem z_expansion_bridge : ∀ i : Fin 126, zData.getD i.val [] = expandedZ B i := by decide +kernel

theorem old_data_unchanged : ∀ i : Fin 126, i ≠ {a} → i ≠ {z} →
    originalData.getD i.val [] = mergedData.getD (oldIndex i).val [] := by decide +kernel
theorem new_data_unchanged : ∀ i : Fin 125, i ≠ {a} →
    mergedData.getD i.val [] = originalData.getD (newIndex i).val [] := by decide +kernel
theorem old_a_certificate : ∀ v : Fin 252,
    originalRow {a} v = (∑ j ∈ oldCoeffs {a}, mergedRow j) v := by decide +kernel
theorem old_b_certificate : ∀ v : Fin 252,
    originalRow {z} v = (∑ j ∈ oldCoeffs {z}, mergedRow j) v := by decide +kernel
theorem new_a_certificate : ∀ v : Fin 252,
    mergedRow {a} v = (originalRow {a} + originalRow {z}) v := by decide +kernel

theorem old_rows_reconstruct : ∀ i : Fin 126, originalRow i = ∑ j ∈ oldCoeffs i, mergedRow j := by
  intro i
  by_cases ha : i = {a}
  · subst i
    funext v
    exact old_a_certificate v
  by_cases hz : i = {z}
  · subst i
    funext v
    exact old_b_certificate v
  calc
    originalRow i = mergedRow (oldIndex i) :=
      row_eq_of_lists_equal originalData mergedData i (oldIndex i) (old_data_unchanged i ha hz)
    _ = ∑ j ∈ oldCoeffs i, mergedRow j := by simp [oldCoeffs, ha, hz]
theorem new_rows_reconstruct : ∀ i : Fin 125, mergedRow i = ∑ j ∈ newCoeffs i, originalRow j := by
  intro i
  by_cases ha : i = {a}
  · subst i
    have h := funext new_a_certificate
    simpa [newCoeffs, Finset.sum_pair (show ({a} : Fin 126) ≠ {z} by decide)] using h
  calc
    mergedRow i = originalRow (newIndex i) :=
      row_eq_of_lists_equal mergedData originalData i (newIndex i) (new_data_unchanged i ha)
    _ = ∑ j ∈ newCoeffs i, originalRow j := by simp [newCoeffs, ha]

theorem old_coordinate_certificate : ∀ (i : Fin 126) (v : Fin 252),
    originalRow i v = (∑ j ∈ oldCoeffs i, mergedRow j) v := by
  intro i v
  exact congrFun (old_rows_reconstruct i) v
theorem new_coordinate_certificate : ∀ (i : Fin 125) (v : Fin 252),
    mergedRow i v = (∑ j ∈ newCoeffs i, originalRow j) v := by
  intro i v
  exact congrFun (new_rows_reconstruct i) v

/-- The two *actual* parity-check matrices have identical zero-syndrome words. -/
theorem kernel_equivalent (x : W) :
    (∀ i : Fin 126, parity (rowSet originalData i) x = 0) ↔
    (∀ i : Fin 125, parity (rowSet mergedData i) x = 0) := by
  have h : (∀ i : Fin 126, dot x (originalRow i) = 0) ↔
      (∀ i : Fin 125, dot x (mergedRow i) = 0) := by
    exact ⟨zero_of_row_combinations mergedRow originalRow newCoeffs new_rows_reconstruct x,
      zero_of_row_combinations originalRow mergedRow oldCoeffs old_rows_reconstruct x⟩
  simpa only [originalRow, mergedRow, dot_row] using h

end {ns}
'''

for witness in data['witnesses']:
    design=witness['design'];ns=names[design]
    tag=ns+('Blocked' if witness['kind'].startswith('actual') else 'Native')
    index=witness['index']
    for label in ['original','merged']:
        row=next(r for r in main['results'] if r['design']==design and r['representation']==label)
        iterations=zlib.decompress(base64.b64decode(row['iterations_zlib_base64']))
        syn=zlib.decompress(base64.b64decode(row['syndrome_flags_zlib_base64']))
        assert witness[label+'_terminal'][0]==iterations[index]
        assert bool(witness[label+'_terminal'][1])==(not bool(syn[index//8]&(1<<(index%8))))
    local=[]
    for w in witness['locals']:
        local.append('{ vertex := '+str(w['variable'])+', ownCheck := '+str(w['own_check'])+', sa := '+lean(bool(w['own_syndrome']))+', sb := '+lean(bool(w['other_syndrome']))+
                     ', xs := '+lean(w['xs'])+', ys := '+lean(w['ys'])+', otherMessages := '+lean(w['other_variable_messages'])+
                     ', observedSplitMessage := '+lean(w['split_message'])+', observedMergedMessage := '+lean(w['merged_message'])+
                     ', observedSplitPost := '+lean(w['split_posterior'])+', observedMergedPost := '+lean(w['merged_posterior'])+' }')
    matrix=next(m for m in data['matrices'] if m['design']==design);a,z=matrix['pair']
    _,hz,_=b.construction(matrix['B'],14)
    residual=b.rowmask(witness['error_support'])^b.rowmask(witness['split_support'])
    assert b.in_span(residual,b.basis(hz))
    if residual:
        stabilizer_index=hz.index(residual)
        recovery_proof=f'''theorem split_residual_certificate : ∀ v : Fin 252,
    errorWord v + splitWord v = word ({ns}.zData.getD {stabilizer_index} []) v := by decide +kernel
theorem split_recovery_is_valid : (fun v => errorWord v + splitWord v) ∈ {ns}.stabilizers := by
  have h : (fun v => errorWord v + splitWord v) = word ({ns}.zData.getD {stabilizer_index} []) := by
    funext v
    exact split_residual_certificate v
  rw [h]
  exact Submodule.subset_span ⟨({stabilizer_index} : Fin 126), rfl⟩
'''
    else:
        recovery_proof=f'''theorem split_residual_certificate : ∀ v : Fin 252, errorWord v + splitWord v = 0 := by decide +kernel
theorem split_recovery_is_valid : (fun v => errorWord v + splitWord v) ∈ {ns}.stabilizers := by
  have h : (fun v => errorWord v + splitWord v) = 0 := by
    funext v
    exact split_residual_certificate v
  rw [h]
  exact Submodule.zero_mem _
'''
    text+=f'''namespace {tag}
/-! Fixed error index {index}, iteration {witness['iteration']}, state from {witness['state_source']}.
External replay establishes reachability. Theorems certify the local update and syndrome obstruction. -/
def errorSupport : List Nat := {lean(witness['error_support'])}
def splitSupport : List Nat := {lean(witness['split_support'])}
def mergedSupport : List Nat := {lean(witness['merged_support'])}
def errorWord : W := word errorSupport
def splitWord : W := word splitSupport
def mergedWord : W := word mergedSupport
def changeWord : W := fun v => splitWord v + mergedWord v
def localData : List LocalInput := [{', '.join(local)}]
def input (i : Fin 12) : LocalInput := localData.getD i.val default
def oddCheck : Fin 126 := {witness['odd_check']}

theorem exact_local_updates : ∀ i : Fin 12,
    check (input i).sa (input i).xs = (input i).observedSplitMessage ∧
    check ((input i).sa ^^ (input i).sb) ((input i).xs ++ (input i).ys) = (input i).observedMergedMessage ∧
    splitPost (input i) = (input i).observedSplitPost ∧
    mergedPost (input i) = (input i).observedMergedPost := by decide +kernel

theorem local_decisions_match_words : ∀ i : Fin 12,
    decision (splitPost (input i)) = decide ((input i).vertex.val ∈ splitSupport) ∧
    decision (mergedPost (input i)) = decide ((input i).vertex.val ∈ mergedSupport) := by decide +kernel

theorem unchanged_off_source_edges : ∀ v : Fin 252,
    (∀ i : Fin 12, (input i).vertex ≠ v) → splitWord v = mergedWord v := by decide +kernel

theorem source_syndromes_match_error : ∀ i : Fin 12,
    parity (rowSet {ns}.originalData (input i).ownCheck) errorWord = (if (input i).sa then 1 else 0) ∧
    parity (rowSet {ns}.originalData (Fin.ofNat 126 (if (input i).ownCheck.val = {a} then {z} else {a}))) errorWord =
      (if (input i).sb then 1 else 0) := by decide +kernel

theorem local_inputs_bounded : ∀ i : Fin 12,
    ((input i).xs ++ (input i).ys).all (fun q => decide (q.natAbs ≤ cap)) = true := by decide +kernel

theorem split_accepts : ∀ c : Fin 126,
    parity (rowSet {ns}.originalData c) (fun v => errorWord v + splitWord v) = 0 := by decide +kernel

{recovery_proof}

theorem change_has_odd_overlap : parity (rowSet {ns}.originalData oddCheck) changeWord = 1 := by decide +kernel

theorem merged_local_update_obstructs_syndrome :
    parity (rowSet {ns}.originalData oddCheck) (fun v => errorWord v + mergedWord v) = 1 := by
  have h := odd_overlap_obstructs_syndrome (rowSet {ns}.originalData oddCheck)
    errorWord splitWord changeWord (split_accepts oddCheck) change_has_odd_overlap
  simpa only [changeWord, binary_cancellation] using h

theorem merged_update_is_rejected_by_actual_merged_matrix :
    ¬ ∀ c : Fin 125, parity (rowSet {ns}.mergedData c) (fun v => errorWord v + mergedWord v) = 0 := by
  intro h
  have hzero := ({ns}.kernel_equivalent (fun v => errorWord v + mergedWord v)).mpr h
  have hbad := hzero oddCheck
  rw [merged_local_update_obstructs_syndrome] at hbad
  exact one_ne_zero hbad

end {tag}
'''

for rec in analysis['records']:
    e=next(e for e in rec['examples'] if 'first_lost_syndrome_match/attenuation_only' in e['reasons'])
    w=e['onset_witness'];ns=names[rec['design']]+'Attenuation'
    text+=f'''namespace {ns}
/-! First attenuation-only lost-match onset: error {e['index']}, round {e['first_message']}, variable {w['variable']}. -/
def xs : List Int := {lean(w['xs'])}
def ys : List Int := {lean(w['ys'])}
theorem actual_onset_attenuation :
    check {lean(bool(w['own_syndrome']))} xs = {lean(w['split_message'])} ∧
    check ({lean(bool(w['own_syndrome']))} ^^ {lean(bool(w['other_syndrome']))}) (xs ++ ys) = {lean(w['merged_message'])} ∧
    (check ({lean(bool(w['own_syndrome']))} ^^ {lean(bool(w['other_syndrome']))}) (xs ++ ys)).natAbs <
      (check {lean(bool(w['own_syndrome']))} xs).natAbs := by decide +kernel
end {ns}
'''
text+='end CyclicMergedWitnesses\n'
for ns in ['Previous','Minimum']:
    for theorem in ['expansion_bridge','old_coordinate_certificate','new_coordinate_certificate','kernel_equivalent']:
        text+=f'#print axioms CyclicMergedWitnesses.{ns}.{theorem}\n'
for ns in ['PreviousNative','PreviousBlocked','MinimumNative','MinimumBlocked']:
    for theorem in ['exact_local_updates','source_syndromes_match_error','split_recovery_is_valid','merged_update_is_rejected_by_actual_merged_matrix']:
        text+=f'#print axioms CyclicMergedWitnesses.{ns}.{theorem}\n'
for ns in ['PreviousAttenuation','MinimumAttenuation']:text+=f'#print axioms CyclicMergedWitnesses.{ns}.actual_onset_attenuation\n'
path=PROJECT/'CyclicMergedWitnesses.lean';path.write_text(text)
print('Generated',path.name,'with exact two-way matrix certificates, four local acceptance obstructions and two attenuation witnesses.')
