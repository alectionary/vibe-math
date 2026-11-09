# Screen for fetch issue 99

- Fetch issue: https://github.com/alectionary/vibe-math/issues/99
- Manifest id: `vibe-math-99-worker-20261109`
- SHA-256: `3b5106e86960fc3516727b2eef22107f901dd77654bf709cf2cda3f855b236bb`
- Pages: 266
- PDF bytes: 14555471
- Unicode characters in the extracted text: 610456
- Question count in this screen: 6
- Bibliography row: F195, linking [formalization/higgott-quantum-decoding](../../../formalization/higgott-quantum-decoding/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The fetch hash matches the thesis hash in that replication's source evidence. Re-replication assessment: [#106](https://github.com/alectionary/vibe-math/issues/106). This note does not redo that replication. The research-source row WebsterJacobHiggott2026Distance is a 2026 distance paper, not this thesis.

## What the thesis establishes

Oscar Higgott, *Practical and Efficient Quantum Error Correction*, University College London, 2024. Record: https://discovery.ucl.ac.uk/id/eprint/10186408/.

The thesis presents sparse blossom and its PyMatching implementation, belief-matching and belief-find, schedule-induced gauge fixing for the subsystem surface code, subsystem hyperbolic codes, and hyperbolic Floquet codes, including a 16-qubit code from the Bolza surface. The general conclusions separate those constructions from the directions below.

## Open questions

Present resolution and Lean discovery were not assessed.

1. [L-F195-realtime-decoder](../../OPEN-PROBLEMS.md#l-f195-realtime-decoder). General conclusions, extracted lines 6868–6874. A real-time decoder must handle a stream of measurements, and FPGA or ASIC implementations may be needed without the accuracy loss of current hardware decoders relative to minimum-weight matching or belief-matching. Lines 2113–2115 are the same avenue for sparse blossom and fusion blossom.

2. [L-F195-belief-matching-speed](../../OPEN-PROBLEMS.md#l-f195-belief-matching-speed). General conclusions, extracted lines 6874–6877. Belief-matching is slower than sparse blossom in practice, and further optimisations may improve the speed-accuracy trade-off.

3. [L-F195-qldpc-decoder-runtime](../../OPEN-PROBLEMS.md#l-f195-qldpc-decoder-runtime). General conclusions, extracted lines 6877–6884. BP-OSD has cubic expected running time in the number of error mechanisms. The stated direction is more efficient decoders for colour codes and general quantum LDPC codes.

4. [L-F195-memory-in-computation](../../OPEN-PROBLEMS.md#l-f195-memory-in-computation). General conclusions, extracted lines 6886–6902. Dehn twists, lattice surgery, and automorphism or ZX-duality gates could be studied for the subsystem hyperbolic and hyperbolic Floquet codes, with the aim of reducing the space-time cost of an algorithm.

5. [L-F195-sigf-other-codes](../../OPEN-PROBLEMS.md#l-f195-sigf-other-codes). Chapter 4 conclusion, extracted lines 4708–4714. Schedule-induced gauge fixing could be tried on the Bacon-Shor code, the heavy-hexagon code, some compass codes, and subsystem codes whose detection events do not come in pairs.

6. [L-F195-floquet-variants](../../OPEN-PROBLEMS.md#l-f195-floquet-variants). Section 7.4, extracted lines 6793–6800. Other Floquet variants, including CSS Floquet codes on the hyperbolic and semi-hyperbolic tilings, could be compared with CSS honeycomb codes. The modular-architecture sentence at lines 6802–6807 is the same performance program, not a second target.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The thesis, software sentences | 2026-11-09 | Sparse blossom is released in PyMatching 2. The printed URL is split across lines 2029–2031 as `https://github.com/oscarhiggott/PyMatching`, with `pip install pymatching`. |
| https://github.com/oscarhiggott/PyMatching | 2026-11-09 | HTTP 200, HTML. The repository was not cloned. |
| https://pypi.org/pypi/pymatching/json | 2026-11-09 | HTTP 200, JSON. The package was not installed. |

No help issue was filed. The question count does not depend on that repository.
