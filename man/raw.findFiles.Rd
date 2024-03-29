% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raw.findFiles.R
\name{raw.findFiles}
\alias{raw.findFiles}
\title{returns a list of files provided the search criteria}
\usage{
raw.findFiles(
  pfad,
  project = "[^_]+",
  date = "[^_]+",
  user = "[^_]+",
  instrument = "[^_]+",
  sample = "[^_]+",
  md5 = "",
  fullPath = TRUE,
  recursive = FALSE
)
}
\arguments{
\item{pfad}{path of RAW files}

\item{project}{name of project}

\item{date}{date in format YYYYMMDD}

\item{user}{2 initials for user}

\item{instrument}{name of instrument, such as 'vsm'}

\item{sample}{sample name}

\item{md5}{single string with comma separated abbreviated MD5 sums}

\item{fullPath}{if \code{TRUE}, returns full path, otherwise filename only}

\item{recursive}{if \code{TRUE}, also searchs subfolders}
}
\value{
list with filenames with certain checksum
}
\description{
returns a list of files provided the search criteria
}
\examples{
pfad = raw.getSamplePath()
file.list = raw.findFiles(pfad, date='201606')  # all files from June 2019
print(basename(file.list))
md5String = raw.getMD5str(file.list)
file.list = raw.findFiles(pfad, md5 = md5String)
print(basename(file.list))
}
