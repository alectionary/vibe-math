import PatternRealizations
import ConstantRows
import FiniteLabels
import Catalog7
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

/-- Assemble all 144 closed checks into a quantified certificate statement. -/
theorem seven_certificates_complete (p : Fin 144) :
    ∃ c : Certificate,checkCertificateFast 7 p.val c=true ∧ ¬needsClassicalBound c.kind := by
  fin_cases p
  · exact ⟨fastCert7_0,fastCase7_0,by decide +kernel⟩
  · exact ⟨fastCert7_1,fastCase7_1,by decide +kernel⟩
  · exact ⟨fastCert7_2,fastCase7_2,by decide +kernel⟩
  · exact ⟨fastCert7_3,fastCase7_3,by decide +kernel⟩
  · exact ⟨fastCert7_4,fastCase7_4,by decide +kernel⟩
  · exact ⟨fastCert7_5,fastCase7_5,by decide +kernel⟩
  · exact ⟨fastCert7_6,fastCase7_6,by decide +kernel⟩
  · exact ⟨fastCert7_7,fastCase7_7,by decide +kernel⟩
  · exact ⟨fastCert7_8,fastCase7_8,by decide +kernel⟩
  · exact ⟨fastCert7_9,fastCase7_9,by decide +kernel⟩
  · exact ⟨fastCert7_10,fastCase7_10,by decide +kernel⟩
  · exact ⟨fastCert7_11,fastCase7_11,by decide +kernel⟩
  · exact ⟨fastCert7_12,fastCase7_12,by decide +kernel⟩
  · exact ⟨fastCert7_13,fastCase7_13,by decide +kernel⟩
  · exact ⟨fastCert7_14,fastCase7_14,by decide +kernel⟩
  · exact ⟨fastCert7_15,fastCase7_15,by decide +kernel⟩
  · exact ⟨fastCert7_16,fastCase7_16,by decide +kernel⟩
  · exact ⟨fastCert7_17,fastCase7_17,by decide +kernel⟩
  · exact ⟨fastCert7_18,fastCase7_18,by decide +kernel⟩
  · exact ⟨fastCert7_19,fastCase7_19,by decide +kernel⟩
  · exact ⟨fastCert7_20,fastCase7_20,by decide +kernel⟩
  · exact ⟨fastCert7_21,fastCase7_21,by decide +kernel⟩
  · exact ⟨fastCert7_22,fastCase7_22,by decide +kernel⟩
  · exact ⟨fastCert7_23,fastCase7_23,by decide +kernel⟩
  · exact ⟨fastCert7_24,fastCase7_24,by decide +kernel⟩
  · exact ⟨fastCert7_25,fastCase7_25,by decide +kernel⟩
  · exact ⟨fastCert7_26,fastCase7_26,by decide +kernel⟩
  · exact ⟨fastCert7_27,fastCase7_27,by decide +kernel⟩
  · exact ⟨fastCert7_28,fastCase7_28,by decide +kernel⟩
  · exact ⟨fastCert7_29,fastCase7_29,by decide +kernel⟩
  · exact ⟨fastCert7_30,fastCase7_30,by decide +kernel⟩
  · exact ⟨fastCert7_31,fastCase7_31,by decide +kernel⟩
  · exact ⟨fastCert7_32,fastCase7_32,by decide +kernel⟩
  · exact ⟨fastCert7_33,fastCase7_33,by decide +kernel⟩
  · exact ⟨fastCert7_34,fastCase7_34,by decide +kernel⟩
  · exact ⟨fastCert7_35,fastCase7_35,by decide +kernel⟩
  · exact ⟨fastCert7_36,fastCase7_36,by decide +kernel⟩
  · exact ⟨fastCert7_37,fastCase7_37,by decide +kernel⟩
  · exact ⟨fastCert7_38,fastCase7_38,by decide +kernel⟩
  · exact ⟨fastCert7_39,fastCase7_39,by decide +kernel⟩
  · exact ⟨fastCert7_40,fastCase7_40,by decide +kernel⟩
  · exact ⟨fastCert7_41,fastCase7_41,by decide +kernel⟩
  · exact ⟨fastCert7_42,fastCase7_42,by decide +kernel⟩
  · exact ⟨fastCert7_43,fastCase7_43,by decide +kernel⟩
  · exact ⟨fastCert7_44,fastCase7_44,by decide +kernel⟩
  · exact ⟨fastCert7_45,fastCase7_45,by decide +kernel⟩
  · exact ⟨fastCert7_46,fastCase7_46,by decide +kernel⟩
  · exact ⟨fastCert7_47,fastCase7_47,by decide +kernel⟩
  · exact ⟨fastCert7_48,fastCase7_48,by decide +kernel⟩
  · exact ⟨fastCert7_49,fastCase7_49,by decide +kernel⟩
  · exact ⟨fastCert7_50,fastCase7_50,by decide +kernel⟩
  · exact ⟨fastCert7_51,fastCase7_51,by decide +kernel⟩
  · exact ⟨fastCert7_52,fastCase7_52,by decide +kernel⟩
  · exact ⟨fastCert7_53,fastCase7_53,by decide +kernel⟩
  · exact ⟨fastCert7_54,fastCase7_54,by decide +kernel⟩
  · exact ⟨fastCert7_55,fastCase7_55,by decide +kernel⟩
  · exact ⟨fastCert7_56,fastCase7_56,by decide +kernel⟩
  · exact ⟨fastCert7_57,fastCase7_57,by decide +kernel⟩
  · exact ⟨fastCert7_58,fastCase7_58,by decide +kernel⟩
  · exact ⟨fastCert7_59,fastCase7_59,by decide +kernel⟩
  · exact ⟨fastCert7_60,fastCase7_60,by decide +kernel⟩
  · exact ⟨fastCert7_61,fastCase7_61,by decide +kernel⟩
  · exact ⟨fastCert7_62,fastCase7_62,by decide +kernel⟩
  · exact ⟨fastCert7_63,fastCase7_63,by decide +kernel⟩
  · exact ⟨fastCert7_64,fastCase7_64,by decide +kernel⟩
  · exact ⟨fastCert7_65,fastCase7_65,by decide +kernel⟩
  · exact ⟨fastCert7_66,fastCase7_66,by decide +kernel⟩
  · exact ⟨fastCert7_67,fastCase7_67,by decide +kernel⟩
  · exact ⟨fastCert7_68,fastCase7_68,by decide +kernel⟩
  · exact ⟨fastCert7_69,fastCase7_69,by decide +kernel⟩
  · exact ⟨fastCert7_70,fastCase7_70,by decide +kernel⟩
  · exact ⟨fastCert7_71,fastCase7_71,by decide +kernel⟩
  · exact ⟨fastCert7_72,fastCase7_72,by decide +kernel⟩
  · exact ⟨fastCert7_73,fastCase7_73,by decide +kernel⟩
  · exact ⟨fastCert7_74,fastCase7_74,by decide +kernel⟩
  · exact ⟨fastCert7_75,fastCase7_75,by decide +kernel⟩
  · exact ⟨fastCert7_76,fastCase7_76,by decide +kernel⟩
  · exact ⟨fastCert7_77,fastCase7_77,by decide +kernel⟩
  · exact ⟨fastCert7_78,fastCase7_78,by decide +kernel⟩
  · exact ⟨fastCert7_79,fastCase7_79,by decide +kernel⟩
  · exact ⟨fastCert7_80,fastCase7_80,by decide +kernel⟩
  · exact ⟨fastCert7_81,fastCase7_81,by decide +kernel⟩
  · exact ⟨fastCert7_82,fastCase7_82,by decide +kernel⟩
  · exact ⟨fastCert7_83,fastCase7_83,by decide +kernel⟩
  · exact ⟨fastCert7_84,fastCase7_84,by decide +kernel⟩
  · exact ⟨fastCert7_85,fastCase7_85,by decide +kernel⟩
  · exact ⟨fastCert7_86,fastCase7_86,by decide +kernel⟩
  · exact ⟨fastCert7_87,fastCase7_87,by decide +kernel⟩
  · exact ⟨fastCert7_88,fastCase7_88,by decide +kernel⟩
  · exact ⟨fastCert7_89,fastCase7_89,by decide +kernel⟩
  · exact ⟨fastCert7_90,fastCase7_90,by decide +kernel⟩
  · exact ⟨fastCert7_91,fastCase7_91,by decide +kernel⟩
  · exact ⟨fastCert7_92,fastCase7_92,by decide +kernel⟩
  · exact ⟨fastCert7_93,fastCase7_93,by decide +kernel⟩
  · exact ⟨fastCert7_94,fastCase7_94,by decide +kernel⟩
  · exact ⟨fastCert7_95,fastCase7_95,by decide +kernel⟩
  · exact ⟨fastCert7_96,fastCase7_96,by decide +kernel⟩
  · exact ⟨fastCert7_97,fastCase7_97,by decide +kernel⟩
  · exact ⟨fastCert7_98,fastCase7_98,by decide +kernel⟩
  · exact ⟨fastCert7_99,fastCase7_99,by decide +kernel⟩
  · exact ⟨fastCert7_100,fastCase7_100,by decide +kernel⟩
  · exact ⟨fastCert7_101,fastCase7_101,by decide +kernel⟩
  · exact ⟨fastCert7_102,fastCase7_102,by decide +kernel⟩
  · exact ⟨fastCert7_103,fastCase7_103,by decide +kernel⟩
  · exact ⟨fastCert7_104,fastCase7_104,by decide +kernel⟩
  · exact ⟨fastCert7_105,fastCase7_105,by decide +kernel⟩
  · exact ⟨fastCert7_106,fastCase7_106,by decide +kernel⟩
  · exact ⟨fastCert7_107,fastCase7_107,by decide +kernel⟩
  · exact ⟨fastCert7_108,fastCase7_108,by decide +kernel⟩
  · exact ⟨fastCert7_109,fastCase7_109,by decide +kernel⟩
  · exact ⟨fastCert7_110,fastCase7_110,by decide +kernel⟩
  · exact ⟨fastCert7_111,fastCase7_111,by decide +kernel⟩
  · exact ⟨fastCert7_112,fastCase7_112,by decide +kernel⟩
  · exact ⟨fastCert7_113,fastCase7_113,by decide +kernel⟩
  · exact ⟨fastCert7_114,fastCase7_114,by decide +kernel⟩
  · exact ⟨fastCert7_115,fastCase7_115,by decide +kernel⟩
  · exact ⟨fastCert7_116,fastCase7_116,by decide +kernel⟩
  · exact ⟨fastCert7_117,fastCase7_117,by decide +kernel⟩
  · exact ⟨fastCert7_118,fastCase7_118,by decide +kernel⟩
  · exact ⟨fastCert7_119,fastCase7_119,by decide +kernel⟩
  · exact ⟨fastCert7_120,fastCase7_120,by decide +kernel⟩
  · exact ⟨fastCert7_121,fastCase7_121,by decide +kernel⟩
  · exact ⟨fastCert7_122,fastCase7_122,by decide +kernel⟩
  · exact ⟨fastCert7_123,fastCase7_123,by decide +kernel⟩
  · exact ⟨fastCert7_124,fastCase7_124,by decide +kernel⟩
  · exact ⟨fastCert7_125,fastCase7_125,by decide +kernel⟩
  · exact ⟨fastCert7_126,fastCase7_126,by decide +kernel⟩
  · exact ⟨fastCert7_127,fastCase7_127,by decide +kernel⟩
  · exact ⟨fastCert7_128,fastCase7_128,by decide +kernel⟩
  · exact ⟨fastCert7_129,fastCase7_129,by decide +kernel⟩
  · exact ⟨fastCert7_130,fastCase7_130,by decide +kernel⟩
  · exact ⟨fastCert7_131,fastCase7_131,by decide +kernel⟩
  · exact ⟨fastCert7_132,fastCase7_132,by decide +kernel⟩
  · exact ⟨fastCert7_133,fastCase7_133,by decide +kernel⟩
  · exact ⟨fastCert7_134,fastCase7_134,by decide +kernel⟩
  · exact ⟨fastCert7_135,fastCase7_135,by decide +kernel⟩
  · exact ⟨fastCert7_136,fastCase7_136,by decide +kernel⟩
  · exact ⟨fastCert7_137,fastCase7_137,by decide +kernel⟩
  · exact ⟨fastCert7_138,fastCase7_138,by decide +kernel⟩
  · exact ⟨fastCert7_139,fastCase7_139,by decide +kernel⟩
  · exact ⟨fastCert7_140,fastCase7_140,by decide +kernel⟩
  · exact ⟨fastCert7_141,fastCase7_141,by decide +kernel⟩
  · exact ⟨fastCert7_142,fastCase7_142,by decide +kernel⟩
  · exact ⟨fastCert7_143,fastCase7_143,by decide +kernel⟩

