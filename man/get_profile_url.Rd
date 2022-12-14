% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_profile_url.R
\name{get_profile_url}
\alias{get_profile_url}
\title{Get and validate a Goodreads profile URL}
\usage{
get_profile_url(name)
}
\arguments{
\item{name}{either a username or url}
}
\value{
Character vector of length 1, a valid URL of a Goodreads profile
}
\description{
Get and validate a Goodreads profile URL
}
\examples{
# When supplied a valid username, returns the corresponding URL
get_profile_url("bookononism")

# When supplied a URL, validates that it is a valid Goodreads profile
get_profile_url("https://www.goodreads.com/user/show/98834377-james")
}
