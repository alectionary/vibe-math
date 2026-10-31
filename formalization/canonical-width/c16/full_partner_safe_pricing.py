"""Fast exact phase pricing with arbitrary-integer Python overflow fallback.

The frozen batch implementation owns int64 safety checks. Only OverflowError
selects the reference Python path; malformed lengths/types remain rejections.
"""
from full_partner_batched_weights import support_all_batched
from full_partner_projection import support_all as reference_support_all


def support_all(oracle,domains,coefficients,batch=None,return_mode=False):
    try:
        result=support_all_batched(oracle,domains,coefficients,batch)
        mode='exact_int64_batch'
    except OverflowError:
        result=reference_support_all(oracle,domains,coefficients)
        mode='exact_python_integer_overflow_fallback'
    return (result,mode) if return_mode else result
