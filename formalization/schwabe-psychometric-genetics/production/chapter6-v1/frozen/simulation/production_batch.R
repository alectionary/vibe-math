# Worker execution only. Python freezes code, allocates output paths and verifies receipts.
args <- commandArgs(TRUE)
manifest <- read.table(args[1],sep='\t',header=FALSE,colClasses='character',quote='',comment.char='')
suppressPackageStartupMessages(library(OpenMx)); suppressPackageStartupMessages(library(MASS))
mxOption(NULL,'Number of Threads',1)
for(i in seq_len(nrow(manifest))) {
 argv <- as.character(manifest[i,1:7]); out <- as.character(manifest[i,8]); tag <- argv[5]
 if(file.exists(file.path(out,'completed.csv'))) stop('Refusing to replace completed job')
 dir.create(out,recursive=TRUE,showWarnings=FALSE)
 Sys.setenv(OUTPUT_DIR=out)
 env <- new.env(parent=globalenv()); env$commandArgs <- local({a<-argv;function(trailingOnly=FALSE)a})
 write.csv(data.frame(tag=tag),file.path(out,'started.csv'),row.names=FALSE)
 start <- proc.time()[3]
 failed <- tryCatch({sys.source('simulation/openmx_production.R',envir=env);''},error=function(e) conditionMessage(e))
 write.csv(data.frame(tag=tag,elapsed_seconds=proc.time()[3]-start,error=failed),file.path(out,'completed.csv'),row.names=FALSE)
 cat('JOB_COMPLETED',tag,proc.time()[3]-start,if(nchar(failed))'ERROR'else'RETURNED','\n');flush.console()
 rm(env);gc(verbose=FALSE)
}
