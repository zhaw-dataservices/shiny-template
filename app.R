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
# Application logic should be defined in `dashboard_server.R`.
# -----------------------------------------------------------------------------


library(shiny)
library(yaml)
library(shiny.i18n)

config <- yaml::read_yaml("config.yml")

# Validate config
if (is.null(config$title) || !nzchar(config$title)) {
  stop("config.yml: 'title' is missing or empty.")
}

i18n <- Translator$new(translation_json_path = "www/i18n/translation.json")
i18n$set_translation_language("de")

source("template/layout.R")
source("dashboard_ui.R")
source("dashboard_server.R")

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    shiny.i18n::usei18n(i18n)
  ),
  div(
    class = "app-page",
    corporate_header(
      title = config$title,
      logo = "zhaw-logo-negativ.png",
      logo_alt = "ZHAW Zurich University of Applied Sciences",
      links = config$header_links,
      i18n = i18n,
      lang_selector = selectInput(
        "selected_language",
        label = NULL,
        choices = c("Deutsch" = "de", "English" = "en"),
        selected = "de",
        width = "120px"
      )
    ),
    corporate_content(
      dashboard_ui(title = config$title, i18n = i18n)
    ),
    corporate_partner_strip(
      partner_logos = config$partner_logos,
      i18n = i18n
    ),
    corporate_footer(
      legal = config$legal_notice,
      references = config$references
    )
  )
)

# Wraps dashboard_server to handle language switching.
server <- function(input, output, session) {
  observeEvent(input$selected_language, {
    shiny.i18n::update_lang(input$selected_language, session)
  })
  dashboard_server(input, output, session)
}

shinyApp(ui, server)