def sevenQubits (k : Fin 4 → Fin 4) (l : Fin 3 → Fin 3)
    (s : Fin 4 → ZMod L) (t : Fin 3 → ZMod L) : Fin 7 → Qubit L :=
  ![.inl ((0,k 0),s 0),.inl ((1,k 1),s 1),.inl ((2,k 2),s 2),.inl ((3,k 3),s 3),
    .inr ((l 0,0),t 0),.inr ((l 1,1),t 1),.inr ((l 2,2),t 2)]

def sevenChecks (e : Fin 3 → Fin 4 → ZMod L) (k : Fin 4 → Fin 4)
    (s : Fin 4 → ZMod L) : Fin 18 → SourceModel.ZCheck L :=
  ![((0,0),s 0+e 0 (k 0)),((0,1),s 0+e 1 (k 0)),((0,2),s 0+e 2 (k 0)),((1,0),s 1+e 0 (k 1)),((1,1),s 1+e 1 (k 1)),((1,2),s 1+e 2 (k 1)),((2,0),s 2+e 0 (k 2)),((2,1),s 2+e 1 (k 2)),((2,2),s 2+e 2 (k 2)),((3,0),s 3+e 0 (k 3)),((3,1),s 3+e 1 (k 3)),((3,2),s 3+e 2 (k 3)),((0,0),0),((0,0),0),((0,0),0),((0,0),0),((0,0),0),((0,0),0)]

