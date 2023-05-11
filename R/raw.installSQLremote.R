#' Install SQL AFM Database from Remote Site
#'
#' @description
#' Installs a large SQL AFM database from a remote site; in order
#' for data R packages to load more quickly and not take up large
#' space on GitHub; it can separately store the AFM images in a
#' SQL database, which can usually be the size of about 1 GB. This
#' database is stored in the `inst/extdata` data folder. First,
#' create an empty SQL database file in the inst/extdata folder
#'
#'
#' @return logical, \code{TRUE}, if SQL db exists or was successfully installed
#'
#'
#' @param dbName file name of the SQL db package
#' @param targetDir target directory to install, usually `inst/extdata`
#' @param urlREPO URL of directory with repository of SQL database
#'
#' @return path and file name of installed SQL database
#'
#' @export
raw.installSQLremote <- function(dbName, targetDir, urlRepo) {
  status = FALSE

  # check that report file exists
  sourceURL = paste0(urlRepo,'/',dbName)
  con <- url(sourceURL)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=2),silent=T)[1])
  suppressWarnings(try(close.connection(con),silent=T))
  urlExists = ifelse(is.null(check),TRUE,FALSE)

  if(urlExists) {
    check <- download.file(url=sourceURL,
                           destfile=file.path(targetDir,dbName),
                           method='curl')
    status = TRUE
  } else {
    warning("Target repository does not exist: ", sourceURL)
  }
  status
}
