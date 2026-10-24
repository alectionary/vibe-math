import GlobalCounting
import Mathlib.SetTheory.Cardinal.Finite

set_option maxHeartbeats 0
namespace UnorderedSections
open GlobalCounting
variable {V G : Type*} [Fintype V] [Fintype G] [DecidableEq V] [DecidableEq G]

noncomputable def graph (S : FourSupport V) (x : Fin 4 → G) : Finset (V × G) :=
  Finset.univ.image (fun i => ((label S i).val,x i))

theorem mem_graph (S : FourSupport V) (x : Fin 4 → G) (u : V) (t : G) :
    (u,t) ∈ graph S x ↔ ∃ i, (label S i).val=u ∧ x i=t := by
  simp only [graph, Finset.mem_image, Finset.mem_univ, true_and, Prod.mk.injEq]

theorem graph_injective (S : FourSupport V) (x : Fin 4 → G) :
    Function.Injective (fun i => ((label S i).val,x i)) := by
  intro i j h
  exact (label S).injective (Subtype.ext (congrArg Prod.fst h))

theorem graph_card (S : FourSupport V) (x : Fin 4 → G) : (graph S x).card=4 := by
  rw [graph, Finset.card_image_of_injective _ (graph_injective S x)]
  exact Fintype.card_fin 4

theorem graph_projection (S : FourSupport V) (x : Fin 4 → G) :
    (graph S x).image Prod.fst=S.val := by
  ext u
  simp only [Finset.mem_image]
  constructor
  · rintro ⟨⟨v,t⟩,ht,hvu⟩
    obtain ⟨i,hi,_⟩ := (mem_graph S x v t).mp ht
    exact hvu ▸ hi ▸ (label S i).prop
  · intro hu
    let i := (label S).symm ⟨u,hu⟩
    refine ⟨(u,x i),?_,rfl⟩
    apply (mem_graph S x u (x i)).mpr
    exact ⟨i,by simp [i],rfl⟩

theorem graph_fst_inj (S : FourSupport V) (x : Fin 4 → G) :
    Set.InjOn Prod.fst (↑(graph S x) : Set (V × G)) := by
  rintro ⟨u,t⟩ hu ⟨v,s⟩ hv huv
  obtain ⟨i,hi,hix⟩ := (mem_graph S x u t).mp hu
  obtain ⟨j,hj,hjx⟩ := (mem_graph S x v s).mp hv
  have hij : i=j := (label S).injective (Subtype.ext (hi.trans (huv.trans hj.symm)))
  subst j
  exact Prod.ext huv (hix.symm.trans hjx)

noncomputable def graphSupport (S : FourSupport V) (x : Fin 4 → G) :
    FourSupport (V × G) :=
  ⟨graph S x,Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _,graph_card S x⟩⟩

def Sections := Σ S : FourSupport V, Fin 4 → G

