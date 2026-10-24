import NormalFormCount
set_option maxRecDepth 1000000
set_option maxHeartbeats 0
namespace NFStarGauge0
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
end NFStarGauge0
