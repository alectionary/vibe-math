import GB48
import GBReflection
set_option maxHeartbeats 0
namespace GB48Spectral
open scoped BigOperators
variable {K : Type*} [CommRing K] [IsDomain K] [StarRing K]

theorem offsets_eval (ψ : AddChar GB48.G K) (s : Finset GB48.G) (j : GB48.G) :
    (∑ x ∈ s.image (fun e => ((0 : Fin 1),e)),
      if x.1=(0 : Fin 1) then ψ (-(j*x.2)) else 0) = GBReflection.eval ψ s j := by
  rw [Finset.sum_image]
  · rfl
  · intro a _ b _ h
    exact congrArg Prod.snd h

theorem socket_rightA : GB48.socketsA 1 = GBReflection.rightA.image (fun e => ((0 : Fin 1),e)) := by decide
theorem socket_rightB : GB48.socketsB 1 = GBReflection.rightB.image (fun e => ((0 : Fin 1),e)) := by decide

theorem right_eval_A (ψ : AddChar GB48.G K) (j : GB48.G) :
    AbsorbingFourier.evaluatedMatrix ψ GB48.socketsA j 0 1 = GBReflection.eval ψ GBReflection.rightA j := by
  unfold AbsorbingFourier.evaluatedMatrix
  rw [socket_rightA,offsets_eval]

theorem right_eval_B (ψ : AddChar GB48.G K) (j : GB48.G) :
    AbsorbingFourier.evaluatedMatrix ψ GB48.socketsB j 0 1 = GBReflection.eval ψ GBReflection.rightB j := by
  unfold AbsorbingFourier.evaluatedMatrix
  rw [socket_rightB,offsets_eval]

theorem left_eval_equal (ψ : AddChar GB48.G K) (j : GB48.G) :
    AbsorbingFourier.evaluatedMatrix ψ GB48.socketsA j 0 0 =
      AbsorbingFourier.evaluatedMatrix ψ GB48.socketsB j 0 0 := by rfl

def M (ψ : AddChar GB48.G K) (s : Fin 2 → Finset GB48.C) (j : GB48.G)
    (c d : Fin 1) : K :=
  ∑ p : Fin 2, AbsorbingFourier.evaluatedMatrix ψ s j c p *
    star (AbsorbingFourier.evaluatedMatrix ψ s j d p)

theorem actual_all_M_equal (ψ : AddChar GB48.G K) (hs : ∀ a, star (ψ a)=ψ (-a)) :
    M ψ GB48.socketsA = M ψ GB48.socketsB := by
  funext j c d
  have hc : c=0 := Subsingleton.elim _ _
  have hd : d=0 := Subsingleton.elim _ _
  subst c
  subst d
  simp only [M,Fin.sum_univ_two]
  rw [left_eval_equal,right_eval_A,right_eval_B]
  rw [GBReflection.rightB_reflection,GBReflection.reflected_norm ψ hs]

theorem no_actual_M_only_count (ψ : AddChar GB48.G K) (hs : ∀ a, star (ψ a)=ψ (-a)) :
    ¬ ∃ f : (GB48.G → Fin 1 → Fin 1 → K) → ℕ,
      f (M ψ GB48.socketsA) = GlobalCounting.count42 GB48.HA ∧
      f (M ψ GB48.socketsB) = GlobalCounting.count42 GB48.HB := by
  rintro ⟨f,ha,hb⟩
  rw [actual_all_M_equal ψ hs,GB48.count_A] at ha
  rw [GB48.count_B] at hb
  omega

#print axioms actual_all_M_equal
#print axioms no_actual_M_only_count
end GB48Spectral
