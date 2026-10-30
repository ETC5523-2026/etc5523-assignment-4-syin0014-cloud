#' Launch the Trash Wheel Explorer
#'
#' Opens the Shiny app included in the installed package.
#'
#' @return No return value; called to launch the Shiny app.
#'
#' @importFrom bslib bs_theme page_sidebar sidebar
#' @importFrom ggplot2 aes facet_wrap geom_col ggplot labs
#'   scale_y_discrete theme_minimal
#' @export
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {

  app_dir <- system.file(
    "app",
    package = "syinexplore"
  )

  shiny::runApp(app_dir)
}
