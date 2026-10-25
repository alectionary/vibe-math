import BothGram
namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
lemma bad_z_binary (S : Finset G) (c : G) (v : Bool × G) :
    BadZ S c v=1 ↔ v.2-c ∈ S := by
  rw [badZBinary_entry]
  by_cases h : v.2-c ∈ S <;> simp [h]
lemma bad_z_column_weight (S : Finset G) (v : Bool × G) :
    (univ.filter (fun c => BadZ S c v=1)).card=S.card := by
  have h := degree S (true,v.2)
  change (univ.filter (fun c : G => v.2-c ∈ S)).card=S.card at h
  simpa only [bad_z_binary] using h
lemma bad_z_row_weight (S : Finset G) (c : G) :
    (univ.filter (fun v => BadZ S c v=1)).card=2*S.card := by
  simp only [bad_z_binary]
  rw [← univ_product_univ]
  rw [filter_product_right (s := (univ : Finset Bool)) (t := (univ : Finset G))
    (fun j : G => j-c ∈ S),card_product]
  have he : (univ.filter (fun j : G => j-c ∈ S)).card=S.card := by
    have heq : univ.filter (fun j : G => j-c ∈ S)=S.image (fun s => s+c) := by
      ext j
      simp only [mem_filter,mem_univ,true_and,mem_image]
      exact ⟨fun hj => ⟨j-c,hj,by abel⟩,fun ⟨s,hs,he⟩ => by simpa [← he] using hs⟩
    rw [heq,card_image_of_injective _ (add_left_injective c)]
  simp only [card_univ,Fintype.card_bool,he]
end SidonStopping
