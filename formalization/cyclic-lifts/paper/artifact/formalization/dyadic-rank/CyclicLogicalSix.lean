import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.Algebra.BigOperators.Ring.Finset

/-! Concrete baseline: same subdivided K3,3 local topology, different logical role.
Generated data from the unchanged lift-14 cyclic benchmark; finite certificates
and a linear-functional proof of exclusion from the complete stabilizer span. -/
set_option maxRecDepth 20000
set_option maxHeartbeats 8000000
namespace CyclicLogicalSix

def baseline_B : List (List Nat) := [[0, 0, 0], [0, 1, 2], [0, 3, 6]]

def hx_rows : List (List Nat) := [[0, 42, 84, 126, 140, 154], [1, 43, 85, 127, 141, 155], [2, 44, 86, 128, 142, 156], [3, 45, 87, 129, 143, 157], [4, 46, 88, 130, 144, 158], [5, 47, 89, 131, 145, 159], [6, 48, 90, 132, 146, 160], [7, 49, 91, 133, 147, 161], [8, 50, 92, 134, 148, 162], [9, 51, 93, 135, 149, 163], [10, 52, 94, 136, 150, 164], [11, 53, 95, 137, 151, 165], [12, 54, 96, 138, 152, 166], [13, 55, 97, 139, 153, 167], [14, 56, 98, 126, 141, 157], [15, 57, 99, 127, 142, 158], [16, 58, 100, 128, 143, 159], [17, 59, 101, 129, 144, 160], [18, 60, 102, 130, 145, 161], [19, 61, 103, 131, 146, 162], [20, 62, 104, 132, 147, 163], [21, 63, 105, 133, 148, 164], [22, 64, 106, 134, 149, 165], [23, 65, 107, 135, 150, 166], [24, 66, 108, 136, 151, 167], [25, 67, 109, 137, 152, 154], [26, 68, 110, 138, 153, 155], [27, 69, 111, 139, 140, 156], [28, 70, 112, 126, 142, 160], [29, 71, 113, 127, 143, 161], [30, 72, 114, 128, 144, 162], [31, 73, 115, 129, 145, 163], [32, 74, 116, 130, 146, 164], [33, 75, 117, 131, 147, 165], [34, 76, 118, 132, 148, 166], [35, 77, 119, 133, 149, 167], [36, 78, 120, 134, 150, 154], [37, 79, 121, 135, 151, 155], [38, 80, 122, 136, 152, 156], [39, 81, 123, 137, 153, 157], [40, 82, 124, 138, 140, 158], [41, 83, 125, 139, 141, 159], [0, 55, 96, 168, 182, 196], [1, 42, 97, 169, 183, 197], [2, 43, 84, 170, 184, 198], [3, 44, 85, 171, 185, 199], [4, 45, 86, 172, 186, 200], [5, 46, 87, 173, 187, 201], [6, 47, 88, 174, 188, 202], [7, 48, 89, 175, 189, 203], [8, 49, 90, 176, 190, 204], [9, 50, 91, 177, 191, 205], [10, 51, 92, 178, 192, 206], [11, 52, 93, 179, 193, 207], [12, 53, 94, 180, 194, 208], [13, 54, 95, 181, 195, 209], [14, 69, 110, 168, 183, 199], [15, 56, 111, 169, 184, 200], [16, 57, 98, 170, 185, 201], [17, 58, 99, 171, 186, 202], [18, 59, 100, 172, 187, 203], [19, 60, 101, 173, 188, 204], [20, 61, 102, 174, 189, 205], [21, 62, 103, 175, 190, 206], [22, 63, 104, 176, 191, 207], [23, 64, 105, 177, 192, 208], [24, 65, 106, 178, 193, 209], [25, 66, 107, 179, 194, 196], [26, 67, 108, 180, 195, 197], [27, 68, 109, 181, 182, 198], [28, 83, 124, 168, 184, 202], [29, 70, 125, 169, 185, 203], [30, 71, 112, 170, 186, 204], [31, 72, 113, 171, 187, 205], [32, 73, 114, 172, 188, 206], [33, 74, 115, 173, 189, 207], [34, 75, 116, 174, 190, 208], [35, 76, 117, 175, 191, 209], [36, 77, 118, 176, 192, 196], [37, 78, 119, 177, 193, 197], [38, 79, 120, 178, 194, 198], [39, 80, 121, 179, 195, 199], [40, 81, 122, 180, 182, 200], [41, 82, 123, 181, 183, 201], [0, 53, 92, 210, 224, 238], [1, 54, 93, 211, 225, 239], [2, 55, 94, 212, 226, 240], [3, 42, 95, 213, 227, 241], [4, 43, 96, 214, 228, 242], [5, 44, 97, 215, 229, 243], [6, 45, 84, 216, 230, 244], [7, 46, 85, 217, 231, 245], [8, 47, 86, 218, 232, 246], [9, 48, 87, 219, 233, 247], [10, 49, 88, 220, 234, 248], [11, 50, 89, 221, 235, 249], [12, 51, 90, 222, 236, 250], [13, 52, 91, 223, 237, 251], [14, 67, 106, 210, 225, 241], [15, 68, 107, 211, 226, 242], [16, 69, 108, 212, 227, 243], [17, 56, 109, 213, 228, 244], [18, 57, 110, 214, 229, 245], [19, 58, 111, 215, 230, 246], [20, 59, 98, 216, 231, 247], [21, 60, 99, 217, 232, 248], [22, 61, 100, 218, 233, 249], [23, 62, 101, 219, 234, 250], [24, 63, 102, 220, 235, 251], [25, 64, 103, 221, 236, 238], [26, 65, 104, 222, 237, 239], [27, 66, 105, 223, 224, 240], [28, 81, 120, 210, 226, 244], [29, 82, 121, 211, 227, 245], [30, 83, 122, 212, 228, 246], [31, 70, 123, 213, 229, 247], [32, 71, 124, 214, 230, 248], [33, 72, 125, 215, 231, 249], [34, 73, 112, 216, 232, 250], [35, 74, 113, 217, 233, 251], [36, 75, 114, 218, 234, 238], [37, 76, 115, 219, 235, 239], [38, 77, 116, 220, 236, 240], [39, 78, 117, 221, 237, 241], [40, 79, 118, 222, 224, 242], [41, 80, 119, 223, 225, 243]]

