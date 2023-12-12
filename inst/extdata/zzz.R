.onAttach <- function(libname, pkgname) {
  dbVer = as.character(utils::packageVersion(pkgname))
  packageStartupMessage('R ',pkgname,' Data v.',dbVer, '\n')
}
