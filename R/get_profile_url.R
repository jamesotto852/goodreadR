#' Get and validate a Goodreads profile URL
#'
#' @param name either a username or url
#'
#' @return Character vector of length 1, a valid URL of a Goodreads profile
#'
#' @import stringr
#' @import assertthat
#' @importFrom glue glue
#'
#' @export
#'
#' @examples
#' # When supplied a valid username, returns the corresponding URL
#' get_profile_url("bookononism")
#'
#' # When supplied a URL, validates that it is a valid Goodreads profile
#' get_profile_url("https://www.goodreads.com/user/show/98834377-james")
get_profile_url <- function(name) {
  assertthat::assert_that(is.character(name))
  assertthat::assert_that(length(name) == 1, msg = "name must be of length 1")

  name <- tolower(name)

  # skip if user provided full url
  if (!stringr::str_detect(name, "\\.com")) name <- glue("https://www.goodreads.com/{name}")

  tryCatch(
    error = function(e) {

      if (str_detect(name, "user/show")) {

        stop(glue("{name} is an invalid url"), call. = FALSE)

      } else {

        stop(glue("{str_extract(name, '(?<=com/).*$')} is an invalid username"), call. = FALSE)

      }

    },

    {
      res <-
        name %>%
        httr2::request() %>%
        httr2::req_perform()

      url <- res$url
    }
  )

  assertthat::assert_that(str_detect(url, "^https://www\\.goodreads\\.com/(author|user)/show"), msg = glue("{url} doesn't point to a Goodreads profile"))

  url
}
