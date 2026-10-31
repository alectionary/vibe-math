# Independent generation-only validation; run only after production/JAGS CPU release.
# No jags.model, update or coda.samples call is evaluated.
# Rscript simulation/validate_generator_summary.R NEW_OUTPUT_CSV
args<-commandArgs(TRUE);stopifnot(length(args)==1L,!file.exists(args[1]))
sha<-function(p)strsplit(system2('sha256sum',shQuote(p),stdout=TRUE),' ',fixed=TRUE)[[1]][1]
stopifnot(sha('simulation/jags_replication.R')=='55ab08fd95bc9a3210ba6eb64106c05777be6f786576abe9c7327ac8d7f28c20')
expr<-parse('simulation/generator_summary_check.R');env<-new.env(parent=globalenv())
# Evaluate only named grid/function assignments, never the script's execution loop.
for(e in expr)if(is.call(e)&&identical(e[[1]],as.name('<-'))&&is.symbol(e[[2]])&&as.character(e[[2]])%in%c('grid','generate','skews','alpha'))eval(e,env)
grid<-env$grid;stopifnot(nrow(grid)==19L,sum(grid$replicates)==2650L)
stopifnot(sum(grid$ch==2)==14L,sum(grid$ch==5)==5L)
source<-parse('simulation/jags_replication.R');boundary<-which(vapply(source,function(e)is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('start')),logical(1)))[1]
stopifnot(!is.na(boundary))
checks<-list();add<-function(condition,test,ok){if(!isTRUE(ok))stop(paste('Failed',condition,test));checks[[length(checks)+1L]]<<-data.frame(condition=condition,test=test,passed=TRUE)}
allseeds<-unlist(lapply(seq_len(nrow(grid)),function(g)910000L+1000L*g+seq_len(grid$replicates[g])))
add(0,'all2650fixed_seeds_distinct',length(unique(allseeds))==2650L)
for(g in seq_len(nrow(grid))){
 d<-grid[g,];seed<-910000L+1000L*g+1L
 baseline<-new.env(parent=globalenv());baseline$commandArgs<-function(...)c(d$ch,d$N,d$J,d$effect,d$difficulty,seed,1000,7000,12000,'unused','.5','items')
 for(e in source[seq_len(boundary-1)])eval(e,baseline)
 s<-env$generate(d$ch,d$N,d$J,d$effect,d$difficulty,seed)
 for(name in c('y','b','theta','ys','nmz'))add(g,paste0('baseline_exact_',name),identical(s[[name]],baseline[[name]]))
 all<-matrix(s$y,2*d$N,d$J);dzpairs<-which(baseline$rho==.5)
 dzrows<-c(dzpairs,d$N+dzpairs);scores<-as.vector(s$ys[dzpairs,])
 add(g,'DZscore_index_identity',identical(as.numeric(rowSums(all[dzrows,])),as.numeric(scores)))
 add(g,'DZsample_size',length(scores)==2*(d$N-round(.28*d$N)))
 add(g,'alpha_matches_baseline',abs(env$alpha(all)-baseline$alpha)<1e-12)
 S<-cov(all);a<-d$J/(d$J-1)*(sum(S)-sum(diag(S)))/sum(S)
 add(g,'alpha_covariance_identity',abs(env$alpha(all)-a)<1e-12)
 # Explicit sums/sample variance, independently arranged from production mean-moment formulas.
 n<-length(scores);centered<-scores-mean(scores);sum2<-sum(centered^2);sum3<-sum(centered^3)
 expected<-c(g1=sqrt(n)*sum3/sum2^1.5,G1=n*sqrt(n-1)/(n-2)*sum3/sum2^1.5,b1=(sum3/n)/var(scores)^1.5)
 add(g,'all_three_skewness_formulas',max(abs(env$skews(scores)-expected))<1e-12)
 if(g<=2)add(g,'illustrative_DZ_n720',n==720L)
}
# Uneven simple fixture ensures formulas have distinct finite-sample corrections.
x<-c(0,0,1,2,7);n<-length(x);m<-mean(x);g1<-sum((x-m)^3)/n/(sum((x-m)^2)/n)^1.5
add(0,'skew_fixture_finite_sample_corrections',isTRUE(all.equal(unname(env$skews(x)),c(g1,sqrt(n*(n-1))/(n-2)*g1,(sum((x-m)^3)/n)/sd(x)^3))))
write.csv(do.call(rbind,checks),args[1],row.names=FALSE)
cat(length(checks),'generation-only checks passed. No model compilation or posterior sampling.\n')
