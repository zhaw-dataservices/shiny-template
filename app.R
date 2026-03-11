# -----------------------------------------------------------------------------
# Main Application -- *DO NOT EDIT*
#
# Entry point for the ZHAW Shiny dashboard template:
#   - Load configuration
#   - Load layout helpers and dashboard content
#   - Assemble UI structure
#   - Initialize Shiny application
#
# Application-specific content should be defined in `dashboard_ui.R`.
# Application logic should be defined in `dashboard_server.R.
# -----------------------------------------------------------------------------


library(shiny)
library(yaml)

config <- yaml::read_yaml("config.yml")

# Validate config
if (is.null(config$title) || !nzchar(config$title)) {
  stop("config.yml: 'title' is missing or empty.")
}
valid_brands <- c("standard", "black")
if (!config$brand %in% valid_brands) {
  stop(sprintf(
    "config.yml: 'brand' must be one of: %s. Got: '%s'.",
    paste(valid_brands, collapse = ", "), config$brand
  ))
}

source("template/layout.R")
source("dashboard_ui.R")
source("dashboard_server.R")

brand_class <- paste0("brand-", config$brand)
logo_file   <- paste0("logo-", config$brand, ".png")

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  div(
    class = paste("app-page", brand_class),

    corporate_header(
      title = config$title,
      logo  = logo_file
    ),

    corporate_content(
      dashboard_ui()
    ),

    corporate_footer(
      render_legal_notice(config$legal_notice)
    )
  )
)

shinyApp(ui, dashboard_server)
