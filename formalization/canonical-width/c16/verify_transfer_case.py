#!/usr/bin/env python3
"""Use the existing independent source/CNF consumer with union-cover parents.

Only the parent metadata reader changes. The physical reconstruction, clause
checks, model checks and DRAT checker remain the previous independent consumer.
"""
import verify_sparse_kept_anchor as consumer
from verify_strategy_cover_union import check_cover
if __name__=='__main__':
    consumer.check_cover=check_cover
    consumer.main()
