#' Manage SQL Database with Data Package
#'
#' @description
#' Some data packages require large amounts of data (1 - 10GB), which cannot be
#' stored in the `extdata` folder directly, since the install would take too long.
#' If data exceeds about 10 MB, then RDA files become inefficient, and an SQL
#' database makes sense. For AFM data, you can use AFM.writeDB() for example.
#'
#' The database needs to be stored in the `extdata` and also needs to be version
#' controlled. This function helps manage this process. The data package generates
#' the small RDA data files and puts the large data files into the SQL databse
#' that is stored in the main directory of the database. The database needs to store
#' at least one more dummy file in the `inst/extdata` folder, so that this folder
#' is generated and loaded.
#'
#' When called with the `pkgname`, the function uses the version to generate the
#' database filename and return its path.
#'
#' @param pkgname name of the R data package
#'
#' @return SQL database filename and path
#'
#' @export
raw.getDatabase <- function(pkgname, dbImportPath = NULL, searchForOldDB = FALSE) {
  # Make sure R data package exists
  if (is.na(packageDescription(pkgname))) return(NULL)

  # Generate the database filename
  pkgVersion = as.character(packageVersion(pkgname))
  dbFilename = paste0(pkgname,"-",pkgVersion,".sqlite")
  dbPath = system.file('extdata',package=pkgname)
  dbFile = file.path(dbPath, dbFilename)

  # Check whether the database needs to be installed from a local version
  if (!is.null(dbImportPath)) {
    dbSource = file.path(dbImportPath, dbFilename)
    if (file.exists(dbSource)) {
      file.copy(from=dbSource,
                to = file.path(dbPath, dbFilename))
    }
    else warning("Cannot import file.")
  }


  if (!file.exists(dbFile)) warning("Current version of AFM DB file not found:",dbFile)

  if ((searchForOldDB) & (!file.exists(dbFile))) {
    warning("Searching for alternative DB file.")
    # check if there is an older version

    oldFiles = c(dir(path=dbPath, pattern=paste0(pkgname,"*.\\.sqlite")),
                 dir(path=here::here(), pattern=paste0(pkgname,"*.\\.sqlite")))
    if (length(oldFiles)>0) dbFile = file.path(dbPath, oldFiles[1]) else warning("No AFM SQL Database found. Install DB with raw.getDatabase(pkgname='",pkgname,"',dbImportPath='.')")

  }

  dbFile
}
