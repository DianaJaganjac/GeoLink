#Step 1 call the data that is used for testing
shp_fn= "./nga_admbnda_adm1_osgof_20190417.shp"
shp_dt <- sf::read_sf(shp_fn)

#Step 2: load the stata data from Chirps:
testthat_print("getting data from CHIRPS with Stata")
df4<- geolink_chirps(time_unit = "month",
                     start_date = "2020-01-01",
                     end_date = "2020-03-01",
                     shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001", ],
                     survey_fn= "./survey.dta",
                     survey_lat= "lat_dd_mod",
                     survey_lon= "lon_dd_mod",
                     extract_fun = "mean")
#
#Step 2: load the stata data from NTL:
testthat_print("getting data from NTL with Stata")
df5<- geolink_ntl(start_date = "2020-01-01",
                  end_date = "2020-12-31",
                  annual_version = "v21",
                  indicator = "average_masked",
                  survey_fn= "./survey.dta",
                  survey_lat= "lat_dd_mod",
                  survey_lon= "lon_dd_mod",
                  buffer_size = 100,
                  shp_dt = shp_dt[shp_dt$ADM1_EN == "Abia",])

#Step 3: run tests for expected output for monthly output
testthat_print("checking expected output")
expect_equal(df4$ADM1_PCODE[61], "NG001")
expect_equal(df4$ADM1_EN[627], "Abia")

#use sum to reliably check rainfall data
test_that("stata rainfall data is correct", {
  sumrainfall= sum(df4$rainfall_month3)
  expect_equal(sumrainfall, 56763.272)

})



