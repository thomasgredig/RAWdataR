#' Writes an RAW ID file with Header
#'
#' @param rID RAW ID data frame
#' @param header_list list to be saved
#' @param fIDfile filen ame RAW_ID.csv to be saved
#'
#'
#' @importFrom utils write.csv write.table
#'
#' @export
raw.writeRAWIDfile <- function(rID, header_list, fIDfile) {
  write.csv(rID, file=fIDfile, row.names = FALSE)
  raw.writeRAWIDheader(header_list, fIDfile)
}

#' Writes a RAW ID Header
#'
#' @param header_list list to be saved
#' @param fIDfile filen ame RAW_ID.csv to be saved
#'
#' @importFrom utils write.table
#' @importFrom methods is
#'
#' @export
raw.writeRAWIDheader <- function(header_list, fIDfile) {
  if (!is(header_list,"list")) stop("header_list must be a list()")
  # add meta information
  # header_data = c("# head: test", "# num: 10")
  header_data = c()
  for(keys in names(header_list)) {
    v = header_list[[keys]]
    if (length(v) > 1) v = paste(v,collapse = ";") ## serialize vectors
    header_data = c(header_data, paste("#", keys, ":", v))
  }
  write.table(header_data, file=fIDfile,
              append=TRUE, quote=FALSE,
              col.names = FALSE, row.names = FALSE)
}
