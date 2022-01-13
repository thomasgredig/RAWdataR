#' Fix invalid data filename
#'
#' @param filename name of file
#' @param addProject project to be added
#' @param addInstrument instrument to be added
#' @param addUser user to be added
#' @param addSample sample to be added
#' @param renameFile if \code{TRUE} file will be renamed
#' @return returns fixed filenames
#' @examples
#' f = raw.findFiles(raw.getSamplePath(), instrument='MM160622SI1')
#' print(f)
#' f.new = raw.fixInvalidFile(f, addInstrument='vsm')
#' print(paste("Old name:",f))
#' print(paste("New name:",f.new))
#' @export
raw.fixInvalidFile <- function(filename, addInstrument='', addUser='',
                               addProject='', addSample='',
                               renameFile=FALSE) {
  p = dirname(filename)
  f.old=filename
  f = basename(filename)
  fs = strsplit(f, '_')
  if (nchar(addProject)>0)
    fs = lapply(fs, function(x) { append(x, addProject, after = 1) } )
  if (nchar(addUser)>0)
    fs = lapply(fs, function(x) { append(x, addUser, after = 2) } )
  if (nchar(addInstrument)>0)
    fs = lapply(fs, function(x) { append(x, addInstrument, after = 3) } )
  if (nchar(addSample)>0)
    fs = lapply(fs, function(x) { append(x, addSample, after = 4) } )
  f = sapply(fs, function(x) { paste(x,collapse = '_') })
  f.new = file.path(p,f)
  if (renameFile) file.rename(from=f.old, to=f.new)
  f.new
}
