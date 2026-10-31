#!/usr/bin/env bash
# Reproduce every result in RESTRICTED-FRAMES-20261031.md.
# KISSAT/DRAT_TRIM default to binaries on PATH. Long runs use nice 19, one thread.
set -euo pipefail
cd "$(dirname "$0")"; mkdir -p work
KISSAT=${KISSAT:-kissat}; DRAT_TRIM=${DRAT_TRIM:-drat-trim}
python3 structure.py > /dev/null
for q in '[0,1]' '[2,3]' '[4,5]' '[6,7]'; do
  f=work/quarter-$(echo "$q" | tr -d '[],').cnf
  python3 support_cnf.py "$q" "$f"
  "$KISSAT" -q "$f" work/$(basename "$f" .cnf).drat --no-binary > "$f.out" || true
  grep '^s' "$f.out"
  if grep -q UNSAT "$f.out"; then "$DRAT_TRIM" "$f" work/$(basename "$f" .cnf).drat 2>&1 | grep "^s" || true; fi
done
python3 decode.py work/quarter-01.cnf.map.json work/quarter-01.cnf.out
python3 subgroup_cnf.py 4 work/h4.cnf
"$KISSAT" -q work/h4.cnf work/h4.drat --no-binary > work/h4.out || true; grep '^s' work/h4.out
"$DRAT_TRIM" work/h4.cnf work/h4.drat -t 20000 2>&1 | grep "^s" || true
python3 subgroup_cnf.py 2 work/h2.cnf
python3 support_cnf.py '[0,1,4,5]' work/p0.cnf
python3 support_cnf.py '[2,3,6,7]' work/p1.cnf
sha256sum work/h2.cnf work/p0.cnf work/p1.cnf work/h4.cnf
echo "Open cases (each ran to timeout; see results/): nice -n 19 $KISSAT work/h2.cnf | work/p0.cnf | work/p1.cnf"
# Global quarter consequences (step 1 of the 31 October follow-up)
python3 quarters.py > /dev/null
python3 global_quarter.py
python3 forced_exclusions.py
nice -n 19 python3 local_max.py "$KISSAT"
