# (c) 2018 Thomas Gredig
# Date: 2018-11-21
#' remove duplicate RAW files
#'
#' @param pfad path to search for duplicate files
#' @return
raw.removeDuplicateFiles <- function(pfad) {
  data.file = 'extra-raw-files-2018-11-21.csv'
  data.file = 'all-raw-files-2018-11-21.csv'
  warning("Not implemented yet.")

  d = read.csv(file.path(pfad,data.file), stringsAsFactors = FALSE)
  d = na.omit(d)

  file.list.delete = d$name[which(d$delete==TRUE)]
  r = c()
  for(f in file.list.delete) {
    r=c(r,paste('DELETE: ',f))
  }
  r
}
