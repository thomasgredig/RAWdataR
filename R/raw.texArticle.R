#' LaTeX Article with all Fig2TeX figures
#'
#' @param figPath path for figures, should contain tex figure files generated with \code{fig2tex}
#' @param fileTex name of article that is generated in figPath
#'
#' @seealso \code{\link{fig2tex()}}
#'
#' @export
raw.texArticle <- function(figPath,
                           fileTeX = "_main.tex") {
  if (!dir.exists(figPath)) stop("Figure path not found:", figPath)

  figList = dir(figPath, pattern='^[^\\_].*tex$')

  figListTeX = paste0("\\input{{",figList,"}}", collapse="\n")

  texBase = paste0("\\documentclass[11pt]{article}
\\usepackage{graphicx}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\graphicspath{}

% Generated with RAWdataR::raw.texArticle()

\\begin{document}
\\listoffigures
\\section{Figures}

All figures from directory: ",figPath,"

",figListTeX,"

\\end{document}
")

  fileConn<-file(file.path(figPath,fileTeX),"wt")
  writeLines(texBase, fileConn)
  close(fileConn)

  return(TRUE)
}
