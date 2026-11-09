# Recreate the two formulaic reference curves independently of simulation.
source('formalization/kupzyk-power-assumptions/scripts/model.R')
out <- commandArgs(TRUE)[[1]]
rows <- list()
for (icc in c(.05,.10,.15)) for (J in 12:41) {
  # Occasion error contributes .5 / sum((0:3-1.5)^2) = .1 to slope variance.
  variance <- 4*(icc+(1-icc+.1)/20)/J
  rows[[length(rows)+1L]] <- data.frame(
    icc=icc,J=J,lambda=.25/variance,
    OD=power_value(variance,J-2),BW=power_value(variance,J*80-2-J))
}
write.csv(do.call(rbind,rows),out,row.names=FALSE)
