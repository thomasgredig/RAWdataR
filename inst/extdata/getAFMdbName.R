#' AFM SQLite Database Name with Path
#'
#' @description
#' This data package does not include the AFM image data, which needs to be
#' installed separately. The SQL AFM data file should be stored locally in
#' a folder that is included in the list of folders in the inst/csv folder.
#'
#' @param dbPath path with AFM database
#'
#' @importFrom RAWdataR raw.getDatabase
#'
#' @author Thomas Gredig
#' @examples
#' getAFMdbName()
#'
#' @export
getAFMdbName <- function(dbPath = NULL) {
  raw.getDatabase('__PKG__NAME__', dbPath=dbPath)
}
