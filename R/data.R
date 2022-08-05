#' Awards Data
#'
#' Tibbles with award nominee data from Wikipedia
#'
#' @name Awards
#'
#' @format Tibbles with columns:
#' \describe{
#'   \item{Year}{The Year the work was nominated}
#'   \item{Won}{Did the work win the award?}
#'   \item{Title}{The title of the work}
#'   \item{Author1, Author2, ...}{The author(s) of the works, split over multiple columns}
#' }
NULL

#' @rdname Awards
"df_Hugo"

#' @rdname Awards
"df_Nebula"

#' @rdname Awards
"df_Clarke"

#' @rdname Awards
"df_World_Fantasy"
