// Gauss-Hermite weighted probit pseudo-likelihood.
// school is 1..m with no gaps, and rows are grouped however rowsum would group them.
#include <Rcpp.h>
#include <algorithm>
#include <cmath>
#include <vector>

using namespace Rcpp;

static inline double clip_log(double v) {
  return R_FINITE(v) ? v : -700.0;
}

// Log density and log cdf of a standard normal. The tail uses the mills
// expansion; the center uses Abramowitz and Stegun 26.2.17, which is accurate
// to about 1e-7. That is finer than the three decimals in Appendices C-F.
static inline double fast_logpdf(double x) {
  return -0.91893853320467274 - 0.5 * x * x;
}

static inline void fast_logcdf(double x, double &log1, double &log0) {
  const double ax = std::fabs(x);
  if (ax > 8.0) {
    const double logtail = fast_logpdf(ax) - std::log(ax);
    if (x >= 0) {
      log1 = 0.0;
      log0 = logtail;
    } else {
      log1 = logtail;
      log0 = 0.0;
    }
    return;
  }
  const double t = 1.0 / (1.0 + 0.2316419 * ax);
  const double poly = (((((1.330274429 * t - 1.821255978) * t) + 1.781477937) * t
                         - 0.356563782) * t + 0.319381530) * t;
  double tail = std::exp(fast_logpdf(ax)) * poly;
  if (tail < 1e-300) tail = 1e-300;
  if (tail > 1.0 - 1e-16) tail = 1.0 - 1e-16;
  if (x >= 0) {
    log1 = std::log(1.0 - tail);
    log0 = std::log(tail);
  } else {
    log1 = std::log(tail);
    log0 = std::log(1.0 - tail);
  }
}

// [[Rcpp::export]]
List ri_probit_parts_cpp(NumericVector theta, NumericVector y, NumericMatrix X,
                         NumericVector w1s, IntegerVector school, NumericVector w2c,
                         NumericVector z, NumericVector logw) {
  const int N = y.size();
  const int p = X.ncol();
  const int m = w2c.size();
  const int K = z.size();
  const double tau = std::exp(theta[p]);
  const double s = std::sqrt(2.0 * tau);
  const double ds = 0.5 * s;

  std::vector<double> eta(N);
  for (int i = 0; i < N; ++i) {
    double e = 0.0;
    for (int q = 0; q < p; ++q) e += X(i, q) * theta[q];
    eta[i] = e;
  }

  std::vector<double> S(static_cast<size_t>(m) * K, 0.0);
  std::vector<double> dstore(static_cast<size_t>(N) * K);
  for (int k = 0; k < K; ++k) {
    const double shift = s * z[k];
    for (int i = 0; i < N; ++i) {
      const double lp = eta[i] + shift;
      double log1, log0;
      fast_logcdf(lp, log1, log0);
      log1 = clip_log(log1);
      log0 = clip_log(log0);
      const double logf = y[i] * log1 + (1.0 - y[i]) * log0;
      const double ld = fast_logpdf(lp);
      const double dlogf = y[i] * std::exp(std::min(ld - log1, 40.0)) -
                           (1.0 - y[i]) * std::exp(std::min(ld - log0, 40.0));
      S[static_cast<size_t>(school[i] - 1) + static_cast<size_t>(m) * k] += w1s[i] * logf;
      dstore[static_cast<size_t>(i) + static_cast<size_t>(N) * k] = dlogf;
    }
    for (int j = 0; j < m; ++j) S[static_cast<size_t>(j) + static_cast<size_t>(m) * k] += logw[k];
  }

  std::vector<double> mx(m, -1e300);
  for (int j = 0; j < m; ++j) {
    for (int k = 0; k < K; ++k)
      mx[j] = std::max(mx[j], S[static_cast<size_t>(j) + static_cast<size_t>(m) * k]);
  }
  std::vector<double> sumex(m, 0.0);
  std::vector<double> pi(static_cast<size_t>(m) * K);
  for (int j = 0; j < m; ++j) {
    for (int k = 0; k < K; ++k) {
      const double e = std::exp(S[static_cast<size_t>(j) + static_cast<size_t>(m) * k] - mx[j]);
      pi[static_cast<size_t>(j) + static_cast<size_t>(m) * k] = e;
      sumex[j] += e;
    }
    for (int k = 0; k < K; ++k)
      pi[static_cast<size_t>(j) + static_cast<size_t>(m) * k] /= sumex[j];
  }

  double nll = 0.0;
  for (int j = 0; j < m; ++j) nll -= w2c[j] * (mx[j] + std::log(sumex[j]));

  NumericMatrix score(m, p + 1);
  for (int k = 0; k < K; ++k) {
    std::vector<double> acc(static_cast<size_t>(m) * (p + 1), 0.0);
    for (int i = 0; i < N; ++i) {
      const double dlogf = dstore[static_cast<size_t>(i) + static_cast<size_t>(N) * k];
      const double base = w1s[i] * dlogf;
      const int j = school[i] - 1;
      for (int q = 0; q < p; ++q)
        acc[static_cast<size_t>(j) + static_cast<size_t>(m) * q] += base * X(i, q);
      acc[static_cast<size_t>(j) + static_cast<size_t>(m) * p] += base * (z[k] * ds);
    }
    for (int j = 0; j < m; ++j) {
      const double wk = pi[static_cast<size_t>(j) + static_cast<size_t>(m) * k];
      for (int q = 0; q <= p; ++q)
        score(j, q) += wk * acc[static_cast<size_t>(j) + static_cast<size_t>(m) * q];
    }
  }
  for (int j = 0; j < m; ++j)
    for (int q = 0; q <= p; ++q) score(j, q) *= w2c[j];

  NumericVector grad(p + 1);
  for (int q = 0; q <= p; ++q) {
    double ssum = 0.0;
    for (int j = 0; j < m; ++j) ssum += score(j, q);
    grad[q] = -ssum;
  }
  return List::create(Named("nll") = nll, Named("grad") = grad,
                      Named("score") = score, Named("tau") = tau);
}

