# #stata example- doing read::sf() here to be able to shorten shp_dt
# shp_fn= "./admAll.shp"
# shp_dt <- sf::read_sf(shp_fn)
#
#
# #sample for stata user. Survey.dta as points
# df3<- geolink_chirps(time_unit = "month",
#                      start_date = "2020-01-01",
#                      end_date = "2020-03-01",
#                      shp_dt = shp_dt[shp_dt$ADM1_PCODE == "NG001", ],
#                      grid_size = 1000,
#                      survey_fn= "./survey.dta",
#                      survey_lat= "lat_dd_mod",
#                      survey_lon= "lon_dd_mod",
#                      extract_fun = "mean")
#
# #stata tests
# test_that("sample works for Stata User", {
#   expect_equal(df2$dist_road2[1], 1.1)
#   expect_equal(df2$af_bio_13[2], 320)
#   expect_equal(df2$sq7[3], 1)
#   expect_equal(df2$ndvi_max[4],.462)
#   expect_equal(df2$geoID[9], 1063)
#   expect_equal(df2$poly_id[10], 1063)
# })
