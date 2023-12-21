context("Valid Data File Names")

test_that("Test possible VALID data file names", {
  expect_true(raw.isValid('20141215_FePc_TG_vsm_Tb33Al66_20141215-Tb33Al66-ac1Oe-20Hz.txt'))
})

test_that("Test valid data file name wihtout comment", {
  expect_true(raw.isValid('20141215_FePc_TG_vsm_Tb33Al66.txt'))
})


# test_that("test try fix invalid files", {
#   fname = raw.getInvalidFiles(raw.getSamplePath())[1]
#   newFname = raw.tryFixInvalidFile(pfad = raw.getSamplePath(),filename = fname)
#
#   expect_true(raw.isValid(newFname))
# })


test_that("find duplicates", {
  q = raw.findDuplicates(raw.getSamplePath())

  expect_equal(length(q), 2)
})

#
# test_that("inspect a folder", {
#   q = raw.inspectFolder(raw.getSamplePath())
#
#   expect_equal(q$invalidFiles,1)
#   expect_equal(q$projects, "Dual,FePc,Optical")
#   expect_equal(q$users, "AN,MM,TG")
# })



context("Invalid Data File Names")

test_that("Invalid data file missing comment", {
  expect_true(!raw.isValid('20141215_FePc_TG_vsm.txt'))
})

test_that("Incorrect date format", {
  expect_true(!raw.isValid('01012011_FePc_TG_vsm_Tb33Al66_comment.txt'))
})

test_that("Incorrect month", {
  expect_true(!raw.isValid('20111312_FePc_TG_vsm_Tb33Al66_comment.txt'))
})


test_that("Dash instead of underscore", {
  expect_true(!raw.isValid('20141215_FePc_TG_vsm-Tb33Al66-20141215-Tb33Al66-ac1Oe-20Hz.txt'))
})


test_that("Date is incorrect", {
  expect_true(!raw.isValid('2011215_FePc_TG_vsm_Tb33Al66_20141215-Tb33Al66-ac1Oe-20Hz.txt'))
})
