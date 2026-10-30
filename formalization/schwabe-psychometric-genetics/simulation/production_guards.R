# Fixed before Chapter6 production: conservative numerical-admissibility rules.
# These checks do not establish model correctness, global optimality or unbiasedness.
production_guard_spec <- list(version='1.0', symmetry_relative_tolerance=1e-8,
  scaled_min_eigenvalue=1e-10, scaled_max_condition=1e10,
  hessian_covariance_inverse_tolerance=1e-4,
  delta_variance_minimum=0, valid_optimizer_status=0)

matrix_diagnostics <- function(x, prefix) {
  reasons <- character(); metrics <- list()
  put <- function(key,value) metrics[[paste0(prefix,'_',key)]] <<- value
  if(!is.matrix(x) || nrow(x)!=ncol(x) || nrow(x)<1 || any(!is.finite(x))) {
    return(list(valid=FALSE,reasons=paste0(prefix,'_not_finite_square'),metrics=setNames(list(FALSE),paste0(prefix,'_finite_square'))))
  }
  put('finite_square',TRUE)
  relative_asymmetry <- max(abs(x-t(x)))/max(1,max(abs(x)))
  put('relative_asymmetry',relative_asymmetry)
  if(relative_asymmetry>production_guard_spec$symmetry_relative_tolerance) reasons<-c(reasons,paste0(prefix,'_asymmetric'))
  symmetric <- (x+t(x))/2
  ev <- eigen(symmetric,symmetric=TRUE,only.values=TRUE)$values
  put('raw_min_eigenvalue',min(ev));put('raw_max_eigenvalue',max(ev))
  if(any(diag(symmetric)<=0)) {
    reasons<-c(reasons,paste0(prefix,'_nonpositive_diagonal'));put('scaled_min_eigenvalue',NA_real_);put('scaled_condition',Inf)
  } else {
    scale <- sqrt(diag(symmetric)); scaled_raw <- x/outer(scale,scale)
    scaled_asymmetry <- max(abs(scaled_raw-t(scaled_raw)))/max(1,max(abs(scaled_raw)))
    put('scaled_relative_asymmetry',scaled_asymmetry)
    if(scaled_asymmetry>production_guard_spec$symmetry_relative_tolerance) reasons<-c(reasons,paste0(prefix,'_scaled_asymmetric'))
    scaled <- symmetric/outer(scale,scale)
    sev <- eigen(scaled,symmetric=TRUE,only.values=TRUE)$values
    condition <- if(min(sev)>0) max(sev)/min(sev) else Inf
    put('scaled_min_eigenvalue',min(sev));put('scaled_condition',condition)
    if(min(sev)<=production_guard_spec$scaled_min_eigenvalue) reasons<-c(reasons,paste0(prefix,'_not_positive_definite'))
    if(!is.finite(condition) || condition>=production_guard_spec$scaled_max_condition) reasons<-c(reasons,paste0(prefix,'_ill_conditioned'))
  }
  list(valid=length(reasons)==0,reasons=reasons,metrics=metrics)
}

