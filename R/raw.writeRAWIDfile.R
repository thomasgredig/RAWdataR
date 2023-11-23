#' Writes an RAW ID file with Header
#'
#' @param rID RAW ID data frame
#' @param header_list list to be saved
#' @param fIDfile filen ame RAW_ID.csv to be saved
#'
#'
#' @importFrom utils write.csv write.table
#' @importFrom methods is
#'
#' @export
raw.writeRAWIDfile <- function(rID, header_list, fIDfile) {
  write.csv(rID, file=fIDfile, row.names = FALSE)

  if (!is(header_list,"list")) stop("header_list must be a list()")
  # add meta information
  # header_data = c("# head: test", "# num: 10")
  header_data = c()
  for(keys in names(header_list)) {
    header_data = c(header_data,
                    paste("#", keys, ":", header_list[[keys]]))
  }
  write.table(header_data, file=fIDfile,
              append=TRUE, quote=FALSE,
              col.names = FALSE, row.names = FALSE)
}
