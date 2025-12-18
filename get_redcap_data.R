#!/usr/bin/env Rscript

library(httr)
library(yaml)

secret_path <- file.path("config", "secrets.yml")

secrets <- yaml::read_yaml(secret_path)

token <- secrets$REDCAP_TOKEN
url <- secrets$REDCAP_URL

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
  rawOrLabel = "raw",
  rawOrLabelHeaders = "raw",
  exportCheckboxLabel = "false",
  exportSurveyFields = "false",
  exportDataAccessGroups = "false",
  returnFormat = "json"
)

response <- POST(url, body = form_data, encode = "form")
result <- content(response)

print(result)