import CyclicDecoderEntryWitnesses
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderEntryBridge
open CyclicDecoderPersistence CyclicDecoderTubeData CyclicMergedMessages

theorem constant_map {A : Type} (xs : List A) :
    xs.map (fun _ => prior) = List.replicate xs.length prior := by
  induction xs with
  | nil => rfl
  | cons a xs ih => simp only [List.map_cons, List.length_cons, ih, List.replicate_succ]
namespace Previous
abbrev oldDecoder := CyclicDecoderEntryWitnesses.Previous.oldDecoder
abbrev newDecoder := CyclicDecoderEntryWitnesses.Previous.newDecoder
abbrev edgeMap := CyclicDecoderEntryWitnesses.Previous.edgeMap

def originalCheck (c : C) : Fin 126 :=
  Fin.ofNat 126 (if c.val < 75 then c.val else c.val+1)
def liftedTarget (s : Fin 126 → Bool) (c : C) : Bool :=
  if c = 0 then s 0 ^^ s 75 else s (originalCheck c)

theorem check_label_options : ∀ e : E,
    (oldDecoder.edgeCheck e = 0 ∧ newDecoder.edgeCheck (edgeMap e) = 0) ∨
    (oldDecoder.edgeCheck e = 75 ∧ newDecoder.edgeCheck (edgeMap e) = 0) ∨
    (originalCheck (newDecoder.edgeCheck (edgeMap e)) = oldDecoder.edgeCheck e ∧
      newDecoder.edgeCheck (edgeMap e) ≠ 0) := by
  apply checked_all
  decide +kernel

theorem old_incoming_length : ∀ e : E, (incomingEdges oldDecoder e).length = 5 := by
  apply checked_all
  decide +kernel

theorem new_incoming_length : ∀ e : E,
    (incomingEdges newDecoder e).length = 5 ∨ (incomingEdges newDecoder e).length = 11 := by
  apply checked_all
  decide +kernel

theorem mapped_other_edges : ∀ e : E,
    ((variableOthers oldDecoder e).map edgeMap).Perm
      (variableOthers newDecoder (edgeMap e)) := by
  apply checked_all
  decide +kernel

theorem old_first (s : Fin 126 → Bool) (e : E) :
    messages oldDecoder s (fun _ => prior) e = signed (s (oldDecoder.edgeCheck e)) 2665945 := by
  unfold messages
  rw [constant_map, old_incoming_length]
  exact (CyclicDecoderEntry.first_message_formula _).1

theorem new_first (s : C → Bool) (e : E) :
    messages newDecoder s (fun _ => prior) e = signed (s (newDecoder.edgeCheck e)) 2665945 := by
  unfold messages
  rw [constant_map]
  rcases new_incoming_length e with h | h
  · rw [h]; exact (CyclicDecoderEntry.first_message_formula _).1
  · rw [h]; exact (CyclicDecoderEntry.first_message_formula _).2

theorem target_agrees_when_inactive (s : Fin 126 → Bool)
    (ha : s 0 = false) (hb : s 75 = false) (e : E) :
    liftedTarget s (newDecoder.edgeCheck (edgeMap e)) = s (oldDecoder.edgeCheck e) := by
  rcases check_label_options e with h | h | h
  · rw [h.1, h.2]
    simp [liftedTarget,ha,hb]
  · rw [h.1, h.2]
    simp [liftedTarget,ha,hb]
  · simp only [liftedTarget, ite_eq_right h.2, h.1]

theorem inactive_messages_agree (s : Fin 126 → Bool)
    (ha : s 0 = false) (hb : s 75 = false) (e : E) :
    messages oldDecoder s (fun _ => prior) e =
      messages newDecoder (liftedTarget s) (fun _ => prior) (edgeMap e) := by
  rw [old_first,new_first,target_agrees_when_inactive s ha hb]

/-- For the actual two fixed matrices, inactive source syndromes imply equal
entire first extrinsic updates under the physical edge bijection. -/
theorem inactive_next_agrees (s : Fin 126 → Bool)
    (ha : s 0 = false) (hb : s 75 = false) (e : E) :
    next oldDecoder s (fun _ => prior) e =
      next newDecoder (liftedTarget s) (fun _ => prior) (edgeMap e) := by
  have hp := (mapped_other_edges e).map
    (messages newDecoder (liftedTarget s) (fun _ => prior))
  have hs := hp.sum_eq
  simp only [List.map_map, Function.comp_def] at hs
  have point : (variableOthers oldDecoder e).map
      (messages oldDecoder s (fun _ => prior)) =
      (variableOthers oldDecoder e).map
      (fun f => messages newDecoder (liftedTarget s) (fun _ => prior) (edgeMap f)) := by
    apply CyclicDecoderEntry.map_same_on
    intro f _
    exact inactive_messages_agree s ha hb f
  unfold next
  rw [point, hs]

