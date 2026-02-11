# ZHAW Shiny dashboard template

This repository provides a structured template for building institutional
Shiny dashboards with consistent layout, branding, and legal footer.

UI stands for User Interface. A Shiny application usually consists of two main components: a `ui` object and a `server` function.

- The UI defines what the user sees (layout, inputs, outputs).
- The server defines how the application behaves (reactivity, data processing, rendering).

If you are new to Shiny, see the [official Shiny getting started tutorial](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/) to learn the basics.


---

## File structure

```
app.R                 # Application entry point (do not modify)
ui_layout.R           # Layout helpers (header, footer, content wrapper)

dashboard_ui.R        # Edit this – dashboard UI content
dashboard_server.R    # Edit this – dashboard server logic

config.yml            # Branding and legal configuration
www/
  style.css           # Styling
  logo-standard.png
  logo-black.png
```

---

## What you should edit

### Dashboard UI

Edit `dashboard_ui.R` and define:

```r
dashboard_ui <- function() {
  tagList(
    # your UI components here
  )
}
```

### Dashboard server logic

Edit `dashboard_server.R` and define:

```r
dashboard_server <- function(input, output, session) {
  # your server logic here
}
```

#### Data

Load static datasets at the top of `dashboard_server.R`, above the
`dashboard_server()` function. Use `reactive()` only if data must update during runtime.


### Branding and legal notice

Edit `config.yml`:

```yaml
title: "Dashboard title"
brand: "standard"   # or "black"

legal_notice:
  - "Institution"
  - "Department"
  - "Contact"
```

- `brand` controls the logo and footer color.
- `legal_notice` items are displayed in the footer separated by dots.

---

## Do not edit

- `app.R`
- `ui_layout.R`

These files define the structural template and should remain unchanged.

---

## Run the app

In R:

```r
shiny::runApp()
```

Or open `app.R` in RStudio and click **Run App**.
