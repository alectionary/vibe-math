# Package versions for the lavaan replay.
# Usage: Rscript session_info.R [out_dir]

.libPaths(c("/tmp/Rlib", .libPaths()))
args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[[1]] else "out"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
out <- file.path(out_dir, "session_info.txt")
sink(out)
cat("R ", R.version.string, "\n", sep = "")
cat("platform ", R.version$platform, "\n", sep = "")
cat("lavaan ", as.character(packageVersion("lavaan")), "\n", sep = "")
cat("simsem ", as.character(packageVersion("simsem")), "\n", sep = "")
for (pkg in c("OpenMx", "MplusAutomation")) {
  cat(pkg, " ",
      tryCatch(as.character(packageVersion(pkg)), error = function(e) "not installed"),
      "\n", sep = "")
}
cat("RNGkind ", paste(RNGkind(), collapse = " / "), "\n", sep = "")
cat("seeds\n")
cat("  candidate_readings.R simulated samples: 13131\n")
cat("  validate_gaps.R: RNGkind L'Ecuyer-CMRG, set.seed(13131), then one seed per cell\n")
cat("  monte_carlo.R and identification_check.R: set.seed(13131) after L'Ecuyer-CMRG\n")
cat("  dissertation names set.seed(1313) and exportData seed 13131\n")
cat("\n")
print(sessionInfo())
sink()
cat("wrote ", out, "\n", sep = "")
