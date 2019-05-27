strsplit.max <- function(x,split,maxNo) {
  s = strsplit(x, split)[[1]]
  if (length(s)>maxNo) {
    q = unlist(s)[maxNo:length(s)]
    q1 = paste(q, collapse = split)
    s = c(unlist(s)[1:(maxNo-1)], q1)
  }
  s
}

empty.table = data.frame(
  Date = '',
  Date.formatted = as.Date('20171006', format='%Y%m%d'),
  Project = '',
  User = '',
  Instrument = NA,
  Sample = '',
  Description = '',
  Filename = ''
)

#' splits filename into fields
#'
#' @param filename filename in RAW folder format
#' @return data frame
#' @examples
#' raw.splitFilename('20010101-project-user-inst-sample.DAT')
#'
#' @export
raw.splitFilename <- function(filename) {
  s = strsplit.max(filename,'_',6)
  if (length(s)<6) {
    e = empty.table
    e$Filename = filename
    if (length(s)==5) {
      e = data.frame(
        Date = s[1],
        Date.formatted = as.Date(s[1], format='%Y%m%d'),
        Project = s[2],
        User = s[3],
        Instrument = s[4],
        Sample = s[5],
        Description = '  ??  ',
        Filename = filename
      )
    }
    return(e)
  }
  data.frame(
    Date = s[1],
    Date.formatted = as.Date(s[1], format='%Y%m%d'),
    Project = s[2],
    User = s[3],
    Instrument = s[4],
    Sample = s[5],
    Description = s[6],
    Filename = filename
  )
}
