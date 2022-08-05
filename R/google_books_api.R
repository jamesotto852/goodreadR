# TODO add validation!

#' Querying and parsing data from the Google Books API
#'
#' Various functions for querying and parsing the results of the Google Books API.
#' `query_google_books_api()` takes the title and author of a book as input and returns a nested list
#' with the results from the API call. The `google_*()` functions parse the nested list, returning
#' the desired information as character vectors of length 1.
#'
#' @name google_books_api
#'
#' @param title Book title
#' @param author Book author
#' @param data parsed JSON data from `query_google_books_api()`
#'
#' @return `query_google_books_api()` returns a nested list with the results from the API query.
#' `google_cover()` and `google_isbn()` return character vectors of length 1 with the relevant information
#'
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' data <- query_google_books_api("The Obelisk Gate", "Jemisin, N.K.")
#' google_cover(data)
#' google_isbn(data)
NULL

#' @rdname google_books_api
#' @export
query_google_books_api <- function(title, author) {

  title <- title %>%
    str_replace_all("[:punct:]", "") %>%
    str_replace_all("[:space:]+", "%20")

  author <- author %>%
    str_extract("^[^, ]*")

  res <- glue("https://www.googleapis.com/books/v1/volumes?q={title}+intitle:{title}+inauthor:{author}") %>%
    httr2::request() %>%
    httr2::req_perform()

  jsonlite::fromJSON(rawToChar(res$body))

}

#' @rdname google_books_api
#' @export
google_cover <- function(data) {

  img_urls <- data$items$volumeInfo$imageLinks$thumbnail
  url_index <- min(which(!is.na(img_urls)))

  img_urls[url_index] %>%
    str_replace("edge=curl&", "")
}

#' @rdname google_books_api
#' @export
google_isbn <- function(data) {

  res <- data$items$volumeInfo$industryIdentifiers %>%
    bind_rows() %>%
    filter(type == "ISBN_13") %>%
    slice_head(n = 1)

  res$identifier

}



