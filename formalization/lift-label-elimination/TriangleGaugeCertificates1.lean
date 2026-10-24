import NormalFormCount
import CycleData

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge8
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[-1,0,0],[0,-1,0],[0,-1,1]]
def Ui : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[-1,0,0],[0,-1,0],[0,-1,1]]
def V : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,1,-1,0,0,0,0,0,-1,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,1,-1,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 3 0 8 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^8 :=
  NormalFormCount.count_integer N 3 0 8 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge8

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge8
open NFTriangleGauge8 CycleData
def chosen : Finset (Fin 5) := {3}
def columns : (Fin 3 ⊕ Fin 8) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^8 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge8.count N)
#print axioms actual_count
end ConnectTriangleGauge8

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge9
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[1,0,1,0,0,0],[0,0,0,-1,0,0],[-1,0,0,0,-1,0],[-1,0,0,0,0,-1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[-1,0,1,0,0,0],[0,0,0,-1,0,0],[-1,0,0,0,-1,0],[-1,0,0,0,0,-1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge9

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge9
open NFTriangleGauge9 CycleData
def chosen : Finset (Fin 5) := {0,3}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^5 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge9.count N)
#print axioms actual_count
end ConnectTriangleGauge9

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge10
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,1,0,-1,1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,-1,0,-1,1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,1,-1,0,0,0,0,-1],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[1,0,0,0,0,1,0,0,0,0,1],[0,1,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,1,0,0,0,0,1],[0,0,1,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,1,0,0,-1],[0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge10

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge10
open NFTriangleGauge10 CycleData
def chosen : Finset (Fin 5) := {1,3}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^5 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge10.count N)
#print axioms actual_count
end ConnectTriangleGauge10

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge11
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,0],[-1,0,0,0,0,-1,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,0],[-1,0,0,0,0,-1,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,1,0,0,0,1,0,0,0],[0,0,0,0,1,0,0,0,0,1,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,1,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,1,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge11

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge11
open NFTriangleGauge11 CycleData
def chosen : Finset (Fin 5) := {0,1,3}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^2 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge11.count N)
#print axioms actual_count
end ConnectTriangleGauge11

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge12
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[0,0,-1,0,0,0],[0,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,0,0,-1,1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[0,0,-1,0,0,0],[0,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,0,0,-1,1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,1,-1,0,0,-1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[1,0,0,1,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,1,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,1,-1,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge12

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge12
open NFTriangleGauge12 CycleData
def chosen : Finset (Fin 5) := {2,3}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([2,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^5 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge12.count N)
#print axioms actual_count
end ConnectTriangleGauge12

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge13
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,0,0,0,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,0],[-1,0,0,0,0,0,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,0,0,0,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,0],[-1,0,0,0,0,0,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,1,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge13

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge13
open NFTriangleGauge13 CycleData
def chosen : Finset (Fin 5) := {0,2,3}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,2,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^2 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge13.count N)
#print axioms actual_count
end ConnectTriangleGauge13

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge14
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,0,0,0,0,0,-1,0,0],[0,0,0,0,0,0,0,-1,0],[0,0,-1,0,0,1,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,0,0,0,0,0,-1,0,0],[0,0,0,0,0,0,0,-1,0],[0,0,-1,0,0,-1,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,1,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[1,0,0,0,0,0,0,1,-1,0,0],[0,1,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,-1,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge14

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge14
open NFTriangleGauge14 CycleData
def chosen : Finset (Fin 5) := {1,2,3}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,2,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^2 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge14.count N)
#print axioms actual_count
end ConnectTriangleGauge14

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge15
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0]]
def U : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,0,0,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0,0],[-1,0,0,0,0,0,0,0,0,0,-1,0],[1,0,0,0,0,1,0,0,-1,0,0,1]]
def Ui : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,0,0,0,-1,0,0,0],[0,0,0,0,0,0,-1,0,0,-1,0,0],[-1,0,0,0,0,0,0,0,0,0,-1,0],[-1,0,0,0,0,-1,0,0,-1,0,0,1]]
def V : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,1,0,0,1,0],[0,0,0,1,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,1,0,0,1,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0]]
def Vi : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,-1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 11 1 0 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^0 :=
  NormalFormCount.count_integer N 11 1 0 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge15

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge15
open NFTriangleGauge15 CycleData
def chosen : Finset (Fin 5) := {0,1,2,3}
def columns : (Fin 11 ⊕ Fin 0) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 1) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,2,3] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => fin_cases i <;> decide
    | inr i => fin_cases i <;> decide
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^0 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge15.count N)
#print axioms actual_count
end ConnectTriangleGauge15
