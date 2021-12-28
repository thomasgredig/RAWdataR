strsplit.max <- function(x,split,maxNo) {
  s = strsplit(x, split)[[1]]
  if (length(s)>maxNo) {
    q = unlist(s)[maxNo:length(s)]
    q1 = paste(q, collapse = split)
    s = c(unlist(s)[1:(maxNo-1)], q1)
  }
  s
}

# empty.table = data.frame(
#   Date = '',
#   Date.formatted = as.Date('19900101', format='%Y%m%d'),
#   Project = '',
#   User = '',
#   Instrument = NA,
#   Sample = '',
#   Description = '',
#   Extension = '',
#   Filename = ''
# )

#' splits filename into fields
#'
#' @param filename filename in RAW folder format
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
  # d1 = as.data.frame(t(sapply(filelist, FUN=function(x) { strsplit.max(x,'_',6) } )))
  # s = strsplit.max(filename,'_',6)
  # if (length(s)<6) {
  #   e = empty.table
  #   e$Filename = filename
  #   if (length(s)==5) {
  #     Extension = gsub('.*\\.([^.]+)$','\\1',s[5])
  #     sample =  gsub('(.*)\\.[^.]+$','\\1',s[5])
  #     q = strsplit.max(sample,'-',2)
  #     if(length(q)==2) {
  #       s[5] = q[1]
  #       desc = paste0(q[2],'.',Extension)
  #     } else {
  #       s[5] = sample
  #       desc = paste0('.',Extension)
  #     }
  #     e = data.frame(
  #       Date = s[1],
  #       Date.formatted = as.Date(s[1], format='%Y%m%d'),
  #       Project = s[2],
  #       User = s[3],
  #       Instrument = s[4],
  #       Sample = s[5],
  #       Description = gsub('(.*)\\.[^.]+$','\\1',desc),
  #       Extension = gsub('.*\\.([^.]+)$','\\1',desc),
  #       Filename = filename
  #     )
  #   }
  #   return(e)
  # }
  # data.frame(
  #   Date = s[1],
  #   Date.formatted = as.Date(s[1], format='%Y%m%d'),
  #   Project = s[2],
  #   User = s[3],
  #   Instrument = s[4],
  #   Sample = s[5],
  #   Description = gsub('(.*)\\.[^.]+$','\\1',s[6]),
  #   Extension = gsub('.*\\.([^.]+)$','\\1',s[6]),
  #   Filename = filename
  # )
# }
