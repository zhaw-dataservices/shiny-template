# -----------------------------------------------------------------------------
# UI Layout Helpers -- *DO NOT EDIT*
#
# Defines structural UI components for the ZHAW Shiny dashboard template:
#   - Header
#   - Content wrapper
#   - Footer
#   - Legal notice renderer
#
# This file contains layout logic only.
# No application-specific content should be added here.
# -----------------------------------------------------------------------------


#' Corporate Header
#'
#' Creates the fixed header section of the dashboard.
#'
#' @param title Character string. Dashboard title displayed in the header.
#' @param logo Character string. Filename of the logo located in /www.
#'
#' @return A <header> tag element.
corporate_header <- function(title, logo) {
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


#' Corporate Content Wrapper
#'
#' Wraps dashboard content in a standardized layout container.
#'
#' @param ... UI elements to include in the content area.
#'
#' @return A <div> tag element with class "app-content".
corporate_content <- function(...) {
  div(
    class = "app-content",
    ...
  )
}


#' Corporate Footer
#'
#' Creates the footer section. Footer color is controlled by the brand CSS
#' class on the outer `.app-page` container (e.g. `.brand-black .app-footer`).
#'
#' @param ... UI elements to include inside the footer.
#'
#' @return A <footer> tag element.
corporate_footer <- function(...) {
  tags$footer(
    class = "app-footer",
    ...
  )
}


#' Render Legal Notice
#'
#' Renders legal notice items as a single line separated by dots.
#'
#' @param lines Character vector containing legal notice entries.
#'
#' @return A <p> tag element.
render_legal_notice <- function(lines) {
  tags$p(
    paste(lines, collapse = " · ")
  )
}
