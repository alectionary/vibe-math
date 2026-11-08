# Screen for fetch issue 12

- Fetch issue: https://github.com/alectionary/vibe-math/issues/12
- Manifest id: `fetch-12-arxiv-2502-15166-verified`
- SHA-256: `6373eea0021a7aa835f3d562a431756c4f941669623e457f5d139d4dc0f2c134`
- Pages: 32
- PDF bytes: 653082
- Unicode characters in the extracted text: 125806
- Question count in this screen: 1

The manifest `question_screen.status` stays `not_screened`. This screen reads arXiv:2502.15166v2 (11 April 2026). The manifest also lists DOI `10.37236/14245`. The journal PDF was not opened, so this note does not compare the two versions. No earlier bibliography row matched this arXiv id or this title. F188 is the new row.

Checked 2026-11-02. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The text layer drops superscripts, so \(x^n\) appears there as `(xn)`. Conjecture 7.4 was read from the rendered PDF page 30 (`pdftoppm`), not from that text layer.

## What the paper establishes

Penelope Beall, Erenay Boyali, Nancy Chen, Ellen Chlachidze, Toan Trong Dao, Frederic Garvey, Mitchell Johnson, Yu Olivier Li, Nikola Kuzmanovski, Kelvin Ma, Treanungkur Mal, Rukshan Marasinghe Mudiyanselage, Quinlan Mayo, Nava Minsky-Primus, Alexandra Seceleanu, and Sriram Veerapaneni. *Constructions of Macaulay Posets and Macaulay Rings*. https://arxiv.org/abs/2502.15166.

The paper asks when wedge products, diamond products, and fiber products preserve the Macaulay property, and what that says about the corresponding rings. The introduction states four groups of results. Theorem A relates the Macaulay property for a disjoint union, a wedge product, and a diamond product of equal-rank posets with unique minimal and maximal elements, and it gives an additivity criterion when the posets are isomorphic. Theorem B characterizes the diamond product of two Clements–Lindström posets, and the wedge product of two two-dimensional ones. Theorem C characterizes the fiber product of two two-dimensional Clements–Lindström posets (heart-shaped posets). Theorem D records the ring corollaries of those poset statements. The introduction says the fiber-product analysis in this paper is the two-dimensional case.

Section 7 treats Cartesian products. Proposition 7.1 records the smallest non-Macaulay Cartesian product of Macaulay posets that the authors found by exhaustive search, and the smallest such product that comes from rings. Conjecture 7.2, cited as Kuzmanovski’s Conjecture 6.6, says that if \(S\) is a Macaulay ring, \(x\) is a new variable, and \(n>0\), then \(S \otimes_K K[x]/(x^n)\) is a Macaulay ring. The rendered page says the authors found counterexamples. Example 7.3 says that statement is false and points to Figure 7. The ideal display in the text layer is not used here. That refuted statement is not an open target.

## Open questions

[L-F188-finite-quotient-tensor](../../OPEN-PROBLEMS.md#l-f188-finite-quotient-tensor). Conjecture 7.4, PDF page 30, printed page 30, extracted lines 1797–1798. The rendered page says: if \(S\) is a Macaulay ring, \(x\) is a variable not appearing in \(S\), and \(n\) is strictly larger than the largest degree of any element of \(S\), then \(S \otimes_K K[x]/(x^n)\) is a Macaulay ring. The authors say they found no counterexample to this adjusted form of Conjecture 7.2 and propose it for future investigation. Present resolution and Lean discovery were not assessed.

PDF page 4, in the introduction, points at the same discussion with the words “cf. Theorem 7.4”. Section 7 labels the statement Conjecture 7.4. Those are the paper’s own labels for this one statement, not a second target.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The paper, software-availability sentences | 2026-11-02 | Names Macaulay2, the MacaulayPosets package, and the Bezrukov–Dissanayake poset test. No separate supplement file is named. |
| Macaulay2 as cited, https://faculty.math.illinois.edu/Macaulay2/ | 2026-11-02 | The request did not return an HTTP status. The page was not obtained. |
| https://macaulay2.com/ | 2026-11-02 | HTTP 200, HTML. This is not the URL the paper cites, and the system was not downloaded. |
| MacaulayPosets preprint, https://arxiv.org/pdf/2510.22843 | 2026-11-02 | HTTP 200, `application/pdf`, content length 345526, last-modified 9 July 2026. The PDF was not downloaded and the package was not run. |
| Poset test, http://cs2.uwsuper.edu/sb/posets/macaulay.php | 2026-11-02 | HTTP 500. The tool was not used. |

The question count does not depend on those files. No help issue was filed.
