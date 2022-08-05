
<!-- README.md is generated from README.Rmd. Please edit that file -->

# goodreadR <img src="man/figures/logo.png"  align="right"  width="120" style="padding-left:10px;background-color:white;" />

**goodreadR** exports several functions for scraping and tidying user
data from [goodreads.com](https://www.goodreads.com/). Internally, these
tasks are handled via [**rvest**](https://rvest.tidyverse.org/),
[**stringr**](https://stringr.tidyverse.org/), and other
[tidyverse](https://www.tidyverse.org/) packages.

<!-- badges: start -->

[![R-CMD-check](https://github.com/jamesotto852/goodreadR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jamesotto852/goodreadR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Installation

You can install **goodreadR** from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("jamesotto852/goodreadR")
```

## Getting User data

The main function for getting user data is `get_read()`. It accepts a
profile url as its argument and returns a tibble of the scraped user
data. Below, I show the data from my profile as an example:

``` r
library("goodreadR")
library("tidyverse")

df <- get_read("https://www.goodreads.com/user/show/98834377-james")
  
glimpse(df)
#> Rows: 110
#> Columns: 14
#> $ cover      <chr> "https://i.gr-assets.com/images/S/compressed.photo.goodread…
#> $ title      <chr> "Lirael", "Sabriel", "Children of Ruin", "Children of Time"…
#> $ series     <chr> "Abhorsen", NA, "Children of Time", "Children of Time", NA,…
#> $ series_no  <dbl> 2, 1, 2, 1, NA, 3, 2, 1, NA, NA, 1, 3, NA, 2, 2, 1, NA, NA,…
#> $ author     <chr> "Nix, Garth", "Nix, Garth", "Tchaikovsky, Adrian", "Tchaiko…
#> $ pages      <int> 705, 491, 565, 600, 264, 416, 413, 468, 336, 201, 416, 264,…
#> $ avg_rating <dbl> 4.27, 4.16, 4.06, 4.28, 4.29, 4.36, 4.31, 4.32, 3.86, 4.18,…
#> $ n_ratings  <int> 114831, 199786, 24161, 84320, 149398, 106226, 126750, 20822…
#> $ pub_date   <chr> "Apr 21, 2001", "May 1995", "May 14, 2019", "Jun 04, 2015",…
#> $ rating     <int> 5, 5, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 5, 4, 4, 5, 3, 5,…
#> $ review     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ times_read <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ start_date <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ end_date   <chr> "Jul 04, 2022", "Jul 03, 2022", "Jul 2022", "Jun 26, 2022",…
```

You may have noticed that in the above example, the columns with dates
(`pub_date`, `start_date`, etc.) are not machine-readable. This is
remedied via `fix_dates()` which cleans the output of `get_read()`.

``` r
df |>
  fix_dates() |>
  select(ends_with("date")) |>
  glimpse()
#> Rows: 110
#> Columns: 3
#> $ pub_date   <date> 2001-04-21, 1995-05-19, 2019-05-14, 2015-06-04, 1979-06-19…
#> $ start_date <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ end_date   <date> 2022-07-04, 2022-07-03, 2022-07-20, 2022-06-26, 2022-06-15…
```

Note: each value of `start_date` is `NA`. This is not an error—I just do
not set start dates on my goodreads account!

------------------------------------------------------------------------

Finally, if you know your username, `get_profile_url()` will return the
corresponding url (ready for `get_read()`):

``` r
get_profile_url("bookononism")
#> [1] "https://www.goodreads.com/user/show/98834377-james"
```

## Awards data

**goodreadR** also includes data for various literary awards, scraped
from [Wikipedia](https://wikipedia.com). Currently, `df_Hugo`,
`df_Nebula`, `df_Clarke`, and `df_World_Fantasy` are included. I hope to
add more in the future, keeping them up-to-date.

``` r
df_Hugo
#> # A tibble: 381 × 5
#>     Year Won   Title                             Author1              Author2
#>    <int> <lgl> <chr>                             <chr>                <chr>  
#>  1  2022 FALSE Project Hail Mary                 Andy Weir            <NA>   
#>  2  2022 FALSE A Desolation Called Peace         Arkady Martine       <NA>   
#>  3  2022 FALSE The Galaxy, and the Ground Within Becky Chambers       <NA>   
#>  4  2022 FALSE A Master of Djinn                 P. Djèlí Clark       <NA>   
#>  5  2022 FALSE Light From Uncommon Stars         Ryka Aoki            <NA>   
#>  6  2022 FALSE She Who Became the Sun            Shelley Parker-Chan  <NA>   
#>  7  2021 TRUE  Network Effect                    Martha Wells         <NA>   
#>  8  2021 FALSE The Relentless Moon               Mary Robinette Kowal <NA>   
#>  9  2021 FALSE The City We Became                N. K. Jemisin        <NA>   
#> 10  2021 FALSE Black Sun                         Rebecca Roanhorse    <NA>   
#> # … with 371 more rows
#> # ℹ Use `print(n = ...)` to see more rows
```

## Goodreads Dashboard

I have also developed a [**shiny**](https://shiny.rstudio.com/) app
which makes use of this package, communicating various statistics about
a user’s goodreads data—see it in action
[here](https://jamesotto.app/Goodreads-Dashboard)
