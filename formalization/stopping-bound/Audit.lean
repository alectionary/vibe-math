module

public import Spectral

-- Complete declaration and statement audit.
#print axioms StoppingSpectral.energy
#print axioms StoppingSpectral.normSq
#print axioms StoppingSpectral.energy_eq_gram
#print axioms StoppingSpectral.eigs
#print axioms StoppingSpectral.eBasis
#print axioms StoppingSpectral.eigs_antitone
#print axioms StoppingSpectral.gram_apply_basis
#print axioms StoppingSpectral.normSq_euclidean
#print axioms StoppingSpectral.energy_eigenbasis
#print axioms StoppingSpectral.energy_basis
#print axioms StoppingSpectral.eigs_trace
#print axioms StoppingSpectral.energy_le_of_coeff_zero
#print axioms StoppingSpectral.binary_weighted_cauchy
#print axioms StoppingSpectral.regular_energy_upper
#print axioms StoppingSpectral.regular_trace
#print axioms StoppingSpectral.regular_eigs_le
#print axioms StoppingSpectral.regular_trace_obstruction
#print axioms StoppingSpectral.scalarFactorMatrix
#print axioms StoppingSpectral.fiberLift
#print axioms StoppingSpectral.scalarFactor_right_action
#print axioms StoppingSpectral.scalarFactor_energy_lower
#print axioms StoppingSpectral.replicated_scalar_second_lower
#print axioms StoppingSpectral.replicated_scalar_no_source_regime
#print axioms StoppingSpectral.one_row_density
#print axioms StoppingSpectral.one_row_large_root_le_two
#print axioms StoppingSpectral.one_row_matrix_obstruction
#print axioms StoppingSpectral.binary_column_sum_le_card
#print axioms StoppingSpectral.regular_edge_count
#print axioms StoppingSpectral.one_row_biregular_obstruction
#print axioms StoppingSpectral.qc_scalar_factor_no_source_regime
#print axioms StoppingSpectral.eigs_det
#print axioms StoppingSpectral.denseExample
#print axioms StoppingSpectral.denseEigs
#print axioms StoppingSpectral.denseExample_second
#print axioms StoppingSpectral.IsStopping
#print axioms StoppingSpectral.denseExample_stopping
#print axioms StoppingSpectral.denseExampleBinary
#print axioms StoppingSpectral.denseExample_css
#print axioms StoppingSpectral.denseExample_source_certificate
#print axioms StoppingSpectral.sourceLargeRoot
#print axioms StoppingSpectral.sourceLargeRoot_eq
#print axioms StoppingSpectral.sourceSmallRoot
#print axioms StoppingSpectral.sourceSmallRoot_eq
#print axioms StoppingSpectral.one_row_roots
#print axioms StoppingSpectral.stopping_card_ge_two
#print axioms StoppingSpectral.one_row_stopping_bound_redundant
#print axioms StoppingSpectral.one_row_cardinal_obstruction
#print axioms StoppingSpectral.scalar_one_row_source_obstruction
#print axioms StoppingSpectral.supportCirculant
#print axioms StoppingSpectral.supportCirculant_row_sum
#print axioms StoppingSpectral.running_882_scalar_obstruction
#print axioms StoppingSpectral.denseExample_minimum

#check @StoppingSpectral.qc_scalar_factor_no_source_regime
#check @StoppingSpectral.scalar_one_row_source_obstruction
#check @StoppingSpectral.one_row_stopping_bound_redundant
#check @StoppingSpectral.running_882_scalar_obstruction
#check @StoppingSpectral.denseExample_source_certificate
