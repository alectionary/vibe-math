#!/usr/bin/env Rscript
# Exact regeneration of Chen (2021) simulated datasets from her printed, seeded
# Appendix A code, with her Appendix B point estimates.
#
# Chen's Appendix A seeds the design table (set.seed(18374788)) and the data
# (set.seed(95409)), then writes every dataset in sim_block order. Each dataset
# draws exactly 7 * nobs normals and nothing else between datasets touches the
# RNG, so a dataset that is not kept can be skipped by drawing the same number of
# normals. Kept datasets are built with her own gendata() and fitted with her own
# lm() calls, so they are her datasets and her point estimates.
#
# Usage:
#   Rscript chen_exact.R [KEEP_REPS] [OUTDIR] [MODE]
#     KEEP_REPS  replications kept per condition (default 50; Chen ran 1000)
#     OUTDIR     output folder (default "out")
#     MODE       rows (default): estimates.csv, one row per kept dataset;
#                summary: condition_summary.csv, per condition the mean and SD of
#                every estimate over the kept replications (use with KEEP_REPS 1000)
#
# Outputs (OUTDIR):
#   session.txt            R and package versions, RNG kind
#   data_iter_sha256.txt   hash of the design table, as Chen's fwrite would write it
#   literal_check.txt      kept-mode data equal Chen's literal group_walk/pmap_dfr
#                          output for the first sim_block (must say TRUE)
#   estimates.csv          one row per kept dataset: design, ids, and per cutoff
#                          a, b, c', h, i0M, PNIE, TNIE, PNDE, TNDE, MINT
#   first_dataset.csv      the first kept dataset in full, plus its sha256
#
# No bootstrap: Chen's Appendix B bootstrap sets no seed, so its intervals cannot
# be reproduced exactly; point estimates can.

args <- commandArgs(trailingOnly = TRUE)
keep_reps <- if (length(args) >= 1) as.integer(args[1]) else 50L
outdir <- if (length(args) >= 2) args[2] else "out"
# "rows" writes one row per kept dataset (estimates.csv); "summary" instead accumulates,
# per condition, the mean and SD of every estimate over the kept replications
# (condition_summary.csv), which stays small when all 1,000 replications are kept.
mode <- if (length(args) >= 3) args[3] else "rows"
stopifnot(mode %in% c("rows", "summary"))
nrep <- "1000"  # Chen passes nrep on the command line; it reaches 1:nrep as a string
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(purrr)
  library(data.table); library(stringi); library(digest)
})

# --- Chen Appendix A: gendata, verbatim except straight quotes -----------------
gendata <- function(id, nobs, effa, effb, effcpr, effh, vare1,
                    vare2, ...){
  meddata <- matrix(1, ncol = 16, nrow = nobs,
                    dimnames = list(NULL, c("x", "r1", "t1", "m1",
                                            "y1", "tm1",
                                            "r2", "t2", "m2", "y2",
                                            "tm2",
                                            "r3", "t3", "m3", "y3",
                                            "tm3")))
  meddata[, "x"] <- rnorm(nobs)
  cut1 <- quantile(meddata[, "x"], prob = .25)
  meddata[, "t1"] <- ifelse(meddata[,"x"] < cut1, 0, 1)
  meddata[, "r1"] <- meddata[,"x"] - cut1
  meddata[, "m1"] <- effa*meddata[, "t1"] + rnorm(nobs, sd = vare1)
  meddata[, "tm1"] <- meddata[, "t1"]*meddata[, "m1"]
  meddata[, "y1"] <- effcpr*meddata[, "t1"] + effb*meddata[, "m1"] +
    effh*meddata[, "tm1"] + rnorm(nobs, sd = vare2)
  cut2 <- quantile(meddata[, "x"], prob = .50)
  meddata[, "t2"] <- ifelse(meddata[,"x"] < cut2, 0, 1)
  meddata[, "r2"] <- meddata[,"x"] - cut2
  meddata[, "m2"] <- effa*meddata[, "t2"] + rnorm(nobs, sd = vare1)
  meddata[, "tm2"] <- meddata[, "t2"]*meddata[, "m2"]
  meddata[, "y2"] <- effcpr*meddata[, "t2"] + effb*meddata[, "m2"] +
    effh*meddata[, "tm2"] + rnorm(nobs, sd = vare2)
  cut3 <- quantile(meddata[, "x"], prob = .75)
  meddata[, "t3"] <- ifelse(meddata[,"x"] < cut3, 0, 1)
  meddata[, "r3"] <- meddata[,"x"] - cut3
  meddata[, "m3"] <- effa*meddata[, "t3"] + rnorm(nobs, sd = vare1)
  meddata[, "tm3"] <- meddata[, "t3"]*meddata[, "m3"]
  meddata[, "y3"] <- effcpr*meddata[, "t3"] + effb*meddata[, "m3"] +
    effh*meddata[, "tm3"] + rnorm(nobs, sd = vare2)
  return(data.frame(
    id = id,
    meddata,
    stringsAsFactors = FALSE))
}

