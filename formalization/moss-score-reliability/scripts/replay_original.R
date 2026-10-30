# Execute externally obtained original formulas; upstream source is not redistributed.
args <- commandArgs(trailingOnly=TRUE)
stopifnot(length(args)==1)
revision <- system2('git',c('-C',shQuote(args[1]),'rev-parse','HEAD'),stdout=TRUE)
stopifnot(identical(revision,'e14ad236da3ead61f6ea04d0244e9e458bd7b0cf'))
source(file.path(args[1],'R/reliabilities.R'))
root <- 'formalization/moss-score-reliability'
load(file.path(root,'inputs/bfi.rda'))
rows <- lapply(c('A','C','E','N','O'),function(trait) {
 fit <- lavaan::cfa(paste('y =~',paste(paste0(trait,1:5),collapse=' + ')),data=bfi)
 p <- lavaan::lavInspect(fit,'est')
 l <- as.vector(p$lambda)*sqrt(p$psi[1,1]); s <- sqrt(diag(p$theta))
 data.frame(trait=trait,metric=c('R','H','S','sigma'),
            replay=c(omega(l,s),omega_h(l,s),omega_std(l,s),omega_sigma(l,s)))
})
write.csv(do.call(rbind,rows),file.path(root,'outputs/original-replay.csv'),row.names=FALSE)
