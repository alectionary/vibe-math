# Search certificates

`la/la_gen.c -C FILE` writes the search tree as a gzip text certificate, so that the result
"no frame in this class" can be checked without trusting the search. The format, the checking
rules and the soundness argument are specified in `../../independent-check/CERT-SPEC.md`
(self-contained, written for an independent implementer). `-C` refuses the options that change
what is searched (`-f`, `-x`, `-p`, `-P`).

| File | Content |
|---|---|
| `*.inst` | instance files: pool vectors and items (copies of `../la/inst/g-*.txt`, `gp1-o4.txt`) |
| `swap.cert.gz` | class B (swap), one file |
| `half-s{0,1}of2.cert.gz` | class A (half-turn), 2 shards at depth 1 |
| `swapT8-s{0,1,2,3}of4.cert.gz` | class C (swap with half-turn), 4 shards at depth 1 |
| `test-quarter.*` | T⁴ class on the real pools, no frame (known answer) |
| `test-bad-{1,2,3}.cert.gz` | `test-quarter.cert.gz` with one record altered; must be rejected |
| `test-planted.*` | T⁴ class on the planted pools; contains a frame (`F` record) |
| `*.json` | la_gen run summaries |
| `MANIFEST.json` | SHA-256 of every file here |
| `check_cert_ref.py` | reference checker by the author of la_gen (not independent) |

Commands (from `../la`, `la_gen_c` = `cc -O3 -march=native la_gen.c -o la_gen_c`):

```
./la_gen_c -l -C ../certificates/swap.cert.gz inst/g-swap.txt
./la_gen_c -l -S 2 -s S -D 1 -C ../certificates/half-sSof2.cert.gz inst/g-o2.txt        (S = 0, 1)
./la_gen_c -l -S 4 -s S -D 1 -C ../certificates/swapT8-sSof4.cert.gz inst/g-swapT8.txt  (S = 0..3)
python3 ../certificates/check_cert_ref.py ../certificates/swap.inst ../certificates/swap.cert.gz
```