# --- Chen Appendix B point estimates, verbatim lm() calls -----------------------
estimates <- function(data){
  out <- list()
  for (k in 1:3) {
    mf <- lm(as.formula(sprintf("m%d ~ t%d + r%d", k, k, k)), data = data)
    yf <- lm(as.formula(sprintf("y%d ~ t%d + r%d + m%d + tm%d", k, k, k, k, k)), data = data)
    i0m <- unname(mf$coefficients[1]); a <- unname(mf$coefficients[2])
    cpr <- unname(yf$coefficients[2]); b <- unname(yf$coefficients[4]); h <- unname(yf$coefficients[5])
    out[[sprintf("a%d", k)]] <- a; out[[sprintf("b%d", k)]] <- b
    out[[sprintf("cpr%d", k)]] <- cpr; out[[sprintf("h%d", k)]] <- h; out[[sprintf("i0m%d", k)]] <- i0m
    out[[sprintf("PNIE%d", k)]] <- a * b
    out[[sprintf("TNIE%d", k)]] <- a * b + a * h
    out[[sprintf("PNDE%d", k)]] <- cpr + h * i0m
    out[[sprintf("TNDE%d", k)]] <- cpr + h * i0m + a * h
    out[[sprintf("MINT%d", k)]] <- a * h
  }
  as.data.frame(out)
}

# --- design table, exactly as Appendix A ---------------------------------------
set.seed(18374788)
factorcombo <- crossing(
  nobs = c(500, 1000, 2500, 5000, 10000),
  effa = c(0, 0.14, 0.39, 0.59),
  effb = c(0, 0.14, 0.39, 0.59),
  effcpr = c(0, 0.14, 0.39, 0.59),
  effh = c(0, 0.05, 0.15, 0.34),
  reps = 1:nrep
) %>%
  mutate(
    id = stri_rand_strings(n(), length = 10),
    sim_block = sample(0:999, size = n(), replace = TRUE),
    vare1 = sqrt(1 - effa^2),
    vare2 = sqrt(1 - effb^2)
  )
tmp <- tempfile(fileext = ".csv")
fwrite(factorcombo, tmp, sep = ",")
writeLines(c(digest(file = tmp, algo = "sha256"),
             sprintf("rows=%d", nrow(factorcombo)),
             paste(head(factorcombo$id, 5), collapse = " ")),
           file.path(outdir, "data_iter_sha256.txt"))

writeLines(c(capture.output(sessionInfo()), "", paste("RNGkind:", paste(RNGkind(), collapse = ", "))),
           file.path(outdir, "session.txt"))

# --- check: skipping by drawing 7*nobs normals matches the literal pipeline ----
blocks <- sort(unique(factorcombo$sim_block))
first <- factorcombo %>% filter(sim_block == blocks[1])
set.seed(95409)
literal <- NULL
factorcombo %>% filter(sim_block == blocks[1]) %>% group_by(sim_block) %>%
  group_walk(~ { literal <<- pmap_dfr(.x, gendata) })
seed_after_literal <- .Random.seed
set.seed(95409)
rebuilt <- vector("list", nrow(first))
for (i in seq_len(nrow(first))) {
  row <- first[i, ]
  if (i %% 2 == 1) {
    rebuilt[[i]] <- do.call(gendata, as.list(row %>% select(-sim_block)))
  } else {
    invisible(rnorm(7 * row$nobs))      # skip; leave rebuilt[[i]] empty (assigning NULL would delete it)
  }
}
seed_after_skip <- .Random.seed
# compare values only: row names differ between the stacked literal output and one dataset
diffs <- vapply(seq(1, nrow(first), by = 2), function(i) {
  rows <- literal$id == first$id[i]
  a <- unname(as.matrix(literal[rows, -1])); b <- unname(as.matrix(rebuilt[[i]][, -1]))
  if (!identical(dim(a), dim(b))) return(Inf)
  max(abs(a - b))
}, numeric(1))
same_kept <- all(diffs == 0)
writeLines(c(sprintf("first sim_block = %d, datasets = %d, compared = %d", blocks[1], nrow(first), length(diffs)),
             sprintf("rows in literal output = %d, expected = %d", nrow(literal), sum(first$nobs)),
             sprintf("largest absolute difference over kept datasets = %s", format(max(diffs))),
             sprintf("kept datasets identical to literal pipeline: %s", same_kept),
             sprintf("RNG state identical after the block: %s", identical(seed_after_literal, seed_after_skip))),
           file.path(outdir, "literal_check.txt"))
