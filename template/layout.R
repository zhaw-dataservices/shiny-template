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
#' @param logo_alt Character string. Alt text for the logo image.
#' @param links Optional list of named lists with 'label' and 'url',
#'   rendered as navigation links on the right side of the header.
#'
#' @return A <header> tag element.
corporate_header <- function(title, logo,
                             logo_alt = "Institution logo",
                             links = NULL) {
  nav_links <- if (!is.null(links)) {
    tags$nav(
      class = "app-header-nav",
      lapply(links, function(link) {
        tags$a(href = link$url, link$label, target = "_blank")
      })
    )
  }

  tags$header(
    class = "app-header",
    tags$img(
      src = logo,
      class = "app-logo",
      alt = logo_alt
    ),
    tags$h1(
      title,
      class = "app-title"
    ),
    nav_links
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
#' Creates the footer section with legal notice and optional partner logos.
#'
#' @param legal Named list passed to render_legal_notice().
#' @param partner_logos Optional list of named lists with 'filename' and
#'   'alt' keys, each pointing to an image file in /www.
#'
#' @return A <footer> tag element.
corporate_footer <- function(legal, partner_logos = NULL) {
  logo_els <- if (!is.null(partner_logos) && length(partner_logos) > 0) {
    tags$div(
      class = "app-footer-logos",
      lapply(partner_logos, function(logo) {
        tags$img(
          src   = logo$filename,
          class = "app-footer-partner-logo",
          alt   = logo$alt
        )
      })
    )
  }

  tags$footer(
    class = "app-footer",
    render_legal_notice(legal),
    logo_els
  )
}


# Finds the first email address in a string and wraps it in a mailto link.
# Returns a tagList with the surrounding text preserved, or plain text if no
# email is found.
linkify_email <- function(text) {
  pattern <- "[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}"
  m <- regexpr(pattern, text, perl = TRUE)
  if (m == -1) return(text)
  start <- as.integer(m)
  end   <- start + attr(m, "match.length") - 1
  email <- substr(text, start, end)
  tagList(
    substr(text, 1, start - 1),
    tags$a(href = paste0("mailto:", email), email),
    substr(text, end + 1, nchar(text))
  )
}


#' Render Legal Notice
#'
#' Renders legal notice from a named config list:
#'   - institution: first line, always shown, bold
#'   - unit:        second line (label + optional link), hidden if blank
#'   - department, institute, contact: joined by " · " on the third line;
#'     any email address in contact is automatically made into a mailto link
#'
#' @param cfg Named list: institution, unit, department, institute, contact.
#'
#' @return A tagList of <p> elements.
render_legal_notice <- function(cfg) {
  lines <- list()

  if (!is.null(cfg$institution) && nzchar(cfg$institution))
    lines <- c(lines, list(tags$p(tags$strong(cfg$institution))))

  if (!is.null(cfg$unit$label) && nzchar(cfg$unit$label)) {
    has_link <- !is.null(cfg$unit$link_url) && nzchar(cfg$unit$link_url) &&
                !is.null(cfg$unit$link_text) && nzchar(cfg$unit$link_text)
    unit_el <- if (has_link)
      tagList(cfg$unit$label, " · ",
        tags$a(href = cfg$unit$link_url, cfg$unit$link_text, target = "_blank"))
    else
      cfg$unit$label
    lines <- c(lines, list(tags$p(unit_el)))
  }

  # Build third line item by item so contact can contain a linked email
  parts <- list()
  for (key in c("department", "institute", "contact")) {
    val <- cfg[[key]]
    if (!is.null(val) && nzchar(val))
      parts <- c(parts, list(if (key == "contact") linkify_email(val) else val))
  }
  if (length(parts) > 0) {
    interleaved <- list()
    for (i in seq_along(parts)) {
      interleaved <- c(interleaved, list(parts[[i]]))
      if (i < length(parts)) interleaved <- c(interleaved, list(" · "))
    }
    lines <- c(lines, list(tags$p(do.call(tagList, interleaved))))
  }

  do.call(tagList, lines)
}
