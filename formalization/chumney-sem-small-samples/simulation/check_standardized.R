#!/usr/bin/env Rscript
# Completely standardized loadings implied by the marker-metric population.
# The reflective cross-loading is 0.30 so that the standardized values are
# 0.70 and 0.21 when the unique variance of a cross-loading item is 0.29.

src <- {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg))) else getwd()
}
source(file.path(src, "population.R"))

report <- function(formative, misspecified) {
  m <- population_model(3, formative, misspecified)
  g <- population_gof(m)
  list(
    formative = formative,
    misspecified = misspecified,
    y8 = round(m$lambda_std["Y8", ], 4),
    y1 = round(m$lambda_std["Y1", "eta1"], 4),
    item_sd_y8 = round(sqrt(m$sigma["Y8", "Y8"]), 4),
    gof = round(g$gof, 4),
    gof_loading_one = round(g$gof_loading_one, 4)
  )
}

out <- list(
  reflective_correct = report(FALSE, FALSE),
  reflective_misspec = report(FALSE, TRUE),
  formative_correct = report(TRUE, FALSE),
  formative_misspec = report(TRUE, TRUE)
)
dir.create(file.path(src, "out"), showWarnings = FALSE)
dest <- file.path(src, "out", "standardized_check.json")
# jsonlite may be absent. Write a small JSON by hand for the two numbers
# the note cites, plus a human-readable dump.
con <- file(dest, "w")
writeLines(paste(capture.output(str(out, digits.d = 4)), collapse = "\n"), con)
close(con)
cat(readLines(dest), sep = "\n")
cat("\nwrote", dest, "\n")
