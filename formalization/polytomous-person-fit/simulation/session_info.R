# Write package versions. Rscript session_info.R out
args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args)) args[[1]] else "out"
dir.create(out, showWarnings = FALSE, recursive = TRUE)
.libPaths(c("/tmp/beck/Rlib", .libPaths()))
sink(file.path(out, "session_info.txt"))
print(sessionInfo())
for (p in c("mirt", "mokken", "PerFit", "MASS")) {
  cat(p, as.character(packageVersion(p)), "\n")
}
sink()
cat("wrote", file.path(out, "session_info.txt"), "\n")
