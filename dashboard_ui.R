# -----------------------------------------------------------------------------
# Dashboard UI -- *TO BE EDITED*
#
# Defines UI and dashboard content.
#
# -----------------------------------------------------------------------------

#' Dashboard UI
#'
#' Defines the UI for the dashboard content area. This function should return a
#' Shiny UI object (e.g., a tagList or a div) that contains
#' application-specific UI elements.
#'
#' @return A Shiny UI object representing the dashboard content.
dashboard_ui <- function() {

  tagList(

    fluidRow(
      column(
        12,
        p("This dashboard provides an overview of municipalities.")
      )
    ),

    fluidRow(
      column(4, wellPanel(h4("Cantons"), h2("26"))),
      column(4, wellPanel(h4("Municipalities"), h2("2,131"))),
      column(4, wellPanel(h4("Last update"), h2("2026-01-15")))
    )

  )
}
