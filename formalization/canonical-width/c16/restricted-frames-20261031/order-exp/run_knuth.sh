#!/bin/bash
# Knuth estimates of the unrestricted tree (gen_items.py order 1 instance) under branching orders.
cd "$(dirname "$0")/../la"
OUT=../order-exp/knuth.jsonl
for cfg in "base|" "P54|-P 0x54" "P54Q2|-P 0x54 -Q 2" "P54Q4|-P 0x54 -Q 4" "P54M1Q2|-P 0x54 -M 1 -Q 2" "P54M2Q2|-P 0x54 -M 2 -Q 2"; do
  name=${cfg%%|*}; opts=${cfg#*|}
  for seed in 1 2; do
    res=$(nice ./la_gen_p -l $opts -k 2000 -r $seed inst/g-o1.txt 2>/dev/null | tail -1)
    echo "{\"cfg\": \"$name\", \"opts\": \"$opts\", \"seed\": $seed, \"result\": $res}" >> $OUT
  done
done
echo DONE >> $OUT
