# Internal functions to get award data for /data/ directory

#' @importFrom tidyr pivot_wider
#' @importFrom purrr map_dfr
NULL

# df_Hugo <- get_award_data("Hugo")
# df_Nebula <- get_award_data("Nebula")
# df_Clarke <- get_award_data("Clarke")
# df_World_Fantasy <- get_award_data("World Fantasy")

get_award_data <- function(name) {
  case_when(
    name == "Hugo" ~ "https://en.wikipedia.org/wiki/Hugo_Award_for_Best_Novel",
    name == "Nebula" ~ "https://en.wikipedia.org/wiki/Nebula_Award_for_Best_Novel",
    name == "Clarke" ~ "https://en.wikipedia.org/wiki/Arthur_C._Clarke_Award",
    name == "World Fantasy" ~ "https://en.wikipedia.org/wiki/World_Fantasy_Award%E2%80%94Novel"
  ) %>%
    read_wiki_tables()
}

read_wiki_tables <- function(url) {
  read_html(url) %>%  # scrape web page
    html_nodes("table.wikitable") %>% # pull out specific table
    html_table(fill = TRUE) %>%
    purrr::map_dfr(fix_wiki_table)
}

fix_wiki_table <- function(df) {
  df %>%
    select(Year, Author = starts_with("Author"), Title = starts_with("Novel")) %>%
    mutate(
      Won = str_detect(Author, "\\*"),
      Author = str_replace(Author, "\\*", ""),
      .keep = "unused",
      .before = Title
    ) %>%
    mutate(
      Year = str_extract(Year, "\\d{4}"),
      Year = as.integer(Year)
      ) %>%
    group_by(Title, Year) %>%
    mutate(temp = glue("Author{1:n()}")) %>%
    ungroup() %>%
    tidyr::pivot_wider(c(everything(), -Author), names_from = temp, values_from = Author) %>%
    mutate(Title = str_replace(Title, " \\(also known as .*$", "")) %>%
    arrange(desc(Year), desc(Won), Author1)
}


# TODO -  Unique formats
# "https://en.wikipedia.org/wiki/Locus_Award_for_Best_Science_Fiction_Novel"
# "https://en.wikipedia.org/wiki/Philip_K._Dick_Award"
