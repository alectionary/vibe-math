study <- 'formalization/kupzyk-power-assumptions'
source(file.path(study,'scripts/model.R'))
source(file.path(study,'rerun/fast_generator.R'))
targets <- read.csv(file.path(study,'outputs/targets.csv'))
for(i in seq_len(nrow(targets))) {
 r <- targets[i,]
 J <- c(16,22,28)[match(r$icc,c(.05,.10,.15))]
 for(k in 1:5) for(effect in c(0,.5)) {
  set.seed(20570000L+100L*i+k)
  d <- design(J,r$icc,r$attrition,r$treat,r$size,FALSE)
  initial <- .Random.seed
  original <- generate(d,r$icc,effect)
  end <- .Random.seed
  .Random.seed <- initial
  direct <- generate_response(d,r$icc,effect)
  stopifnot(identical(original$y,direct),identical(end,.Random.seed))
 }
}
cat('540 paired outputs and post-generator RNG states are bit-identical.\n')
