"""Audit guard for clean-checkout exact replay; not a proof dependency."""
import sys

blocked={'numpy','scipy','cvxpy','scs','ortools','psutil'}
assert not any(name.split('.')[0] in blocked for name in sys.modules)

def exact_only(event,args):
    if event=='import' and args and args[0].split('.')[0] in blocked:
        raise RuntimeError('Numerical/solver package imported during exact replay: '+args[0])

sys.addaudithook(exact_only)
