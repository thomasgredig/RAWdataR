#' Full Path of RAW-ID File
#'
#' @description
#' The RAW-ID file is a CSV file with all the unique IDs and MD5 check sums
#' of the data files. This function guesses the location or returns it.
#'
#' @param pRESULTS path for the RAW ID file
#' @param idFile name for the RAW-ID file, usually, this is RAW-ID.csv
#' @param ... verbose logical
#'
#' @examples
#' ##This may create a new directory
#' raw.RAWIDfile()
#'
#' @export
raw.RAWIDfile <- function(pRESULTS = 'data-raw', idFile = 'RAW-ID.csv', ...) {
  if (dir.exists(pRESULTS)) return(file.path(pRESULTS, idFile))
  # directory does not exist, try to make it.
  dir.create(pRESULTS, recursive = TRUE)
  file.path(pRESULTS, idFile)
}