stopifnot(nrow(literal) == sum(first$nobs), same_kept, identical(seed_after_literal, seed_after_skip))

# --- full pass in Chen's order --------------------------------------------------
set.seed(95409)
ordered <- factorcombo %>% arrange(sim_block)   # group_walk visits groups in sim_block order;
# arrange() is stable, so rows keep their crossing() order within a block, as in group_walk
res <- if (mode == "rows") vector("list", 1280L * keep_reps) else NULL
k <- 0L
cond_keys <- unique(paste(ordered$nobs, ordered$effa, ordered$effb, ordered$effcpr, ordered$effh))
cond_id <- match(paste(ordered$nobs, ordered$effa, ordered$effb, ordered$effcpr, ordered$effh), cond_keys)
acc_sum <- NULL; acc_sq <- NULL; acc_n <- integer(length(cond_keys))
t0 <- Sys.time()
O <- as.list(ordered)   # plain vectors: indexing a tibble row by row is slow at 1.28M rows
N <- length(O$id)
for (i in seq_len(N)) {
  if (O$reps[i] <= keep_reps) {
    d <- gendata(O$id[i], O$nobs[i], O$effa[i], O$effb[i], O$effcpr[i], O$effh[i], O$vare1[i], O$vare2[i])
    if (k == 0L) {
      fwrite(d, file.path(outdir, "first_dataset.csv"))
      writeLines(digest(file = file.path(outdir, "first_dataset.csv"), algo = "sha256"),
                 file.path(outdir, "first_dataset_sha256.txt"))
    }
    k <- k + 1L
    est <- estimates(d)
    if (mode == "rows") {
      res[[k]] <- cbind(data.frame(id = O$id[i], sim_block = O$sim_block[i], nobs = O$nobs[i],
                                   effa = O$effa[i], effb = O$effb[i], effcpr = O$effcpr[i],
                                   effh = O$effh[i], reps = O$reps[i], stringsAsFactors = FALSE),
                        est)
    } else {
      v <- unlist(est)
      if (is.null(acc_sum)) {
        acc_sum <- matrix(0, length(cond_keys), length(v), dimnames = list(NULL, names(v)))
        acc_sq <- acc_sum
      }
      j <- cond_id[i]
      acc_sum[j, ] <- acc_sum[j, ] + v
      acc_sq[j, ] <- acc_sq[j, ] + v * v
      acc_n[j] <- acc_n[j] + 1L
    }
  } else {
    invisible(rnorm(7 * O$nobs[i]))
  }
  if (i %% 100000 == 0) message(sprintf("%d / %d datasets, %.1f min", i, N,
                                         as.numeric(difftime(Sys.time(), t0, units = "mins"))))
}
if (mode == "rows") {
  fwrite(rbindlist(res[seq_len(k)]), file.path(outdir, "estimates.csv"))
} else {
  key <- do.call(rbind, strsplit(cond_keys, " "))
  m <- acc_sum / acc_n
  sdv <- sqrt(pmax(acc_sq - acc_n * m^2, 0) / pmax(acc_n - 1, 1))
  colnames(m) <- paste0("mean_", colnames(m)); colnames(sdv) <- paste0("sd_", colnames(acc_sum))
  out <- data.frame(nobs = as.numeric(key[, 1]), effa = as.numeric(key[, 2]), effb = as.numeric(key[, 3]),
                    effcpr = as.numeric(key[, 4]), effh = as.numeric(key[, 5]), reps = acc_n, m, sdv)
  fwrite(out, file.path(outdir, "condition_summary.csv"))
}
message(sprintf("done: %d kept datasets in %.1f min", k, as.numeric(difftime(Sys.time(), t0, units = "mins"))))
