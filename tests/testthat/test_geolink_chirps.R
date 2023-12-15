#Step 1 call the data that is used for testing
data("hhgeo_dt")
data("shp_dt")

#Step 2: load the monthly data from Chirps:
testthat_print("getting testing data from CHIRPS")
df1<- geolink_chirps(time_unit = "month",
                     start_date = "2020-01-01",
                     end_date = "2020-03-01",
                     shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001", ],
                     grid_size = 1000,
                     survey_dt = hhgeo_dt,
                     extract_fun = "mean")

#Step 3: load the annual data from chirps:
df2<- geolink_chirps(time_unit = "annual",
                     start_date = "2020-01-01-01",
                     end_date = "2021-01-01",
                     shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001", ],
                     grid_size = 1000,
                     survey_dt = hhgeo_dt,
                     extract_fun = "mean")

#Step 4: run tests for expected output for monthly output
testthat_print("checking for expected output")
#testing if non-numeric variables are equal
test_that("testing data is correctly merged", {
  expect_equal(df1$ADM2_PCODE[61], "NG001014")
  expect_equal(df1$ADM2_EN[627], "Ugwunagbo")
  expect_equal(df1$ADM1_EN[6], "Abia")

})

#use sum to reliably check rainfall data
test_that("monthly rainfall data is correct", {
  sumrainfall= sum(df1$rainfall_month3)
  expect_equal(sumrainfall, 56763.272)

})

#Step 5: run tests for expected output for annual output
#testing if non-numeric variables are equal
test_that("testing annual data is correctly merged", {
  expect_equal(df2$ADM2_PCODE[61], "NG001014")
  expect_equal(df2$ADM2_EN[627], "Ugwunagbo")
  expect_equal(df2$ADM1_EN[6], "Abia")

})

#use sum to reliably check rainfall data
test_that("annual rainfall data is correct", {
  sumrainfall= sum(df2$rainfall_annual2)
  expect_equal(sumrainfall, 10738505)

})

#Step 6: Create pathways for possible errors
testthat_print("checking for expected errors")
test_that("code gives expected errors)", {
  #test if time_unit is null
  expect_error(geolink_chirps(time_unit = "null",
                              start_date = "2020-05-01",
                              end_date = "2020-02-01",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "Time unit should either be month or annual", fixed= TRUE)

  #test if dates are switched
  expect_error(geolink_chirps(time_unit = "month",
                              start_date = "2020-05-01",
                              end_date = "2020-02-01",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "Invalid time range, start time exceeds end time!", fixed= TRUE)

  #test if date is formatted wrongly as year/day/month
  expect_error(geolink_chirps(time_unit = "null",
                              start_date = "2020-14-01",
                              end_date = "2020-28-02",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid_size = 1000,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "character string is not in a standard unambiguous format", fixed= TRUE)

})

