"""Count ReShape oracle calls on the worked examples.

The dissertation reports O(k) classical nearest-codeword oracle calls and
O(n^2) further operations. This script counts the calls this implementation
makes. It does not time a universal proof.
"""
import json
from pathlib import Path
import numpy as np
from gf2 import HGP
from verify import seeds

ROOT = Path(__file__).resolve().parents[1]


def oracle_calls(code):
    """Columns of the left complement plus rows of the right complement."""
    left = int(np.count_nonzero(code.pl.any(axis=0)))
    right = int(np.count_nonzero(code.pr.any(axis=0)))
    return left + right, left, right


def main():
    rows = []
    for name, seed, distance in seeds():
        code = HGP(seed, seed)
        calls, left, right = oracle_calls(code)
        # One syndrome matvec plus the complement projections, in bit operations.
        classical_bit_ops = int(code.hx.size + code.pl.size + code.pr.size + code.n)
        sample = np.zeros(code.n, dtype=np.uint8)
        sample[:min(distance, code.n)] = 1
        corrected = code.correct(sample)
        rows.append({
            'code': name,
            'n': int(code.n),
            'k': int(code.k),
            'distance_label': int(distance),
            'oracle_calls': calls,
            'left_oracle_calls': left,
            'right_oracle_calls': right,
            'calls_at_most_k': calls <= int(code.k),
            'classical_bit_operations_one_correction': classical_bit_ops,
            'classical_over_n_squared': classical_bit_ops / max(int(code.n) ** 2, 1),
            'sample_weight': int(sample.sum()),
            'sample_logical_after_correction': int(code.logical(sample ^ corrected).any()),
        })
    out = {
        'statement': 'Reported resource bound is O(k) oracle calls and O(n^2) additional operations.',
        'implementation': 'analysis/gf2.py HGP.reshape loops once per nonzero complement column or row.',
        'rows': rows,
    }
    path = ROOT / 'results' / 'reshape_cost.json'
    path.write_text(json.dumps(out, indent=2) + '\n')
    print(json.dumps(rows, indent=2))


if __name__ == '__main__':
    main()