noncomputable def toSupport (a : Sections (V := V) (G := G)) :
    {T : FourSupport (V × G) // Set.InjOn Prod.fst (↑T.val : Set (V × G))} :=
  ⟨graphSupport a.1 a.2,graph_fst_inj a.1 a.2⟩

theorem toSupport_injective : Function.Injective (toSupport (V := V) (G := G)) := by
  rintro ⟨S,x⟩ ⟨T,y⟩ h
  have hg : graph S x=graph T y := congrArg (fun a => a.val.val) h
  have hS : S=T := Subtype.ext (by
    rw [← graph_projection S x, ← graph_projection T y, hg])
  subst T
  have hxy : x=y := by
    funext i
    have hm : ((label S i).val,x i)∈graph S y := by
      rw [← hg]; exact (mem_graph S x _ _).mpr ⟨i,rfl,rfl⟩
    obtain ⟨j,hj,hyj⟩ := (mem_graph S y _ _).mp hm
    have hji : j=i := (label S).injective (Subtype.ext hj)
    subst j
    exact hyj.symm
  subst y
  rfl

theorem toSupport_surjective : Function.Surjective (toSupport (V := V) (G := G)) := by
  rintro ⟨T,hT⟩
  let S : FourSupport V := ⟨T.val.image Prod.fst,
    Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _,by
      rw [Finset.card_image_of_injOn hT]; exact support_card T⟩⟩
  have hx : ∀ i : Fin 4, ∃ t : G, ((label S i).val,t)∈T.val := by
    intro i
    obtain ⟨⟨u,t⟩,ht,hu⟩ := Finset.mem_image.mp (label S i).prop
    exact ⟨t,by simpa only [Prod.fst] using hu ▸ ht⟩
  choose x hx using hx
  refine ⟨⟨S,x⟩,?_⟩
  apply Subtype.ext
  apply Subtype.ext
  change graph S x=T.val
  ext a
  constructor
  · intro ha
    obtain ⟨i,hi,hxi⟩ := (mem_graph S x a.1 a.2).mp ha
    have hh := hx i
    simpa only [hi,hxi,Prod.mk.eta] using hh
  · intro ha
    have hu : a.1∈S.val := Finset.mem_image.mpr ⟨a,ha,rfl⟩
    let i := (label S).symm ⟨a.1,hu⟩
    have hi : (label S i).val=a.1 := by simp [i]
    have he : ((label S i).val,x i)=a := hT (hx i) ha hi
    exact (mem_graph S x a.1 a.2).mpr ⟨i,hi,congrArg Prod.snd he⟩

noncomputable def sectionEquiv : Sections (V := V) (G := G) ≃
    {T : FourSupport (V × G) // Set.InjOn Prod.fst (↑T.val : Set (V × G))} :=
  Equiv.ofBijective toSupport ⟨toSupport_injective,toSupport_surjective⟩

noncomputable def filteredEquiv (P : Finset (V × G) → Prop)
    (hP : ∀ T : FourSupport (V × G), P T.val →
      Set.InjOn Prod.fst (↑T.val : Set (V × G))) :
    {T : FourSupport (V × G) // P T.val} ≃
      (Σ S : FourSupport V, {x : Fin 4 → G // P (graph S x)}) := by
  let e1 : {T : FourSupport (V × G) // P T.val} ≃
      {T : {T : FourSupport (V × G) // Set.InjOn Prod.fst (↑T.val : Set (V × G))} //
        P T.val.val} := {
    toFun := fun T => ⟨⟨T.val,hP T.val T.prop⟩,T.prop⟩
    invFun := fun T => ⟨T.val.val,T.prop⟩
    left_inv := fun _ => rfl
    right_inv := fun _ => rfl }
  let e2 : {T : {T : FourSupport (V × G) // Set.InjOn Prod.fst (↑T.val : Set (V × G))} //
        P T.val.val} ≃ {a : Sections (V := V) (G := G) // P (graph a.1 a.2)} :=
    (Equiv.subtypeEquiv (sectionEquiv (V := V) (G := G)) (fun _ => Iff.rfl)).symm
  let e3 : {a : Sections (V := V) (G := G) // P (graph a.1 a.2)} ≃
      (Σ S : FourSupport V, {x : Fin 4 → G // P (graph S x)}) := {
    toFun := fun a => ⟨a.val.1,⟨a.val.2,a.prop⟩⟩
    invFun := fun a => ⟨⟨a.1,a.2.val⟩,a.2.prop⟩
    left_inv := fun _ => rfl
    right_inv := fun _ => rfl }
  exact e1.trans (e2.trans e3)

/-- An exact partition of unordered supports; it counts each support once. -/
theorem partition_count (P : Finset (V × G) → Prop)
    (hP : ∀ T : FourSupport (V × G), P T.val →
      Set.InjOn Prod.fst (↑T.val : Set (V × G))) :
    Nat.card {T : FourSupport (V × G) // P T.val} =
      ∑ S : FourSupport V, Nat.card {x : Fin 4 → G // P (graph S x)} := by
  classical
  rw [Nat.card_congr (filteredEquiv P hP), Nat.card_sigma]

#print axioms graph_card
#print axioms sectionEquiv
#print axioms partition_count
end UnorderedSections
