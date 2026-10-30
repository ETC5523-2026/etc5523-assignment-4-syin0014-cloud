#' Summarise rubbish counts for selected Trash Wheels and years
#'
#' Filters collection records and calculates the mean estimated item
#' count for each selected Trash Wheel and rubbish category.
#'
#' @param data A data frame with the columns in [trash_items].
#' @param wheels Character vector of full Trash Wheel names.
#' @param years Numeric vector of length two giving the first and
#'   last years to include. Both endpoints are included.
#'
#' @return A tibble with one row per Trash Wheel and rubbish category:
#' \describe{
#'   \item{name}{Full name of the Trash Wheel.}
#'   \item{trash_type}{Rubbish category.}
#'   \item{collections}{Number of selected collection records.}
#'   \item{recorded_collections}{Number with a non-missing item count.}
#'   \item{mean_count}{Mean estimated item count among recorded
#'     collections. NA if all counts in the group are missing.}
#' }
#'
#' @details
#' Missing counts are excluded from the mean, rather than treated
#' as zero. A selection with no matching records returns zero rows.
#' The mean describes recorded collections, not a daily collection
#' rate or the amount of rubbish remaining in the water.
#'
#' @importFrom dplyr arrange desc filter group_by n summarise
#' @export
#'
#' @examples
#' summarise_data(
#'   trash_items,
#'   wheels = "Mister Trash Wheel",
#'   years = c(2022, 2023)
#' )
summarise_data <- function(data, wheels, years) {

  selected <- data |>
    filter(
      name %in% wheels,
      year >= years[1],
      year <= years[2]
    )

  selected |>
    group_by(name, trash_type) |>
    summarise(
      collections = n(),
      recorded_collections = sum(!is.na(count)),
      mean_count = if (all(is.na(count))) {
        NA_real_
      } else {
        mean(count, na.rm = TRUE)
      },
      .groups = "drop"
    ) |>
    arrange(name, desc(mean_count))
}
