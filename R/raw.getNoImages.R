#' returns the number of images
#'
#' @param pfad path to the RAW folder
#' @return number of images
#' @examples
#' raw.getNoImages(raw.getSamplePath())
#'
#' @export
raw.getNoImages <- function(pfad) {
  file.list = tolower(dir(pfad))
  length(grep('jpg$', file.list)) +
    length(grep('png$', file.list)) +
    length(grep('tiff$', file.list)) +
    length(grep('eps$', file.list)) +
    length(grep('jpeg$', file.list))
}
