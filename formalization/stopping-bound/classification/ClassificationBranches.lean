module
public import ClassificationData
@[expose] public section
namespace Incidence.Classification
open Incidence

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_false_0 :
    classifiesList pickList row good 4 [(false,0-1,27),(false,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_false_1 :
    classifiesList pickList row good 4 [(false,0-2,27-54),(false,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_false_2 :
    classifiesList pickList row good 4 [(true,0,27),(false,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_false_3 :
    classifiesList pickList row good 4 [(true,0,27+1),(false,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_false_4 :
    classifiesList pickList row good 4 [(true,0,27+6),(false,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_true_0 :
    classifiesList pickList row good 4 [(false,0,0-27),(true,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_true_1 :
    classifiesList pickList row good 4 [(false,0-1,0),(true,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_true_2 :
    classifiesList pickList row good 4 [(false,0-2,0-54),(true,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_true_3 :
    classifiesList pickList row good 4 [(true,0,0+1),(true,0,0)] = true := by
  decide +kernel

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem branch_true_4 :
    classifiesList pickList row good 4 [(true,0,0+6),(true,0,0)] = true := by
  decide +kernel

end Incidence.Classification
