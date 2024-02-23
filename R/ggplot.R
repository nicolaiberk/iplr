#' Title
#'
#' This function does x/y
#'
#' @param var Some param
#'
#' @importFrom ggplot2 element_rect
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 theme
#' @export
ggplot_theme <- function(var) {
  theme_minimal() +
    theme(
      text = element_text(family = "Arial", size = 12),
      plot.background = element_rect(fill = "white"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      panel.border = element_rect(colour = "black"),
      legend.position = "bottom"
    )
}
