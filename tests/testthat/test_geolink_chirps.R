#Step 1 call the data that is used for testing
data("hhgeo_dt")
data("shp_dt")

#Step 2: load the monthly data from Chirps:
print("getting testing data from CHIRPS")
geolink_chirps(time_unit = "month",
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

#Step 4: Run Tests for Expected Output
#check shp_dt was correctly loaded
#Variables in shp_dt: ADM2P_CODE for Arochukwu is NG001003 in Abia

#Hhgeo_dt:
##for HHID 19010: dist-pop center= 1
# for 19104: Pop density= 10700
# for 10010, NVDI Max= .540

#check if chirps data is added correctly: where is Chirps data added back in?

#mean or rainfall for chirps variable




#Step 5: Create pathways for possible errors



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

#error checks
test_that("code gives expected errors)", {
  #test if time_unit is null
  expect_error(geolink_chirps(time_unit = "null",
                              start_date = "2020-05-01",
                              end_date = "2020-02-01",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid_size = 1000,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "Time unit should either be month or annual", fixed= TRUE)

  #test if dates are switched
  expect_error(geolink_chirps(time_unit = "month",
                              start_date = "2020-05-01",
                              end_date = "2020-02-01",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid_size = 1000,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "Invalid time range, start time exceeds end time!", fixed= TRUE)

  #test if date is formatted wrongly as year/day/month
  expect_error(geolink_chirps(time_unit = "null",
                              start_date = "2020-31-01",
                              end_date = "2020-31-02",
                              shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001",],
                              grid_size = 1000,
                              survey_dt = hhgeo_dt,
                              extract_fun = "mean"), "character string is not in a standard unambiguous format", fixed= TRUE)

})

