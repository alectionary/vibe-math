#!/usr/bin/env Rscript
# Two-standard-error comparison of the three-indicator slice, then Holm.
# Run from this directory after replicate.R has written an rds file.

.libPaths(c("/tmp/rlib", .libPaths()))

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
src <- if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg))) else getwd()

rds_arg <- commandArgs(trailingOnly = TRUE)
rds <- if (length(rds_arg)) rds_arg[[1]] else file.path(src, "out", "reps150-full.rds")
if (!file.exists(rds)) {
  cands <- list.files(file.path(src, "out"), pattern = "\\.rds$", full.names = TRUE)
  stop("Missing ", rds, ". Found: ", paste(basename(cands), collapse = ", "))
}

obj <- readRDS(rds)
pub <- read.csv(file.path(src, "published_i3.csv"), stringsAsFactors = FALSE)

rows <- list()
for (cell in obj$cells) {
  if (cell$n_items != 3) next
  for (m in names(cell$summary)) {
    s <- cell$summary[[m]]
    rows[[length(rows) + 1]] <- data.frame(
      method = m, n = cell$n, spec = cell$spec, form = cell$form,
      n_ok = s$n_ok, n_rep = s$n,
      meas = s$meas_mean, meas_sd = s$meas_sd,
      struct = s$struct_mean, struct_sd = s$struct_sd,
      gof = s$gof_mean, gof_sd = s$gof_sd,
      bias_std = s$gof_bias_std, bias_one = s$gof_bias_one,
      stringsAsFactors = FALSE
    )
  }
}
ours <- do.call(rbind, rows)

# Convergence uses a binomial standard error of the difference of proportions.
# Other outcomes use the standard error of the difference of Monte Carlo means.
band <- function(ours_hat, ours_sd, n_ours, pub_hat, pub_sd, n_pub, binomial = FALSE) {
  if (binomial) {
    p1 <- ours_hat / n_ours
    p2 <- pub_hat / n_pub
    se <- sqrt(p1 * (1 - p1) / n_ours + p2 * (1 - p2) / n_pub)
    diff <- p1 - p2
    # Report counts in the table; the z-test is on the proportions.
    z <- if (se == 0) { if (abs(ours_hat - pub_hat) < 1e-9) 0 else Inf } else diff / se
    list(diff = ours_hat - pub_hat, se = se * n_ours, z = z)
  } else {
    if (is.na(pub_sd) || is.na(ours_sd) || n_ours < 2 || n_pub < 2) {
      return(list(diff = ours_hat - pub_hat, se = NA_real_, z = NA_real_))
    }
    se <- sqrt(ours_sd^2 / n_ours + pub_sd^2 / n_pub)
    diff <- ours_hat - pub_hat
    z <- if (se == 0) { if (abs(diff) < 1e-9) 0 else Inf } else diff / se
    list(diff = diff, se = se, z = z)
  }
}

pull <- function(table_name, value, sd, binomial = FALSE) {
  out <- list()
  sub <- pub[pub$table == table_name, ]
  for (i in seq_len(nrow(sub))) {
    r <- sub[i, ]
    hit <- ours[ours$method == r$method & ours$n == r$n &
                  ours$spec == r$spec & ours$form == r$form, ]
    if (nrow(hit) != 1) next
    b <- band(hit[[value]], if (binomial) NA else hit[[sd]],
              if (binomial) hit$n_rep else hit$n_ok,
              r$published, r$sd, r$n_pub, binomial = binomial)
    p <- if (is.na(b$z)) NA else 2 * pnorm(-abs(b$z))
    out[[length(out) + 1]] <- data.frame(
      table = table_name, method = r$method, n = r$n, spec = r$spec, form = r$form,
      published = r$published, ours = if (binomial) hit$n_ok else hit[[value]],
      diff = b$diff, se = b$se, z = b$z, p = p,
      stringsAsFactors = FALSE
    )
  }
  do.call(rbind, out)
}

pieces <- list(
  pull("convergence", "n_ok", "meas_sd", binomial = TRUE),
  pull("measurement", "meas", "meas_sd"),
  pull("structural", "struct", "struct_sd"),
  pull("gof", "bias_one", "gof_sd"),
  pull("gof", "bias_std", "gof_sd")
)
# The two GoF readings share the published column. Tag them.
pieces[[4]]$table <- "gof_minus_0.600"
pieces[[5]]$table <- "gof_minus_population"
cmp <- do.call(rbind, pieces)

cmp$holm <- NA_real_
cmp$reject_holm <- FALSE
for (tb in unique(cmp$table)) {
  ix <- which(cmp$table == tb & !is.na(cmp$p))
  if (!length(ix)) next
  adj <- p.adjust(cmp$p[ix], method = "holm")
  cmp$holm[ix] <- adj
  cmp$reject_holm[ix] <- adj < 0.05
}

cmp$verdict <- ifelse(is.na(cmp$z), "unchecked",
                      ifelse(!cmp$reject_holm & abs(cmp$z) <= 2, "match",
                             ifelse(abs(cmp$z) <= 3, "close", "no match")))

out_dir <- file.path(src, "out")
dir.create(out_dir, showWarnings = FALSE)
write.csv(cmp, file.path(out_dir, "comparison_i3.csv"), row.names = FALSE)
write.csv(ours, file.path(out_dir, "ours_i3.csv"), row.names = FALSE)

# Also dump every cell in the rds, for the i = 5 and i = 7 checks.
all_rows <- list()
for (cell in obj$cells) {
  for (m in names(cell$summary)) {
    s <- cell$summary[[m]]
    all_rows[[length(all_rows) + 1]] <- data.frame(
      method = m, n = cell$n, n_items = cell$n_items,
      spec = cell$spec, form = cell$form,
      n_ok = s$n_ok,
      meas = round(s$meas_mean, 3), meas_sd = round(s$meas_sd, 3),
      struct = round(s$struct_mean, 3), struct_sd = round(s$struct_sd, 3),
      gof_bias_one = round(s$gof_bias_one, 3),
      gof_bias_std = round(s$gof_bias_std, 3),
      stringsAsFactors = FALSE
    )
  }
}
write.csv(do.call(rbind, all_rows), file.path(out_dir, "ours_all.csv"), row.names = FALSE)

cat("rds", rds, "\n")
cat("rows", nrow(cmp), "\n")
print(table(cmp$table, cmp$verdict))
# Headline ordering at n = 1000, measurement percent bias.
cat("\nMeasurement percent bias at n = 1000, i = 3\n")
sub <- ours[ours$n == 1000, c("method", "spec", "form", "meas")]
print(sub[order(sub$spec, sub$form, sub$method), ])