/-- Actual singleton matching supplies an actual realization of its decoded
seven-vertex pattern; no support-coverage premise is assumed here. -/
def seven_realization_of_labels
    (e : Fin 3 → Fin 4 → ZMod L)
    (k : Fin 4 → Fin 4) (l : Fin 3 → Fin 3)
    (s : Fin 4 → ZMod L) (t : Fin 3 → ZMod L)
    (hc : ∀ j i,s j+e i (k j)=t i-e (l i) j)
    (p₄ : Fin 24) (p₃ : Fin 6)
    (hk : ∀ j : Fin 4,perm4Value p₄.val j.val=(k j).val)
    (hl : ∀ i : Fin 3,perm3Value p₃.val i.val=(l i).val) :
    PatternRealization e 7 (6*p₄.val+p₃.val) := by
  have hpdiv : (6*p₄.val+p₃.val)/6=p₄.val := by omega
  have hpmod : (6*p₄.val+p₃.val)%6=p₃.val := by omega
  refine {
    qubits := sevenQubits k l s t
    checks := fun r _ => sevenChecks e k s r
    left_bound := ?_
    right_bound := ?_
    labels := ?_
    check_column := ?_
    check_row := ?_
    left_edge := ?_
    right_edge := ?_
  }
  · intro r hr
    simp only [edgeCount,ite_true] at hr
    simp [edge]
    omega
  · intro r hr
    simp only [edgeCount,ite_true] at hr
    simp [edge]
    omega
  · intro v
    fin_cases v <;> simp [sevenQubits,VertexLabel,vertex,hpdiv,hpmod]
    · exact hk 0
    · exact hk 1
    · exact hk 2
    · exact hk 3
    · exact hl 0
    · exact hl 1
    · exact hl 2
  · intro r hr
    fin_cases r <;> norm_num [edgeCount] at hr <;> simp [edge,sevenChecks]
  · intro r hr
    fin_cases r <;> norm_num [edgeCount] at hr <;> simp [edge,sevenChecks]
  · intro r hr
    fin_cases r <;> norm_num [edgeCount] at hr <;>
      simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
  · intro r hr
    fin_cases r <;> norm_num [edgeCount] at hr
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 0 0
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 0 1
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 0 2
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 1 0
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 1 1
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 1 2
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 2 0
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 2 1
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 2 2
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 3 0
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 3 1
      linear_combination -h
    · simp [edge,sevenChecks,sevenQubits,ZEdge,CEdge]
      have h := hc 3 2
      linear_combination -h

