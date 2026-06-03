# ZHAW Shiny dashboard template

This repository provides a structured template for building institutional
Shiny dashboards with consistent layout, branding, and legal footer.

UI stands for User Interface. A Shiny application usually consists of two main components: a `ui` object and a `server` function.

- The UI defines what the user sees (layout, inputs, outputs).
- The server defines how the application behaves (reactivity, data processing, rendering).

If you are new to Shiny, see the [official Shiny getting started tutorial](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/) to learn the basics.


---

## Quickstart

1. Clone or copy this repository.
2. Open `config.yml` and set your title, brand, and legal notice.
3. Open `dashboard_ui.R` and add your UI elements inside `dashboard_ui()`.
4. Open `dashboard_server.R` and add your server logic inside `dashboard_server()`.
5. Run the app:

```r
shiny::runApp()
```

That's it. You do not need to touch any other file.

---

## File structure

```
app.R                       # Application entry point (do not modify)
template/
  layout.R               # Layout helpers (do not modify)

dashboard_ui.R              # Edit this – dashboard UI content
dashboard_server.R          # Edit this – dashboard server logic

config.yml                  # Branding and legal configuration
write_manifest.R            # Run once before deploying to Posit Connect
www/
  style.css                 # Styling
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
- `partner_logos` should be prepared in `1500 x 850 px` (about `1.76:1`),
  and the template scales them into a consistent display frame.

---

## Languages

The template ships with English and German support via [`shiny.i18n`](https://github.com/Appsilon/shiny.i18n).
A language selector is shown in the header — no configuration needed to use it.

### Translating your own strings

1. Open [www/i18n/translation.json](www/i18n/translation.json) and add a row for each string you want to translate:

```json
{
  "languages": ["en", "de"],
  "translation": [
    {"en": "My label", "de": "Meine Beschriftung"}
  ]
}
```

2. In `dashboard_ui.R`, wrap the string with `tr()`:

```r
p(tr("My label"))
```

`tr()` is already defined at the top of `dashboard_ui()` — it calls `i18n$t()` when a translator is available and falls back to the raw string otherwise.

### Adding a language

1. Add the language code to the `"languages"` array in `translation.json` and add a translation column to every row.
2. Add a choice to the `selectInput` in `app.R`:

```r
choices = c("English" = "en", "Deutsch" = "de", "Français" = "fr")
```

---

## Do not edit

- `app.R`
- `template/layout.R`

These files define the structural template and should remain unchanged.

---

## Run the app

In R:

```r
shiny::runApp()
```

Or open `app.R` in RStudio and click **Run App**.
