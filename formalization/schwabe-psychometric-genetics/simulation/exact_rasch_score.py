"""Fixed-calibration Rasch score probabilities and latent-only target kernels.

No fitting, random generation, or sampling. Masks are observed/conditioned upon;
this module does not supply an informative-missingness model. Calibration is
fixed: dropping response-pattern constants is invalid when it is estimated.
"""
import math


def logadd(a, b):
    if a == -math.inf:
        return b
    if b == -math.inf:
        return a
    return max(a, b) + math.log1p(math.exp(-abs(a-b)))


def softplus(x):
    return max(x, 0.) + math.log1p(math.exp(-abs(x)))


def finite(x):
    x = float(x)
    if not math.isfinite(x):
        raise ValueError('Finite real input required')
    return x


class CalibratedRasch:
    """Immutable-in-use calibration; retain item order and the observed mask.

    Coefficients are computed once in O(J^2) time/O(J) space in log space.
    Trait evaluation is O(J); this is not a measured speedup over an item graph.
    Numerical representability, not just finite input, is required: arithmetic
    overflow raises rather than silently clipping probabilities or parameters.
    """
    def __init__(self, difficulties, mask=None):
        all_b = tuple(finite(v) for v in difficulties)
        if mask is None:
            mask = (True,)*len(all_b)
        mask = tuple(mask)
        if len(mask) != len(all_b) or any(type(v) is not bool for v in mask):
            raise ValueError('Mask must contain one Boolean per item')
        self.mask = mask
        self.difficulties = all_b
        self.b = tuple(v for v, observed in zip(all_b, mask) if observed)
        self.J = len(self.b)
        # A common shift keeps coefficients smaller without changing the model.
        self.anchor = (min(self.b)/2 + max(self.b)/2) if self.b else 0.
        c = [0.] + [-math.inf]*self.J
        for j, b in enumerate(self.b):
            w = self.anchor-b
            for s in range(j+1, 0, -1):
                c[s] = logadd(c[s], w+c[s-1])
        if not all(math.isfinite(v) for v in c):
            raise FloatingPointError('Log coefficients exceed floating range')
        self.log_coefficients = tuple(c)

    def _score(self, score):
        if isinstance(score, bool) or not isinstance(score, int) or not 0 <= score <= self.J:
            raise ValueError('Score must be an integer in [0, observed item count]')
        return score

    def _delta(self, theta):
        d = finite(theta)-self.anchor
        if not math.isfinite(d):
            raise FloatingPointError('Trait/calibration difference exceeds floating range')
        return d

    def log_pmf(self, theta):
        """Normalized score log PMF, using cached coefficients.

        Subtract a common degree-J term when delta>=0. Thus the boundary score
        avoids a subtraction of two huge positive terms. Normalization by the
        polynomial is exactly the product Bernoulli denominator in real arithmetic.
        """
        d = self._delta(theta)
        base = self.J if d >= 0 else 0
        weights = [c+(s-base)*d for s, c in enumerate(self.log_coefficients)]
        if not all(math.isfinite(w) for w in weights):
            raise FloatingPointError('Score log weights exceed floating range')
        peak = max(weights)
        shifted = [w-peak for w in weights]
        if not all(math.isfinite(w) for w in shifted):
            raise FloatingPointError('Score log probabilities exceed floating range')
        normalizer = math.log(math.fsum(math.exp(w) for w in shifted))
        return tuple(w-normalizer for w in shifted)

    def log_score_probability(self, theta, score):
        return self.log_pmf(theta)[self._score(score)]

    def score(self, responses):
        responses = tuple(responses)
        if len(responses) != len(self.mask):
            raise ValueError('One response slot per original item required')
        observed = tuple(y for y, m in zip(responses, self.mask) if m)
        if any(type(y) not in (int, bool) or y not in (0, 1) for y in observed):
            raise ValueError('Observed responses must be binary')
        return sum(observed)

    def log_pattern_probability(self, theta, responses):
        responses = tuple(responses)
        self.score(responses)
        theta = finite(theta)
        eta = [theta-b for b in self.b]
        if not all(math.isfinite(x) for x in eta):
            raise FloatingPointError('Trait/calibration difference exceeds floating range')
        values = [-softplus(-x) if y else -softplus(x)
                  for x, y in zip(eta, (y for y,m in zip(responses,self.mask) if m))]
        result = math.fsum(values)
        if not math.isfinite(result):
            raise FloatingPointError('Pattern log probability exceeds floating range')
        return result

    def log_pattern_given_score(self, responses):
        """Known log p(y|S,b), independent of theta and latent-law parameters."""
        responses = tuple(responses)
        score = self.score(responses)
        selected = [self.anchor-b for b,y in zip(self.b, (y for y,m in zip(responses,self.mask) if m)) if y]
        value = math.fsum(selected)-self.log_coefficients[score]
        if not math.isfinite(value):
            raise FloatingPointError('Pattern constant exceeds floating range')
        return value

    def canonical_log_kernel(self, theta, score):
        """A stable latent-only kernel: first S observed positions are successes.

        This is NOT the normalized score probability. Its ratio to that PMF is
        a known calibration/score-only constant. It preserves the full latent
        posterior under unchanged priors, and is always nonpositive.
        """
        score = self._score(score)
        theta = finite(theta)
        eta = [theta-b for b in self.b]
        if not all(math.isfinite(x) for x in eta):
            raise FloatingPointError('Trait/calibration difference exceeds floating range')
        terms = [-softplus(-x) if j < score else -softplus(x)
                 for j,x in enumerate(eta)]
        value = math.fsum(terms)
        if not math.isfinite(value):
            raise FloatingPointError('Canonical kernel exceeds floating range')
        return value

    def derivatives(self, theta, score):
        """Exact analytic first/second derivatives of either latent-only kernel."""
        score = self._score(score)
        theta = finite(theta)
        p = []
        curvature = []
        for b in self.b:
            x = theta-b
            if not math.isfinite(x):
                raise FloatingPointError('Trait/calibration difference exceeds floating range')
            z = math.exp(-abs(x))
            p.append(1/(1+z) if x >= 0 else z/(1+z))
            curvature.append(z/(1+z)**2)
        return score-math.fsum(p), -math.fsum(curvature)