def hz_rows : List (List Nat) := [[0, 14, 28, 126, 168, 210], [1, 15, 29, 127, 169, 211], [2, 16, 30, 128, 170, 212], [3, 17, 31, 129, 171, 213], [4, 18, 32, 130, 172, 214], [5, 19, 33, 131, 173, 215], [6, 20, 34, 132, 174, 216], [7, 21, 35, 133, 175, 217], [8, 22, 36, 134, 176, 218], [9, 23, 37, 135, 177, 219], [10, 24, 38, 136, 178, 220], [11, 25, 39, 137, 179, 221], [12, 26, 40, 138, 180, 222], [13, 27, 41, 139, 181, 223], [0, 27, 40, 140, 182, 224], [1, 14, 41, 141, 183, 225], [2, 15, 28, 142, 184, 226], [3, 16, 29, 143, 185, 227], [4, 17, 30, 144, 186, 228], [5, 18, 31, 145, 187, 229], [6, 19, 32, 146, 188, 230], [7, 20, 33, 147, 189, 231], [8, 21, 34, 148, 190, 232], [9, 22, 35, 149, 191, 233], [10, 23, 36, 150, 192, 234], [11, 24, 37, 151, 193, 235], [12, 25, 38, 152, 194, 236], [13, 26, 39, 153, 195, 237], [0, 25, 36, 154, 196, 238], [1, 26, 37, 155, 197, 239], [2, 27, 38, 156, 198, 240], [3, 14, 39, 157, 199, 241], [4, 15, 40, 158, 200, 242], [5, 16, 41, 159, 201, 243], [6, 17, 28, 160, 202, 244], [7, 18, 29, 161, 203, 245], [8, 19, 30, 162, 204, 246], [9, 20, 31, 163, 205, 247], [10, 21, 32, 164, 206, 248], [11, 22, 33, 165, 207, 249], [12, 23, 34, 166, 208, 250], [13, 24, 35, 167, 209, 251], [42, 56, 70, 126, 169, 213], [43, 57, 71, 127, 170, 214], [44, 58, 72, 128, 171, 215], [45, 59, 73, 129, 172, 216], [46, 60, 74, 130, 173, 217], [47, 61, 75, 131, 174, 218], [48, 62, 76, 132, 175, 219], [49, 63, 77, 133, 176, 220], [50, 64, 78, 134, 177, 221], [51, 65, 79, 135, 178, 222], [52, 66, 80, 136, 179, 223], [53, 67, 81, 137, 180, 210], [54, 68, 82, 138, 181, 211], [55, 69, 83, 139, 168, 212], [42, 69, 82, 140, 183, 227], [43, 56, 83, 141, 184, 228], [44, 57, 70, 142, 185, 229], [45, 58, 71, 143, 186, 230], [46, 59, 72, 144, 187, 231], [47, 60, 73, 145, 188, 232], [48, 61, 74, 146, 189, 233], [49, 62, 75, 147, 190, 234], [50, 63, 76, 148, 191, 235], [51, 64, 77, 149, 192, 236], [52, 65, 78, 150, 193, 237], [53, 66, 79, 151, 194, 224], [54, 67, 80, 152, 195, 225], [55, 68, 81, 153, 182, 226], [42, 67, 78, 154, 197, 241], [43, 68, 79, 155, 198, 242], [44, 69, 80, 156, 199, 243], [45, 56, 81, 157, 200, 244], [46, 57, 82, 158, 201, 245], [47, 58, 83, 159, 202, 246], [48, 59, 70, 160, 203, 247], [49, 60, 71, 161, 204, 248], [50, 61, 72, 162, 205, 249], [51, 62, 73, 163, 206, 250], [52, 63, 74, 164, 207, 251], [53, 64, 75, 165, 208, 238], [54, 65, 76, 166, 209, 239], [55, 66, 77, 167, 196, 240], [84, 98, 112, 126, 170, 216], [85, 99, 113, 127, 171, 217], [86, 100, 114, 128, 172, 218], [87, 101, 115, 129, 173, 219], [88, 102, 116, 130, 174, 220], [89, 103, 117, 131, 175, 221], [90, 104, 118, 132, 176, 222], [91, 105, 119, 133, 177, 223], [92, 106, 120, 134, 178, 210], [93, 107, 121, 135, 179, 211], [94, 108, 122, 136, 180, 212], [95, 109, 123, 137, 181, 213], [96, 110, 124, 138, 168, 214], [97, 111, 125, 139, 169, 215], [84, 111, 124, 140, 184, 230], [85, 98, 125, 141, 185, 231], [86, 99, 112, 142, 186, 232], [87, 100, 113, 143, 187, 233], [88, 101, 114, 144, 188, 234], [89, 102, 115, 145, 189, 235], [90, 103, 116, 146, 190, 236], [91, 104, 117, 147, 191, 237], [92, 105, 118, 148, 192, 224], [93, 106, 119, 149, 193, 225], [94, 107, 120, 150, 194, 226], [95, 108, 121, 151, 195, 227], [96, 109, 122, 152, 182, 228], [97, 110, 123, 153, 183, 229], [84, 109, 120, 154, 198, 244], [85, 110, 121, 155, 199, 245], [86, 111, 122, 156, 200, 246], [87, 98, 123, 157, 201, 247], [88, 99, 124, 158, 202, 248], [89, 100, 125, 159, 203, 249], [90, 101, 112, 160, 204, 250], [91, 102, 113, 161, 205, 251], [92, 103, 114, 162, 206, 238], [93, 104, 115, 163, 207, 239], [94, 105, 116, 164, 208, 240], [95, 106, 117, 165, 209, 241], [96, 107, 118, 166, 196, 242], [97, 108, 119, 167, 197, 243]]

