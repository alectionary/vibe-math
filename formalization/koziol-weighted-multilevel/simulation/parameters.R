# Superpopulation values implied by Koziol (2015), Appendix A and pp. 69-70.
# Level-1 and level-2 slopes are set so each predictor accounts for 6% of the
# relevant variance: gamma^2 / (gamma^2 + target variance) = 0.06.
# Random-intercept tau00 is the empty residual ICC on the unit residual scale,
# tau00 / (tau00 + 1) = rho. Appendix A prints tau00 = .052632 for rho = .05.

gamma10_value <- function() sqrt(0.06 / 0.94)

ri_parameters <- function(icc) {
  tau00 <- icc / (1 - icc)
  g10 <- gamma10_value()
  g01 <- sqrt(tau00 * 0.06 / 0.94)
  list(
    model = "RI", icc = icc, gamma00 = 0, gamma01 = g01, gamma10 = g10,
    gamma11 = NA_real_, sigma2 = 1, tau00 = tau00, tau11 = NA_real_,
    tau01 = NA_real_
  )
}

# Population-averaged probit parameters, Koziol equation 10 / Table 3.4:
# gamma_PA = gamma_CS / sqrt(1 + tau00) for a random-intercept model.
ri_pa_parameters <- function(par) {
  scale <- sqrt(1 + par$tau00)
  list(gamma00 = par$gamma00 / scale, gamma01 = par$gamma01 / scale,
       gamma10 = par$gamma10 / scale)
}
