# Kupzyk re-replication: research status

The new run uses the November 9 replication-paper workflow on a branch based on
the current master. The prior report and outputs are historical and remain in
place. The new results and source transcriptions have separate paths.

The whole-dissertation plan was committed before the first simulation. The
university's archived 143-page source is verified; see
[the acquisition record](../provenance/source-acquisition.json). The source PDF
is intentionally untracked. Source figures and tables are indexed and transcribed
under [source-values](../source-values). Figures 6–11 use PDF vector paths,
regardless of the inventory helper's conservative classification of pages with
few paths; Figure 4 uses raster positions. Three exemplary markers on Figures 7
and 8 overlap filled marks too closely to read independently.

The established-engine pilot took a mean 0.452 seconds per fit across 53 cells
after excluding package startup. At that rate the main 1,382,400-fit grid would
take about 174 CPU hours on this host. A profiled restricted likelihood reduces
the Gaussian model to two coefficients per arm; it estimates the same covariance
components under the same REML objective. On one fresh dataset per cell, its
largest absolute difference from lme4 was 2.15e-7 for the treatment-by-time
coefficient and 1.23e-6 for its standard error. An independent dense generator
supplied half the validation datasets; nlme supplied a third fit in 18 cells.
See [the paired validation](../results/engine-comparison.csv). This checks
the implemented objective and its numerical solution; it does not verify SAS
random streams or its handling of degrees of freedom.

The resumable full run schedules 1,382,400 main draws, a separate 50,000-draw
baseline, and 25,600 null draws in each of the two Appendix D settings for the
J−2 and between–within tests. The null count is a precision target; the
dissertation does not clearly identify the original null-run denominator.
SAS containment, Satterthwaite and Kenward–Roger are separate checks. Batch
counts and convergence come from checkpoint files, not the scheduling totals.
No new empirical result is considered final until all its intended batches
have been checked.

## Saved progress

The committed interim snapshot preserves counts by arm and the repeat of the
fixed-covariance calculations across all 54 final and 54 initial settings.
It also retains the original exploratory denominator-rule pilot. The full
empirical analysis, independent fresh-mask threshold sweep, and compact
Kenward–Roger validation were still running at the time of this checkpoint.
The prior manuscript has not been replaced. The replication plan remains
open and the new paper has not entered independent editorial review.

To resume without the original temporary run directory, extract
`results/interim/checkpoints.tar.gz` into the new run directory. Point the main
runner to its `grid` subdirectory and the Appendix D runner to
`appendix-d-grid`. Their file names and seeds are stable. The snapshot's
scientific comparisons use its own counts; the archive can contain additional
checkpoints that completed while it was being preserved.
