# Bounded batch execution of the unchanged Chapter 6 model in isolated environments.
# Args: a tab-separated manifest containing q,missing,mechanism,seed,tag (no header).
# Does not infer scientific validity from process completion. Never overwrites outputs.
manifest <- read.table(commandArgs(TRUE)[1], sep='\t', header=FALSE, colClasses='character')
suppressPackageStartupMessages(library(OpenMx)); suppressPackageStartupMessages(library(MASS))
for(i in seq_len(nrow(manifest))) {
  argv <- as.character(manifest[i,]); tag <- argv[5]
  targets <- file.path('outputs',paste0(tag,c('-full.csv','-deletion.csv','-input.rds')))
  if(any(file.exists(targets))) stop(paste('Refusing to overwrite',tag))
  env <- new.env(parent=globalenv())
  env$commandArgs <- local({ a <- argv; function(trailingOnly=FALSE) a })
  started <- proc.time()[3]
  tryCatch({sys.source('simulation/openmx_replication.R',envir=env)
    cat('BATCH_COMPLETED',tag,proc.time()[3]-started,'\n')
  },error=function(e) {cat('BATCH_FAILED',tag,conditionMessage(e),'\n');quit(status=1)})
  rm(env);gc(verbose=FALSE)
}
