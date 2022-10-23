#' makes a data R project
#'
#' Use the interactive directory selector to create a data R project:
#' The selected folder should have a subdirectory called RAW and all
#' the RAW data files are stored in that directory
#'
#' @param sourceDir if specified, R project will be generated in this directory, otherwise an interactive window allows user to select directory
#'
#' @importFrom rstudioapi selectDirectory isAvailable
#' @importFrom usethis create_package proj_set use_proprietary_license use_readme_md use_news_md use_test proj_activate
#'
#' @examples
#' \dontrun{
#' RAWdataR::raw.dataProject()
#' }
#' @export
raw.dataProject <- function(sourceDir = NULL) {
  if (is.null(sourceDir)) sourceDir = rstudioapi::selectDirectory(caption="Select Directory with Project that contains RAW folder")
  if (is.null(sourceDir)) stop("No directory is selected.")
  sourceDirRAW = file.path(sourceDir, 'RAW')
  if (!dir.exists(sourceDirRAW)) stop(paste("RAW directory path not found",sourceDirRAW))

  # check if project already exists:
  if (file.exists(file.path(sourceDir,'DESCRIPTION'))) {
    warning("Project already exists. Using existing project description.")
  } else {
    projectTitle = readline(prompt = 'Title: What the Package Does (One Line, Title Case): ');

    usethis::create_package(
      sourceDir,
      fields = list( `Authors@R` = 'person("Thomas", "Gredig", email = "tgredig@csulb.edu",
                    role = c("aut", "cre"),
                    comment = c(ORCID = "0000-0002-5824-7626"))',
                     Maintainer = "Thomas Gredig <tgredig@csulb.edu>",
                     Title = projectTitle,
                     Description = projectTitle,
                     Language =  "en"),
      rstudio = rstudioapi::isAvailable(),
      roxygen = TRUE,
      check_name = TRUE,
      open = FALSE  #rlang::is_interactive()
    )
  }


  # proj_get()
  proj_set(sourceDir)
  use_proprietary_license('CSULB Gredig Molecular Thin Film Lab')
  use_readme_md()
  use_news_md()
  use_test("general")

  initFile <- "# Run to initialize RAW data
library(RAWdataR)

file.remove('NAMESPACE')
roxygen2::roxygenise()
dir.create('data-raw')

raw.dataMaker('make.dataRAW.R')

devtools::document()
pkgdown::build_site()
"
  fInit = file.path(sourceDir,"_init.R")
  if (!file.exists(fInit)) {
    fileConn<-file(fInit,"wt")
    writeLines(initFile, fileConn)
    close(fileConn)
  } else {
    warning("_init.R already exists; will not overwrite.")
  }

  usethis::proj_activate(sourceDir)
  invisible(TRUE)
}
