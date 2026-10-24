import ScalarWeight
import BinarySupportEquiv
import Mathlib.Tactic.Abel

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace ScalarIncidence
open CyclicRecurrence Matrix
open scoped BigOperators

def exponent (i : Fin 3) : ℕ := match i.val with | 0 => 0 | 1 => 1 | _ => 3

theorem exponent_bound : ∀ i, exponent i≤3 := by decide
theorem exponent_injective : Function.Injective exponent := by decide

theorem sidon : ∀ i j k l : Fin 3, i≠j → k≠l →
    exponent i+exponent l=exponent k+exponent j → i=k ∧ j=l := by decide

variable (N : ℕ) [NeZero N]

theorem cast_small_injective (a b : ℕ) (ha : a<N) (hb : b<N)
    (h : (a : ZMod N)=(b : ZMod N)) : a=b := by
  have he := congrArg ZMod.val h
  rwa [ZMod.val_natCast_of_lt ha,ZMod.val_natCast_of_lt hb] at he

def columns (t : ZMod N) : Finset (ZMod N) :=
  Finset.univ.image (fun i : Fin 3 => t-(exponent i : ZMod N))

theorem shifts_injective (hN : 7≤N) (t : ZMod N) :
    Function.Injective (fun i : Fin 3 => t-(exponent i : ZMod N)) := by
  intro i j h
  have hc : (exponent i : ZMod N)=(exponent j : ZMod N) := sub_right_injective h
  exact exponent_injective (cast_small_injective N _ _
    (by have := exponent_bound i; omega) (by have := exponent_bound j; omega) hc)

theorem cubic (hN : 7≤N) (t : ZMod N) : (columns N t).card=3 := by
  rw [columns,Finset.card_image_of_injective _ (shifts_injective N hN t)]
  exact Fintype.card_fin 3

theorem differences_unique (hN : 7≤N) (i j k l : Fin 3)
    (hij : i≠j) (hkl : k≠l)
    (he : (exponent i : ZMod N)-exponent j=(exponent k : ZMod N)-exponent l) :
    i=k ∧ j=l := by
  have hcast : ((exponent i+exponent l : ℕ) : ZMod N)=
      ((exponent k+exponent j : ℕ) : ZMod N) := by
    simp only [Nat.cast_add]
    calc
      (exponent i : ZMod N)+exponent l=
          ((exponent i : ZMod N)-exponent j)+exponent j+exponent l := by abel
      _=((exponent k : ZMod N)-exponent l)+exponent j+exponent l := by rw [he]
      _=(exponent k : ZMod N)+exponent j := by abel
  apply sidon i j k l hij hkl
  exact cast_small_injective N _ _
    (by have := exponent_bound i; have := exponent_bound l; omega)
    (by have := exponent_bound k; have := exponent_bound j; omega) hcast

theorem linear (hN : 7≤N) (u v : ZMod N) (huv : u≠v) :
    (columns N u ∩ columns N v).card≤1 := by
  apply Finset.card_le_one.mpr
  intro c hc d hd
  by_contra hcd
  obtain ⟨i,_,hi⟩ := Finset.mem_image.mp (Finset.mem_inter.mp hc).1
  obtain ⟨k,_,hk⟩ := Finset.mem_image.mp (Finset.mem_inter.mp hc).2
  obtain ⟨j,_,hj⟩ := Finset.mem_image.mp (Finset.mem_inter.mp hd).1
  obtain ⟨l,_,hl⟩ := Finset.mem_image.mp (Finset.mem_inter.mp hd).2
  have hij : i≠j := by intro h; subst j; exact hcd (hi.symm.trans hj)
  have hkl : k≠l := by intro h; subst l; exact hcd (hk.symm.trans hl)
  have ei : (exponent i : ZMod N)=u-c := by rw [← hi]; abel
  have ej : (exponent j : ZMod N)=u-d := by rw [← hj]; abel
  have ek : (exponent k : ZMod N)=v-c := by rw [← hk]; abel
  have el : (exponent l : ZMod N)=v-d := by rw [← hl]; abel
  have he : (exponent i : ZMod N)-exponent j=(exponent k : ZMod N)-exponent l := by
    rw [ei,ej,ek,el]; abel
  have hik := (differences_unique N hN i j k l hij hkl he).1
  subst k
  exact huv (sub_left_injective (hi.trans hk.symm))

theorem columns_three (t : ZMod N) : columns N t={t,t-1,t-3} := by
  unfold columns
  rw [show (Finset.univ : Finset (Fin 3))={0,1,2} by decide]
  simp [exponent]

lemma indicator_three {T : Type*} [DecidableEq T] (a b c y : T)
    (hab : a≠b) (hac : a≠c) (hbc : b≠c) :
    (if y∈({a,b,c} : Finset T) then (1 : F) else 0)=
      (if y=a then 1 else 0)+(if y=b then 1 else 0)+(if y=c then 1 else 0) := by
  by_cases h1 : y=a <;> by_cases h2 : y=b <;> by_cases h3 : y=c <;> simp_all

