# Shared-stream check of the R generator against generate_py.py.
# Uses a reduced population so the vectors fit in a small CSV. The formulas
# are the Appendix A formulas; only M and the average population cluster size
# are reduced, and those reductions are explicit arguments to both sides.

args <- commandArgs(trailingOnly = TRUE)
out <- args[[1]]
M <- 400L
icc <- 0.05
set.seed(20261102)
wj <- rnorm(M)
tau <- icc / (1 - icc)
u0 <- rnorm(M, 0, sqrt(tau))
delta <- rnorm(M, 0, sqrt(0.2))
u_noise <- rnorm(M, 0, sqrt(2))
cap <- 1.5 * sqrt(0.2)
delta_c <- pmin(pmax(delta, -cap), cap)
Nj.ave <- 25
Nj <- ifelse(delta_c <= 0, round(Nj.ave * exp(delta_c)),
             round(2 * Nj.ave - Nj.ave * exp(-delta_c)))
Nj <- pmax(as.integer(Nj), 1L)
N <- sum(Nj)
rij <- rnorm(N)
x <- rnorm(N)
r_noise <- rnorm(N, 0, sqrt(2))
unif_j <- runif(M)
unif_i <- runif(N)
dir.create(out, showWarnings = FALSE, recursive = TRUE)
write.table(data.frame(wj, u0, delta, u_noise, unif_j),
            file.path(out, "level2.csv"), sep = ",", row.names = FALSE)
write.table(data.frame(rij, x, r_noise, unif_i),
            file.path(out, "level1.csv"), sep = ",", row.names = FALSE)

# R reference, same formulas as generate.R, with M and Nj.ave overridden.
scale2 <- function(z) ((z - mean(z)) / sd(z)) * sqrt(2)
school <- rep.int(seq_len(M), Nj)
x_sum <- rowsum(x, school, reorder = FALSE)
x_n <- rowsum(rep(1, N), school, reorder = FALSE)
xgmc <- x - as.numeric(x_sum / x_n)[school]
g10 <- sqrt(0.06 / 0.94)
g01 <- sqrt(tau * 0.06 / 0.94)
ystar <- g01 * wj[school] + u0[school] + g10 * xgmc + rij
u_used <- scale2(u0)
r_used <- scale2(rij)
prob_j <- 1 / (1 + exp((-u_used / 2) + 4.12))
prob_i <- 1 / (1 + exp((-r_used / 2) + 1.53))
keep <- (prob_j[school] > unif_j[school]) & (prob_i > unif_i)
sch <- school[keep]
ref <- c(
  n = sum(keep), m = length(unique(sch)), N = N,
  mean_y = mean(ystar[keep]), mean_wj = mean((1 / prob_j)[sch])
)
write.csv(as.data.frame(as.list(ref)), file.path(out, "r_reference.csv"), row.names = FALSE)
print(as.list(ref))
