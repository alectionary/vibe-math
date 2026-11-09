# Same generator and RNG consumption as model.R, without creating factors
# and a data frame for the fit that needs only the response and its layout.
generate_response <- function(d,icc,effect) {
  J <- max(d$cluster)
  N <- length(d$k)
  id <- rep.int(seq_len(N),d$k)
  tt <- sequence(d$k)-1L
  cl <- d$cluster[id]
  u0 <- rnorm(J,0,sqrt(.1));u1 <- rnorm(J,0,sqrt(icc))
  b0 <- rnorm(N,0,sqrt(.2));b1 <- rnorm(N,0,sqrt(1-icc))
  effect*tt*d$group[id]+u0[cl]+u1[cl]*tt+b0[id]+b1[id]*tt+rnorm(length(id),0,sqrt(.5))
}
