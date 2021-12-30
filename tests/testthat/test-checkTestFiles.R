context('RAW test files')

test_that("Verify there are test files.", {
  expect_equal(length(dir(system.file("extdata",package="RAWdataR"))),4)
})

test_that("Find valid files.", {
    expect_equal(length(raw.getValidFiles(
      raw.getSamplePath())),3)
})

test_that("Find invalid files.", {
  expect_equal(length(raw.getInvalidFiles(
    raw.getSamplePath())),1)
})



test_that("Verify MD5 strings for files.", {
  md5str = raw.getMD5str(raw.getSampleFiles())
  expect_equal(md5str, "7545cd,7545cd,24fefa,7545cd")
})

# test_that("Add instrument name", {
#   raw.fixInvalidFile(f, instrument='vsm')
# })

test_that("Add instrument name", {
  f="20211213_myProj_MM_MM211202B_IrMn_measure.png"
  f.new = basename(raw.fixInvalidFile(f, addInstrument='vsm'))
  expect_equal(f.new,'20211213_myProj_MM_vsm_MM211202B_IrMn_measure.png')
})

test_that("Add project name", {
  f="20211213_MM_MM211202B_IrMn_measure.png"
  f.new = basename(raw.fixInvalidFile(f, addInstrument='vsm', addProject='myProj'))
  expect_equal(f.new,'20211213_myProj_MM_vsm_MM211202B_IrMn_measure.png')
})

test_that("Add sample name", {
  f="20211213_myProj_MM_vsm_IrMn_measure.png"
  f.new = basename(raw.fixInvalidFile(f, addSample='MM211202B'))
  expect_equal(f.new,'20211213_myProj_MM_vsm_MM211202B_IrMn_measure.png')
})

test_that("Add user name", {
  f="20211213_myProj_vsm_MM211202B_IrMn_measure.png"
  f.new = basename(raw.fixInvalidFile(f, addUser='MM'))
  expect_equal(f.new,'20211213_myProj_MM_vsm_MM211202B_IrMn_measure.png')
})


test_that("Add user name and sample", {
  f="20211213_vsm_IrMn_measure.png"
  f.new = basename(raw.fixInvalidFile(f, addUser='MM', addSample = 'MM211202B',
                                      addProject = 'myProj'))
  expect_equal(f.new,'20211213_myProj_MM_vsm_MM211202B_IrMn_measure.png')
})