theorem source_labels :
    oldDecoder.edgeCheck (0 : E) = 0 ∧
    oldDecoder.edgeCheck (450 : E) = 75 ∧
    newDecoder.edgeCheck (edgeMap (0 : E)) = 0 ∧
    newDecoder.edgeCheck (edgeMap (450 : E)) = 0 := by
  decide +kernel

/-- Initial source activity is exactly immediate message divergence in these
actual graphs, for all input syndrome vectors. -/
theorem immediate_divergence_iff (s : Fin 126 → Bool) :
    (∃ e : E, messages oldDecoder s (fun _ => prior) e ≠
      messages newDecoder (liftedTarget s) (fun _ => prior) (edgeMap e)) ↔
      (s 0 || s 75) = true := by
  constructor
  · rintro ⟨e, different⟩
    by_contra hn
    have ha : s 0 = false := by cases h : s 0 <;> simp_all
    have hb : s 75 = false := by cases h : s 75 <;> simp_all
    exact different (inactive_messages_agree s ha hb e)
  · intro active
    have h := CyclicDecoderEntry.immediate_source_divergence (s 0) (s 75)
    obtain h | h := h.mpr active
    · refine ⟨0, ?_⟩
      rw [old_first,new_first,source_labels.1,source_labels.2.2.1]
      simpa [liftedTarget] using h
    · refine ⟨450, ?_⟩
      rw [old_first,new_first,source_labels.2.1,source_labels.2.2.2]
      simpa [liftedTarget] using h

def sourceEdge (e : E) : Prop :=
  oldDecoder.edgeCheck e = 0 ∨ oldDecoder.edgeCheck e = 75
instance (e : E) : Decidable (sourceEdge e) :=
  inferInstanceAs (Decidable (oldDecoder.edgeCheck e = 0 ∨ oldDecoder.edgeCheck e = 75))
def directlyAffected (e : E) : Prop :=
  ∃ g ∈ variableOthers oldDecoder e, sourceEdge g

theorem mapped_common_check_inputs : ∀ e : E, ¬sourceEdge e →
    ((incomingEdges oldDecoder e).map edgeMap).Perm
      (incomingEdges newDecoder (edgeMap e)) := by
  apply checked_all
  decide +kernel

theorem common_target (s : Fin 126 → Bool) (e : E) (common : ¬sourceEdge e) :
    liftedTarget s (newDecoder.edgeCheck (edgeMap e)) = s (oldDecoder.edgeCheck e) := by
  rcases check_label_options e with h | h | h
  · exact (common (Or.inl h.1)).elim
  · exact (common (Or.inr h.1)).elim
  · simp only [liftedTarget, ite_eq_right h.2, h.1]

/-- At identical physical incoming messages, every common check has the same
exact sign/minimum/rounding output, for arbitrary message vectors. -/
theorem common_message (s : Fin 126 → Bool) (q : E → Int)
    (e : E) (common : ¬sourceEdge e) :
    messages oldDecoder s (fun f => q (edgeMap f)) e =
      messages newDecoder (liftedTarget s) q (edgeMap e) := by
  unfold messages
  rw [common_target s e common]
  have h := (mapped_common_check_inputs e common).map q
  simpa only [List.map_map, Function.comp_def] using
    CyclicDecoderEntry.check_perm (s (oldDecoder.edgeCheck e)) h

/-- The actual full update maps differ only on the 24 directly affected
extrinsic coordinates at the same physical input state. -/
theorem common_update (s : Fin 126 → Bool) (q : E → Int)
    (e : E) (common : ¬directlyAffected e) :
    next oldDecoder s (fun f => q (edgeMap f)) e =
      next newDecoder (liftedTarget s) q (edgeMap e) := by
  have hp := (mapped_other_edges e).map (messages newDecoder (liftedTarget s) q)
  have hs := hp.sum_eq
  simp only [List.map_map, Function.comp_def] at hs
  have point : (variableOthers oldDecoder e).map
      (messages oldDecoder s (fun f => q (edgeMap f))) =
      (variableOthers oldDecoder e).map
      (fun f => messages newDecoder (liftedTarget s) q (edgeMap f)) := by
    apply CyclicDecoderEntry.map_same_on
    intro f hf
    apply common_message
    intro source
    exact common ⟨f,hf,source⟩
  unfold next
  rw [point,hs]

