import NormalFormCount
import CycleData

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge16
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[-1,0,0],[0,-1,0],[-1,1,-1]]
def Ui : Matrix (Fin 3 ⊕ Fin 0) (Fin 3 ⊕ Fin 0) ℤ :=
  data [[-1,0,0],[0,-1,0],[1,-1,-1]]
def V : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,0,0,1,0,0,0,0,0,0,0],[1,0,-1,0,0,-1,1,0,0,0,0],[0,1,0,0,0,-1,0,0,0,0,0],[0,0,1,0,0,1,-1,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 3 ⊕ Fin 8) (Fin 3 ⊕ Fin 8) ℤ :=
  data [[0,1,0,1,0,0,0,0,0,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,0,0,1,0,-1,1,0,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 3 0 8 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^8 :=
  NormalFormCount.count_integer N 3 0 8 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge16

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge16
open NFTriangleGauge16 CycleData
def chosen : Finset (Fin 5) := {4}
def columns : (Fin 3 ⊕ Fin 8) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 3 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge16.count N)
#print axioms actual_count
end ConnectTriangleGauge16

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge17
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[1,0,1,0,0,0],[-1,1,-1,-1,0,0],[-1,0,-1,0,-1,0],[0,-1,0,0,0,-1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[-1,0,1,0,0,0],[0,-1,-1,-1,0,0],[0,0,-1,0,-1,0],[0,1,0,0,0,-1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge17

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge17
open NFTriangleGauge17 CycleData
def chosen : Finset (Fin 5) := {0,4}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge17.count N)
#print axioms actual_count
end ConnectTriangleGauge17

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge18
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,-1,0,0],[-1,0,0,0,-1,0],[0,1,0,0,0,1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,-1,0,0],[-1,0,0,0,-1,0],[0,-1,0,0,0,1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,1,1,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,1,0,-1,0,0,-1,-1,0],[0,0,0,0,0,0,0,1,0,0,0],[1,0,0,0,1,0,0,0,-1,0,0],[0,1,0,0,0,0,0,0,0,1,0],[0,0,0,0,1,0,0,0,-1,0,0],[0,0,1,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,1,0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,1,0,0,0],[0,1,-1,0,0,0,0,0,0,-1,0],[1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge18

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge18
open NFTriangleGauge18 CycleData
def chosen : Finset (Fin 5) := {1,4}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge18.count N)
#print axioms actual_count
end ConnectTriangleGauge18

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge19
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0],[-1,1,-1,0,0,0,-1,0,0],[-1,0,-1,-1,0,0,0,-1,0],[0,-1,0,0,-1,0,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0],[0,0,0,0,0,1,0,0,0],[0,-1,-1,0,0,0,-1,0,0],[0,0,-1,-1,0,0,0,-1,0],[0,1,0,0,-1,0,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,1,0,0,0,1,0,0,0],[0,0,0,0,1,0,0,0,1,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0,0,0,1],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,0,1]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,1]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge19

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge19
open NFTriangleGauge19 CycleData
def chosen : Finset (Fin 5) := {0,1,4}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge19.count N)
#print axioms actual_count
end ConnectTriangleGauge19

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge20
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[0,0,-1,0,0,0],[-1,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,-1]]
def Ui : Matrix (Fin 6 ⊕ Fin 0) (Fin 6 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0],[0,-1,0,0,0,0],[0,0,-1,0,0,0],[-1,0,0,-1,0,0],[0,0,0,0,-1,0],[0,0,0,0,0,-1]]
def V : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[1,0,0,1,0,0,0,0,0,-1,0],[0,0,0,1,0,0,0,0,0,-1,0],[0,0,0,0,1,0,0,0,0,0,-1],[0,0,0,0,0,1,0,0,0,1,-1],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
def Vi : Matrix (Fin 6 ⊕ Fin 5) (Fin 6 ⊕ Fin 5) ℤ :=
  data [[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,1,0,0,1,0,0,0,0,0,0],[0,0,1,0,0,1,0,0,0,0,0],[0,-1,1,0,0,0,1,0,0,0,0],[1,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,1,0,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 6 0 5 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^5 :=
  NormalFormCount.count_integer N 6 0 5 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge20

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge20
open NFTriangleGauge20 CycleData
def chosen : Finset (Fin 5) := {2,4}
def columns : (Fin 6 ⊕ Fin 5) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 6 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([2,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge20.count N)
#print axioms actual_count
end ConnectTriangleGauge20

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge21
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[-1,1,-1,-1,0,0,-1,0,0],[-1,0,-1,0,0,0,0,-1,0],[0,-1,0,0,0,0,0,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,-1,-1,-1,0,0,-1,0,0],[0,0,-1,0,0,0,0,-1,0],[0,1,0,0,0,0,0,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,1,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,1,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,1,-1,0,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0,0,0],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0],[0,0,0,0,0,0,1,0,0,0,0],[0,0,0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,1,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge21

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge21
open NFTriangleGauge21 CycleData
def chosen : Finset (Fin 5) := {0,2,4}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,2,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge21.count N)
#print axioms actual_count
end ConnectTriangleGauge21

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge22
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,0,0,-1,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,0],[0,-1,0,-1,1,0,-1,0,-1]]
def Ui : Matrix (Fin 9 ⊕ Fin 0) (Fin 9 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0,0],[0,0,1,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0],[0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,-1,0,0,0],[0,0,0,-1,0,0,-1,0,0],[-1,0,0,0,0,0,0,-1,0],[0,-1,0,0,-1,0,1,0,-1]]
def V : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,-1,0],[0,0,0,1,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,1,0],[1,0,0,0,0,0,0,1,-1,1,0],[0,1,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,1,-1,1,0],[0,0,1,0,0,1,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0]]
def Vi : Matrix (Fin 9 ⊕ Fin 2) (Fin 9 ⊕ Fin 2) ℤ :=
  data [[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,0,0,0,1],[0,1,0,0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,1,0,0,0],[0,0,1,0,1,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0],[1,0,0,0,0,0,0,0,0,0,0]]
