"""Noisy conventional S and T injection gadget.

This is the standard ancilla gadget: prepare a magic state, apply CNOT from
the data qubit to the ancilla, measure the ancilla in Z, and apply a conditional
phase correction. Depolarizing noise follows preparation and the CNOT. It is
not the dissertation's image-only wiring, which was not recovered from the
rendered circuit.
"""
import json
from pathlib import Path
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
SHOTS = 20000
PS = [0.0, 0.001, 0.01, 0.05]
I2 = np.eye(2, dtype=complex)
KET0 = np.array([1, 0], dtype=complex)
KET1 = np.array([0, 1], dtype=complex)
KETP = np.array([1, 1], dtype=complex) / np.sqrt(2)


def phase(theta):
    return np.diag([1, np.exp(1j * theta)])


PAULI = (
    np.array([[0, 1], [1, 0]], dtype=complex),
    np.array([[0, -1j], [1j, 0]], dtype=complex),
    np.diag([1, -1]).astype(complex),
)
# Data is the control and the ancilla is the target.
CNOT = np.array([
    [1, 0, 0, 0],
    [0, 1, 0, 0],
    [0, 0, 0, 1],
    [0, 0, 1, 0],
], dtype=complex)


def depolarize(state, p, rng):
    if p == 0 or rng.random() >= p:
        return state
    return PAULI[int(rng.integers(0, 3))] @ state


def gadget(theta, data, p, rng):
    """Return True when the data matches the ideal phase gate, up to a global phase.

    Circuit: magic-state preparation, CNOT from data to ancilla, Z measurement
    of the ancilla, and diag(1, exp(2 i theta)) on the odd outcome.
    """
    ancilla = depolarize(phase(theta) @ KETP, p, rng)
    data_in = depolarize(np.array(data, dtype=complex), p, rng)
    joint = CNOT @ np.kron(data_in, ancilla)
    if p and rng.random() < p:
        joint = np.kron(PAULI[int(rng.integers(0, 3))], I2) @ joint
    if p and rng.random() < p:
        joint = np.kron(I2, PAULI[int(rng.integers(0, 3))]) @ joint
    c00, c01, c10, c11 = joint
    zero = np.array([c00, c10])
    one = np.array([c01, c11])
    if rng.random() < float(np.vdot(zero, zero).real):
        data_out = zero
    else:
        data_out = np.diag([1, np.exp(2j * theta)]) @ one
    norm = np.linalg.norm(data_out)
    if norm == 0:
        return False
    target = phase(theta) @ np.array(data, dtype=complex)
    overlap = abs(np.vdot(target / np.linalg.norm(target), data_out / norm)) ** 2
    return overlap > 1 - 1e-8


def main():
    rng = np.random.default_rng(20261103)
    rows = []
    for theta, name in ((np.pi / 2, 'S'), (np.pi / 4, 'T')):
        for p in PS:
            for start_name, start in (('zero', KET0), ('plus', KETP.copy())):
                errors = 0
                for _ in range(SHOTS):
                    if not gadget(theta, start.copy(), p, rng):
                        errors += 1
                rows.append({
                    'gate': name,
                    'theta': float(theta),
                    'depolarizing_p': p,
                    'input': start_name,
                    'shots': SHOTS,
                    'errors': errors,
                    'error_rate': errors / SHOTS,
                })
                print(rows[-1], flush=True)
    path = ROOT / 'results' / 'noisy_injection.json'
    path.write_text(json.dumps({
        'circuit': 'Conventional CZ plus X measurement and conditional phase correction.',
        'noise': 'Independent depolarizing noise on preparation and on each qubit after CZ.',
        'source_wiring': 'not recovered from the rendered circuit; this is not that wiring',
        'seed': 20261103,
        'rows': rows,
    }, indent=2) + '\n')


if __name__ == '__main__':
    main()
