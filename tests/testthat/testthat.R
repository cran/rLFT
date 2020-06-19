library(testthat)
library(rLFT)

#test_check("rLFT")

# load in data to run tests on
data("shpObject")
data("polygonShpObject")
data("latlongShpObject")
data("pointObject")
multipolygonShpObject <- st_cast(polygonShpObject, "MULTIPOLYGON")
output <- bct(shpObject, 50, 100, "RID")

test_that("input data check", {
  expect_error(bct(shpObject, 50, 100, "RI", filename = ""), info = "column name exists check")
  expect_error(bct(shpObject, 50, 100, 5, filename = ""), info = "column name is a string check")
  expect_error(bct(shpObject, 50, 100, "RID", filename = 5), info = "file name is a string check")
  expect_error(bct(5, 50, 100), info = "is sf object check")
  expect_error(bct(shpObject, -50, 100), info = "positive step size check")
  expect_error(bct(shpObject, "test", 100), info = "step size is a numeric check")
  expect_error(bct(shpObject, 50, "test"), info = "window size is a numeric check")
  expect_error(bct(shpObject, 50, 100, "RID", "outputfile"), info = "file name ends with .txt check")
  expect_error(bct(shpObject, 50, 100, "geometry"), info = "incorrect column check")
  expect_warning(bct(polygonShpObject, 50, 100), info = "polygon warning check")
  expect_warning(bct(multipolygonShpObject, 50, 100), info = "multipolygon warning check")
  expect_error(bct(latlongShpObject, 50, 100), info = "coord system check")
  expect_error(bct(pointObject, 50, 100), info = "Accepted geometry type check")
  
  # change test since we normally do not want any output
  expect_output(bct(shpObject, 50, 100, "RID"), info = "CBC should be successful")
  expect_equal(class(output), "data.frame", info = "correct output check")
  
})