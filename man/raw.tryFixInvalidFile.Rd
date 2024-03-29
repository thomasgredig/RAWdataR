% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raw.tryFixInvalidFile.R
\name{raw.tryFixInvalidFile}
\alias{raw.tryFixInvalidFile}
\title{suggests a new filename for an invalid filename}
\usage{
raw.tryFixInvalidFile(
  pfad,
  filename,
  project = "xx",
  user = "unknown",
  guessSample = FALSE
)
}
\arguments{
\item{pfad}{path of RAW folder}

\item{filename}{filename in RAW folder}

\item{project}{project name if known}

\item{user}{2 or 3 letter user initials}

\item{guessSample}{TRUE/FALSE to add sample name}
}
\value{
string with suggested filename
}
\description{
suggests a new filename for an invalid filename
}
\examples{
fname = raw.getInvalidFiles(raw.getSamplePath())[1]
raw.tryFixInvalidFile(pfad = raw.getSamplePath(),filename = fname)
}
