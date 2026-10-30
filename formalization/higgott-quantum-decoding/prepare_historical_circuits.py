"""Serialize the aligned primary circuits for version-independent replay."""
from pathlib import Path
from circuits import bolza,planar
root=Path(__file__).parent;dest=root/'historical_circuits';dest.mkdir(exist_ok=True)
for i in range(16):
    p=10**(-3+i/10)
    for family in ['b1','q2']:
        for b in (['X','Z'] if family=='b1' else ['H','V']):
            c=bolza(root/'inputs'/'bolza',1,b,p) if family=='b1' else planar(2,b,p,noise_model='EM3_v3')
            (dest/f'{family}_{b}_{i}.stim').write_text(str(c))
