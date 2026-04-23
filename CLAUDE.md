# CLAUDE.md — Footer and partner strip implementation task

## Project overview

This is a Shiny dashboard template for ZHAW researchers. It provides a
corporate-design shell (header, content area, footer) that researchers deploy
on Posit Connect. Researchers edit only `dashboard_ui.R`, `dashboard_server.R`,
and `config.yml`. Everything else is locked infrastructure.

Relevant files for this task:

- `template/layout.R` — layout helper functions (header, content, footer)
- `www/style.css` — all CSS
- `config.yml` — runtime configuration
- `app.R` — entry point, do not restructure

---

## Task 1 — Fix footer anchoring

The footer currently does not stay anchored to the bottom of the viewport
when page content is short. Fix this without restructuring `app.R`.

The flex chain is already partially in place:
- `.app-page` has `display: flex; flex-direction: column; min-height: 100vh`
- `.app-content` has `flex: 1`

The likely break is that Shiny's generated `.container-fluid` wrapper
interrupts the flex chain. Fix by adding to `www/style.css`:

```css
.container-fluid {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
}
```

Also verify that `html` and `body` both have `height: 100%`. They should
already — if not, add them.

Do not use `position: fixed` or `position: sticky` for the footer.

---

## Task 2 — Add a dedicated partner strip above the footer

### Design specification

The bottom of the page now has two distinct zones, in this order from top
to bottom:

1. **Partner strip** — a dedicated band for partner logos, shown only when
   partner logos are configured. Light blue-grey background (`#f0f4f8`),
   top border `1px solid #dde3ea`. Contains a "Partners" label on the left
   followed by a horizontal row of logo images.

2. **Legal footer** — the existing legal notice text, on a white background
   with a `1px solid #e6e6e6` top border. Full width, legal text only.

When no partner logos are configured, the partner strip is not rendered at
all — the legal footer sits directly below the content area.

### Visual reference

```
┌─────────────────────────────────────────────────────┐
│  dashboard content                                  │
├─────────────────────────────────────────────────────┤  ← 1px #dde3ea
│  [#f0f4f8 background]                               │
│  Partners   [Logo A]  [Logo B]  [Logo C]            │
├─────────────────────────────────────────────────────┤  ← 1px #e6e6e6
│  ZHAW Zürcher Hochschule für Angewandte ...         │
│  Services Forschungsdaten · contact@zhaw.ch         │
└─────────────────────────────────────────────────────┘
```

### Changes to `template/layout.R`

Split the current `corporate_footer()` into two separate functions:
`corporate_partner_strip()` and `corporate_footer()`.

```r
#' Corporate Partner Strip
#'
#' Renders a band of partner logos above the footer.
#' Returns NULL invisibly if no logos are configured.
#'
#' @param partner_logos Character vector of image filenames located in /www.
#'   If NULL or empty, nothing is rendered.
#'
#' @return A <div> tag element or NULL.
corporate_partner_strip <- function(partner_logos = NULL) {
  if (is.null(partner_logos) || length(partner_logos) == 0) return(NULL)

  tags$div(
    class = "app-partner-strip",
    tags$span("Partners", class = "app-partner-label"),
    lapply(partner_logos, function(filename) {
      tags$img(
        src      = filename,
        class    = "app-partner-logo",
        alt      = paste("Partner logo:", tools::file_path_sans_ext(filename))
      )
    })
  )
}


#' Corporate Footer
#'
#' Renders the legal notice footer. Always shown.
#'
#' @param legal Named list passed to render_legal_notice().
#'
#' @return A <footer> tag element.
corporate_footer <- function(legal) {
  tags$footer(
    class = "app-footer",
    render_legal_notice(legal)
  )
}
```

### Changes to `app.R`

Add `corporate_partner_strip()` between `corporate_content()` and
`corporate_footer()` inside the `.app-page` div:

```r
div(
  class = "app-page",

  corporate_header(
    title = config$title,
    logo  = "logo-negativ.png",
    links = config$header_links
  ),

  corporate_content(
    dashboard_ui()
  ),

  corporate_partner_strip(
    partner_logos = config$partner_logos
  ),

  corporate_footer(
    legal = config$legal_notice
  )
)
```

### Changes to `www/style.css`

Replace the existing `.app-footer` block and add new rules for the partner
strip:

```css
/* Partner strip — shown only when partner logos are configured */
.app-partner-strip {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px 30px;
  background-color: #f0f4f8;
  border-top: 1px solid #dde3ea;
}

.app-partner-label {
  font-size: 11px;
  color: #666666;
  padding-right: 16px;
  border-right: 0.5px solid #dde3ea;
  white-space: nowrap;
  flex-shrink: 0;
}

.app-partner-logo {
  height: 44px;
  width: auto;
  display: block;
}

/* Legal footer — always shown */
.app-footer {
  padding: 10px 30px;
  background-color: #ffffff;
  border-top: 1px solid #e6e6e6;
  font-size: 12px;
  line-height: 1.6;
  color: #000000;
}

.app-footer p {
  margin: 0;
}
```

### Changes to `config.yml`

Add a `partner_logos` key. The value is a list of image filenames located
in `/www`. If there are no partners, the key should be absent or null.

Example with partners:

```yaml
partner_logos:
  - logo-partner-a.png
  - logo-partner-b.png
  - logo-partner-c.png
```

Example without partners (strip not rendered):

```yaml
# partner_logos:
```

---

## Constraints — do not violate these

- Do not edit `dashboard_ui.R` or `dashboard_server.R`
- Do not restructure `app.R` beyond the changes specified above
- Arial is the mandatory font per ZHAW CD — do not change `font-family`
- ZHAW blue is `#0064a6` — do not introduce other brand colours
- The ZHAW logo in the header is not affected by this task
- Partner logo filenames must come from `config.yml`, never hardcoded
- Alt text on partner logo `<img>` tags is required for accessibility
- The label in the partner strip must read "Partners" — do not change this
- Do not use `position: fixed` or `position: sticky` anywhere

---

## How to verify

After implementation:

1. Run the app with `partner_logos` set in `config.yml` — confirm the
   partner strip appears between the content and the legal footer, with
   the light blue-grey background and "Partners" label
2. Run the app with `partner_logos` absent from `config.yml` — confirm
   no partner strip is rendered and the legal footer sits directly below
   the content
3. Resize the browser to a short viewport — confirm the footer and partner
   strip stay anchored to the bottom and do not overlap content
4. Check that logo images render at 44px height and are not distorted
