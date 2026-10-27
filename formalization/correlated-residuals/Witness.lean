/-
Concrete certificates for three one-edge residual collisions in the
three-trait recursive pattern of Mi–Eskridge–Wang–Baenziger–Campbell–Gill–Dweikat–Bovaird,
equation (7), written in the structural form of their equation (3).

Only positions (0,1), (0,2), and (1,2) of `B` may be nonzero. A value `L`
is accepted as `(I - B)⁻¹` only after both products with `I - B` are the identity.
The joint covariance is the block map in the source:
`Σ_yy = L (Γ Φ Γᵀ + Ψ) Lᵀ`, `Σ_yx = L Γ Φ`, `Σ_xx = Φ`.

The diagonal-residual injectivity statement is recorded in `INVESTIGATION.md`.
It is not claimed as a Lean theorem in this file.
-/

abbrev Mat := Fin 3 → Fin 3 → Int

def mat (a b c d e f g h i : Int) : Mat :=
  fun r s =>
    match r, s with
    | 0, 0 => a | 0, 1 => b | 0, 2 => c
    | 1, 0 => d | 1, 1 => e | 1, 2 => f
    | 2, 0 => g | 2, 1 => h | 2, 2 => i

def eye : Mat := mat 1 0 0 0 1 0 0 0 1

def mul (A B : Mat) : Mat :=
  fun i j => A i 0 * B 0 j + A i 1 * B 1 j + A i 2 * B 2 j

def add (A B : Mat) : Mat := fun i j => A i j + B i j

def transpose (A : Mat) : Mat := fun i j => A j i

def matEq (A B : Mat) : Bool :=
  A 0 0 == B 0 0 && A 0 1 == B 0 1 && A 0 2 == B 0 2 &&
  A 1 0 == B 1 0 && A 1 1 == B 1 1 && A 1 2 == B 1 2 &&
  A 2 0 == B 2 0 && A 2 1 == B 2 1 && A 2 2 == B 2 2

def subEye (B : Mat) : Mat := fun i j => eye i j - B i j

structure Model where
  B : Mat
  Gamma : Mat
  Psi : Mat
  Phi : Mat
  L : Mat

def sigmaYY (M : Model) : Mat :=
  let pi := mul M.L M.Gamma
  let noise := mul (mul M.L M.Psi) (transpose M.L)
  let signal := mul (mul pi M.Phi) (transpose pi)
  add noise signal

def sigmaYX (M : Model) : Mat :=
  mul (mul M.L M.Gamma) M.Phi

def sigmaXX (M : Model) : Mat := M.Phi

def inverseOK (M : Model) : Bool :=
  matEq (mul (subEye M.B) M.L) eye && matEq (mul M.L (subEye M.B)) eye

def sameLaw (M N : Model) : Bool :=
  matEq (sigmaYY M) (sigmaYY N) && matEq (sigmaYX M) (sigmaYX N) &&
    matEq (sigmaXX M) (sigmaXX N)

def baseModel : Model :=
  { B := mat 0 0 0 0 0 0 0 0 0
    Gamma := eye
    Psi := eye
    Phi := eye
    L := eye }

def bow12 : Model :=
  { B := mat 0 (-1) 0 0 0 0 0 0 0
    Gamma := mat 1 1 0 0 1 0 0 0 1
    Psi := mat 2 1 0 1 1 0 0 0 1
    Phi := eye
    L := mat 1 (-1) 0 0 1 0 0 0 1 }

def bow13 : Model :=
  { B := mat 0 0 1 0 0 0 0 0 0
    Gamma := mat 1 0 (-1) 0 1 0 0 0 1
    Psi := mat 2 0 (-1) 0 1 0 (-1) 0 1
    Phi := eye
    L := mat 1 0 1 0 1 0 0 0 1 }

def bow23 : Model :=
  { B := mat 0 0 0 0 0 1 0 0 0
    Gamma := mat 1 0 0 0 1 (-1) 0 0 1
    Psi := mat 1 0 0 0 2 (-1) 0 (-1) 1
    Phi := eye
    L := mat 1 0 0 0 1 1 0 0 1 }

def psiPD (M : Model) : Bool :=
  let a := M.Psi
  let m1 := a 0 0
  let m2 := a 0 0 * a 1 1 - a 0 1 * a 1 0
  let m3 :=
    a 0 0 * (a 1 1 * a 2 2 - a 1 2 * a 2 1) -
    a 0 1 * (a 1 0 * a 2 2 - a 1 2 * a 2 0) +
    a 0 2 * (a 1 0 * a 2 1 - a 1 1 * a 2 0)
  m1 > 0 && m2 > 0 && m3 > 0

def paramsDiffer (M : Model) : Bool :=
  matEq M.B baseModel.B == false || matEq M.Gamma baseModel.Gamma == false ||
    matEq M.Psi baseModel.Psi == false

theorem base_inverse : inverseOK baseModel = true := by decide

theorem bow12_inverse : inverseOK bow12 = true := by decide

theorem bow13_inverse : inverseOK bow13 = true := by decide

theorem bow23_inverse : inverseOK bow23 = true := by decide

theorem bow12_same_law : sameLaw bow12 baseModel = true := by decide

theorem bow13_same_law : sameLaw bow13 baseModel = true := by decide

theorem bow23_same_law : sameLaw bow23 baseModel = true := by decide

theorem bow12_pd : psiPD bow12 = true := by decide

theorem bow13_pd : psiPD bow13 = true := by decide

theorem bow23_pd : psiPD bow23 = true := by decide

theorem base_pd : psiPD baseModel = true := by decide

theorem bow12_diff : paramsDiffer bow12 = true := by decide

theorem bow13_diff : paramsDiffer bow13 = true := by decide

theorem bow23_diff : paramsDiffer bow23 = true := by decide
