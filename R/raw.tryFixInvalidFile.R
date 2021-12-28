#' suggests a new filename for an invalid filename
#'
#' @param pfad path of RAW folder
#' @param filename filename in RAW folder
#' @param project project name if known
#' @param user 2 or 3 letter user initials
#' @param guessSample TRUE/FALSE to add sample name
#' @return string with suggested filename
#' @examples
#' raw.tryFixInvalidFile(pfad = raw.getSamplePath(),
#'        filename = raw.getInvalidFiles(raw.getSamplePath())[1])
#'
#' @export
raw.tryFixInvalidFile <- function(pfad, filename,
                                  project='xx',
                                  user='unknown',
                                  guessSample = FALSE) {
  instr.list = c('AFM','XRD','NTE','XRD','XRD','PPMS',
                 'VSM')
  fext = c('nid','ras','txt','asc','raw','seq',
           'dat')

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


  n = grep(tolower(tools::file_ext(filename)), fext)
  inst = 'XXX'
  if (length(n)>0) {
    inst = instr.list[n]
  }

  n = grep(inst,filename, ignore.case = TRUE)
  if (length(n)>0) {
    gsub(inst,'',filename, ignore.case = TRUE) -> filename
  }
  gsub('_','-',filename) -> filename

  if (guessSample==TRUE) {
    # sample.name = gsub('(.*)([A-Z]{2}[[:digit:]]{2,}[[:lower:]]*)(.*)','\\1_\\2\\3',filename)
    filename = gsub('(.*)([A-Z]{2}[[:digit:]]{2,}[[:lower:]]*)(.*)','\\2_\\1\\3',filename)
    filename = gsub('_-','_',filename)
#    if (length(sample.name)>0 && length(sample.name)<10) {
#      filename = paste0(sample.name,'_',gsub(sample.name,'',filename))
#    }
  }
  gsub('__','_',filename) -> filename
  gsub('^-','',filename) -> filename
  gsub('\\s+','',filename) -> filename

  paste0(dt,'_',project,'_',user,'_',inst,'_',filename)
}
