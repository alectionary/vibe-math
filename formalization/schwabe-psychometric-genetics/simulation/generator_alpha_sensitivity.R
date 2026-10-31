# Regenerate fixed response datasets only; no posterior fitting. Raw/standardized alpha audit.
args<-commandArgs(TRUE);stopifnot(length(args)==1,!dir.exists(args[1]));out<-args[1];dir.create(out,recursive=TRUE)
sha<-function(p)strsplit(system2('sha256sum',shQuote(p),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
stopifnot(sha('simulation/generator_summary_check.R')=='3339ca63639d783830370e001032f13dea62bf0df0f6314bf469f40ab5499124')
stopifnot(sha('production/generator-summary-v1/summaries.csv')=='909211a9b24da1b0fff5a98d49a604e84b9e313fe9d9d405da90146ca084ada9')
expr<-parse('simulation/generator_summary_check.R');e<-new.env(parent=globalenv())
for(z in expr)if(is.call(z)&&identical(z[[1]],as.name('<-'))&&is.symbol(z[[2]])&&as.character(z[[2]])%in%c('grid','generate','alpha','atomic_csv'))eval(z,e)
grid<-e$grid;original<-read.csv('production/generator-summary-v1/summaries.csv');stopifnot(nrow(original)==2650,nrow(grid)==19,sum(grid$replicates)==2650)
rows<-list();t0<-proc.time()[3]
for(g in seq_len(nrow(grid))){d<-grid[g,]
 for(rep in seq_len(d$replicates)){
  seed<-910000L+1000L*g+rep;s<-e$generate(d$ch,d$N,d$J,d$effect,d$difficulty,seed);y<-matrix(s$y,2*d$N,d$J)
  V<-cov(y);v<-diag(V);raw<-d$J/(d$J-1)*(1-sum(v)/sum(V));old<-original[original$seed==seed,];stopifnot(nrow(old)==1,old$condition==g,old$replicate==rep,abs(raw-old$alpha_all)<1e-12)
  constant<-sum(v<=0);standardized<-NA_real_
  if(constant==0){C<-V/sqrt(outer(v,v));rbar<-(sum(C)-d$J)/(d$J*(d$J-1));standardized<-d$J*rbar/(1+(d$J-1)*rbar);alternate<-d$J/(d$J-1)*(1-d$J/sum(C));stopifnot(abs(standardized-alternate)<1e-12)}
  rows[[length(rows)+1]]<-data.frame(condition=g,replicate=rep,seed=seed,alpha_raw=raw,alpha_standardized=standardized,constant_items=constant,elapsed_seconds=proc.time()[3]-t0)
 }
 e$atomic_csv(do.call(rbind,rows),file.path(out,'summaries.csv'))
}
saveRDS(list(status='completed',rows=length(rows),elapsed_seconds=proc.time()[3]-t0,posterior_fits=0,meaning='Same2650fixeddatasets regenerated, not additional independentreplicates'),file.path(out,'terminal.rds'))
