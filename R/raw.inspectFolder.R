#' Inspect RAW data folder
#'
#' @param pfad path to folder with RAW data
#' @return list
#' @examples
#' raw.inspectFolder(raw.getSamplePath())
#' @export
raw.inspectFolder <- function(pfad) {
  hasSubfolders = !raw.checkNoSubfolders(pfad)
  numFiles = length(dir(pfad))
  file.list = raw.findFiles(pfad)
  d = raw.getNames(file.list)
  projects = paste(levels(as.factor(d$project)), collapse=',')
  users = paste(levels(as.factor(d$user)), collapse=',')
  samples = paste(levels(as.factor(d$sample)), collapse=',')
  instruments  = paste(levels(as.factor(tolower(d$instrument))), collapse=',')

  list(
    hasSubfolders = hasSubfolders,
    projects = projects,
    users = users,
    samples = samples,
    instruments = instruments,
    validFiles = length(file.list),
    invalidFiles = numFiles - length(file.list)
  )
}


#' Separate projects, dates, and users
#'
#' @param file.list file names
#' @return list
#' @examples
#' raw.getNames(raw.getSampleFiles())
#' @export
raw.getNames <- function(file.list) {
  file.list = basename(file.list)
  valFiles = raw.isValid(file.list)
  invalid.files = length(which(valFiles==FALSE))
  if(invalid.files>0) {
    warning(paste("There are",invalid.files,"invalid files that were removed from analysis."))
    file.list = file.list[valFiles]
  }
  s = strsplit(basename(file.list),'_')
  r = data.frame(
    date = sapply(s, '[[', 1),
    project = sapply(s, '[[', 2),
    user = sapply(s, '[[', 3),
    instrument = sapply(s, '[[', 4),
    sample = sapply(s, '[[', 5),
    comment = gsub('^.*_.*_.*_.*_.*_.*?_(.*)\\.(.*)$','\\1',file.list),
    extension = gsub('^.*_.*_.*_.*_.*_.*?_(.*)\\.(.*)$','\\2',file.list),
    size = file.info(file.list)$size
  )
  r
}
