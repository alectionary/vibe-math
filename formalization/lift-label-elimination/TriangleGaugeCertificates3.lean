import NormalFormCount
import CycleData

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge24
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[-1,0,0,0,0,0],[0,-1,0,0,0,0],[0,-1,1,0,0,0],[0,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[-1,0,0,0,0,0],[0,-1,0,0,0,0],[0,-1,1,0,0,0],[0,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,1,-1,0,0,0,0,0,-1,0,0],[0,0,0,0,0,1,1,1,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,1,0,-1,-1,-1,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,1,-1,0,0],[0,1,0,1,0,0,0,0,0,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge24

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge24
open NFTriangleGauge24 CycleData
def chosen : Finset (Fin 5) := {3,4}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge24.count N)
#print axioms actual_count
end ConnectTriangleGauge24

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge25
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0],[0,0,0,-1,0,0,0,0,0],[-1,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,-1,0,0,0],[-1,1,-1,0,0,0,-1,0,0],[-1,0,-1,0,0,0,0,-1,0],[0,-1,0,0,0,0,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0],[0,0,0,-1,0,0,0,0,0],[-1,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,-1,0,0,0],[0,-1,-1,0,0,0,-1,0,0],[0,0,-1,0,0,0,0,-1,0],[0,1,0,0,0,0,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge25

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge25
open NFTriangleGauge25 CycleData
def chosen : Finset (Fin 5) := {0,3,4}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge25.count N)
#print axioms actual_count
end ConnectTriangleGauge25

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge26
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0],[0,0,0,-1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,1,0,-1,1,0,0,0],[0,0,0,0,0,0,-1,0,0],[-1,0,-1,0,1,-1,0,-1,0],[1,-1,1,0,-1,1,-1,1,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0],[0,0,0,-1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,-1,0,-1,1,0,0,0],[0,0,0,0,0,0,-1,0,0],[-1,0,0,0,0,-1,0,-1,0],[0,-1,0,0,0,0,1,-1,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,1,-1,0,0,0,0,-1],[0,0,0,0,0,0,1,0,-1,1,-1],[0,0,0,0,0,0,0,1,0,0,-1],[0,0,0,0,0,0,0,0,1,-1,1],[0,0,0,1,0,0,0,0,0,0,0],[1,0,0,0,0,1,0,0,0,0,1],[0,1,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,1,0,0,0,0,1],[0,0,1,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,1,0,0,-1],[0,1,0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,0,0,0,1,-1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge26

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge26
open NFTriangleGauge26 CycleData
def chosen : Finset (Fin 5) := {1,3,4}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge26.count N)
#print axioms actual_count
end ConnectTriangleGauge26

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge27
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,-1,0,0,-1,0,0,0],[-1,1,-1,0,0,0,0,0,0,-1,0,0],[0,-1,0,0,-1,0,0,0,0,0,0,-1],[0,0,1,1,0,0,0,-1,0,0,1,0]]
def Ui : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,-1,0,0,-1,0,0,0],[0,-1,-1,0,0,0,0,0,0,-1,0,0],[0,0,-1,-1,0,0,0,-1,0,0,0,1],[0,1,0,0,-1,0,0,0,0,0,-1,0]]
def V : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,1,0,0,0,1,0,0,0],[0,0,0,0,1,0,0,0,0,0,1],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,1,0,0]]
def Vi : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 11 1 0 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^0 :=
  NormalFormCount.count_integer N 11 1 0 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge27

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge27
open NFTriangleGauge27 CycleData
def chosen : Finset (Fin 5) := {0,1,3,4}
def columns : (Fin 11 ⊕ Fin 0) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 1) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge27.count N)
#print axioms actual_count
end ConnectTriangleGauge27

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge28
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,0,0,0,0],[0,0,0,-1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,-1,1,0,0,0],[-1,0,0,1,0,0,-1,0,0],[0,0,0,0,0,0,0,-1,0],[-1,0,0,1,0,0,-1,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,0,0,0,0],[0,0,0,-1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,-1,1,0,0,0],[-1,0,0,-1,0,0,-1,0,0],[0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,1,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,1,-1,0,0,0,-1,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[1,0,0,1,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,-1],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,0,1,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,1,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,1,-1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,0,1,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge28

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge28
open NFTriangleGauge28 CycleData
def chosen : Finset (Fin 5) := {2,3,4}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([2,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge28.count N)
#print axioms actual_count
end ConnectTriangleGauge28

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge29
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0,0,0,0],[0,0,0,0,0,-1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0,0],[-1,0,-1,0,0,0,0,0,0,0,-1,0],[0,-1,0,0,0,0,0,0,0,0,0,-1],[1,-1,1,1,0,0,-1,0,0,1,0,0]]
def Ui : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0,0,0,0],[0,0,0,0,0,-1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0,0],[0,-1,-1,-1,0,0,-1,0,0,0,0,1],[0,0,-1,0,0,0,0,0,0,-1,0,0],[0,1,0,0,0,0,0,0,0,0,-1,0]]
def V : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,1,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 11 1 0 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^0 :=
  NormalFormCount.count_integer N 11 1 0 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge29

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge29
open NFTriangleGauge29 CycleData
def chosen : Finset (Fin 5) := {0,2,3,4}
def columns : (Fin 11 ⊕ Fin 0) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 1) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,2,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge29.count N)
#print axioms actual_count
end ConnectTriangleGauge29

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge30
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0,0,0,0],[0,0,0,0,0,-1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0],[0,0,-1,0,0,1,0,0,-1,0,0,0],[0,0,0,-1,0,0,1,0,0,-1,0,0],[-1,0,-1,0,0,1,0,1,-1,0,-1,0],[-1,1,-1,1,-1,1,-1,1,-1,1,-1,1]]
def Ui : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0,0,0,0],[0,0,0,0,0,-1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0],[0,0,-1,0,0,-1,0,0,-1,0,0,0],[0,0,0,-1,0,0,-1,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,1,0,-1,0],[0,-1,0,0,-1,0,0,0,0,1,-1,1]]
def V : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,1,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[1,0,0,0,0,0,0,1,-1,0,0],[0,1,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,-1,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 11 1 0 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^0 :=
  NormalFormCount.count_integer N 11 1 0 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge30

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge30
open NFTriangleGauge30 CycleData
def chosen : Finset (Fin 5) := {1,2,3,4}
def columns : (Fin 11 ⊕ Fin 0) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 1) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,2,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge30.count N)
#print axioms actual_count
end ConnectTriangleGauge30

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge31
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 11 ⊕ Fin 4) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,0,0,0,-1,0,0,0,0,0,0],[-1,0,0,0,0,0,0,-1,0,0,0],[-1,0,0,0,0,0,0,0,-1,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 11 ⊕ Fin 4) (Fin 11 ⊕ Fin 4) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,-1,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0,0,0,0,0],[-1,0,0,0,0,0,0,0,0,0,-1,0,0,0,0],[1,0,0,0,0,1,0,0,-1,0,0,1,0,0,0],[1,-1,1,0,0,0,1,0,0,-1,0,0,1,0,0],[0,0,1,1,0,0,0,0,0,0,-1,0,0,1,0],[0,1,0,0,1,0,0,-1,0,0,0,0,0,0,1]]
def Ui : Matrix (Fin 11 ⊕ Fin 4) (Fin 11 ⊕ Fin 4) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,-1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,-1,0,0,0,0,0],[-1,0,0,0,0,0,0,0,0,0,-1,0,0,0,0],[-1,0,0,0,0,-1,0,0,-1,0,0,1,0,0,0],[0,-1,-1,0,0,0,0,0,0,-1,0,0,1,0,0],[0,0,-1,-1,0,0,0,0,0,0,-1,0,0,1,0],[0,1,0,0,-1,0,0,-1,0,0,0,0,0,0,1]]
def V : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,1,0,0,1,0],[0,0,0,1,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,1,0,0,1,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0]]
def Vi : Matrix (Fin 11 ⊕ Fin 0) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,-1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 11 4 0 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^0 :=
  NormalFormCount.count_integer N 11 4 0 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge31

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge31
open NFTriangleGauge31 CycleData
def chosen : Finset (Fin 5) := {0,1,2,3,4}
def columns : (Fin 11 ⊕ Fin 0) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 4) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,2,3,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge31.count N)
#print axioms actual_count
end ConnectTriangleGauge31
