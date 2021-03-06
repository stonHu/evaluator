% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/common_graphs.R
\name{generate_heatmap}
\alias{generate_heatmap}
\title{Display a heatmap of impact by domain}
\usage{
generate_heatmap(domain_impact)
}
\arguments{
\item{domain_impact}{Domain impact information from \code{calculate_domain_impact}.}
}
\value{
A ggplot object.
}
\description{
Given a domain_summary and a list of all domains, generate a heatmap colored
by the 95% VaR. This plot displays the domains in which aggregreate risk is
greater than others.
}
\examples{
dat <- calculate_domain_impact(domain_summary, domains)
generate_heatmap(dat)
}