/-- A full source theorem for the seven-singleton mixed profile. This is one
profile of the requested through-weight-eleven target, not the full bound. -/
theorem source_seven_singleton_profile_stabilizer
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hker : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hU : ∀ j,leftCount u j=1) (hV : ∀ i,rightCount v i=1) :
    GeneralLP.InSpanX e u v := by
  obtain ⟨k,s,l,t,hu,hv,hc,hcase⟩ := actual_singleton_label_alternative e h4 u v hker
    (fun j : Fin 4 => j) Function.injective_id hU hV
  rcases hcase with ⟨K,H,hk,hl⟩|⟨hk,hl⟩
  · apply constant_all_singletons_stabilizer e u v hker K H s t
    · simpa only [hk] using hu
    · simpa only [hl] using hv
  · obtain ⟨p₄,hp₄⟩ := permutation4_complete k hk
    obtain ⟨p₃,hp₃⟩ := permutation3_complete l hl
    have hp : 6*p₄.val+p₃.val<144 := by omega
    obtain ⟨c,hcert,hn⟩ := seven_certificates_complete ⟨_,hp⟩
    have hD : ClassicalAtLeast e 0 := by intro x hx hx0;exact Nat.zero_le _
    exact False.elim (certified_pattern_has_no_source_realization e h4 h6 hR0 hC0 hCP hP
      0 hD 7 _ c hcert (fun h => False.elim (hn h))
      ⟨seven_realization_of_labels e k l s t hc p₄ p₃ hp₄ hp₃⟩)

#print axioms seven_certificates_complete
#print axioms seven_realization_of_labels
#print axioms source_seven_singleton_profile_stabilizer
end TruncatedDistance
