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
#' @param lang_selector Optional Shiny UI element (e.g. selectInput) for
#'   language switching, rendered to the right of the navigation links.
#'
#' @return A <header> tag element.
corporate_header <- function(title, logo,
                             logo_alt = "Institution logo",
                             links = NULL,
                             lang_selector = NULL) {
  nav_links <- if (!is.null(links)) {
    tags$nav(
      class = "app-header-nav",
      lapply(links, function(link) {
        tags$a(href = link$url, link$label, target = "_blank")
      })
    )
  }

  lang_el <- if (!is.null(lang_selector)) {
    div(class = "app-lang-selector", lang_selector)
  }

  controls <- if (!is.null(nav_links) || !is.null(lang_el)) {
    div(class = "app-header-controls", nav_links, lang_el)
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
    controls
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


#' Corporate Partner Strip
#'
#' Renders a band of partner logos above the footer.
#' Returns NULL invisibly if no logos are configured.
#'
#' @param partner_logos Optional list of named lists with 'filename' and
#'   'alt' keys, each pointing to an image file in /www.
#' @param i18n Optional shiny.i18n Translator object for translating labels.
#'
#' @return A <div> tag element or NULL.
corporate_partner_strip <- function(partner_logos = NULL, i18n = NULL) {
  if (is.null(partner_logos) || length(partner_logos) == 0) {
    return(NULL)
  }

  tr <- function(x) if (!is.null(i18n)) i18n$t(x) else x

  tags$div(
    class = "app-partner-strip",
    tags$span(tr("Partners"), class = "app-partner-label"),
    lapply(partner_logos, function(logo) {
      tags$img(
        src = logo$filename,
        class = "app-partner-logo",
        alt = logo$alt
      )
    })
  )
}


#' Corporate Footer
#'
#' Renders the legal notice footer. Always shown.
#'
#' @param legal Named list passed to render_legal_notice().
#' @param references Optional named list with keys 'project_database' and 'ord',
#'   each a list of named lists with 'label' and 'url'. Omitted sections are hidden.
#' @param i18n Optional shiny.i18n Translator object for translating labels.
#'
#' @return A <footer> tag element.
corporate_footer <- function(legal, references = NULL, i18n = NULL) {
  tags$footer(
    class = "app-footer",
    render_legal_notice(legal),
    render_references(references, i18n = i18n)
  )
}


# Renders a cross-reference section from a named list with optional keys
# 'project_database' and 'ord', each a list of {label, url} entries.
# Returns NULL if both sections are absent or empty.
render_references <- function(cfg, i18n = NULL) {
  if (is.null(cfg)) return(NULL)

  tr <- function(x) if (!is.null(i18n)) i18n$t(x) else x

  make_link_row <- function(section_label, links) {
    if (is.null(links) || length(links) == 0) return(NULL)
    link_tags <- lapply(links, function(l) {
      tags$a(href = l$url, l$label, target = "_blank")
    })
    interleaved <- list()
    for (i in seq_along(link_tags)) {
      interleaved <- c(interleaved, list(link_tags[[i]]))
      if (i < length(link_tags)) interleaved <- c(interleaved, list(" · "))
    }
    tags$p(
      tags$span(section_label, ": ", class = "app-footer-ref-label"),
      do.call(tagList, interleaved)
    )
  }

  rows <- list(
    make_link_row(tr("Project Database"), cfg$project_database),
    make_link_row(tr("ORD"),              cfg$ord)
  )
  rows <- Filter(Negate(is.null), rows)
  if (length(rows) == 0) return(NULL)

  tagList(
    tags$hr(class = "app-footer-divider"),
    do.call(tagList, rows)
  )
}


# Finds the first email address in a string and wraps it in a mailto link.
# Returns a tagList with the surrounding text preserved, or plain text if no
# email is found.
linkify_email <- function(text) {
  pattern <- "[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}"
  m <- regexpr(pattern, text, perl = TRUE)
  if (m == -1) {
    return(text)
  }
  start <- as.integer(m)
  end <- start + attr(m, "match.length") - 1
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

  if (!is.null(cfg$institution) && nzchar(cfg$institution)) {
    lines <- c(lines, list(tags$p(tags$strong(cfg$institution))))
  }

  if (!is.null(cfg$unit$label) && nzchar(cfg$unit$label)) {
    has_link <- !is.null(cfg$unit$link_url) && nzchar(cfg$unit$link_url) &&
      !is.null(cfg$unit$link_text) && nzchar(cfg$unit$link_text)
    unit_el <- if (has_link) {
      tagList(
        cfg$unit$label, " · ",
        tags$a(href = cfg$unit$link_url, cfg$unit$link_text, target = "_blank")
      )
    } else {
      cfg$unit$label
    }
    lines <- c(lines, list(tags$p(unit_el)))
  }

  # Build third line item by item so contact can contain a linked email
  parts <- list()
  for (key in c("department", "institute", "contact")) {
    val <- cfg[[key]]
    if (!is.null(val) && nzchar(val)) {
      parts <- c(parts, list(if (key == "contact") linkify_email(val) else val))
    }
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