def logical_support : List (Fin 252) := [28, 56, 84, 126, 184, 244]

def stabilizer_support : List (Fin 252) := [0, 14, 28, 126, 168, 210]

def dual_support : Finset (Fin 252) := {196, 198, 200, 202, 204, 206, 208, 238, 240, 242, 244, 246, 248, 250}

abbrev F := ZMod 2
abbrev Word := Fin 252 → F

def indicator (support : List (Fin 252)) : Word :=
  fun v => if v ∈ support then 1 else 0

def row (data : List (List Nat)) (i : Fin 126) : Word :=
  fun v => if v.val ∈ data.getD i.val [] then 1 else 0

def sparseParity (ns : List Nat) (word : Word) : F :=
  (ns.map (fun v => word (Fin.ofNat 252 v))).sum

def expandedX (i : Fin 126) : List Nat :=
  let a := i.val % 14
  let u := i.val / 42
  let v := i.val / 14 % 3
  (List.range 3).map (fun k => (3*k+v)*14 +
      ((a+14-(baseline_B.getD u []).getD k 0)%14)) ++
  (List.range 3).map (fun k => 126+(3*u+k)*14 +
      ((a+(baseline_B.getD k []).getD v 0)%14))

def expandedZ (i : Fin 126) : List Nat :=
  let a := i.val % 14
  let u := i.val / 42
  let v := i.val / 14 % 3
  (List.range 3).map (fun k => (3*u+k)*14 +
      ((a+14-(baseline_B.getD v []).getD k 0)%14)) ++
  (List.range 3).map (fun k => 126+(3*k+v)*14 +
      ((a+(baseline_B.getD k []).getD u 0)%14))