theorem inverseU : Ui*U=1 := by decide
theorem inverseV : V*Vi=1 := by decide
theorem inverseVi : Vi*V=1 := by decide
theorem normal : U*A*V=NormalFormCount.diagonal 9 0 2 := by decide
theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^2 :=
  NormalFormCount.count_integer N 9 0 2 A U Ui V Vi inverseU inverseV inverseVi normal
#print axioms normal
#print axioms count
end NFTriangleGauge22

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge22
open NFTriangleGauge22 CycleData
def chosen : Finset (Fin 5) := {1,2,4}
def columns : (Fin 9 ⊕ Fin 2) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 9 ⊕ Fin 0) → Fin 5 × Fin 3 := fun m =>
  (⟨([1,2,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge22.count N)
#print axioms actual_count
end ConnectTriangleGauge22

set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFTriangleGauge23
def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)
def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=
  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0
def A : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 0) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0],[0,-1,1,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,-1,0,0,0],[0,0,0,0,0,0,1,0,0,-1,0],[0,0,0,0,0,0,0,0,1,0,-1],[0,0,0,1,-1,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,-1,0],[0,0,0,0,0,0,0,0,0,0,-1],[0,-1,0,-1,0,0,0,0,0,0,0],[0,0,-1,0,0,-1,0,0,0,0,0],[0,1,-1,0,0,0,-1,0,0,0,0]]
def U : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,0,0,0,-1,0,0,0],[-1,1,-1,0,0,0,0,0,0,-1,0,0],[-1,0,-1,-1,0,0,0,0,0,0,-1,0],[0,1,0,0,1,0,0,-1,0,0,0,1]]
def Ui : Matrix (Fin 11 ⊕ Fin 1) (Fin 11 ⊕ Fin 1) ℤ :=
  data [[1,0,0,0,0,0,0,0,0,0,0,0],[0,-1,0,0,0,0,0,0,0,0,0,0],[-1,0,1,0,0,0,0,0,0,0,0,0],[0,0,0,1,0,0,0,0,0,0,0,0],[0,0,0,0,1,0,0,0,0,0,0,0],[0,0,0,0,0,1,0,0,0,0,0,0],[0,0,0,0,0,0,-1,0,0,0,0,0],[0,0,0,0,0,0,0,-1,0,0,0,0],[0,0,0,0,0,0,0,0,-1,0,0,0],[0,-1,-1,0,0,0,0,0,0,-1,0,0],[0,0,-1,-1,0,0,0,0,0,0,-1,0],[0,1,0,0,-1,0,0,-1,0,0,0,1]]
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
end NFTriangleGauge23

set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace ConnectTriangleGauge23
open NFTriangleGauge23 CycleData
def chosen : Finset (Fin 5) := {0,1,2,4}
def columns : (Fin 11 ⊕ Fin 0) ≃ Fin 11 := finSumFinEquiv
def rowAt : (Fin 11 ⊕ Fin 1) → Fin 5 × Fin 3 := fun m =>
  (⟨([0,1,2,4] : List ℕ)[ix m / 3]?.getD 0, by
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
  exact (Nat.card_congr (e1.trans e2)).trans (NFTriangleGauge23.count N)
#print axioms actual_count
end ConnectTriangleGauge23
