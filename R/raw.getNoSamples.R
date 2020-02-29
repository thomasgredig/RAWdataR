#' returns approximate number of samples that were made
#'
#' @param pfad path to the RAW folder
#' @return number of samples that were made with the NTE
#' @examples
#' raw.getNoSamples('.')
#'
#' @export
raw.getNoSamples <- function(pfad) {
  file.list = raw.findFiles(pfad, instrument='NTE')
  length(file.list)
}
