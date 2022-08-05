test_that("read table works", {
  df <- get_profile_url("bookononism") %>% get_read()

  # checksum for pages read in 2021
  expect_equal(sum(df$pages[grep("2021", df$end_date)], na.rm = TRUE), 11212)

  # checking that books w/ multiple series are dealt with correctly
  # (pick only the first series)
  df_series <- df[!is.na(df$series),]
  expect_false(nrow(df_series[df_series$series == "Discworld",]) == 0)
})
