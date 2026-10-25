import Std.Tactic.BVDecide

set_option maxHeartbeats 0
namespace BinaryWords

theorem forall_fin_of_all {n : Nat} (P : Fin n → Prop) [DecidablePred P]
    (h : (List.finRange n).all (fun i => decide (P i)) = true) : ∀ i, P i := by
  intro i
  exact of_decide_eq_true (List.all_eq_true.mp h i (List.mem_finRange i))

theorem forall_fin_two_of_all {n m : Nat} (P : Fin n → Fin m → Prop) [DecidableRel P]
    (h : (List.finRange n).all (fun i =>
      (List.finRange m).all (fun j => decide (P i j))) = true) : ∀ i j, P i j := by
  intro i
  exact forall_fin_of_all (P i) (List.all_eq_true.mp h i (List.mem_finRange i))

def dotOn {n : Nat} (is : List Nat) (x y : BitVec n) : Bool :=
  is.foldr (fun i b => (x.getLsbD i && y.getLsbD i) ^^ b) false

def dot {n : Nat} (x y : BitVec n) : Bool := dotOn (List.range n) x y

theorem getLsbD_bool_ite {n : Nat} (b : Bool) (v : BitVec n) (i : Nat) :
    (if b then v else 0#n).getLsbD i = (b && v.getLsbD i) := by
  cases b <;> simp

theorem dotOn_xor {n : Nat} (is : List Nat) (x y z : BitVec n) :
    dotOn is x (y ^^^ z) = (dotOn is x y ^^ dotOn is x z) := by
  induction is with
  | nil => simp [dotOn]
  | cons i is ih =>
    change ((x.getLsbD i && (y ^^^ z).getLsbD i) ^^ dotOn is x (y ^^^ z)) =
      (((x.getLsbD i && y.getLsbD i) ^^ dotOn is x y) ^^
       ((x.getLsbD i && z.getLsbD i) ^^ dotOn is x z))
    rw [BitVec.getLsbD_xor, ih]
    have hb (a b c d e : Bool) :
        ((a && (b ^^ c)) ^^ (d ^^ e)) = (((a && b) ^^ d) ^^ ((a && c) ^^ e)) := by
      cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> rfl
    exact hb _ _ _ _ _

theorem dot_xor {n : Nat} (x y z : BitVec n) :
    dot x (y ^^^ z) = (dot x y ^^ dot x z) := dotOn_xor _ _ _ _

theorem dotOn_zero {n : Nat} (is : List Nat) (x : BitVec n) :
    dotOn is x 0 = false := by
  induction is with
  | nil => rfl
  | cons i is ih =>
    change ((x.getLsbD i && (0 : BitVec n).getLsbD i) ^^ dotOn is x 0) = false
    rw [ih]
    simp [BitVec.getLsbD]

theorem dot_zero {n : Nat} (x : BitVec n) : dot x 0 = false := dotOn_zero _ _

theorem dotOn_comm {n : Nat} (is : List Nat) (x y : BitVec n) :
    dotOn is x y = dotOn is y x := by
  induction is with
  | nil => rfl
  | cons i is ih =>
    change ((x.getLsbD i && y.getLsbD i) ^^ dotOn is x y) =
      ((y.getLsbD i && x.getLsbD i) ^^ dotOn is y x)
    rw [Bool.and_comm, ih]

theorem dot_comm {n : Nat} (x y : BitVec n) : dot x y = dot y x := dotOn_comm _ _ _

theorem dot_xor_left {n : Nat} (x y z : BitVec n) :
    dot (x ^^^ y) z = (dot x z ^^ dot y z) := by
  rw [dot_comm, dot_xor, dot_comm z x, dot_comm z y]

def rowSum {n : Nat} {I : Type} (rows : I → BitVec n) (is : List I) : BitVec n :=
  is.foldr (fun i x => rows i ^^^ x) 0

def InRowSpan {n : Nat} {I : Type} (rows : I → BitVec n) (x : BitVec n) : Prop :=
  ∃ is : List I, rowSum rows is = x

theorem dot_rowSum {n : Nat} {I : Type} (rows : I → BitVec n) (w : BitVec n)
    (h : ∀ i, dot w (rows i) = false) (is : List I) :
    dot w (rowSum rows is) = false := by
  induction is with
  | nil => exact dot_zero _
  | cons i is ih =>
    change dot w (rows i ^^^ rowSum rows is) = false
    rw [dot_xor, h i, ih]
    rfl

theorem not_in_row_span {n : Nat} {I : Type} (rows : I → BitVec n)
    (w x : BitVec n) (h : ∀ i, dot w (rows i) = false) (hw : dot w x = true) :
    ¬ InRowSpan rows x := by
  rintro ⟨is, his⟩
  have hz := dot_rowSum rows w h is
  rw [his, hw] at hz
  contradiction

theorem equation_of_row_relation {n : Nat} {I : Type} (rows : I → BitVec n)
    (x a b : BitVec n) (h : ∀ i, dot (rows i) x = false)
    (is : List I) (he : rowSum rows is = a ^^^ b) : dot a x = dot b x := by
  have hh : dot x (rowSum rows is) = false :=
    dot_rowSum rows x (fun i => (dot_comm x (rows i)).trans (h i)) is
  rw [he, dot_xor, dot_comm x a, dot_comm x b] at hh
  cases ha : dot a x <;> cases hb : dot b x <;> simp_all

#print axioms not_in_row_span
end BinaryWords