/-- Check the explicit circulant expansion and the column-index convention. -/
theorem expansion_bridge :
    (∀ i : Fin 126, hx_rows.getD i.val [] = expandedX i) ∧
    (∀ i : Fin 126, hz_rows.getD i.val [] = expandedZ i) := by decide +kernel

def logicalWord : Word := indicator logical_support

def stabilizerWord : Word := indicator stabilizer_support

def stabilizers : Submodule F Word := Submodule.span F (Set.range (row hz_rows))

/-- The sparse dual witness defines a linear functional on all 252-bit words. -/
def dualFunctional : Word →ₗ[F] F where
  toFun x := ∑ v ∈ dual_support, x v
  map_add' x y := by simp [Finset.sum_add_distrib]
  map_smul' a x := by simp [Finset.mul_sum]

theorem logical_zero_syndrome : ∀ i : Fin 126,
    sparseParity (hx_rows.getD i.val []) logicalWord = 0 := by decide +kernel

theorem generators_annihilated : ∀ i : Fin 126,
    dualFunctional (row hz_rows i) = 0 := by decide +kernel

theorem logical_pairing : dualFunctional logicalWord = 1 := by decide +kernel

/-- Nonmembership concerns the full linear stabilizer span, not just its rows. -/
theorem logical_not_stabilizer : logicalWord ∉ stabilizers := by
  have hs : stabilizers ≤ LinearMap.ker dualFunctional := by
    apply Submodule.span_le.mpr
    rintro _ ⟨i,rfl⟩
    exact generators_annihilated i
  intro h
  have hz : dualFunctional logicalWord = 0 := hs h
  rw [logical_pairing] at hz
  exact one_ne_zero hz

theorem stabilizer_is_row : stabilizerWord = row hz_rows 0 := by decide +kernel

theorem stabilizer_mem : stabilizerWord ∈ stabilizers := by
  rw [stabilizer_is_row]
  exact Submodule.subset_span ⟨0,rfl⟩

def sharesCheck (support : List (Fin 252)) (i j : Fin 6) : Bool :=
  decide (i ≠ j) && hx_rows.any (fun ns =>
    decide ((support.getD i.val 0).val ∈ ns ∧ (support.getD j.val 0).val ∈ ns))

def k33 (i j : Fin 6) : Bool :=
  decide ((i.val < 3 ∧ 3 ≤ j.val) ∨ (j.val < 3 ∧ 3 ≤ i.val))

/-- Contracting the nine induced degree-two checks gives K3,3 for both supports. -/
theorem same_k33_adjacency : ∀ i j : Fin 6,
    sharesCheck logical_support i j = k33 i j ∧
    sharesCheck stabilizer_support i j = k33 i j := by decide +kernel

def inducedDegree (support : List (Fin 252)) (ns : List Nat) : Nat :=
  (support.filter (fun v => decide (v.val ∈ ns))).length

theorem both_nine_degree_two_checks :
    (∀ ns ∈ hx_rows, inducedDegree logical_support ns = 0 ∨ inducedDegree logical_support ns = 2) ∧
    (∀ ns ∈ hx_rows, inducedDegree stabilizer_support ns = 0 ∨ inducedDegree stabilizer_support ns = 2) ∧
    (hx_rows.filter (fun ns => decide (inducedDegree logical_support ns = 2))).length = 9 ∧
    (hx_rows.filter (fun ns => decide (inducedDegree stabilizer_support ns = 2))).length = 9 := by
  decide +kernel

/-- Same contracted local adjacency, opposite stabilizer membership. -/
theorem same_local_topology_different_logical_role :
    (∀ i j : Fin 6, sharesCheck logical_support i j = sharesCheck stabilizer_support i j) ∧
    logicalWord ∉ stabilizers ∧ stabilizerWord ∈ stabilizers := by
  refine ⟨?_,logical_not_stabilizer,stabilizer_mem⟩
  intro i j
  exact (same_k33_adjacency i j).1.trans (same_k33_adjacency i j).2.symm

end CyclicLogicalSix
#print axioms CyclicLogicalSix.expansion_bridge
#print axioms CyclicLogicalSix.logical_zero_syndrome
#print axioms CyclicLogicalSix.generators_annihilated
#print axioms CyclicLogicalSix.logical_pairing
#print axioms CyclicLogicalSix.logical_not_stabilizer
#print axioms CyclicLogicalSix.stabilizer_is_row
#print axioms CyclicLogicalSix.stabilizer_mem
#print axioms CyclicLogicalSix.same_k33_adjacency
#print axioms CyclicLogicalSix.both_nine_degree_two_checks
#print axioms CyclicLogicalSix.same_local_topology_different_logical_role
