# ------------------------------------------------------------------------------
# get_redcap_data.R
#
# Downloads records from REDCap and return them as a data frame.
#
# The section labeled "API Playground Code" is copied from the REDCap
# API Playground and should be copy+pasted from there and edited if export
# options change.
# ------------------------------------------------------------------------------

get_redcap_data <- function(secret_path = file.path("config", "secrets.yml")) {
    library(httr)
  library(yaml)
  
  secrets <- yaml::read_yaml(secret_path)
  token <- secrets$REDCAP_TOKEN
  url   <- secrets$REDCAP_URL
  
  stopifnot(!is.null(token), !is.null(url))
  
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>
  # REDCap API Playground Code
  # <<<<<<<<<<<<<<<<<<<<<<<<<<
  
  form_data <- list(
    token = token,
    content = "record",
    action = "export",
    format = "csv",
    type = "flat",
    csvDelimiter = "",
    "fields[0]" = "record_id",
    "fields[1]" = "history_number",
    "fields[2]" = "canton_code",
    "fields[3]" = "canton_name",
    "fields[4]" = "district_number",
    "fields[5]" = "district_name",
    "fields[6]" = "bfs_municipality_number",
    "fields[7]" = "municipality_name",
    "fields[8]" = "date_of_inclusion",
    "fields[9]" = "municipalities_complete",
    rawOrLabel = "label",
    rawOrLabelHeaders = "raw",
    exportCheckboxLabel = "true",
    exportSurveyFields = "false",
    exportDataAccessGroups = "false",
    returnFormat = "json"
  )
  
  response <- httr::POST(
    url = url,
    body = form_data,
    encode = "form"
  )
  
  # <<<<<<<<<<<<>>>>>>>>>>>>>>>>>
  
  httr::stop_for_status(response)
  
  raw_csv <- httr::content(response, as = "text", encoding = "UTF-8")
  read.csv(text = raw_csv, stringsAsFactors = FALSE)
}
