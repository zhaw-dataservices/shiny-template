library(shiny)

source("ui_layout.R")

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  div(
    class = "app-page",
    
    corporate_header(
      title = "Municipalities Dashboard",
      logo = "logo.png"
    ),
    
    corporate_content(
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
    ),
    
    corporate_footer(
      tagList(
        tags$p("© 2026 Swiss Research Institute"),
        tags$p("Internal use only"),
        tags$p("Contact: data@institute.ch")
      )
    )
  )
)


server <- function(input, output, session) {

  preview_data <- data.frame(
    Canton = c("ZH", "BE", "VD"),
    Municipality = c("Zürich", "Bern", "Lausanne"),
    Included = c("Yes", "Yes", "No"),
    stringsAsFactors = FALSE
  )

  output$preview_table <- renderTable({
    preview_data
  })
}

shinyApp(ui, server)
