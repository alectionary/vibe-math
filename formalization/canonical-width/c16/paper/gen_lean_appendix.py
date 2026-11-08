#!/usr/bin/env python3
"""Write lean-appendix.tex: complete bodies of the central Lean declarations, with current
(master) and commit-pinned links to each, from lean-appendix.json.

  python3 gen_lean_appendix.py      (rerun after the Lean files change)

The work is done by the shared verified-release script scripts/release/lean_appendix.py,
which fails if a declaration differs from its pinned copy.
"""
import runpy, sys
from pathlib import Path

here = Path(__file__).resolve().parent
sys.argv = ['lean_appendix.py', str(here / 'lean-appendix.json')]
runpy.run_path(str(here.parents[3] / 'scripts' / 'release' / 'lean_appendix.py'), run_name='__main__')
