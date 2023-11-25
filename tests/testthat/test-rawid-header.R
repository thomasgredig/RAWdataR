test_that("serialization in RAW ID header", {

  fID <- tempfile()
  r.in = data.frame(ID = c(7,8), path = c("test",""), filename = c("a.txt",'b.txt'))
  h.in = list(
    pgm = "RAWdataR",
    path = dirname(fID),
    paths = c(dirname(fID),"..", "."),
    version = "2.0",
    another_seq = c("A","B","C")
  )
  raw.writeRAWIDfile(r.in, h.in, fID)

  h.out <- raw.readRAWIDheader(fID)
  r.out <- raw.readRAWIDfile(fID)

  expect_equal(nrow(r.in), nrow(r.out))
  expect_equal(h.in, h.out)
})
