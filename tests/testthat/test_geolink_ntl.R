#Step 1 call the data that is used for testing
data("hhgeo_dt")
data("shp_dt")

#Step 2: load data
#as currently designed: output for chirps is different than output for hhgeo_dt
testthat_print("getting testing data from NTL")

#Use two examples:
#buffer with annual data
df3<- geolink_ntl(start_date = "2020-01-01",
            end_date = "2020-12-31",
            annual_version = "v21",
            indicator = "average_masked",
            survey_dt = st_as_sf(hhgeo_dt[ADM1_EN == "Abia",],
                                 crs = 4326),
            buffer_size = 100,
            shp_dt = shp_dt[shp_dt$ADM1_EN == "Abia",])

#grid with monthly data-> monthly function needs work
# df4<- geolink_ntl(time_unit= "month",
#             start_date = "2020-01-01",
#             end_date = "2020-03-31",
#             month_version = "v10",
#             indicator = "average_masked",
#             survey_dt = st_as_sf(hhgeo_dt[ADM1_EN == "Abia",],
#                                                crs = 4326),
#             grid_size = 1000,
#             shp_dt = shp_dt[shp_dt$ADM1_EN == "Abia",])

#Step 3: run tests for expected output for monthly output
testthat_print("checking for expected output")
#testing if non-numeric variables are equal
test_that("testing data is correctly merged", {
  expect_equal(df3$ADM2_PCODE[61], "NG001004")
  expect_equal(df3$ADM2_EN[127], "Isiala-Ngwa North")
  expect_equal(df3$ADM1_EN[6], "Abia")

})

#use sum to reliably check radians data
test_that("annual ntl data is correct", {
  sumradians= sum(df3$radians_annual1)
  expect_equal(sumradians, 199.21488)

})

