#' returns approximate number of samples that were made
#'
#' @param pfad path to the RAW folder
#' @param underscoreComments include files with comments that have _
#' @return number of samples that were made with the NTE
#' @examples
#' raw.getNoSamples(raw.getSamplePath())
#'
#' @export
raw.getNoSamples <- function(pfad, underscoreComments=TRUE) {
  file.list = raw.findFiles(pfad, instrument='NTE', underscoreComments)
  length(file.list)
}
