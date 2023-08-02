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
#' @importFrom utils packageVersion
#'
#' @return SQL database filename and path
#'
#' @export
raw.getDatabase <- function(pkgname, dbPath = NULL, verbose = FALSE) {
  dbFolderListFile <- "database-folders.csv"
  dbFile <- NULL

  if (!nzchar(system.file(package = pkgname))) {
    if (verbose) cat("Package", pkgname,"not installed.")
    return (NULL)
  }
  pkgVersion = as.character(packageVersion(pkgname))
  dbFileName = paste0(pkgname,"-",pkgVersion,".sqlite")
  if (verbose) cat("SQL Database filename:", dbFileName,"\n")

  # possible file locations to check:
  dbSearchPaths = c(".")

  if (!is.null(dbPath)) {
    dbSearchPaths = c(dbSearchPaths, dbPath)
  }

  # Search for location of
  srcFile <- system.file("csv", dbFolderListFile, package=pkgname)
  if (nchar(srcFile)==0) srcFile <- system.file(dbFolderListFile, package=pkgname)
  if (nchar(srcFile)==0) srcFile <- system.file(file.path('inst','csv'), dbFolderListFile, package=pkgname)

  if (nchar(srcFile) > 0) {
    # Read all lines from the file
    dbFolders <- readLines(srcFile,warn = FALSE)
    for(dbFolder in dbFolders) {
      if (dir.exists(dbFolder)) dbSearchPaths = c(dbSearchPaths, dbFolder)
    }
  } else {
    if (verbose) cat("Could not find database folder list ",dbFolderListFile," in package ", pkgname, "\n",
                     "Searched:", system.file("csv", package=pkgname),"and",
                     system.file(package=pkgname),"\n")
  }

  if (verbose) cat("Searching", length(dbSearchPaths), "folders.\n")

  for(pfad in dbSearchPaths) {
    dbFileCheck <- file.path(pfad,dbFileName)
    if (file.exists(dbFileCheck)) { dbFile <- dbFileCheck } else {
      dbFileNameAlternative = dir(pfad, pattern=paste0(pkgname,'.*sqlite$'))
      if (length(dbFileNameAlternative)>0) dbFile <- file.path(pfad, dbFileNameAlternative[1])
    }
  }

  dbFile
}
