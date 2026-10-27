"""Necessary parity constraints on the numbers of canonical orbit pairs.

Let A sum each length16 coordinate block and J repeat each of eight bits
sixteen times. A J=0 over F2. A full dual frame obeys sum x_i z_i^T=I,
so sum A(x_i) A(z_i)^T=0. Cyclic phases do not change A(x_i).
This is necessary only; a solution of these constraints is not a frame.
"""


def augmentation(value):
    return sum(((value >> (16*s) & 65535).bit_count() & 1) << s for s in range(8))


def add_augmentation_constraints(model, flows, X, Z):
    ax=[augmentation(X[16*a]) for a in range(45)]
    az=[augmentation(Z[16*b]) for b in range(45)]
    assert all(augmentation(X[16*a+h]) == ax[a] for a in range(45) for h in range(16))
    assert all(augmentation(Z[16*b+h]) == az[b] for b in range(45) for h in range(16))
    equations=[]
    for u in range(8):
        for v in range(8):
            terms=[flows[a][b] for a in range(45) for b in range(45) if (ax[a]>>u&1) and (az[b]>>v&1)]
            half=model.new_int_var(0,64,f'augmentation_half{u}_{v}')
            model.add(sum(terms)==2*half)  # Total pair count is128.
            equations.append(len(terms))
    return equations
