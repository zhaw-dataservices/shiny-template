# -----------------------------------------------------------------------------
# Dashboard UI -- *TO BE EDITED*
#
# Defines UI and dashboard content.
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
    h2("Palmer Penguins Explorer"),
    p("Explore body measurements of three penguin species observed on islands in the Palmer Archipelago, Antarctica."),

    fluidRow(
      column(4,
        selectInput("species", "Species",
          choices = c("All", "Adelie", "Chinstrap", "Gentoo"),
          selected = "All"
        )
      ),
      column(4,
        selectInput("x_var", "X axis",
          choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
          selected = "bill_length_mm"
        )
      ),
      column(4,
        selectInput("y_var", "Y axis",
          choices = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
          selected = "flipper_length_mm"
        )
      )
    ),

    plotOutput("scatter", height = "400px"),

    hr(),

    h3("Summary statistics"),
    tableOutput("summary"),

    hr(),

    h3("Raw data"),
    p("Showing first 50 rows."),
    tableOutput("table")
  )
}