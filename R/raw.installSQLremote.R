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
#' @param pkgname name of the package
#' @param urlREPO URL of directory with repository of SQL database
#'
#' @return path and file name of installed SQL database
#'
#' @export
raw.installSQLremote <- function(pkgname, urlREPO) {
  # check that package is installed
  if (system.file(package = pkgname)=="") stop("Package ",pkgname," is not installed.")

  # check for SQL AFM database
  # ==========================
  # create the version specific SQL filename
  baseSQLfile = paste0(pkgname,"AFM_",
                       as.character(packageVersion(pkgname)),
                       ".sqlite")
  # dataAFM.filenameSQL <- file.path(system.file(package = pkgname),
  #                                  'extdata',baseSQLfile)
  dataAFM.filenameSQL <- system.file('extdata', baseSQLfile, package = pkgname)

  if (dataAFM.filenameSQL == "") {
    # try to download it
    sourceURL = paste0(urlREPO,baseSQLfile)

    # determine if file is found
    con <- url(sourceURL)
    check <- suppressWarnings(try(open.connection(con,open="rt",timeout=2),silent=T)[1])
    suppressWarnings(try(close.connection(con),silent=T))
    urlExists = ifelse(is.null(check),TRUE,FALSE)

    if(urlExists) {
      check <- download.file(url=sourceURL,
                    destfile=dataAFM.filenameSQL,
                    method='curl')
    }
    if (check!=0) dataAFM.filenameSQL = ""
  }

  dataAFM.filenameSQL
}