theorem entry (hN : 7≤N) (c t : ZMod N) :
    PaschKernelCount.checkMatrix (columns N) c t=
      (if c=t then 1 else 0)+(if c=t-1 then 1 else 0)+(if c=t-3 then 1 else 0) := by
  have hi := shifts_injective N hN t
  have h01 : t≠t-1 := by
    intro h; have he : (0 : Fin 3)=1 := hi (by simpa [exponent] using h); cases he
  have h02 : t≠t-3 := by
    intro h; have he : (0 : Fin 3)=2 := hi (by simpa [exponent] using h); cases he
  have h12 : t-1≠t-3 := by
    intro h; have he : (1 : Fin 3)=2 := hi (by simpa [exponent] using h); cases he
  unfold PaschKernelCount.checkMatrix
  rw [columns_three]
  exact indicator_three t (t-1) (t-3) c h01 h02 h12

theorem matrix_apply (hN : 7≤N) (x : ZMod N → F) (c : ZMod N) :
    (PaschKernelCount.checkMatrix (columns N)*ᵥx) c=x c+x (c+1)+x (c+3) := by
  have he (c t k : ZMod N) : c=t-k ↔ t=c+k := by
    constructor <;> intro h
    · rw [h]; abel
    · rw [h]; abel
  change (∑ t, PaschKernelCount.checkMatrix (columns N) c t*x t)=_
  simp_rw [entry N hN,add_mul,Finset.sum_add_distrib,he]
  simp [ite_mul,Finset.sum_ite_eq',Finset.sum_ite_eq]

theorem kernel_iff (hN : 7≤N) (x : ZMod N → F) :
    PaschKernelCount.checkMatrix (columns N)*ᵥx=0 ↔ ScalarCondition N x := by
  have hthird : ∀ a b c : F, a+b+c=0 ↔ c=a+b := by decide
  rw [funext_iff]
  simp only [matrix_apply N hN,Pi.zero_apply,ScalarCondition]
  exact forall_congr' (fun c => hthird _ _ _)

/-- The actual scalar Tanner graph at length7q has no four-variable dependency. -/
theorem no_four_dependency (q : ℕ) (hq : 2≤q) (g : Fin 4 → ZMod (7*q))
    (hg : Function.Injective g) :
    ¬ PaschClassification.EvenChecks (fun i => columns (7*q) (g i)) := by
  letI : NeZero q := ⟨by omega⟩
  intro he
  let S : Finset (ZMod (7*q)) := Finset.univ.image g
  let x := PaschKernelCount.supportIndicator S
  have hc : S.card=4 := by simp [S,Finset.card_image_of_injective _ hg]
  have hx : PaschKernelCount.checkMatrix (columns (7*q))*ᵥx=0 := by
    funext c
    change (PaschKernelCount.checkMatrix (columns (7*q))*ᵥ
      PaschKernelCount.supportIndicator S) c=0
    rw [PaschKernelCount.matrix_indicator_eq_selected]
    have hs : GlobalCounting.selected (columns (7*q)) S c=
        (FourColumnClassification.support (fun i => columns (7*q) (g i)) c).image g := by
      ext v
      simp only [GlobalCounting.selected,S,Finset.mem_filter,Finset.mem_image,Finset.mem_univ,
        true_and,FourColumnClassification.mem_support]
      constructor
      · rintro ⟨⟨i,rfl⟩,h⟩; exact ⟨i,h,rfl⟩
      · rintro ⟨i,h,rfl⟩; exact ⟨⟨i,rfl⟩,h⟩
    rw [hs,Finset.card_image_of_injective _ hg]
    exact (ZMod.natCast_eq_zero_iff _ _).mpr (Nat.dvd_of_mod_eq_zero (he c))
  have hn : x≠0 := by
    intro hn
    have hs : S=∅ := by
      have hb := congrArg BinarySupportEquiv.bitSupport hn
      change BinarySupportEquiv.bitSupport (PaschKernelCount.supportIndicator S)=
        BinarySupportEquiv.bitSupport 0 at hb
      rw [BinarySupportEquiv.support_indicator] at hb
      simpa [BinarySupportEquiv.bitSupport] using hb
    rw [hs] at hc
    contradiction
  have hw : Nat.card {t : ZMod (7*q) // x t≠0}=4 := by
    rw [Nat.card_eq_fintype_card,Fintype.card_subtype]
    change (Finset.univ.filter (fun t => PaschKernelCount.supportIndicator S t≠0)).card=4
    simpa [PaschKernelCount.supportIndicator] using hc
  have hwq := ScalarWeight.kernel_weight q x ((kernel_iff (7*q) (by omega) x).mp hx) hn
  rw [hw] at hwq
  omega

#print axioms cubic
#print axioms linear
#print axioms matrix_apply
#print axioms no_four_dependency
end ScalarIncidence
