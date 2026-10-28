# Rerun the remaining-miss cells with simsem 0.5-16.
# simsem::exportData calls sim(), which sets RNGkind("L'Ecuyer-CMRG"),
# set.seed(seed), and draws the rows with lavaan::simulateData.
# Each cell uses seed 13131, the seed in the commented exportData calls.
#
# Usage: Rscript env_miss.R [reps] [out_dir]
# The library path must contain simsem 0.5-16 before 0.5-17.

args <- commandArgs(trailingOnly = TRUE)
reps <- if (length(args) >= 1) as.integer(args[[1]]) else 10000L
out_dir <- if (length(args) >= 2) args[[2]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

lib16 <- "/tmp/Rlib16"
.libPaths(c(lib16, .libPaths()))
suppressPackageStartupMessages({
  library(simsem)
  library(lavaan)
  library(parallel)
})
stopifnot(identical(as.character(packageVersion("simsem")), "0.5.16"))
stopifnot(identical(as.character(packageVersion("lavaan")), "0.6.17"))

pop_of <- function(means) {
  sprintf("
eta =~ NA*i1 + 0.7*i1 + 0.7*i2 + 0.7*i3 + 0.7*i4
eta ~~ .5*eta
i1 ~~ 0.51*i1
i1 ~ 1*1
i2 ~~ 0.51*i2
i2 ~ 1*1
i3 ~~ 0.51*i3
i3 ~ 1*1
i4 ~~ 0.51*i4
i4 ~ 1*1
eta ~ c(%s)*1
", paste(means, collapse = ", "))
}

mg_model <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ c(a, b, c, d)*1
i1 + i2 + i3 + i4 ~ c(eq, eq, eq, eq)*1
c1 := -1*((a + c) / 2) + ((b + d) / 2)
c2 := -1*((a + b) / 2) + ((c + d) / 2)
c3 := -1*((b + c) / 2) + ((a + d) / 2)
"
mimic_free <- "
eta =~ 1*i1 + i2 + i3 + i4
eta ~~ NA*eta
eta ~ 1 + c1 + c2 + c3
i1 + i2 + i3 + i4 ~ eq*1
"

recast <- function(dat) {
  dat$subgroup <- factor(dat$group)
  sg <- as.integer(as.character(dat$subgroup))
  dat$c1 <- factor(ifelse(sg %in% c(1, 3), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c2 <- factor(ifelse(sg %in% c(1, 2), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat$c3 <- factor(ifelse(sg %in% c(1, 4), -1, 1), levels = c(-1, 1), labels = c("g1", "g2"))
  dat
}

one_fit <- function(dat, kind) {
  warns <- character()
  fit <- withCallingHandlers(
    tryCatch(
      if (kind == "mgcfa") {
        sem(mg_model, data = dat, group = "subgroup", missing = "ML",
            estimator = "MLR", meanstructure = TRUE,
            control = list(iter.max = 10000))
      } else {
        sem(mimic_free, data = dat, missing = "ML", estimator = "MLR",
            control = list(iter.max = 10000))
      },
      error = function(e) NULL
    ),
    warning = function(w) {
      warns <<- c(warns, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  empty <- list(header = 0L, se_ok = 0L, var_ok = 0L, gradient = 0L,
                est = rep(NA_real_, 3), se = rep(NA_real_, 3), p = rep(NA_real_, 3))
  if (is.null(fit)) {
    empty$gradient <- as.integer(any(grepl("gradient", warns, ignore.case = TRUE)))
    return(empty)
  }
  header <- isTRUE(lavInspect(fit, "converged"))
  pe <- tryCatch(parameterEstimates(fit), error = function(e) NULL)
  est <- se <- p <- rep(NA_real_, 3)
  var_ok <- FALSE
  if (!is.null(pe)) {
    v <- pe$est[pe$op == "~~" & pe$lhs == pe$rhs]
    var_ok <- length(v) > 0 && all(is.finite(v)) && all(v >= -1e-8)
    if (kind == "mgcfa") {
      for (j in 1:3) {
        hit <- pe[pe$label == c("c1", "c2", "c3")[[j]], , drop = FALSE]
        if (nrow(hit) == 1) {
          est[[j]] <- hit$est[[1]]
          se[[j]] <- hit$se[[1]]
          p[[j]] <- hit$pvalue[[1]]
        }
      }
    } else {
      hit <- pe[pe$lhs == "eta" & pe$op == "~" & pe$rhs %in% c("c1", "c2", "c3"), , drop = FALSE]
      for (name in c("c1", "c2", "c3")) {
        row <- hit[hit$rhs == name, , drop = FALSE]
        j <- match(name, c("c1", "c2", "c3"))
        if (nrow(row) == 1) {
          est[[j]] <- row$est[[1]]
          se[[j]] <- row$se[[1]]
          p[[j]] <- row$pvalue[[1]]
        }
      }
    }
  }
  se_ok <- header && all(is.finite(est)) && all(is.finite(se)) && all(is.finite(p))
  list(header = as.integer(header), se_ok = as.integer(se_ok),
       var_ok = as.integer(header && var_ok && se_ok),
       gradient = as.integer(any(grepl("gradient", warns, ignore.case = TRUE))),
       est = est, se = se, p = p)
}

run_cell <- function(cell) {
  means <- if (cell$setting == "true") c(1, 0.6, 0.8, 0.4) else c(1, 1, 1, 1)
  n_g <- switch(as.character(cell$cond),
                "1" = list(60, 60, 60, 60),
                "3" = list(108, 108, 12, 12))
  dats <- sim(nRep = cell$reps, model = pop_of(means), n = n_g,
              dataOnly = TRUE, seed = cell$seed, silent = TRUE, multicore = FALSE)
  log_path <- file.path(out_dir, "env_miss.log")
  store <- vector("list", length(dats))
  for (r in seq_along(dats)) {
    store[[r]] <- one_fit(recast(dats[[r]]), cell$kind)
    if (r %% 1000L == 0L) {
      cat(sprintf("%s %s cond %s rep %d\n", cell$kind, cell$setting, cell$cond, r),
          file = log_path, append = TRUE)
    }
  }
  header <- vapply(store, function(z) z$header, integer(1))
  se_ok <- vapply(store, function(z) z$se_ok, integer(1))
  var_ok <- vapply(store, function(z) z$var_ok, integer(1))
  gradient <- vapply(store, function(z) z$gradient, integer(1))
  rows <- lapply(1:3, function(j) {
    est_se <- vapply(store, function(z) z$est[[j]], numeric(1))
    p_se <- vapply(store, function(z) z$p[[j]], numeric(1))
    est_var <- est_se
    use_se <- se_ok == 1L
    use_var <- var_ok == 1L
    data.frame(
      kind = cell$kind, cond = cell$cond, setting = cell$setting, contrast = j,
      reps = length(dats), seed = cell$seed,
      n_header = sum(header), n_se = sum(se_ok), n_var = sum(var_ok),
      n_gradient = sum(gradient),
      mean_se_rule = mean(est_se[use_se]),
      pct_se_rule = mean(p_se[use_se] < 0.05) * 100,
      mean_var_rule = mean(est_var[use_var]),
      pct_var_rule = mean(p_se[use_var] < 0.05) * 100,
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  write.csv(out, file.path(out_dir, sprintf("env_%s_c%s_%s.csv", cell$kind, cell$cond, cell$setting)),
            row.names = FALSE)
  out
}

cells <- list(
  data.frame(kind = "mimic_free", cond = 3, setting = "true", reps = reps, seed = 13131L),
  data.frame(kind = "mimic_free", cond = 3, setting = "null", reps = reps, seed = 13131L),
  data.frame(kind = "mimic_free", cond = 1, setting = "null", reps = reps, seed = 13131L),
  data.frame(kind = "mimic_free", cond = 1, setting = "true", reps = reps, seed = 13131L),
  data.frame(kind = "mgcfa", cond = 1, setting = "null", reps = reps, seed = 13131L)
)
message("simsem ", packageVersion("simsem"), " lavaan ", packageVersion("lavaan"),
        " R ", getRversion(), " reps ", reps)
pieces <- mclapply(cells, run_cell, mc.cores = 4, mc.preschedule = FALSE)
tab <- do.call(rbind, pieces)
write.csv(tab, file.path(out_dir, "env_miss.csv"), row.names = FALSE)
session_path <- file.path(out_dir, "env_session.txt")
cat("R ", R.version.string, "\n", file = session_path)
cat("RNGkind default before sim(): Mersenne-Twister / Inversion / Rejection\n",
    file = session_path, append = TRUE)
cat("sim() sets RNGkind(\"L'Ecuyer-CMRG\") and set.seed(13131)\n",
    file = session_path, append = TRUE)
cat("simsem ", as.character(packageVersion("simsem")), "\n", file = session_path, append = TRUE)
cat("lavaan ", as.character(packageVersion("lavaan")), "\n", file = session_path, append = TRUE)
capture.output(sessionInfo(), file = session_path, append = TRUE)
message("wrote ", file.path(out_dir, "env_miss.csv"))
print(tab)
