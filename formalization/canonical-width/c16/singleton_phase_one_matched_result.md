# One matched phase-I improvement trial, orbit 15 at point 22

The single authorized trial reduced the exact restricted L1 optimum from
approximately **0.8686600975674751** to **0.8375701024527064**, a **3.57907485%**
decrease. The comparison uses the full rational values, with every prior
column and every target coordinate preserved. The new optimum uses 519
positive basis weights.

The accepted old dual supplied one maximizing physical rank-127 basis. We
enumerated its fundamental exchanges using the negated old dual and selected
64 distinct, strictly profitable exchanges whose removed/added edges form a
forest. Root's independent consumer and a separate peer replay checked all
65 new physical bases, exact profits, and direction rank 64. This is rank
within the batch, with no claim of independence modulo the old archive.
Exactly 3,225 old columns plus these 65 new columns gave the 3,290-column LP.
Only one exchange remains on the same maximizing face. Positive profit
against an old optimal dual did not imply strict decrease in advance; the
new exact primal/dual endpoint establishes the observed decrease.

The one SoPlex call took 34.12 seconds with 367,919,104 bytes maximum sampled
RSS. Verified nice 19, one thread, a 60-second internal limit, a 90-second
external limit, and a 2GB cap were enforced. The independent versioned
consumer checked the full LP, physical columns, exact primal/dual optimum,
and complete physical greedy pricing. The latter has separation gap
approximately **−6.530473308382572**. Therefore neither full singleton
membership nor a global source rank cut was established. The gate stopped
after this result; no new column or second solve followed.

The frozen bank is
`two-basis-results/singleton-phase-one-matched-batch-point22.json`.
The phase-I model and raw solve use prefix
`two-basis-results/singleton-phase-one-matched-point22`.
Its accepted endpoint receipt is `-endpoint-independent.json`, SHA
`a26881df48bdc5d805916a9e6d01631777a480c4056c312cd599a16bb3291d58`.
The `-comparison.json` artifact stores both exact objectives, their exact
difference, and the literal retained-column/target checks.

These are restricted-archive findings for the fixed point-22, orbit-15
selected-conditioned T law. The source C16 answer and cover remain unchanged.
