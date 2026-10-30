# Source: TidyTuesday, 5 March 2024.
# Original data: Baltimore Healthy Harbor / Mr. Trash Wheel.
# Item counts are estimates. Missing counts remain NA.

url <- paste0(
  "https://raw.githubusercontent.com/rfordatascience/",
  "tidytuesday/main/data/2024/2024-03-05/trashwheel.csv"
)

trash_items <- readr::read_csv(
  url,
  show_col_types = FALSE
) |>
  janitor::clean_names() |>
  dplyr::mutate(
    date = lubridate::mdy(date)
  ) |>
  dplyr::select(
    id,
    name,
    dumpster,
    date,
    year,
    plastic_bottles:sports_balls
  ) |>
  tidyr::pivot_longer(
    cols = plastic_bottles:sports_balls,
    names_to = "trash_type",
    values_to = "count"
  )

usethis::use_data(
  trash_items,
  overwrite = TRUE
)