validate_production_fit <- function(estimates,status,objective,hessian,covariance,jacobian,
                                    expected_covariances,free_parameters,gradient=NULL) {
  reasons <- character(); metrics <- list(guard_version=production_guard_spec$version)
  if(length(status)!=1 || !is.finite(status) || status!=production_guard_spec$valid_optimizer_status) reasons<-c(reasons,'optimizer_status_not_zero')
  if(!length(estimates) || any(!is.finite(estimates))) reasons<-c(reasons,'nonfinite_estimate')
  if(!length(free_parameters) || any(!is.finite(free_parameters))) reasons<-c(reasons,'nonfinite_free_parameter')
  if(length(objective)!=1 || !is.finite(objective)) reasons<-c(reasons,'nonfinite_objective')
  if(!is.null(gradient)) {
    metrics$gradient_max_abs<-if(length(gradient)&&all(is.finite(gradient)))max(abs(gradient)) else NA_real_
    if(!length(gradient) || any(!is.finite(gradient)))reasons<-c(reasons,'nonfinite_gradient')
  }
  if(!is.list(expected_covariances)||!all(c('expected_MZ','expected_DZ') %in% names(expected_covariances)))reasons<-c(reasons,'expected_covariances_missing')
  matrix_list<-c(list(hessian=hessian,covariance=covariance),expected_covariances)
  for(name in names(matrix_list)) {
    d<-matrix_diagnostics(matrix_list[[name]],name);reasons<-c(reasons,d$reasons);metrics<-c(metrics,d$metrics)
  }
  dims_ok<-is.matrix(covariance)&&is.matrix(hessian)&&is.matrix(jacobian)&&
    nrow(covariance)==length(free_parameters)&&ncol(covariance)==length(free_parameters)&&
    identical(dim(hessian),dim(covariance))&&nrow(jacobian)==length(estimates)&&ncol(jacobian)==length(free_parameters)
  names_ok<-dims_ok && !is.null(names(free_parameters)) && !is.null(names(estimates)) &&
    identical(rownames(jacobian),names(estimates)) &&
    identical(colnames(jacobian),names(free_parameters))&&identical(rownames(covariance),names(free_parameters))&&
    identical(colnames(covariance),names(free_parameters))&&identical(rownames(hessian),names(free_parameters))&&
    identical(colnames(hessian),names(free_parameters))
  metrics$parameter_alignment_valid<-names_ok
  if(!names_ok) reasons<-c(reasons,'parameter_alignment_invalid')
  if(!is.matrix(jacobian)||any(!is.finite(jacobian)))reasons<-c(reasons,'nonfinite_jacobian')
  delta<-rep(NA_real_,length(estimates));se<-delta
  if(dims_ok&&all(is.finite(jacobian))&&all(is.finite(covariance))) {
    delta<-diag(jacobian%*%covariance%*%t(jacobian));metrics$delta_variance_min<-min(delta)
    if(any(!is.finite(delta)))reasons<-c(reasons,'nonfinite_delta_variance')
    if(any(delta<0,na.rm=TRUE))reasons<-c(reasons,'negative_delta_variance')
    se[is.finite(delta)&delta>=0]<-sqrt(delta[is.finite(delta)&delta>=0])
    if(any(!is.finite(se)) || any(se<=0,na.rm=TRUE)) reasons<-c(reasons,'nonpositive_or_nonfinite_se')
  }
  if(dims_ok&&all(is.finite(hessian))&&all(is.finite(covariance))) {
    # OpenMx objective is -2 log L: V = 2 H^{-1}, not H^{-1}.
    err<-max(abs(hessian%*%covariance/2-diag(nrow(hessian))))
    metrics$hessian_covariance_inverse_residual<-err
    if(!is.finite(err)||err>production_guard_spec$hessian_covariance_inverse_tolerance)reasons<-c(reasons,'hessian_covariance_inverse_mismatch')
  }
  list(valid=length(reasons)==0,reasons=unique(reasons),se=se,delta_variance=delta,metrics=metrics)
}

production_fit_rows <- function(fit,pars,jac,V,optimizer) {
  free<-omxGetParameters(fit);H<-fit$output$hessian
  # OpenMx stores hessian in output$estimate order; require explicit equality.
  estimate_order<-names(fit$output$estimate)
  if(is.matrix(H)&&is.null(rownames(H))&&identical(estimate_order,names(free)))dimnames(H)<-list(estimate_order,estimate_order)
  expected<-list(expected_MZ=mxEval(SMZ,fit),expected_DZ=mxEval(SDZ,fit))
  check<-validate_production_fit(pars,fit$output$status$code,fit$output$fit,H,V,jac,expected,free,fit$output$gradient)
  out<-data.frame(parameter=names(pars),estimate=as.numeric(pars),se=check$se,
    delta_variance=check$delta_variance,status=fit$output$status$code,
    minus2loglik=fit$output$fit,optimizer=optimizer,valid=check$valid,
    invalid_reasons=paste(check$reasons,collapse=';'),stringsAsFactors=FALSE)
  for(k in names(check$metrics))out[[k]]<-check$metrics[[k]]
  attr(out,'diagnostics')<-list(check=check,free_parameters=free,estimates=pars,hessian=H,
    covariance=V,jacobian=jac,expected_covariances=expected,output=fit$output,
    hessian_order=estimate_order,guard_spec=production_guard_spec)
  out
}
