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
  substr(filename,1,8) -> q
  td = !is.na(as.Date(q, format='%Y%m%d'))
  tf = grepl("^(\\d{8})_(\\S*?)_(\\S*?)_(\\S*?)_(.*)\\.(.*)$",filename, perl=TRUE)

  td & tf
}



raw.validateFiles <- function(file.list) {
  f1 = file.list[raw.isValid(file.list)]
}
