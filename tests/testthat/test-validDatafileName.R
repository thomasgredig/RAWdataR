context("Valid Data File Names")

test_that("Test possible VALID data file names", {
  expect_true(raw.isValid('20141215_FePc_TG_vsm_Tb33Al66_20141215-Tb33Al66-ac1Oe-20Hz.txt'))
})



context("Invalid Data File Names")


test_that("Dash instead of underscore", {
  expect_true(!raw.isValid('20141215_FePc_TG_vsm-Tb33Al66-20141215-Tb33Al66-ac1Oe-20Hz.txt'))
})


test_that("Date is incorrect", {
  expect_true(!raw.isValid('2011215_FePc_TG_vsm_Tb33Al66_20141215-Tb33Al66-ac1Oe-20Hz.txt'))
})
