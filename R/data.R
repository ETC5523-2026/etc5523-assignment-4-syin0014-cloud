#' Rubbish collected by Baltimore's Trash Wheel family
#'
#' Collection records from four Trash Wheels operating in Baltimore.
#' Each row describes one rubbish category in one dumpster collection.
#' Item counts are estimated using samples taken during collection.
#'
#' @format A tibble with 6,951 rows and 7 variables:
#' \describe{
#'   \item{id}{Short identifier for the Trash Wheel.}
#'   \item{name}{Full name of the Trash Wheel.}
#'   \item{dumpster}{Collection number reported by the source.
#'     Numbers can repeat within a Trash Wheel. Use `id`, `date`,
#'     and `dumpster` together to distinguish collection records.}
#'   \item{date}{Date of collection, stored as a Date.}
#'   \item{year}{Year of collection.}
#'   \item{trash_type}{Category of rubbish counted.}
#'   \item{count}{Estimated number of items; missing when not reported.}
#' }
#'
#' @details
#' Missing counts do not mean zero. Collection histories and reporting
#' coverage differ between Trash Wheels. The records should not be
#' used directly to rank local pollution levels or machine performance.
#'
#' @source
#' TidyTuesday:
#' \url{https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-03-05}
#'
#' Original data from Baltimore Healthy Harbor / Mr. Trash Wheel:
#' \url{https://www.mrtrashwheel.com/}
#'
#' @examples
#' head(trash_items)
"trash_items"
