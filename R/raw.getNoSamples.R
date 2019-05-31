#' returns number of samples that were made
#'
#' @param pfad path to the RAW folder
#' @return number of samples that were made with the NTE
#' @examples
#' raw.getNoSamples('.')
#'
#' @export
raw.getNoSamples <- function(pfad) {
  file.list = dir(pfad,pattern='^[^_]')
  length(grep('NTE\\_',file.list))
}
