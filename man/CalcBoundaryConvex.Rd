% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{CalcBoundaryConvex}
\alias{CalcBoundaryConvex}
\title{Calculate Boundary Convexity}
\usage{
CalcBoundaryConvex(
  feature,
  windowSize,
  stepSize,
  fid,
  rid,
  filename = "",
  noRID = TRUE
)
}
\arguments{
\item{feature}{A NumericMatrix that holds the data of one feature from the given sf object.}

\item{windowSize}{A double describing the diameter of the window used to measure convexity.}

\item{stepSize}{A double describing the distance between measurements along an arc.}

\item{fid}{An integer that holds the current feature id.}

\item{rid}{A string that holds the unique route ID for the current feature.}

\item{filename}{A string denoting the name of the file you wish to output convexity data to.}

\item{noRID}{A boolean that denotes whether the given sf object has an RID column.}
}
\value{
matrix
}
\description{
Cpp function that calculates convexity of a single feature.
}
\details{
Cpp function that takes in a single feature from the given sf object and calculates raw convexity,
convexity index, and sinuosity of that feature. It formats convexity data into a NumericMatrix and outputs
it.
}
\keyword{internal}
