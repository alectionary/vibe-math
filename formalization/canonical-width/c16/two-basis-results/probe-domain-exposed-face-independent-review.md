# A selected probe domain as an exposed matroid face

Reasoning-only review. No computation, import, rank query or solver was run.

The proposed lemma is correct under these explicit hypotheses:

1. The original domain is nonempty. Its auxiliary matroid M0 has rank R and
   every basis is a full physical Z basis of the working ambient space.
2. Evaluation against such a full basis distinguishes the working X vectors.
   Equivalently, the pairing is nondegenerate in the relevant dual quotient.
3. The probe defines a nonzero functional and is distinct as a functional
   from every selected old X anchor. Distinct pool indices alone would not
   suffice if the pool admitted duplicate vectors.
4. Adding the probe leaves the same-sector forced/deleted anchor statuses
   unchanged. An unanchored probe avoids a conflict with an already absent
   X anchor in the fixed pattern.

Let A be the physical pairing-one neighbors of the probe and H its complement
in the indexed pool. Every M0 basis meets A: otherwise its full physical span
would be annihilated by a nonzero probe functional.

Suppose an M0 basis meets A at exactly one element j. The probe's evaluation
row on this basis is the unit row at j. If j also owned a selected old X anchor,
that anchor would have the same evaluation row. Nondegeneracy and the full
physical basis would imply equality of the two X functionals, contrary to the
hypothesis. Hence j is a new, distinct owner; all old owners lie in H. The basis
therefore satisfies exactly the augmented-domain restrictions. Conversely,
every augmented-domain basis has exactly one probe owner and hence one A element.

Thus the augmented bases are precisely the M0 bases with |B intersect A|=1.
For any matroid, the minimum A count in a basis is R-r0(H). Here this minimum
is at least one, so

    M1 is nonempty  iff  r0(H)=R-1.

If r0(H)<R-1, M1 is empty. The minimum-A face of B(M0) still exists in that
case, but its bases have more than one A element; it must not be identified
with the augmented domain. The equality r0(H)=R-1 is a feasible-domain
conclusion, not an unconditional property of every probe.

## Face rank and a simpler oracle

For a feasible probe, the minimum-A face is the base polytope of

    (M0 restricted to H) direct-sum (M0 contracted by H, on A).

A minimum-A basis consists of a basis of H and a basis of the contraction,
and any such union is an M0 basis. Consequently

    r1(S) = r0(S intersect H)
            + r0(H union (S intersect A)) - r0(H).

Since the contraction has rank one, define G=A minus closure_M0(H). Then

    r1(S) = r0(S intersect H) + 1_{S intersects G}.

All A elements in that closure are loops of the selected face matroid.
After G is justified, a selected-domain rank query reduces to one original
rank query and a set-intersection test. This is a representation identity,
not a runtime estimate or an implemented optimization.

## Forced-element cases

- A forced old unit owner in A would share the probe's unique owner. Under
  the distinct-functional hypothesis this cannot occur in a one-A basis;
  the augmented domain is empty and the original minimum A count exceeds one.
- A forced old zero-signature element in A can become the unique forced probe
  owner. If the augmented domain is feasible, other A elements become loops
  in the contraction unless they are that owner. Two forced A elements make
  the augmented domain empty immediately.
- Forced H elements retain their appropriate compulsory roles. Deleted own
  anchors and original loops remain loops. These facts use the effective
  singleton owner-bin convention of the original domain matroid.
- If the probe is a nontrivial sum of selected old anchors, its evaluation
  row has as many ones as the number of summands, at distinct old owners.
  The empty-domain criterion therefore also detects this dependence.

The nonzero and distinct-functional hypotheses are essential. A zero probe
has minimum A count zero, while a duplicate old anchor has minimum A count
one without a distinct new owner. Neither satisfies the proposed equivalence.

No cross-pattern prescribed-T, full owner-lift, full-frame or source-exclusion
claim follows from this local face characterization.
