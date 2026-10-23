# Bounded continuation of P34's decoding-properties program

The originating source is Freij-Hollanti, Morris and Sapokaite, arXiv:2606.11987v1, Section 5 final paragraph and Conclusion. The first asks about consequences of the girth conditions for decoding-related properties. The conclusion specifically points to translating row/column constraints for low-weight logical operators into Tanner-graph properties. This is a broad program; the current girth theorem does not complete it.

## Fixed scope

Use exactly the four existing 252-qubit, ten-logical-qubit, lift-14 benchmark codes in benchmark-confirmation.json, both Pauli sectors. Keep the matrices, decoder and channel unchanged. Generate no new candidate codes or noise samples.

Certify absence of binary kernel words of weights one through five by nonzero/distinct columns, distinct unordered-pair syndromes and odd column degree. Enumerate every unordered triple of columns, bucket by exact binary syndrome, and join equal-syndrome disjoint triples. Every weight-six kernel support has exactly ten unordered 3+3 partitions. Enumerate all such supports and distinguish stabilizers from nontrivial logical operators by exact full row-span membership. Validate witnesses with independent binary elimination.

If a nontrivial logical of weight six exists, this gives exact tested-sector distance six. If none exists, absence of odd-weight kernel words strengthens the tested-sector lower bound to eight. Do not call this an exact distance of eight without a matching witness. The census is a finite computation, not a Lean proof or a general distance formula.

## Stop condition

Report both sectors for all four codes, retain unsuccessful attempts and all low-weight logical witnesses, and relate the findings to the paper's absorbing-support experiment and the source's low-weight-logical direction. If possible derive a precise obstruction or design implication from the census. Stop at weight six: do not enumerate all quadruples, introduce a decoder variation, or launch another optimization population. Separate this continuation from the P11 dyadic trajectory result.
