#' Get tidy tibble of a user's reading history
#'
#' @param url A URL pointing to a user's profile, the output of `get_profile_url()`
#'
#' @import rvest
#' @import dplyr
#'
#' @return a tibble
#' @export
#'
#' @examples
#' library("magrittr") # for pipe
#'
#' get_profile_url("bookononism") %>%
#'   get_read()
get_read <- function(url) {

  no_read <- get_no_read(url)

  # Number of pages of results to scrape
  # (30 entries per page)
  pages <- no_read %/% 30 + ((no_read %% 30) > 0)

  str_replace(url, "user/show", "review/list") %>%
    str_c(glue("?page={1:pages}&per_page=30&shelf=read&utf8=%E2%9C%93")) %>%
    purrr::map_dfr(get_book_table) %>%
    clean_book_table()

}

get_no_read <- function(url) {

  # Previous attempt -- run into issues w/ multiple shelves (esp. "to read")

  # read_html(url) %>%
  #   html_element(css = ".actionLinkLite.userShowPageShelfListItem") %>%
  #   html_text() %>%
  #   str_extract("(?<=\\().*(?=\\))") %>%
  #   as.integer()

  read_html(url) %>%
    html_element("#shelves") %>%
    html_text() %>%
    str_replace_all("\\s", "") %>%
    str_extract("(?<=\\()[:digit:]+(?=\\))") %>%
    as.integer()

}


get_book_table <- function(url) {
  # This doesn't work:
  # "https://www.goodreads.com/review/list/7046137-lisa?page=1&per_page=30&shelf=read&utf8=%E2%9C%93"

  # space out requests
  Sys.sleep(.1)

  html <- read_html(url)

  table <- html %>%
    html_element("#booksBody") %>%
    html_table()

  covers <- html %>%
    html_element("#booksBody") %>%
    html_elements(".field.cover") %>%
    html_element("img") %>%
    html_attr("src") %>%
    str_replace("(?<=_S).*(?=_\\..{3}$)", "Y800") # fixing res

  table %>% mutate(X3 = covers)
}


clean_book_table <- function(df) {
  df %>%
    select(
      cover = X3,
      title = X4,
      author = X5,
      pages = X9,
      avg_rating = X10,
      n_ratings = X11,
      pub_date = X12,
      rating = X14,
      review = X16,
      times_read = X20,
      start_date = X21,
      end_date = X22
    ) %>%
    # break title into title, series, and series_no
    # remove parentheses around series if needed
    # (only keeping first series)
    mutate(
      series =  str_extract(title, "(?<=\\()[^;]*#(\\d|\\.)+"),
      title =  if_else(!is.na(series), str_extract(title, "^(.|\\n)*(?= \\()"), title),
      series_no =  str_extract(series, "(?<=#).*$"),
      series =  str_extract(series, "^.*(?=,+ #)"),
      .after = title
    ) %>%
    # remove repeated text at beginning of fields + surrounding whitespace
    mutate(
      across(c(everything(), -cover, -series_no, -series),
      ~ str_extract(.x, "(\\n|\\s){3,}.*"))
    ) %>%
    mutate(across(everything(), str_trim)) %>%
    # fix encoding of ratings
    mutate(
      rating = case_when(
        rating == "it was amazing" ~ 5L,
        rating == "really liked it" ~ 4L,
        rating == "liked it" ~ 3L,
        rating == "it was okay" ~ 2L,
        rating == "did not like it" ~ 1L,
        rating == "None" ~ NA_integer_
      )
    ) %>%
    # add NAs where applicable
    mutate(
      pages = if_else(pages == "unknown", NA_character_, pages),
      review = if_else(review == "None", NA_character_, review),
      start_date = if_else(start_date == "not set", NA_character_, start_date),
      end_date = if_else(end_date == "not set", NA_character_, end_date)
    ) %>%
    # Fix encoding of numerics
    mutate(
      series_no = as.numeric(series_no), # fractional no. allowed!
      pages = as.integer(pages),
      avg_rating = as.numeric(avg_rating),
      n_ratings = str_replace_all(n_ratings, ",", ""),
      n_ratings = as.integer(n_ratings),
      times_read = as.integer(times_read)
    )
}



