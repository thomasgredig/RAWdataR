#' returns a list of files provided the search criteria
#'
#' @param pfad path of RAW files
#' @param project name of project
#' @param date date in format YYYYMMDD
#' @param user 2 initials for user
#' @param instrument name of instrument, such as 'vsm'
#' @param sample sample name
#' @param md5 single string with comma separated abbreviated MD5 sums
#' @param fullPath if TRUE, returns full path, otherwise filename only
#' @param underscoreComments if TRUE, comments can have underscores
#' @return list with filenames with certain checksum
#' @examples
#' pfad = raw.getSamplePath()
#' file.list = raw.findFiles(pfad, date='201606')  # all files from Jan 2019
#' print(file.list)
#' md5String = raw.getMD5str(file.list)
#' file.list = raw.findFiles(pfad, md5 = md5String)
#' print(file.list)
#' @export
raw.findFiles <- function(pfad, project='.*', date='.*',
                          user='.*', instrument='.*',
                          sample='.*',md5='',
                          fullPath = TRUE,
                          underscoreComments = TRUE) {
  if ((date!='.*') & (nchar(date)<8)) { date=paste0(date,'.*') }
  muster = paste0(date, '_',project,'_',user,'_',instrument,'_',sample)
  f = raw.validateFiles(dir(pfad, pattern=muster, ignore.case = TRUE), underscoreComments)
  # check MD5 of those files and return only those files that agree
  if(nchar(md5)>0) {
    md5v = strsplit(md5,',')[[1]] # verify that those are the files
    f1 = file.path(pfad,f)
    m2 = strsplit(raw.getPartialMD5str(f1),',')[[1]]
    f=f[duplicated(c(md5v,m2))[(length(md5v)+1):(length(md5v)+length(m2))]]
  }
  if (fullPath == TRUE) { f = file.path(pfad, f) }
  f
}

raw.validateFiles <- function(file.list, underscoreComments) {
  f1 = file.list[sapply(strsplit(file.list,'_'),length)>=5]
  if (underscoreComments==TRUE) {
    f1
  } else {
    f1[sapply(strsplit(f1,'_'),length)<=6]
  }
}
