# Shared basis-column master: precise reuse and next gate

This is a reformulation of the already validated16-pattern two-sided basis
hull, not a new oracle or new general optimization method. Earlier gates used
the same physical support formula, Wolfe projection, and restricted phase-I
masters. The proposed difference is to retain the full shared owner-edge,
Fréchet, neighbor-capacity and complete eight-event constraints in **one**
master, with exact restricted LP and exact full-domain pricing acceptance.
No implementation or optimization was performed for this note.

For sector s and old anchor mask m, let B_sm be the finite set of all physical
128-element bases in the accepted conditional domain: selected own anchors
forced, absent own anchors deleted, selected opposite anchors assigned exactly
one distinct owner, and the remaining zero-evaluation part a basis after joint
forced contraction. Replace a conditional allocation by

    y_sm,j = Σ_(B∈B_sm) w_sm,B 1[j∈B],
    Σ_(B∈B_sm) w_sm,B = λ_m,       w_sm,B >= 0.

Keep y as linking variables if that avoids expanding every parent row. A full
source frame supplies these sector bases in its actual pattern, hence embeds
in this extended relaxation. Conversely, the equations enforce exact local
basis-hull membership for each sector-pattern allocation; they do not enforce
all unanchored mutual X/Z pairings. Empty conditional domains force λ_m=0.
Every original pattern must be retained for a source-general law.

All existing parent rows are linear in y,λ,t and the two same-sector pair
masses. Inserting the basis expression therefore gives every new column a
dual coefficient of the form

    a_sm(B) = γ_sm + Σ_(j∈B) c_sm,j.

Fréchet lower bounds, capacities, old star inequalities and complete K2,2
atoms change c and γ through their dual multipliers; they do not make pricing
nonlinear or couple the choice of one sector's basis to the other sector's
basis. The unchanged signed full-basis oracle computes each minimum exactly
by negating its weights, contracting all forced zero elements jointly,
fixing forced owners and greedily completing the required rank. Required owner
bins must contribute even when every weight is negative. Thirty-two independent
domain queries certify all column inequalities; they do not enumerate basis
pairs. Reuse the independent physical support consumer.

For a feasibility Farkas combination in the convention rows<=0, nonnegative
weights on inequalities and signed weights on equalities give column
coefficients a_sm(B). A restricted ray extends to the full master exactly when
every physical minimum a_sm(B)>=0, so nonnegative column-bound multipliers can
cancel those coefficients. If a minimum is negative, its literal physical
basis is a missing column only. The remaining finite-variable cancellation,
source-row signs and positive constant contradiction must also be exact.
Checking only currently positive-mass patterns is insufficient for an
unrestricted-law certificate. A pinned-law certificate retains its pin scope
unless the explicit pin coefficients vanish in a valid universal projection.

A useful phase-I variant starts from a certified feasible parent allocation,
uses its exact pattern masses for the initial weights, chooses one physical
basis per positive domain, and puts signed L1 errors only in the y-link equations. This
is an explicit feasible starting point, not automatically a simplex basis.
It requires a physical basis in every positive-mass domain; otherwise this
initialization must be rejected or its additional mass errors stated explicitly.
Unit error costs bound the link dual coordinates by |c_sm,j|<=1. Since each
physical basis has128 elements, |Σ_(j∈B)c_sm,j|<=128. With fixed positive row
costs σ_j the bound becomes the sum of the128 largest σ_j. A uniform rounding
error ε changes one basis score/support by at most128ε; at a fixed shared law,
the two-sector λ-weighted support error is at most256ε because Σ_m λ_m=1.
Exact rational pricing removes this approximation entirely. Do not divide by
an unfixed λ_m; law-dependent row normalization would change the formulation.

Ordinary conditional matroid-rank rows become redundant once y has this exact
basis representation. Stronger source caps, forbidden-pair restrictions,
shared matching/flow constraints and global moment rows do not become
redundant merely because they mention ranks or selected vectors.

A nonduplicate prototype would freeze one accepted full shared parent model,
its exact target and law scope, reuse archived bases only as geometry, and
prepare one shared exact phase-I restricted master with all link identities.
Before solving, replay its literal columns, source rows and an explicit
feasible phase-I start. After one bounded solve, price every required domain
exactly: accept either a complete exact full-master obstruction or exact
membership with all parent rows, otherwise record missing columns or a cap.
No automatic column loop follows. A finite projected membership remains an
auxiliary barrier; a pin-free owner cut or a necessary source-case certificate
requires the further elimination/case bridge described in the closing audit.
