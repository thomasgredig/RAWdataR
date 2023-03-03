test_that("check file types", {
  expect_equal(.getFileType('test.ras'), 'XRD')
  expect_equal(.getFileType('test.rasx'), 'XRD')
  expect_equal(.getFileType('test.ibw'), 'AFM')

  expect_equal(.getFileType('20220224_EH_XRD_RM20_General_01.asc'), 'XRD')
  expect_equal(.getFileType('20220224_EH_XRR_RM20_General_01.asc'), 'XRR')

})
