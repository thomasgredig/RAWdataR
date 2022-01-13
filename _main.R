# generate site
# use_vignette("")

devtools::document()
pkgdown::build_site()

library(covr)
report()
