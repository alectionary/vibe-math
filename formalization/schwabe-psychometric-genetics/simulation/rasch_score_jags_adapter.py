"""Static Chapter-2 graph/data adapter. Never imports or starts a sampler.

Two likelihood representations in the SAME JAGS backend, not independent
engines. Compilation, sampler assignment, performance and mixing are untested.
"""
from exact_rasch_score import CalibratedRasch

PRIORS = '''mu ~ dnorm(0,.1)
ta ~ dgamma(1,1)
tc ~ dgamma(1,1)
va <- 1/ta
vc <- 1/tc
beta0 ~ dnorm(0,1)
beta1 ~ dnorm(0,.1)
ve <- exp(beta0)'''


def chapter2_graph(n_pairs, n_mz, representation='score'):
    if (type(n_pairs) is not int or type(n_mz) is not int or
            not 0 < n_mz < n_pairs):
        raise ValueError('A positive MZ and DZ group are both required')
    if representation not in ('score', 'items'):
        raise ValueError('Unknown likelihood representation')
    measurement = '''for(k in 1:J){
  logit(p[i,t,k]) <- theta[i,t]-b[k]
  y[i,t,k] ~ dbern(p[i,t,k])
}'''
    if representation == 'score':
        measurement = '''for(k in 1:J){
  logit(p[i,t,k]) <- theta[i,t]-b[k]
  signed_eta[i,t,k] <- (1-2*canonical_y[i,t,k])*(theta[i,t]-b[k])
  loss[i,t,k] <- observed[i,t,k]*(max(signed_eta[i,t,k],0)+log(1+exp(-abs(signed_eta[i,t,k]))))
}
lambda[i,t] <- 1+sum(loss[i,t,1:J])
zeros[i,t] ~ dpois(lambda[i,t])'''
    return f'''model {{
{PRIORS}
for(i in 1:N){{
 c[i] ~ dnorm(0,tc)
 for(t in 1:2){{
  prec[i,t] <- exp(-beta0-beta1*a[i,t])
  theta[i,t] ~ dnorm(mu+a[i,t]+c[i],prec[i,t])
  {measurement}
 }}
}}
for(i in 1:{n_mz}){{
 a[i,1] ~ dnorm(0,ta)
 a[i,2] <- a[i,1]
}}
for(i in {n_mz+1}:N){{
 a[i,1] ~ dnorm(0,ta)
 a[i,2] ~ dnorm(.5*a[i,1],ta/.75)
}}
}}
'''


def prepare_scores(difficulties, responses, masks=None):
    """Return score-only observed likelihood inputs, keeping calibration/masks.

    responses is N x 2 x J; only unobserved response slots may be nonbinary.
    No latent state, prior, data ordering or initialization is changed. Empty
    observed masks contribute a constant e^-1 to the zeros-trick likelihood.
    The item representation requires a separate missing-data integration check
    before a sampling comparison with incomplete masks (pilot data are complete).
    """
    b = tuple(difficulties)
    if not b:
        raise ValueError('JAGS graph requires J>0; Python likelihood supports J=0')
    persons = list(responses)
    if not persons:
        raise ValueError('At least one pair required')
    if masks is None:
        masks = [[[True]*len(b) for _ in range(2)] for _ in persons]
    masks = list(masks)
    if len(masks) != len(persons):
        raise ValueError('Mask pair count mismatch')
    canonical, observed, scores, constants = [], [], [], []
    for pair, pair_masks in zip(persons, masks):
        if len(pair) != 2 or len(pair_masks) != 2:
            raise ValueError('Two twins per pair required')
        yc, om, sc, cc = [], [], [], []
        for y, mask in zip(pair, pair_masks):
            y, mask = tuple(y), tuple(mask)
            model = CalibratedRasch(b, mask)
            score = model.score(y)
            remaining = score
            pattern = []
            for present in mask:
                success = int(present and remaining > 0)
                pattern.append(success)
                remaining -= success
            yc.append(pattern); om.append([int(m) for m in mask]); sc.append(score)
            # log L_items - log L_canonical is parameter independent.
            cc.append(model.log_pattern_given_score(y)-model.log_pattern_given_score(pattern))
        canonical.append(yc); observed.append(om); scores.append(sc); constants.append(cc)
    return {'N':len(persons), 'J':len(b), 'b':list(map(float,b)),
            'canonical_y':canonical, 'observed':observed,
            'zeros':[[0,0] for _ in persons], 'scores':scores,
            'item_minus_canonical_log_constants':constants}


def prepare_chapter2_case(difficulties, responses, rho, masks=None):
    """Validate zygosity ordering before constructing the two static graphs."""
    data = prepare_scores(difficulties, responses, masks)
    rho = tuple(rho)
    n_mz = rho.count(1)
    if len(rho) != data['N'] or rho != (1,)*n_mz + (.5,)*(len(rho)-n_mz):
        raise ValueError('Expected all MZ pairs then all DZ pairs, correlations 1/.5')
    models = {kind:chapter2_graph(data['N'],n_mz,kind) for kind in ('items','score')}
    return {'models':models, 'score_data':{k:data[k] for k in
            ('N','J','b','canonical_y','observed','zeros')},
            'audit':{'scores':data['scores'],
                     'item_minus_canonical_log_constants':data['item_minus_canonical_log_constants'],
                     'n_mz':n_mz, 'n_dz':len(rho)-n_mz,
                     'compiled':False, 'sampling_started':False,
                     'backend':'JAGS for both representations; not independent engines'}}
