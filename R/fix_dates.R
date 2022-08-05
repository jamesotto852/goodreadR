#' Fix dates from `get_read()`
#'
#' The output of `get_read()` is generally very clean,
#' however the columns corresponding to dates can be a little messy.
#' These columns are character vectors and should be in mdy format.
#' However, it is possible for the date and/or month to be missing.
#'
#' This function attempts to clean these columns,
#' making some assumptions:
#' missing days are set as the first of the month;
#' missing months are set to January.
#'
#' @param df the output of `get_read()`, a data.frame
#'
#' @return a tibble with the relevant columns formatted as `Date` vectors
#' @export
#'
#' @examples
#' library("magrittr") # for pipe
#'
#' get_profile_url("bookononism") %>%
#'   get_read() %>%
#'   fix_dates()
fix_dates <- function(df) {
  mutate(df, across(ends_with("date"), fix_date))
}


fix_date <- function(x) {
  # Append "Jan " if only year is provided
  x <- if_else(str_detect(x, "^[^a-z]*$"), glue("Jan {x}"), x)
  lubridate::mdy(x, quiet = TRUE)
}
