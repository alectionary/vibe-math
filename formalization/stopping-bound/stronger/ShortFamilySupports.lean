import SeparateSidon
import PowersThree
namespace ShortFamily
open Finset

def NS : Finset ℕ := {0,1,3,11}
def NT : Finset ℕ := {0,5,12,18}
def S (n : ℕ) : Finset (ZMod n) := NS.image (fun a : ℕ => (a : ZMod n))
def T (n : ℕ) : Finset (ZMod n) := NT.image (fun a : ℕ => (a : ZMod n))
set_option maxRecDepth 100000
set_option maxHeartbeats 0
lemma ns_bound : ∀ a ∈ NS, a≤18 := by decide +kernel
lemma nt_bound : ∀ a ∈ NT, a≤18 := by decide +kernel
lemma ns_card : NS.card=4 := by decide +kernel
lemma nt_card : NT.card=4 := by decide +kernel
lemma ns_sidon : ∀ a ∈ NS, ∀ b ∈ NS, ∀ c ∈ NS, ∀ d ∈ NS,
    a+b=c+d → (a=c ∧ b=d) ∨ (a=d ∧ b=c) := by decide +kernel
lemma nt_sidon : ∀ a ∈ NT, ∀ b ∈ NT, ∀ c ∈ NT, ∀ d ∈ NT,
    a+b=c+d → (a=c ∧ b=d) ∨ (a=d ∧ b=c) := by decide +kernel
lemma nat_cross : ∀ a ∈ NS, ∀ b ∈ NT, ∀ c ∈ NS, ∀ d ∈ NT,
    a+b=c+d → a=c ∧ b=d := by decide +kernel

lemma cast_inj (n a b : ℕ) (hn : 37≤n) (ha : a≤18) (hb : b≤18)
    (he : (a : ZMod n)=(b : ZMod n)) : a=b := by
  have h := PowersThree.cast_sum_injective (n := n) a 0 b 0 (by omega) (by omega) (by simpa using he)
  simpa using h
lemma lifted_card (U : Finset ℕ) (hU : ∀ a ∈ U,a≤18) (n : ℕ) (hn : 37≤n) :
    (U.image (fun a : ℕ => (a : ZMod n))).card=U.card := by
  apply card_image_of_injOn
  intro a ha b hb he
  exact cast_inj n a b hn (hU a ha) (hU b hb) he
lemma cardS (n : ℕ) (hn : 37≤n) : (S n).card=4 := by
  rw [S,lifted_card NS ns_bound n hn,ns_card]
lemma cardT (n : ℕ) (hn : 37≤n) : (T n).card=4 := by
  rw [T,lifted_card NT nt_bound n hn,nt_card]
lemma lifted_sidon (U : Finset ℕ) (hU : ∀ a ∈ U,a≤18)
    (hs : ∀ a ∈ U, ∀ b ∈ U, ∀ c ∈ U, ∀ d ∈ U,
      a+b=c+d → (a=c ∧ b=d) ∨ (a=d ∧ b=c))
    (n : ℕ) (hn : 37≤n) : SidonStopping.IsSidon (U.image (fun a : ℕ => (a : ZMod n))) := by
  intro a ha b hb c hc d hd he
  obtain ⟨aa,haa,hea⟩ := mem_image.mp ha
  obtain ⟨bb,hbb,heb⟩ := mem_image.mp hb
  obtain ⟨cc,hcc,hec⟩ := mem_image.mp hc
  obtain ⟨dd,hdd,hed⟩ := mem_image.mp hd
  have ha' := hU aa haa
  have hb' := hU bb hbb
  have hc' := hU cc hcc
  have hd' := hU dd hdd
  have he' : (aa : ZMod n)+bb=(cc : ZMod n)+dd := by rw [hea,heb,hec,hed];exact he
  have hnat := PowersThree.cast_sum_injective (n := n) aa bb cc dd (by omega) (by omega) he'
  rcases hs aa haa bb hbb cc hcc dd hdd hnat with ⟨hac,hbd⟩ | ⟨had,hbc⟩
  · subst cc;subst dd
    exact Or.inl ⟨hea.symm.trans hec,heb.symm.trans hed⟩
  · subst dd;subst cc
    exact Or.inr ⟨hea.symm.trans hed,heb.symm.trans hec⟩

lemma sidonS (n : ℕ) (hn : 37≤n) : SidonStopping.IsSidon (S n) :=
  lifted_sidon NS ns_bound ns_sidon n hn
lemma sidonT (n : ℕ) (hn : 37≤n) : SidonStopping.IsSidon (T n) :=
  lifted_sidon NT nt_bound nt_sidon n hn
lemma cross (n : ℕ) (hn : 37≤n) : JointSidon.CrossUnique (S n) (T n) := by
  intro a ha b hb c hc d hd he
  obtain ⟨aa,haa,hea⟩ := mem_image.mp ha
  obtain ⟨bb,hbb,heb⟩ := mem_image.mp hb
  obtain ⟨cc,hcc,hec⟩ := mem_image.mp hc
  obtain ⟨dd,hdd,hed⟩ := mem_image.mp hd
  have ha' := ns_bound aa haa
  have hb' := nt_bound bb hbb
  have hc' := ns_bound cc hcc
  have hd' := nt_bound dd hdd
  have he' : (aa : ZMod n)+bb=(cc : ZMod n)+dd := by rw [hea,heb,hec,hed];exact he
  have hnat := PowersThree.cast_sum_injective (n := n) aa bb cc dd (by omega) (by omega) he'
  obtain ⟨hac,hbd⟩ := nat_cross aa haa bb hbb cc hcc dd hdd hnat
  subst cc;subst dd
  exact ⟨hea.symm.trans hec,heb.symm.trans hed⟩

lemma cross_swap (n : ℕ) (hn : 37≤n) : JointSidon.CrossUnique (T n) (S n) := by
  intro a ha b hb c hc d hd he
  have h := cross n hn b hb a ha d hd c hc (by simpa only [add_comm] using he)
  exact ⟨h.2,h.1⟩
end ShortFamily
