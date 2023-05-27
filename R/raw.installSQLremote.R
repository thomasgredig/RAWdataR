#' Install SQL AFM Database from Remote Site
#'
#' @description
#' Installs a large SQL AFM database from a remote site; in order
#' for data R packages to load more quickly and not take up large
#' space on external repositories, this function implements a solution
#' that stores the database remotely. When needed, it will be installed
#' locally in the `extdata/` folder. The function returns the name of
#' the database.
#'
#' If new data is added to the SQL databse, a new version is generally
#' generated; this can be done by upgrading from an existing old version.
#'
#'
#' @param pkgname file name of the SQL db package
#' @param urlREPO URL or PATH of directory with repository of SQL database
#' @param upgradeFrom old version, string such as "0.2.1", black if not an upgrade
#'
#' @return SQL database filename and path
#'
#' @export
raw.installSQLremote <- function(pkgname, urlRepo, upgradeFrom = "") {
  # determine directory for SQL DB
  targetDir = file.path(system.file(package=pkgname), 'extdata')
  if (!dir.exists(targetDir)) stop("Package ",pkgname," not installed or extdata folder not found at:",targetDir)

  # determine file name for SQL DB
  pkgVersion = as.character(packageVersion(pkgname))
  if (upgradeFrom=="") upgradeFrom = pkgVersion
  baseSQLnew = paste0(pkgname,"AFM_",pkgVersion,".sqlite")
  baseSQLupgrade = paste0(pkgname,"AFM_",upgradeFrom,".sqlite")

  dbSQL = file.path(targetDir, baseSQLupgrade)
  dbSQLnew = file.path(targetDir, baseSQLnew)

  # download file, if needed
  if (!file.exists(dbSQLnew)) {

    # check that URL has SQL
    sourceURL = paste0(urlRepo,'/',baseSQLupgrade)
    if (!grepl("^http",sourceURL)) {
      # It is a PATH
      sourceURL = file.path(urlRepo,baseSQLupgrade)
      if (file.exists(sourceURL)) {
        file.copy(from=sourceURL, to=dbSQL)
        if (!(upgradeFrom == "")) file.rename(from = dbSQL, to = dbSQLnew)
      }
    } else {
      # It is a URL
      con <- url(sourceURL)
      check <- suppressWarnings(try(open.connection(con,open="rt",timeout=2),silent=T)[1])
      suppressWarnings(try(close.connection(con),silent=T))
      urlExists = ifelse(is.null(check),TRUE,FALSE)

      # URL is verified, then download
      if(urlExists) {
        check <- download.file(url=sourceURL,destfile=dbSQL,method='curl')
        # rename required during upgrade??
        if (!(upgradeFrom == "")) file.rename(from = dbSQL, to = dbSQLnew)
      }
    }
  }

  dbSQLnew
}
