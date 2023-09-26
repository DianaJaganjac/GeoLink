#Load the data that is used for testing
data("hhgeo_dt")
data("shp_dt")

df <- geolink_chirps(time_unit = "month",
                     start_date = "2020-01-01",
                     end_date = "2020-03-01",
                     shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001", ],
                     grid = TRUE,
                     grid_size = 1000,
                     use_survey = TRUE,
                     survey_dt = hhgeo_dt,
                     extract_fun = "mean")

#stata example
shp_fn= "/Users/chaseyoung/Desktop/GeoLink/data-raw/shapefiles/nga_admbndp_admALL_osgof_eha_itos_20190417.shp"
shp_dt <- sf::read_sf(shp_fn)

df2<- geolink_chirps(time_unit = "month",
                     start_date = "2020-01-01",
                     end_date = "2020-03-01",
                     shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001", ],
                     grid = TRUE,
                     grid_size = 1000,
                     survey_fn= "/Users/chaseyoung/Desktop/GeoLink/data/Survey.dta",
                     survey_lat= "lat_dd_mod",
                     survey_lon= "lon_dd_mod",
                     extract_fun = "mean")



test_that("sample data is correctly loaded", {
  expect_equal(hhgeo_dt[1:1]$hhid,10001)
  expect_equal(shp_dt$ADM0_PCODE[1],"NG")
})

test_that("sample works for R-user)", {
  expect_equal(df$dist_road2[1], 1.1)
  expect_equal(df$af_bio_13[2], 320)
  expect_equal(df$sq7[3], 1)
  expect_equal(df$ndvi_max[4],.462)
  expect_equal(df$geoID[9], 1063)
  expect_equal(df$poly_id[10], 1063)
})

test_that("code gives expected errors)", {
  #test if time_unit is null
  expect_error(geolink_chirps(time_unit = "null",
                              start_date = "2020-05-01",
                              end_date = "2020-02-01",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid = TRUE,
                              grid_size = 1000,
                              use_survey = TRUE,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "Time unit should either be month or annual", fixed= TRUE)

  #test if dates are switched
  expect_error(geolink_chirps(time_unit = "month",
                              start_date = "2020-05-01",
                              end_date = "2020-02-01",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid = TRUE,
                              grid_size = 1000,
                              use_survey = TRUE,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "Invalid time range, start time exceeds end time!", fixed= TRUE)
  #test if date is formatted wrongly as year/day/month
  expect_error(geolink_chirps(time_unit = "null",
                              start_date = "2020-31-01",
                              end_date = "2020-31-02",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid = TRUE,
                              grid_size = 1000,
                              use_survey = TRUE,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "character string is not in a standard unambiguous format", fixed= TRUE)

})

##question is it the survey or the data?  survey frim
test_that("sample works for Stata User", {
  expect_equal(df2$dist_road2[1], 1.1)
  expect_equal(df2$af_bio_13[2], 320)
  expect_equal(df2$sq7[3], 1)
  expect_equal(df2$ndvi_max[4],.462)
  expect_equal(df2$geoID[9], 1063)
  expect_equal(df2$poly_id[10], 1063)
})
