# -----------------------------------------------------------------------------
# Generate Deployment Manifest
#
# Run this script once before deploying to Posit Connect. It generates
# manifest.json, which pins the exact R and package versions needed to
# reproduce your app on the server.
#
# Usage (from any working directory):
#   Rscript write_manifest.R
#   Rscript path/to/your-app/write_manifest.R
# -----------------------------------------------------------------------------

if (!requireNamespace("rsconnect", quietly = TRUE)) {
  install.packages("rsconnect", repos = "https://cloud.r-project.org")
}

args <- commandArgs(trailingOnly = FALSE)
script_flag <- args[startsWith(args, "--file=")]
if (length(script_flag) == 1) {
  app_dir <- normalizePath(dirname(sub("--file=", "", script_flag)))
} else if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  app_dir <- normalizePath(dirname(rstudioapi::getSourceEditorContext()$path))
} else {
  app_dir <- getwd()
}

message("Writing manifest.json in: ", app_dir)
rsconnect::writeManifest(appDir = app_dir)
message("Done. Commit manifest.json and upload to Posit Connect.")
