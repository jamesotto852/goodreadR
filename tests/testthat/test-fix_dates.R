test_that("date cleaning works", {
  df <- get_profile_url("bookononism") %>% get_read() %>% fix_dates

  # checksum for date of first book read
  expect_equal(rev(df$pub_date)[1] , lubridate::ymd("1937-09-21"))

  # checking that dates w/ only years or year + month specified
  expect_equal(df$pub_date[df$title == "Parable of the Talents"], lubridate::ymd("1998-01-19"))
  expect_equal(df$pub_date[df$title == "Parable of the Sower"], lubridate::ymd("1993-10-19"))
})




