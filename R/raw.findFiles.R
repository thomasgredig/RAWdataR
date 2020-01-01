#' returns a list of files provided the search criteria
#'
#' @param file.list path of RAW files
#' @param project name of project
#' @param date date in format YYYYMMDD
#' @param user 2 initials for user
#' @param instrument name of instrument, such as 'vsm'
#' @param sample sample name
#' @param md5
#' @return filename with certain checksum
#' @examples
#' raw.findFiles(pfad, date='2020')  # all files from 2020
#'
#' @export
raw.findFiles <- function(pfad, project='.*', date='.*',
                          user='.*', instrument='.*',
                          sample='.*',md5='') {
  if ((date!='.*') & (nchar(date)<8)) { date=paste0(date,'.*') }
  muster = paste0(date, '_',project,'_',user,'_',instrument,'_',sample)
  f = raw.validateFiles(dir(pfad, pattern=muster, ignore.case = TRUE))
  # check MD5 of those files and return only those files that agree
  if(length(md5)>0) {
    md5v = strsplit(md5,',')[[1]] # verify that those are the files
    m2 = strsplit(raw.getPartialMD5str(f),',')[[1]]
    f=f[duplicated(c(md5v,m2))[(length(md5v)+1):(length(md5v)+length(m2))]]
  }
  f
}

raw.validateFiles <- function(file.list) {
  file.list[sapply(strsplit(file.list,'_'),length)==6]
}
