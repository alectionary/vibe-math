# Compare Monte Carlo rates with Beck's printed tables.
# Two combined standard errors, then Holm on the normal two-sided p-values.
# The plug-in variance is our within-cell variance. Their replication count is 1000.
#
# Rscript score_gaps.R mc.csv out [sens|spec|ppv|npv|all] [outname.csv]

args <- commandArgs(trailingOnly = TRUE)
mc_path <- args[[1]]
out_dir <- if (length(args) >= 2) args[[2]] else dirname(mc_path)
pub_path <- file.path(out_dir, "published_classification.csv")
if (!file.exists(pub_path)) pub_path <- file.path("out", "published_classification.csv")

mc <- read.csv(mc_path, stringsAsFactors = FALSE)
if ("bias" %in% names(mc)) mc <- mc[!is.na(mc$bias), ]
pub <- read.csv(pub_path, stringsAsFactors = FALSE)
suffixes <- c(sens = "sensitivity", spec = "specificity", ppv = "ppv", npv = "npv")
which_out <- if (length(args) >= 3 && args[[3]] %in% c(names(suffixes), "all")) args[[3]] else "sens"
outs <- if (which_out == "all") names(suffixes) else which_out

# Tables A6-A23 are three statistics cycling through six biases.
bias_of <- c(A6 = "acquiescence", A7 = "acquiescence", A8 = "acquiescence",
             A9 = "disacquiescence", A10 = "disacquiescence", A11 = "disacquiescence",
             A12 = "midpoint", A13 = "midpoint", A14 = "midpoint",
             A15 = "extreme", A16 = "extreme", A17 = "extreme",
             A18 = "social", A19 = "social", A20 = "social",
             A21 = "careless", A22 = "careless", A23 = "careless",
             A24 = "grand", A25 = "grand", A26 = "grand")
level_bias <- c(Acquiescence = "acquiescence", Disacquiescence = "disacquiescence",
                Midpoint = "midpoint", Extreme = "extreme", Social = "social",
                Careless = "careless", MEAN = "all")
stat_of <- c(A6 = "G", A9 = "G", A12 = "G", A15 = "G", A18 = "G", A21 = "G", A24 = "G",
             A7 = "H", A10 = "H", A13 = "H", A16 = "H", A19 = "H", A22 = "H", A25 = "H",
             A8 = "U3", A11 = "U3", A14 = "U3", A17 = "U3", A20 = "U3", A23 = "U3", A26 = "U3")
# Readings of the cutoff tail. H is low-is-misfit. U3 and G are high-is-misfit
# in PerFit, and the method chapter also states a 5th percentile for every statistic.
readings <- list(
  G = c(upper = "G_upper", lower = "G_lower"),
  H = c(lower = "H_lower"),
  U3 = c(upper = "U3_upper", lower = "U3_lower")
)

cell_sd <- function(x) {
  x <- x[is.finite(x)]
  if (length(x) < 2) return(NA_real_)
  stats::sd(x)
}

subset_cells <- function(dat, margin, level) {
  if (margin == "aberrancy") return(dat)
  if (margin == "dimension") return(dat[dat$dim == as.integer(level), ])
  if (margin == "categories") return(dat[dat$k == as.integer(level), ])
  if (margin == "length") return(dat[dat$length == as.integer(level), ])
  stop(margin)
}

one_comparison <- function(dat, column, published, margin, level) {
  sub <- subset_cells(dat, margin, level)
  # Cell means and within-cell sds.
  key <- interaction(sub$k, sub$dim, sub$length, drop = TRUE)
  means <- tapply(sub[[column]], key, mean)
  sds <- tapply(sub[[column]], key, cell_sd)
  reps <- tapply(sub[[column]], key, length)
  ours <- mean(means)
  # Plug-in: their Monte Carlo used 1000 reps in each cell.
  vars <- sds^2 * (1 / reps + 1 / 1000)
  vars[!is.finite(vars)] <- 0
  se <- sqrt(sum(vars) / length(vars)^2)
  diff <- ours - published
  if (se == 0) {
    z <- if (abs(diff) < 1e-12) 0 else Inf
  } else {
    z <- abs(diff) / se
  }
  p <- if (is.infinite(z)) 0 else 2 * stats::pnorm(-z)
  data.frame(ours = ours, published = published, diff = diff, se = se,
             z = z, p = p, n_cells = length(means), reps = max(reps))
}

rows <- list()
for (outcome in outs) {
  for (reading_name in c("upper", "lower")) {
    for (table in names(stat_of)) {
      st <- stat_of[[table]]
      cols <- readings[[st]]
      if (!reading_name %in% names(cols)) next
      column <- paste0(cols[[reading_name]], "_", outcome)
      bias <- bias_of[[table]]
      block <- pub[pub$table == table, ]
      for (i in seq_len(nrow(block))) {
        rec <- block[i, ]
        use_bias <- if (bias == "grand") level_bias[[as.character(rec$level)]] else bias
        dat <- if (identical(use_bias, "all")) mc else mc[mc$bias == use_bias, ]
        cmp <- one_comparison(dat, column, rec[[suffixes[[outcome]]]], rec$margin, rec$level)
        rows[[length(rows) + 1L]] <- data.frame(
          outcome = outcome,
          reading = paste0(st, "_", reading_name),
          table = table, margin = rec$margin, level = rec$level,
          bias = if (bias == "grand") rec$level else bias,
          cmp, stringsAsFactors = FALSE
        )
      }
    }
  }
}
cmp <- do.call(rbind, rows)
# Holm within each reading, on the grand aberrancy rows (the headline family)
# and, separately, on the factor-margin rows.
cmp$family <- ifelse(cmp$margin == "aberrancy" & cmp$level != "MEAN", "grand",
                     ifelse(cmp$level == "MEAN", "mean_row", "margin"))
cmp$p_holm <- NA_real_
cmp$p_bonferroni <- NA_real_
for (oc in unique(cmp$outcome)) {
  for (rd in unique(cmp$reading)) {
    for (fam in c("grand", "margin")) {
      ix <- cmp$outcome == oc & cmp$reading == rd & cmp$family == fam
      if (!any(ix)) next
      cmp$p_holm[ix] <- p.adjust(cmp$p[ix], method = "holm")
      cmp$p_bonferroni[ix] <- p.adjust(cmp$p[ix], method = "bonferroni")
    }
  }
}
cmp$raw_band <- ifelse(!is.finite(cmp$z), "no match",
                       ifelse(cmp$z <= 2, "match", ifelse(cmp$z <= 3, "close", "no match")))
cmp$holm_band <- ifelse(is.na(cmp$p_holm), "",
                        ifelse(cmp$p_holm >= 0.05, "match", "no match"))
out_name <- if (length(args) >= 4) args[[4]] else if (which_out == "all") "comparison_all.csv" else "comparison.csv"
utils::write.csv(cmp, file.path(out_dir, out_name), row.names = FALSE)

grand <- cmp[cmp$family == "grand", ]
cat("Grand rates\n")
print(grand[, c("outcome", "reading", "bias", "published", "ours", "diff", "se", "raw_band", "holm_band")],
      digits = 3, row.names = FALSE)
cat("\nCounts by reading and raw band, grand family\n")
print(table(grand$reading, grand$raw_band))
cat("\nCounts by reading and Holm band, grand family\n")
print(table(grand$reading, grand$holm_band))
margins <- cmp[cmp$family == "margin", ]
cat("\nMargin rows outside the raw 2-SE band\n")
print(table(margins$reading, margins$raw_band))
cat("\nMargin rows after Holm\n")
print(table(margins$reading, margins$holm_band))
