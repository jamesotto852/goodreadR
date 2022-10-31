test_that("read table works", {
  df <- get_profile_url("bookononism") %>% get_read()

  # checksum for pages read in 2021
  # occasionally need to update expected value, according to rereads
  expect_equal(sum(df$pages[grep("2021", df$end_date)], na.rm = TRUE), 11007)

  # checking that books w/ multiple series are dealt with correctly
  # (pick only the first series)
  df_series <- df[!is.na(df$series),]
  expect_false(nrow(df_series[df_series$series == "Discworld",]) == 0)
})
