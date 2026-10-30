# Population covariance for Chumney (2013), Figures 1-4.
# Unstandardized marker scaling: factor variances 0.49, paths 0.60,
# disturbance variances 0.3136 so the standardized disturbance is 0.64.
# The figure prints 0.31, which is that disturbance rounded to two decimals.

indicator_sets <- function(n_items) {
  f1 <- paste0("Y", 1:7)
  f2 <- paste0("Y", 8:14)
  f3 <- paste0("Y", 15:21)
  if (n_items == 3) {
    list(eta1 = c("Y1", "Y2", "Y3"),
         eta2 = c("Y8", "Y9", "Y14"),
         eta3 = c("Y15", "Y16", "Y17"))
  } else if (n_items == 5) {
    list(eta1 = f1[1:5],
         eta2 = c("Y8", "Y9", "Y10", "Y11", "Y14"),
         eta3 = f3[1:5])
  } else if (n_items == 7) {
    list(eta1 = f1, eta2 = f2, eta3 = f3)
  } else {
    stop("n_items must be 3, 5, or 7")
  }
}

# Cross-loading items are in every item-count condition.
# Y8 (eta2) also loads on eta1; Y14 (eta2) also loads on eta3;
# Y15 (eta3) also loads on eta2.
cross_spec <- list(
  Y8 = c(eta2 = 1, eta1 = NA),
  Y14 = c(eta2 = 1, eta3 = NA),
  Y15 = c(eta3 = 1, eta2 = NA)
)

latent_phi <- function() {
  v <- 0.49
  b <- 0.60
  # Equal factor variances and standardized path 0.60.
  phi <- matrix(c(
    v, b * v, b * b * v,
    b * v, v, b * v,
    b * b * v, b * v, v
  ), 3, 3, byrow = TRUE)
  rownames(phi) <- colnames(phi) <- c("eta1", "eta2", "eta3")
  phi
}

population_model <- function(n_items, formative, misspecified,
                             reflective_cross = 0.30) {
  sets <- indicator_sets(n_items)
  names_y <- c(sets$eta1, sets$eta2, sets$eta3)
  p <- length(names_y)
  factors <- c("eta1", "eta2", "eta3")
  lambda <- matrix(0, p, 3, dimnames = list(names_y, factors))
  for (f in factors) lambda[sets[[f]], f] <- 1

  theta <- rep(if (formative) 0.001 else 0.51, p)
  names(theta) <- names_y

  if (misspecified) {
    # Reflective: unstandardized cross-loading 0.30 reproduces the
    # parenthetical standardized values 0.70 and 0.21 with residual 0.29.
    # Formative: the figure prints unstandardized 1 on both arrows, which
    # reproduces the parenthetical standardized value 0.56.
    cross <- if (formative) 1 else reflective_cross
    resid <- if (formative) 0.001 else 0.29
    lambda["Y8", "eta1"] <- cross
    lambda["Y14", "eta3"] <- cross
    lambda["Y15", "eta2"] <- cross
    theta[c("Y8", "Y14", "Y15")] <- resid
  }

  phi <- latent_phi()
  sigma <- lambda %*% phi %*% t(lambda)
  diag(sigma) <- diag(sigma) + theta
  sigma <- (sigma + t(sigma)) / 2

  # Completely standardized regression coefficients (not correlations).
  sdy <- sqrt(diag(sigma))
  sdf <- sqrt(diag(phi))
  lambda_std <- lambda
  for (j in seq_along(factors)) {
    lambda_std[, j] <- lambda[, j] * sdf[j] / sdy
  }

  # Nominal targets named in the text: 0.70 / 1.00 / 0.56 and paths 0.60.
  nominal <- rep(NA_real_, p)
  names(nominal) <- names_y
  if (!formative) {
    nominal[] <- 0.70
  } else {
    nominal[] <- 1
    if (misspecified) nominal[c("Y8", "Y14", "Y15")] <- 0.56
  }

  list(
    sigma = sigma,
    names = names_y,
    sets = sets,
    lambda = lambda,
    lambda_std = lambda_std,
    theta = theta,
    phi = phi,
    nominal_loading = nominal,
    path = 0.60,
    formative = formative,
    misspecified = misspecified,
    n_items = n_items
  )
}

# Population GoF under equation (14), using squared correlations with the
# factors (equation 12) and the mean R^2 of the two endogenous factors.
population_gof <- function(model) {
  phi <- model$phi
  sigma <- model$sigma
  sets <- model$sets
  # cov(y, eta) = Lambda %*% Phi
  cov_ye <- model$lambda %*% phi
  sdy <- sqrt(diag(sigma))
  sdf <- sqrt(diag(phi))
  blocks <- list()
  for (f in names(sets)) {
    ys <- sets[[f]]
    j <- match(f, colnames(phi))
    cors <- cov_ye[ys, j] / (sdy[ys] * sdf[j])
    blocks[[f]] <- mean(cors^2)
  }
  # Structural R^2 is 0.36 for eta2 and eta3 when the path is 0.60.
  r2 <- 0.36
  cbar <- mean(unlist(blocks))
  list(
    communality = blocks,
    cbar = cbar,
    r2 = r2,
    gof = sqrt(cbar * r2),
    # Alternative: square the unstandardized loading 1, which is  the
    # number printed above the parentheses, and keep R^2 = 0.36.
    gof_loading_one = sqrt(1 * r2)
  )
}
