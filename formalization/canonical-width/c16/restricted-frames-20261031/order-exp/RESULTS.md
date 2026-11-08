# Branching-order experiment for the unrestricted search (2026-11-03)

**Question.** The theory push (`../theory/THEORY-NOTES.md`) found that local frames fail at blocks
2, 4 and 6 (a shift-by-3 "phase twist"). Does branching first on residual entries in those blocks
shrink the unrestricted exact search by orders of magnitude?

**Answer: no** [heuristic: Knuth estimates]. Every block preference tried gives a tree at least as
large as the default rule (branch on the residual entry with the fewest live candidates). Preferring
blocks 2, 4, 6 makes it 2–5 times larger; preferring blocks 0, 1, 3, 5, 7 is within noise of the
default. The fewest-candidates rule is already as good as block ordering gets.

## Method

- Instance: `la/inst/g-o1.txt` (`gen_items.py order 1`: all 99,808 single pairs).
- Search: `la/la_gen.c` with `-l`, new option `-P MASK [-M mode] [-Q F]`: among entries with
  `R[c][k] = 1`, prefer those whose row block (or column block; mode 0 either, 1 both, 2 row
  only) is in `MASK`, unless the preferred entry has more than `F` times the fewest candidates.
  Any entry with `R = 1` is a valid branch point, so the set of frames found is unchanged; without
  `-P` the program behaves exactly as before.
- Validation of `-P`: on the T⁴ instance (`inst/g-o4.txt`) every variant is COMPLETE with no frame
  (9,666–16,608 nodes against 15,088 by default); on the planted swap instance (`inst/gp1-swap.txt`)
  every variant finds the planted frame.
- Estimates: `la_gen -k 2000 -r SEED` (2,000 Knuth probes), seeds 1 and 2; driver `run_knuth.sh`,
  raw output `knuth.jsonl`.

## Results (estimated tree size, nodes)

| Configuration | Options | Seed 1 | Seed 2 |
|---|---|---|---|
| default | | 1.37e12 | 1.66e12 |
| prefer 2,4,6 (row or column) | `-P 0x54` | 2.86e12 | 3.19e12 |
| prefer 2,4,6, within 2× of min | `-P 0x54 -Q 2` | 2.88e12 | 2.71e12 |
| prefer 2,4,6, within 4× of min | `-P 0x54 -Q 4` | 2.93e12 | 3.17e12 |
| prefer 2,4,6 (row and column), within 2× | `-P 0x54 -M 1 -Q 2` | 7.82e12 | 5.45e12 |
| prefer 2,4,6 (row only), within 2× | `-P 0x54 -M 2 -Q 2` | 5.15e12 | 5.99e12 |
| prefer 0,1,3,5,7 | `-P 0xAB` | 2.94e12 | 1.44e12 |
| prefer 0,1,3,5,7, within 2× | `-P 0xAB -Q 2` | 2.87e12 | 1.33e12 |

The estimates are heavy-tailed (single probes up to 3e15), so differences below about 2× are noise.
The unrestricted search stays at roughly 1e12 nodes, i.e. 1e4–1e6 core-hours.
