import NormalFormCount
import CycleData

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge0
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 0 ⊕ Fin 0) (Fin 0 ⊕ Fin 11) ℤ :=
  data []
def U : Matrix (Fin 0 ⊕ Fin 0) (Fin 0 ⊕ Fin 0) ℤ :=
  data []
def Ui : Matrix (Fin 0 ⊕ Fin 0) (Fin 0 ⊕ Fin 0) ℤ :=
  data []
def V : Matrix (Fin 0 ⊕ Fin 11) (Fin 0 ⊕ Fin 11) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 0 ⊕ Fin 11) (Fin 0 ⊕ Fin 11) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 0 0 11 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^11 :=
  NormalFormCount.count_integer N 0 0 11 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge0

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge0
open NFTriangleGauge0 CycleData
def chosen : Finset (Fin 5) := ∅
def columns : (Fin 0 ⊕ Fin 11) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 0 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([] : List ℕ)[ix m / 3]?.getD 0, by
    cases m with
    | inl i => exact Fin.elim0 i
    | inr i => exact Fin.elim0 i
  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)
theorem rows_match : ∀ m k, A m (columns.symm k)=triangleGauge (rowAt m).1 (rowAt m).2 k := by decide
theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide
theorem actual_count (N : ℕ) [NeZero N] :
    Nat.card {z : Fin 11 → ZMod N // CycleKernelBridge.Events triangleGauge chosen z}=N^11 := by
  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) triangleGauge chosen
    (A.submatrix id columns.symm) rowAt rows_match rows_complete
  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge0.count N)
#print axioms actual_count
end ConnectTriangleGauge0

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge1
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0]]
def U : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[1,0,0],[0,-1,0],[1,0,1]]
def Ui : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[1,0,0],[0,-1,0],[-1,0,1]]
def V : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 3 0 8 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^8 :=
  NormalFormCount.count_integer N 3 0 8 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge1

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge1
open NFTriangleGauge1 CycleData
def chosen : Finset (Fin 5) := {0}
def columns : (Fin 3 ⊕ Fin 8) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge1.count N)
#print axioms actual_count
end ConnectTriangleGauge1

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge2
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1]]
def U : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[1,0,0],[0,1,0],[0,0,1]]
def Ui : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[1,0,0],[0,1,0],[0,0,1]]
def V : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,1,0,0,0],[0,1,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,1,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 3 0 8 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^8 :=
  NormalFormCount.count_integer N 3 0 8 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge2

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge2
open NFTriangleGauge2 CycleData
def chosen : Finset (Fin 5) := {1}
def columns : (Fin 3 ⊕ Fin 8) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge2.count N)
#print axioms actual_count
end ConnectTriangleGauge2

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge3
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[1,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[-1,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,1,0,0,0,1,0,0,0],[0,0,0,0,1,0,0,0,0,1,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge3

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge3
open NFTriangleGauge3 CycleData
def chosen : Finset (Fin 5) := {0,1}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge3.count N)
#print axioms actual_count
end ConnectTriangleGauge3

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge4
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1]]
def U : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[1,0,0],[0,-1,0],[0,0,-1]]
def Ui : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[1,0,0],[0,-1,0],[0,0,-1]]
def V : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[1,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
def Vi : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 3 0 8 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^8 :=
  NormalFormCount.count_integer N 3 0 8 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge4

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge4
open NFTriangleGauge4 CycleData
def chosen : Finset (Fin 5) := {2}
def columns : (Fin 3 ⊕ Fin 8) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([2] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge4.count N)
#print axioms actual_count
end ConnectTriangleGauge4

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge5
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[1,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,-1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[-1,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,-1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge5

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge5
open NFTriangleGauge5 CycleData
def chosen : Finset (Fin 5) := {0,2}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,2] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge5.count N)
#print axioms actual_count
end ConnectTriangleGauge5

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge6
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,-1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,-1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,1,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,1,0],[1,0,0,0,0,0,0,1,0,0,0],[0,1,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,1,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge6

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge6
open NFTriangleGauge6 CycleData
def chosen : Finset (Fin 5) := {1,2}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,2] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge6.count N)
#print axioms actual_count
end ConnectTriangleGauge6

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge7
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,-1,0,0],[0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,-1,0,0],[0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0,0,0,1],[0,0,0,1,0,0,0,0,0,1,0],[0,0,0,0,1,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,1,0,0,1,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,-1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,1,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge7

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge7
open NFTriangleGauge7 CycleData
def chosen : Finset (Fin 5) := {0,1,2}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,2] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge7.count N)
#print axioms actual_count
end ConnectTriangleGauge7
