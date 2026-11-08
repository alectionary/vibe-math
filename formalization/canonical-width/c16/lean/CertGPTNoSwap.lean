import CertGPTRoot
import CertGPTRun
import CertGPTPool
import PoolData

namespace C16Frames.CertGPT
set_option maxRecDepth 4096
set_option maxHeartbeats 2000000

/-- The actual 128-coordinate parity Gram matrix, with finite pool indices. -/
def arrayG {N : Nat} (x z : Array Nat) (i j : Fin N) : ZMod 2 :=
  bitZ (par128 (x[i.val]! &&& z[j.val]!))

def natPair {N : Nat} (p : Fin N × Fin N) : Pair := (p.1.val, p.2.val)

theorem natPair_injective {N : Nat} : Function.Injective (@natPair N) := by
  intro p q h
  apply Prod.ext
  · exact Fin.ext (congrArg Prod.fst h)
  · exact Fin.ext (congrArg Prod.snd h)

theorem no_finite_swap_frame_of_check {N : Nat} (d : Instance) (tokens : Array Nat)
    (hx : d.x.size = N) (hz : d.z.size = N)
    (hv : validateItems d "swap" = true) (ha : checkViaKernel d tokens = true) :
    ¬ ∃ F : Finset (Fin N × Fin N), IsPairFrame (arrayG d.x d.z) F ∧
      F.card = 128 ∧ F.image Prod.swap = F := by
  classical
  rintro ⟨F,hf,hc,hs⟩
  apply no_swap_frame_of_check d tokens hv ha
  refine ⟨F.image natPair, ?_, ?_, ?_, ?_⟩
  · refine ⟨?_,?_,?_⟩
    · intro p hp q hq he
      obtain ⟨a,ha,rfl⟩ := Finset.mem_image.mp hp
      obtain ⟨b,hb,rfl⟩ := Finset.mem_image.mp hq
      exact congrArg natPair (hf.1 a ha b hb (Fin.ext he))
    · intro p hp q hq he
      obtain ⟨a,ha,rfl⟩ := Finset.mem_image.mp hp
      obtain ⟨b,hb,rfl⟩ := Finset.mem_image.mp hq
      exact congrArg natPair (hf.2.1 a ha b hb (Fin.ext he))
    · intro p hp q hq
      obtain ⟨a,ha,rfl⟩ := Finset.mem_image.mp hp
      obtain ⟨b,hb,rfl⟩ := Finset.mem_image.mp hq
      have hh := hf.2.2 a ha b hb
      change arrayG d.x d.z a.1 b.2 = _
      rw [hh]
      simp only [natPair_injective.eq_iff]
  · rw [Finset.card_image_of_injective _ natPair_injective, hc]
  · calc
      (F.image natPair).image Prod.swap = (F.image Prod.swap).image natPair := by
        simp only [Finset.image_image]
        rfl
      _ = F.image natPair := by rw [hs]
  · intro p hp
    obtain ⟨a,ha,rfl⟩ := Finset.mem_image.mp hp
    exact ⟨hx ▸ a.1.isLt, hz ▸ a.2.isLt⟩

def decodedCheck (decoded : Option (Instance × Array Nat)) : Bool :=
  match decoded with
  | none => false
  | some (d,t) => validateItems d "swap" && checkViaKernel d t

def decodedPools (x z : Array Nat) (decoded : Option (Instance × Array Nat)) : Bool :=
  match decoded with
  | none => false
  | some (d,_) => d.x == x && d.z == z

/-- Instantiate without reducing either the large pool arrays or encoded certificate
inside the generic proof. Both Boolean facts must already have been checked. -/
theorem no_swap_from_decoded {N : Nat} (x z : Array Nat)
    (decoded : Option (Instance × Array Nat))
    (hx : x.size = N) (hz : z.size = N)
    (checked : decodedCheck decoded = true)
    (pools : decodedPools x z decoded = true) :
    ¬ ∃ F : Finset (Fin N × Fin N), IsPairFrame (arrayG x z) F ∧
      F.card = 128 ∧ F.image Prod.swap = F := by
  cases decoded with
  | none => contradiction
  | some dt =>
    rcases dt with ⟨d,t⟩
    have hchecks := Bool.and_eq_true_iff.mp checked
    have hpools := Bool.and_eq_true_iff.mp pools
    have hdx : d.x = x := by simpa using hpools.1
    have hdz : d.z = z := by simpa using hpools.2
    have h := no_finite_swap_frame_of_check d t
      (hdx ▸ hx) (hdz ▸ hz) hchecks.1 hchecks.2
    rw [hdx, hdz] at h
    exact h

/-- No size-128 swap-invariant frame exists in the actual 720×720 pool Gram matrix.
The two native_decide facts certify checking and exact equality with PoolData.
All search soundness and frame/orbit mathematics are kernel-proved. -/
theorem no_swap_frame :
    ¬ ∃ F : Finset (Fin 720 × Fin 720),
      IsPairFrame (arrayG C16Frames.Pools.xArr C16Frames.Pools.zArr) F ∧
      F.card = 128 ∧ F.image Prod.swap = F := by
  exact no_swap_from_decoded C16Frames.Pools.xArr C16Frames.Pools.zArr
    (decodeText swapEncoded) (by decide) (by decide) swap_check_ok swap_pools_ok

#print axioms no_swap_frame

end C16Frames.CertGPT
