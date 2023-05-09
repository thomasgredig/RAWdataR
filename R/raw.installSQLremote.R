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
#' @param pkgname name of the package
#' @param urlREPO URL of directory with repository of SQL database
#'
#' @return path and file name of installed SQL database
#'
#' @export
raw.installSQLremote <- function(pkgname, urlREPO) {
  status = FALSE # returns TRUE if SQL is installed or was installed
  # check that package is installed
  if (system.file(package = pkgname)=="") stop("Package ",pkgname," is not installed.")

  # check for SQL AFM database
  # ==========================
  # create the version specific SQL filename
  baseSQLfile = paste0(pkgname,"AFM_",
                       as.character(packageVersion(pkgname)),
                       ".sqlite")
  # find the place holder file
  dataAFM.filenameSQL <- system.file('extdata', paste0(baseSQLfile,'.txt'), package = pkgname)
  # warning("Package: ", pkgname, " Base: ", baseSQLfile)
  # warning("Found: ",dataAFM.filenameSQL)

  # need to have a place holder to get the directory
  if (dataAFM.filenameSQL == "") {
    # the package should have a dummy SQL file in place
    warning("Package ", pkgname, " does not have place holder SQL filename in inst/extdata folder. ",
            "Create empty place holder file in that package: file.create('inst/extdata/",baseSQLfile,".txt')")
  } else {
    # is the DB available already?
    # warning("Found SQL: ", system.file('extdata', baseSQLfile, package = pkgname))
    if (system.file('extdata', baseSQLfile, package = pkgname) == "") {
      # fix dataAFM.filenameSQL
      gsub('\\.txt$','',dataAFM.filenameSQL) -> dataAFM.filenameSQL
      # try to download it
      sourceURL = paste0(urlREPO,'/',baseSQLfile)

      # determine if file is found
      con <- url(sourceURL)
      check <- suppressWarnings(try(open.connection(con,open="rt",timeout=2),silent=T)[1])
      suppressWarnings(try(close.connection(con),silent=T))
      urlExists = ifelse(is.null(check),TRUE,FALSE)

      if(urlExists) {
        warning("Install SQL Db to: ", dataAFM.filenameSQL)
        check <- download.file(url=sourceURL,
                      destfile=dataAFM.filenameSQL,
                      method='curl')
      } else {
        warning("URL not valid: ", sourceURL)
      }
      if (check==0) status = TRUE
    } else {
      # SQL database is already installed
      status = TRUE
    }
  }

  status
}
