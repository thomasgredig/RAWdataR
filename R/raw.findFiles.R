#' returns a list of files provided the search criteria
#'
#' @param pfad path of RAW files
#' @param project name of project
#' @param date date in format YYYYMMDD
#' @param user 2 initials for user
#' @param instrument name of instrument, such as 'vsm'
#' @param sample sample name
#' @param md5 single string with comma separated abbreviated MD5 sums
#' @return list with filenames with certain checksum
#' @examples
#' file.list = raw.findFiles(pfad, date='201901')  # all files from Jan 2019
#' md5String = raw.getPartialMD5str(file.list)
#' file.list = raw.findFiles(pfad, date='201901',md5 = md5String)
#'
#' @export
raw.findFiles <- function(pfad, project='.*', date='.*',
                          user='.*', instrument='.*',
                          sample='.*',md5='') {
  if ((date!='.*') & (nchar(date)<8)) { date=paste0(date,'.*') }
  muster = paste0(date, '_',project,'_',user,'_',instrument,'_',sample)
  f = raw.validateFiles(dir(pfad, pattern=muster, ignore.case = TRUE))
  # check MD5 of those files and return only those files that agree
  if(nchar(md5)>0) {
    md5v = strsplit(md5,',')[[1]] # verify that those are the files
    f1 = file.path(pfad,f)
    m2 = strsplit(raw.getPartialMD5str(f1),',')[[1]]
    f=f[duplicated(c(md5v,m2))[(length(md5v)+1):(length(md5v)+length(m2))]]
  }
  f
}

raw.validateFiles <- function(file.list) {
  file.list[sapply(strsplit(file.list,'_'),length)==6]
}
