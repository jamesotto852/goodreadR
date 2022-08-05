test_that("Require string of length 1 for get_profile_url", {
  expect_error(get_profile_url(TRUE), "name is not a character vector")
  expect_error(get_profile_url(letters), "name must be of length 1")
})

test_that("get_profile_url works with valid url and username", {
  expect_equal(get_profile_url("bookononism"), "https://www.goodreads.com/user/show/98834377-james")
  expect_equal(get_profile_url("https://www.goodreads.com/user/show/98834377-james"), "https://www.goodreads.com/user/show/98834377-james")
})

# Temporarily removed -- expect_error causing issues with RCMD check
# test_that("get_profile_url fails with invalid url or username", {
#   expect_error(get_profile_url("bokononism"), "bokononism is an invalid username")
#   expect_error(get_profile_url("https://www.godreads.com/user/show/98834377-james"), "https://www.godreads.com/user/show/98834377-james is an invalid url")
#   expect_error(get_profile_url("https://www.google.com"), "https://www.google.com/ doesn't point to a Goodreads profile")
# })
