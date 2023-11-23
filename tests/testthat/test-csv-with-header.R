test_that("Read META header info in CSV", {
  df <- data.frame(
    ID = (1:10)+7,
    t = "type",
    name = "some name"
  )
  df[8,'name'] = 'very looooong name'

  p = tempdir()
  write.csv(df, file.path(p, 'data.csv'), row.names=FALSE)

  # add comments
  header_data = c("# head: test", "# num: 10")
  write.table(header_data, file=file.path(p, 'data.csv'),
              append=TRUE, quote=FALSE,
              col.names = FALSE, row.names = FALSE)

  # read data
  df2 <- read.csv(file.path(p, 'data.csv'), comment.char = "#")

  # read comments
  df_header <- read.csv(file.path(p, 'data.csv'), comment.char = "")
  h <- df_header[grep("^#",df_header$ID),'ID']
  h <- trimws(gsub('^#','',h))
  r = setNames(as.list(trimws(sapply(strsplit(h,":"),'[[',2 ))),
        trimws(sapply(strsplit(h,":"),'[[',1 )))

  expect_equal(length(r), length(header_data))
  expect_equal(nrow(df), nrow(df2))
})