/-- A concrete dependency-cone theorem for these two actual graph operators.
It is a possible-influence bound, not a claim that every reached coordinate
actually differs or that a difference implies decoding failure. -/
theorem trajectory_confined (s : Fin 126 → Bool) : ∀ k e,
    ¬CyclicDecoderEntry.cone (CyclicDecoderEntry.updateDepends oldDecoder)
      directlyAffected k e →
    CyclicDecoderPersistence.orbit (next oldDecoder s) (fun _ => prior) k e =
    CyclicDecoderPersistence.orbit (next newDecoder (liftedTarget s))
      (fun _ => prior) k (edgeMap e) := by
  intro k
  induction k with
  | zero => intro e _; rfl
  | succ k ih =>
    intro e outside
    change next oldDecoder s
      (CyclicDecoderPersistence.orbit (next oldDecoder s) (fun _ => prior) k) e =
      next newDecoder (liftedTarget s)
      (CyclicDecoderPersistence.orbit (next newDecoder (liftedTarget s))
        (fun _ => prior) k) (edgeMap e)
    have common : ¬directlyAffected e := fun h => outside (Or.inl h)
    have inputs : ∀ f, CyclicDecoderEntry.updateDepends oldDecoder e f →
        CyclicDecoderPersistence.orbit (next oldDecoder s) (fun _ => prior) k f =
        CyclicDecoderPersistence.orbit (next newDecoder (liftedTarget s))
          (fun _ => prior) k (edgeMap f) := by
      intro f hf
      apply ih
      intro reached
      exact outside (Or.inr ⟨f,hf,reached⟩)
    exact (CyclicDecoderEntry.next_local oldDecoder s _ _ e inputs).trans
      (common_update s _ e common)
end Previous
namespace Minimum
abbrev oldDecoder := CyclicDecoderEntryWitnesses.Minimum.oldDecoder
abbrev newDecoder := CyclicDecoderEntryWitnesses.Minimum.newDecoder
abbrev edgeMap := CyclicDecoderEntryWitnesses.Minimum.edgeMap

def originalCheck (c : C) : Fin 126 :=
  Fin.ofNat 126 (if c.val < 119 then c.val else c.val+1)
def liftedTarget (s : Fin 126 → Bool) (c : C) : Bool :=
  if c = 42 then s 42 ^^ s 119 else s (originalCheck c)

theorem check_label_options : ∀ e : E,
    (oldDecoder.edgeCheck e = 42 ∧ newDecoder.edgeCheck (edgeMap e) = 42) ∨
    (oldDecoder.edgeCheck e = 119 ∧ newDecoder.edgeCheck (edgeMap e) = 42) ∨
    (originalCheck (newDecoder.edgeCheck (edgeMap e)) = oldDecoder.edgeCheck e ∧
      newDecoder.edgeCheck (edgeMap e) ≠ 42) := by
  apply checked_all
  decide +kernel

theorem old_incoming_length : ∀ e : E, (incomingEdges oldDecoder e).length = 5 := by
  apply checked_all
  decide +kernel

theorem new_incoming_length : ∀ e : E,
    (incomingEdges newDecoder e).length = 5 ∨ (incomingEdges newDecoder e).length = 11 := by
  apply checked_all
  decide +kernel

theorem mapped_other_edges : ∀ e : E,
    ((variableOthers oldDecoder e).map edgeMap).Perm
      (variableOthers newDecoder (edgeMap e)) := by
  apply checked_all
  decide +kernel

theorem old_first (s : Fin 126 → Bool) (e : E) :
    messages oldDecoder s (fun _ => prior) e = signed (s (oldDecoder.edgeCheck e)) 2665945 := by
  unfold messages
  rw [constant_map, old_incoming_length]
  exact (CyclicDecoderEntry.first_message_formula _).1

theorem new_first (s : C → Bool) (e : E) :
    messages newDecoder s (fun _ => prior) e = signed (s (newDecoder.edgeCheck e)) 2665945 := by
  unfold messages
  rw [constant_map]
  rcases new_incoming_length e with h | h
  · rw [h]; exact (CyclicDecoderEntry.first_message_formula _).1
  · rw [h]; exact (CyclicDecoderEntry.first_message_formula _).2

