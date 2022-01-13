strsplit.max <- function(x,split,maxNo) {
  s = strsplit(x, split)[[1]]
  if (length(s)>maxNo) {
    q = unlist(s)[maxNo:length(s)]
    q1 = paste(q, collapse = split)
    s = c(unlist(s)[1:(maxNo-1)], q1)
  }
  s
}


#' splits filename into fields
#'
#' @param filelist filename in RAW folder format
#' @importFrom tools file_ext
#' @return data frame
#' @examples
#' raw.splitFilename('20010101-project-user-inst-sample.DAT')
#'
#' @export
raw.splitFilename <- function(filelist) {
  d1 = as.data.frame(t(sapply(filelist, FUN=function(x) { strsplit.max(basename(x),'_',6) } )))
  rownames(d1) <- NULL
  names(d1) = c('Date','Project','User','Instrument','Sample','Description')
  d1$Extension = tools::file_ext(filelist)
  d1
}

