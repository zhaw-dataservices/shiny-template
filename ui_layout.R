corporate_header <- function(
  title = "Institutional Dashboard",
  logo = "logo.png"
) {
  tags$header(
    class = "app-header",
    tags$img(
      src = logo,
      class = "app-logo",
      alt = "Institution logo"
    ),
    tags$h1(
      title,
      class = "app-title"
    )
  )
}

corporate_content <- function(...) {
  div(
    class = "app-content",
    ...
  )
}

corporate_footer <- function(...) {
  tags$footer(
    class = "app-footer",
    ...
  )
}