theorem target_agrees_when_inactive (s : Fin 126 → Bool)
    (ha : s 42 = false) (hb : s 119 = false) (e : E) :
    liftedTarget s (newDecoder.edgeCheck (edgeMap e)) = s (oldDecoder.edgeCheck e) := by
  rcases check_label_options e with h | h | h
  · rw [h.1, h.2]
    simp [liftedTarget,ha,hb]
  · rw [h.1, h.2]
    simp [liftedTarget,ha,hb]
  · simp only [liftedTarget, ite_eq_right h.2, h.1]

theorem inactive_messages_agree (s : Fin 126 → Bool)
    (ha : s 42 = false) (hb : s 119 = false) (e : E) :
    messages oldDecoder s (fun _ => prior) e =
      messages newDecoder (liftedTarget s) (fun _ => prior) (edgeMap e) := by
  rw [old_first,new_first,target_agrees_when_inactive s ha hb]

/-- For the actual two fixed matrices, inactive source syndromes imply equal
entire first extrinsic updates under the physical edge bijection. -/
theorem inactive_next_agrees (s : Fin 126 → Bool)
    (ha : s 42 = false) (hb : s 119 = false) (e : E) :
    next oldDecoder s (fun _ => prior) e =
      next newDecoder (liftedTarget s) (fun _ => prior) (edgeMap e) := by
  have hp := (mapped_other_edges e).map
    (messages newDecoder (liftedTarget s) (fun _ => prior))
  have hs := hp.sum_eq
  simp only [List.map_map, Function.comp_def] at hs
  have point : (variableOthers oldDecoder e).map
      (messages oldDecoder s (fun _ => prior)) =
      (variableOthers oldDecoder e).map
      (fun f => messages newDecoder (liftedTarget s) (fun _ => prior) (edgeMap f)) := by
    apply CyclicDecoderEntry.map_same_on
    intro f _
    exact inactive_messages_agree s ha hb f
  unfold next
  rw [point, hs]

theorem source_labels :
    oldDecoder.edgeCheck (252 : E) = 42 ∧
    oldDecoder.edgeCheck (714 : E) = 119 ∧
    newDecoder.edgeCheck (edgeMap (252 : E)) = 42 ∧
    newDecoder.edgeCheck (edgeMap (714 : E)) = 42 := by
  decide +kernel

/-- Initial source activity is exactly immediate message divergence in these
actual graphs, for all input syndrome vectors. -/
theorem immediate_divergence_iff (s : Fin 126 → Bool) :
    (∃ e : E, messages oldDecoder s (fun _ => prior) e ≠
      messages newDecoder (liftedTarget s) (fun _ => prior) (edgeMap e)) ↔
      (s 42 || s 119) = true := by
  constructor
  · rintro ⟨e, different⟩
    by_contra hn
    have ha : s 42 = false := by cases h : s 42 <;> simp_all
    have hb : s 119 = false := by cases h : s 119 <;> simp_all
    exact different (inactive_messages_agree s ha hb e)
  · intro active
    have h := CyclicDecoderEntry.immediate_source_divergence (s 42) (s 119)
    obtain h | h := h.mpr active
    · refine ⟨252, ?_⟩
      rw [old_first,new_first,source_labels.1,source_labels.2.2.1]
      simpa [liftedTarget] using h
    · refine ⟨714, ?_⟩
      rw [old_first,new_first,source_labels.2.1,source_labels.2.2.2]
      simpa [liftedTarget] using h

def sourceEdge (e : E) : Prop :=
  oldDecoder.edgeCheck e = 42 ∨ oldDecoder.edgeCheck e = 119
instance (e : E) : Decidable (sourceEdge e) :=
  inferInstanceAs (Decidable (oldDecoder.edgeCheck e = 42 ∨ oldDecoder.edgeCheck e = 119))
def directlyAffected (e : E) : Prop :=
  ∃ g ∈ variableOthers oldDecoder e, sourceEdge g

theorem mapped_common_check_inputs : ∀ e : E, ¬sourceEdge e →
    ((incomingEdges oldDecoder e).map edgeMap).Perm
      (incomingEdges newDecoder (edgeMap e)) := by
  apply checked_all
  decide +kernel

