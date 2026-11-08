"""Minimal stand-in for the two python-sat entry points used by subgroup_frame.py
(CardEnc.equals / CardEnc.atmost). PyPI is unreachable in the 2026-10-31 session.
Encodings are sequential counters, logically equivalent to PySAT's but not
clause-identical, so CNF hashes differ from the frozen structural-results runs."""
