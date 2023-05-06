#' Install SQL AFM Database from Remote Site
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
  dataAFM.filenameSQL <- file.path(system.file(package = pkgname),
                                   'extdata',baseSQLfile)


  if (!file.exists(dataAFM.filenameSQL)) {
    # try to download it
    sourceURL = paste0(urlREPO,basename(dataAFM.filenameSQL))

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