theorem common_target (s : Fin 126 → Bool) (e : E) (common : ¬sourceEdge e) :
    liftedTarget s (newDecoder.edgeCheck (edgeMap e)) = s (oldDecoder.edgeCheck e) := by
  rcases check_label_options e with h | h | h
  · exact (common (Or.inl h.1)).elim
  · exact (common (Or.inr h.1)).elim
  · simp only [liftedTarget, ite_eq_right h.2, h.1]

/-- At identical physical incoming messages, every common check has the same
exact sign/minimum/rounding output, for arbitrary message vectors. -/
theorem common_message (s : Fin 126 → Bool) (q : E → Int)
    (e : E) (common : ¬sourceEdge e) :
    messages oldDecoder s (fun f => q (edgeMap f)) e =
      messages newDecoder (liftedTarget s) q (edgeMap e) := by
  unfold messages
  rw [common_target s e common]
  have h := (mapped_common_check_inputs e common).map q
  simpa only [List.map_map, Function.comp_def] using
    CyclicDecoderEntry.check_perm (s (oldDecoder.edgeCheck e)) h

/-- The actual full update maps differ only on the 24 directly affected
extrinsic coordinates at the same physical input state. -/
theorem common_update (s : Fin 126 → Bool) (q : E → Int)
    (e : E) (common : ¬directlyAffected e) :
    next oldDecoder s (fun f => q (edgeMap f)) e =
      next newDecoder (liftedTarget s) q (edgeMap e) := by
  have hp := (mapped_other_edges e).map (messages newDecoder (liftedTarget s) q)
  have hs := hp.sum_eq
  simp only [List.map_map, Function.comp_def] at hs
  have point : (variableOthers oldDecoder e).map
      (messages oldDecoder s (fun f => q (edgeMap f))) =
      (variableOthers oldDecoder e).map
      (fun f => messages newDecoder (liftedTarget s) q (edgeMap f)) := by
    apply CyclicDecoderEntry.map_same_on
    intro f hf
    apply common_message
    intro source
    exact common ⟨f,hf,source⟩
  unfold next
  rw [point,hs]

/-- A concrete dependency-cone theorem for these two actual graph operators.
It is a possible-influence bound, not a claim that every reached coordinate
actually differs or that a difference implies decoding failure. -/
theorem trajectory_confined (s : Fin 126 → Bool) : ∀ k e,
    ¬CyclicDecoderEntry.cone (CyclicDecoderEntry.updateDepends oldDecoder)
      directlyAffected k e →
    CyclicDecoderPersistence.orbit (next oldDecoder s) (fun _ => prior) k e =
    CyclicDecoderPersistence.orbit (next newDecoder (liftedTarget s))
      (fun _ => prior) k (edgeMap e) := by
  intro k
  induction k with
  | zero => intro e _; rfl
  | succ k ih =>
    intro e outside
    change next oldDecoder s
      (CyclicDecoderPersistence.orbit (next oldDecoder s) (fun _ => prior) k) e =
      next newDecoder (liftedTarget s)
      (CyclicDecoderPersistence.orbit (next newDecoder (liftedTarget s))
        (fun _ => prior) k) (edgeMap e)
    have common : ¬directlyAffected e := fun h => outside (Or.inl h)
    have inputs : ∀ f, CyclicDecoderEntry.updateDepends oldDecoder e f →
        CyclicDecoderPersistence.orbit (next oldDecoder s) (fun _ => prior) k f =
        CyclicDecoderPersistence.orbit (next newDecoder (liftedTarget s))
          (fun _ => prior) k (edgeMap f) := by
      intro f hf
      apply ih
      intro reached
      exact outside (Or.inr ⟨f,hf,reached⟩)
    exact (CyclicDecoderEntry.next_local oldDecoder s _ _ e inputs).trans
      (common_update s _ e common)
end Minimum
end CyclicDecoderEntryBridge
#print axioms CyclicDecoderEntryBridge.Previous.inactive_next_agrees
#print axioms CyclicDecoderEntryBridge.Previous.immediate_divergence_iff
#print axioms CyclicDecoderEntryBridge.Minimum.inactive_next_agrees
#print axioms CyclicDecoderEntryBridge.Minimum.immediate_divergence_iff
#print axioms CyclicDecoderEntryBridge.Previous.common_update
#print axioms CyclicDecoderEntryBridge.Previous.trajectory_confined
#print axioms CyclicDecoderEntryBridge.Minimum.common_update
#print axioms CyclicDecoderEntryBridge.Minimum.trajectory_confined
