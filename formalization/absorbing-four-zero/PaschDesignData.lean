import PaschSTS13

set_option maxHeartbeats 0
namespace PaschDesignData
open HGPGramObstruction

theorem STS13_A_point_Gram : ∀ c d : Fin 13,
    checkGram PaschSTS13.baseA c d = if c=d then 6 else 1 := by decide

theorem STS13_B_point_Gram (c d : Fin 13) :
    checkGram PaschSTS13.baseB c d = if c=d then 6 else 1 := by
  rw [← PaschSTS13.equal_point_Gram]
  exact STS13_A_point_Gram c d

theorem fano_diagonal : ∀ a : Fin 7, checkGram FanoBlock.columns a a = 3 := by decide

theorem product_A_check_degree (c : Fin 13) (a : Fin 7) :
    checkGram (HGPIncidence.columns PaschSTS13.baseA FanoBlock.columns) (c,a) (c,a) = 9 := by
  rw [gram_product]
  simp [STS13_A_point_Gram,fano_diagonal]

theorem product_B_check_degree (c : Fin 13) (a : Fin 7) :
    checkGram (HGPIncidence.columns PaschSTS13.baseB FanoBlock.columns) (c,a) (c,a) = 9 := by
  rw [gram_product]
  simp [STS13_B_point_Gram,fano_diagonal]

theorem equal_full_binary_check_Gram :
    checkGram (HGPIncidence.columns PaschSTS13.baseA FanoBlock.columns) =
    checkGram (HGPIncidence.columns PaschSTS13.baseB FanoBlock.columns) := by
  funext ⟨c,a⟩ ⟨d,b⟩
  simp only [gram_product,PaschSTS13.equal_point_Gram]

#print axioms STS13_A_point_Gram
#print axioms STS13_B_point_Gram
#print axioms product_A_check_degree
#print axioms equal_full_binary_check_Gram
end PaschDesignData
