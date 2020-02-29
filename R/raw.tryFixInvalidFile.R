#' suggests a new filename for an invalid filename
#'
#' @param pfad path of RAW folder
#' @param filename filename in RAW folder
#' @param project project name if known
#' @param user 2 or 3 letter user initials
#' @return string with suggested filename
#' @examples
#' raw.tryFixInvalidFile('.',dir('.')[1])
#'
#' @export
raw.tryFixInvalidFile <- function(pfad, filename, project='xx', user='unknown') {
  instr.list = c('AFM','XRD','NTE','XRD','XRD')
  fext = c('nid','ras','txt','asc','raw')

  dt = format(as.Date(file.info(file.path(pfad,filename))$mtime),
              format = '%Y%m%d')
  if (length(grep('.*20\\d{6}.*',filename))>0) {
    dt = gsub('.*(20\\d{6}).*','\\1',filename)
    gsub('20\\d{6}','',filename) -> filename
  }
  if (length(grep('.*\\d{2}-\\d{2}-\\d{2}.*',filename))>0) {
    dt = gsub('.*(\\d{2})-(\\d{2})-(\\d{2}).*','20\\3\\1\\2',filename)
    gsub('\\d{2}-\\d{2}-\\d{2}','',filename) -> filename
  }


  n = grep(tolower(file_ext(filename)), fext)
  inst = 'XXX'
  if (length(n)>0) {
    inst = instr.list[n]
  }

  n = grep(inst,filename, ignore.case = TRUE)
  if (length(n)>0) {
    gsub(inst,'',filename, ignore.case = TRUE) -> filename
  }
  gsub('__','_',filename) -> filename
  gsub('_','-',filename) -> filename
  gsub('^-','',filename) -> filename
  gsub('\\s+','',filename) -> filename

  paste0(dt,'_',project,'_',user,'_',inst,'_',filename)
}