// Random intercept and slope. Node pair (k, l):
// u0 = exp(a)*sqrt(2)*z_k
// u1 = sqrt(2)*(b*z_k + exp(c)*z_l)
// theta = c(beta, a, b, c)
// [[Rcpp::export]]
List rc_probit_parts_cpp(NumericVector theta, NumericVector y, NumericMatrix X,
                         NumericVector zslope, NumericVector w1s, IntegerVector school,
                         NumericVector w2c, NumericVector z, NumericVector logw) {
  const int N = y.size();
  const int p = X.ncol();
  const int m = w2c.size();
  const int K = z.size();
  const int KK = K * K;
  const double a = theta[p];
  const double b = theta[p + 1];
  const double c = theta[p + 2];
  const double L00 = std::exp(a);
  const double L11 = std::exp(c);
  const double s2 = std::sqrt(2.0);

  std::vector<double> eta(N);
  for (int i = 0; i < N; ++i) {
    double e = 0.0;
    for (int q = 0; q < p; ++q) e += X(i, q) * theta[q];
    eta[i] = e;
  }

  std::vector<double> u0(KK), u1(KK), lognw(KK);
  for (int k = 0; k < K; ++k) {
    for (int l = 0; l < K; ++l) {
      const int t = k * K + l;
      u0[t] = L00 * s2 * z[k];
      u1[t] = s2 * (b * z[k] + L11 * z[l]);
      lognw[t] = logw[k] + logw[l];
    }
  }

  std::vector<double> S(static_cast<size_t>(m) * KK, 0.0);
  std::vector<double> dstore(static_cast<size_t>(N) * KK);
  for (int t = 0; t < KK; ++t) {
    for (int i = 0; i < N; ++i) {
      const double lp = eta[i] + u0[t] + u1[t] * zslope[i];
      double log1, log0;
      fast_logcdf(lp, log1, log0);
      log1 = clip_log(log1);
      log0 = clip_log(log0);
      const double logf = y[i] * log1 + (1.0 - y[i]) * log0;
      const double ld = fast_logpdf(lp);
      const double dlogf = y[i] * std::exp(std::min(ld - log1, 40.0)) -
                           (1.0 - y[i]) * std::exp(std::min(ld - log0, 40.0));
      S[static_cast<size_t>(school[i] - 1) + static_cast<size_t>(m) * t] += w1s[i] * logf;
      dstore[static_cast<size_t>(i) + static_cast<size_t>(N) * t] = dlogf;
    }
    for (int j = 0; j < m; ++j)
      S[static_cast<size_t>(j) + static_cast<size_t>(m) * t] += lognw[t];
  }

  std::vector<double> mx(m, -1e300), sumex(m, 0.0);
  for (int j = 0; j < m; ++j)
    for (int t = 0; t < KK; ++t)
      mx[j] = std::max(mx[j], S[static_cast<size_t>(j) + static_cast<size_t>(m) * t]);
  std::vector<double> pi(static_cast<size_t>(m) * KK);
  for (int j = 0; j < m; ++j) {
    for (int t = 0; t < KK; ++t) {
      const double e = std::exp(S[static_cast<size_t>(j) + static_cast<size_t>(m) * t] - mx[j]);
      pi[static_cast<size_t>(j) + static_cast<size_t>(m) * t] = e;
      sumex[j] += e;
    }
    for (int t = 0; t < KK; ++t)
      pi[static_cast<size_t>(j) + static_cast<size_t>(m) * t] /= sumex[j];
  }
  double nll = 0.0;
  for (int j = 0; j < m; ++j) nll -= w2c[j] * (mx[j] + std::log(sumex[j]));

  NumericMatrix score(m, p + 3);
  for (int k = 0; k < K; ++k) {
    for (int l = 0; l < K; ++l) {
      const int t = k * K + l;
      std::vector<double> acc(static_cast<size_t>(m) * (p + 3), 0.0);
      for (int i = 0; i < N; ++i) {
        const double dlogf = dstore[static_cast<size_t>(i) + static_cast<size_t>(N) * t];
        const double base = w1s[i] * dlogf;
        const int j = school[i] - 1;
        for (int q = 0; q < p; ++q)
          acc[static_cast<size_t>(j) + static_cast<size_t>(m) * q] += base * X(i, q);
        // d lp / d a = u0, d lp / d b = sqrt(2)*z_k*x, d lp / d c = u1_from_l * x
        acc[static_cast<size_t>(j) + static_cast<size_t>(m) * p] += base * u0[t];
        acc[static_cast<size_t>(j) + static_cast<size_t>(m) * (p + 1)] += base * (s2 * z[k] * zslope[i]);
        acc[static_cast<size_t>(j) + static_cast<size_t>(m) * (p + 2)] += base * (L11 * s2 * z[l] * zslope[i]);
      }
      for (int j = 0; j < m; ++j) {
        const double wk = pi[static_cast<size_t>(j) + static_cast<size_t>(m) * t];
        for (int q = 0; q < p + 3; ++q)
          score(j, q) += wk * acc[static_cast<size_t>(j) + static_cast<size_t>(m) * q];
      }
    }
  }
  for (int j = 0; j < m; ++j)
    for (int q = 0; q < p + 3; ++q) score(j, q) *= w2c[j];

  NumericVector grad(p + 3);
  for (int q = 0; q < p + 3; ++q) {
    double ssum = 0.0;
    for (int j = 0; j < m; ++j) ssum += score(j, q);
    grad[q] = -ssum;
  }
  const double G00 = L00 * L00;
  const double G01 = b * L00;
  const double G11 = b * b + L11 * L11;
  return List::create(Named("nll") = nll, Named("grad") = grad, Named("score") = score,
                      Named("G00") = G00, Named("G01") = G01, Named("G11") = G11);
}
