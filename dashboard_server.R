# -----------------------------------------------------------------------------
# Dashboard Server Logic -- *TO BE EDITED*
#
# Defines server-side logic for the dashboard.
#
# Load static datasets above the server function so they are read once
# when the app starts (recommended).
# -----------------------------------------------------------------------------

library(palmerpenguins)

penguins_data <- palmerpenguins::penguins

#' Server
#'
#' Defines server-side logic for the dashboard.
#'
#' @param input Shiny input object.
#' @param output Shiny output object.
#' @param session Shiny session object.
#'
#' @return None. Registers reactive behavior.
dashboard_server <- function(input, output, session) {

  filtered <- reactive({
    df <- penguins_data
    if (input$species != "All") df <- df[df$species == input$species, ]
    df
  })

  output$scatter <- renderPlot({
    df <- filtered()
    x  <- df[[input$x_var]]
    y  <- df[[input$y_var]]
    col <- c(Adelie = "#0064a6", Chinstrap = "#e87d00", Gentoo = "#5a9b5a")
    plot(x, y,
      col  = col[as.character(df$species)],
      pch  = 19,
      xlab = input$x_var,
      ylab = input$y_var,
      main = paste(input$y_var, "vs", input$x_var)
    )
    legend("topleft",
      legend = names(col),
      col    = col,
      pch    = 19,
      bty    = "n"
    )
  })

  output$summary <- renderTable({
    df <- filtered()
    data.frame(
      Variable = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
      Mean     = sapply(c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                   function(v) round(mean(df[[v]], na.rm = TRUE), 1)),
      SD       = sapply(c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                   function(v) round(sd(df[[v]], na.rm = TRUE), 1)),
      Min      = sapply(c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                   function(v) round(min(df[[v]], na.rm = TRUE), 1)),
      Max      = sapply(c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"),
                   function(v) round(max(df[[v]], na.rm = TRUE), 1)),
      row.names = NULL
    )
  })

  output$table <- renderTable({
    head(filtered()[, c("species", "island", "bill_length_mm", "bill_depth_mm",
                        "flipper_length_mm", "body_mass_g", "sex")], 50)
  })

}
