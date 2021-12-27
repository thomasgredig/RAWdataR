#' Sample path to RAW folder
#'
#' Returns a path with several sample files to check validity of
#' filenames.
#'
#' @return path with sample RAW files
#' @examples
#' raw.getSamplePath()
#' @export
raw.getSamplePath <- function() {
  system.file("extdata",package="RAWdataR")
}

#' Sample Files from RAW folder
#'
#' Returns a list of filenames to a sample RAW folder
#'
#' @return list of filenames including path
#' @examples
#' raw.getSampleFiles()
#' @export
raw.getSampleFiles<- function() {
  file.path(raw.getSamplePath(),dir(raw.getSamplePath()))
}
