"""For every monomial orbit pair (X orbit a, Z orbit b): does any frame contain the 16 pairs of
(a, b)? By the splitting lemma (THEORY-NOTES-2, Lemma A) the rest would be a frame of the complement
pair (U2^perp, U^perp) from pool vectors; check rank first, then search."""
import json, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from subspace_frames import local_and_complement
mono = json.load(open('mono_pairs.json')); res = []
for a, b, h in mono:
    r = local_and_complement([a], [b], f'm{a}_{b}'); res.append(r)
    print(a, b, r['local'], r.get('complement_ranks'), r.get('complement'), r.get('complement_knuth'), flush=True)
json.dump(res, open('mono_split.json', 'w'), indent=1)
