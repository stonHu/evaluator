% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/openfair.R
\name{get_mean_control_strength}
\alias{get_mean_control_strength}
\title{Calculate difficulty strength across multiple controls by taking the mean}
\usage{
get_mean_control_strength(n, diff_estimates)
}
\arguments{
\item{n}{Number of threat events to sample controls across.}

\item{diff_estimates}{Parameters to pass to \code{\link{sample_diff}}.}
}
\value{
Vector of control effectiveness.
}
\description{
Given a set of estimation parameters, calculate control strength as the
arithmetic mean of sampled control effectiveness.
}
\seealso{
Other OpenFAIR helpers: \code{\link{compare_tef_vuln}},
  \code{\link{openfair_tef_tc_diff_lm}},
  \code{\link{sample_diff}}, \code{\link{sample_lef}},
  \code{\link{sample_lm}}, \code{\link{sample_tc}},
  \code{\link{sample_tef}}, \code{\link{sample_vuln}},
  \code{\link{select_loss_opportunities}}
}
