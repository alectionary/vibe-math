import NormalFormCount
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
