#' check whether a RAW data file has a valid filename
#'
#' @param filename name of file
#' @return returns \code{TRUE} if name has a valid format
#' @examples
#' raw.isValid(raw.getSampleFiles())
#'
#' @export
raw.isValid <- function(filename) {
  filename = basename(filename)   # make sure no path information included
  grepl("^(\\d{8})_(\\S*?)_(\\S*?)_(\\S*?)_(.*)\\.(.*)$",filename, perl=TRUE)
}



raw.validateFiles <- function(file.list, underscoreComments) {
  f1 = file.list[raw.isValid(file.list)]
  # f1 = file.list[sapply(strsplit(file.list,'_'),length)>=5]
  # if (underscoreComments==TRUE) {
  #   f1
  # } else {
  #   f1[sapply(strsplit(f1,'_'),length)<=6]
  # }
}
