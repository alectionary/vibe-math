"""Strict sparse rational CLI output reader; no solver status proves validity."""
from fractions import Fraction
from pathlib import Path
import re

RATIONAL = re.compile(r'[+-]?\d+(?:/[1-9]\d*)?\Z')

def read_named_rational(path, names, kind='primal'):
    headers={'primal':'Primal solution (name, value):',
             'farkas':'Dual ray (name, value):',
             'dual':'Dual solution (name, value):'}
    header=headers[kind]
    names=list(names)
    if len(set(names)) != len(names):
        raise ValueError('duplicate expected names')
    values={name:Fraction(0) for name in names}
    lines=Path(path).read_text().splitlines()
    positions=[i for i,line in enumerate(lines) if line.strip()==header]
    if len(positions)!=1:
        raise ValueError('expected exactly one rational output section')
    seen=set();terminated=False
    for line in lines[positions[0]+1:]:
        line=line.strip()
        if line.startswith('All other variables are zero.') or line=='All other entries are zero.':
            terminated=True
            break
        if not line:
            continue
        fields=line.split()
        if len(fields)!=2:
            raise ValueError('unexpected rational output line')
        name,value=fields
        if name not in values or name in seen or not RATIONAL.fullmatch(value):
            raise ValueError('unknown/duplicate name or nonrational token')
        seen.add(name);values[name]=Fraction(value)
    if not terminated:
        raise ValueError('missing sparse-zero terminator')
    return values
