# Coverage of the small-flat geometry bank

Fix a pattern and jointly contract its forced zero elements. Work in the
resulting binary linear matroid on free zero-pool indices. The bank is
independent of the target point and pattern probabilities.

First remove loops, whose rank-zero inequality forces zero allocation.
Aggregate each nonzero parallel class. Its allocation is at most one
conditional unit by a rank-one row, or by the coordinate box when the
class contains one index. It remains to consider simple binary flats.

A rank-two binary space has three nonzero points. If the ground set has
all three, the bank includes their full line closure, with every original
index in its parallel classes. If only two points occur, the rank-two
inequality follows from their two rank-one inequalities. Thus every
rank-two subset inequality is covered, by first passing to its closure.

A simple rank-three restriction lies in the seven nonzero points of
`F2^3`. Every five-point subset contains a four-circuit: its complementary
pair extends to a line, and the four-point complement of that line is
contained in the five-point subset and sums to zero. Therefore a
rank-three restriction with no four-circuit has at most four points.
A rank-three four-point set has a unique dependency. It is either the
four-circuit or a triangle with one coloop. Three points of rank three
are independent. Consequently a restriction without a four-circuit is
a direct sum of lower-rank pieces, whose inequalities have already been
included or follow from boxes.

Every four-circuit has a partition into two pairs with equal XOR.
Enumerating all pair-XOR collisions therefore finds every four-circuit.
Any three of its four points span its full rank-three flat. The bank
includes the intersection of that span with the entire quotient ground
set, including all parallel indices. Hence every remaining rank-three
subset inequality follows from one listed closure row and nonnegativity.

This proves coverage of all contracted rank-zero through rank-three
inequalities. It does not cover arbitrary higher-rank sets and does not
prove matroid base-polytope membership. The producer also exhausts the
128 subsets of the seven-point rank-three binary space as a finite
control; independent source replay must check the actual quotient
closures, row completeness, and physical ranks before using the bank.

For the literal anchors `X=[80,512]`, `Z=[186,433]`, the Z-sector bank has
16 pattern domains and 2,532 rows: four nontrivial parallel-class rows,
854 line rows, and 1,674 four-circuit closure rows. No quotient loops
occur. Rows with zero pattern probability are still valid and retained.
