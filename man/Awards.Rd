% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{Awards}
\alias{Awards}
\alias{df_Hugo}
\alias{df_Nebula}
\alias{df_Clarke}
\alias{df_World_Fantasy}
\title{Awards Data}
\format{
Tibbles with columns:
\describe{
\item{Year}{The Year the work was nominated}
\item{Won}{Did the work win the award?}
\item{Title}{The title of the work}
\item{Author1, Author2, ...}{The author(s) of the works, split over multiple columns}
}

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 381 rows and 5 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 359 rows and 5 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 217 rows and 4 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 255 rows and 6 columns.
}
\usage{
df_Hugo

df_Nebula

df_Clarke

df_World_Fantasy
}
\description{
Tibbles with award nominee data from Wikipedia
}
\keyword{datasets}
