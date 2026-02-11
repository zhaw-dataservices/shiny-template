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
  
  formData <- list("token"=token,
                   content='record',
                   action='export',
                   format='csv',
                   type='flat',
                   csvDelimiter='',
                   'fields[0]'='record_id',
                   'fields[1]'='email_1',
                   'fields[2]'='consent',
                   'fields[3]'='consent_complete',
                   'fields[4]'='sex',
                   'fields[5]'='age',
                   'fields[6]'='time_1',
                   'fields[7]'='time_2',
                   'fields[8]'='time_3',
                   'fields[9]'='time_4',
                   'fields[10]'='time_table',
                   'fields[11]'='problem_1',
                   'fields[12]'='problem_2',
                   'fields[13]'='problem_3',
                   'fields[14]'='problem_4',
                   'fields[15]'='problem_5',
                   'fields[16]'='sleep_quality',
                   'fields[17]'='sleep_score',
                   'fields[18]'='medication',
                   'fields[19]'='form_1_complete',
                   'fields[20]'='problems',
                   'fields[21]'='factor_1',
                   'fields[22]'='factor_2',
                   'fields[23]'='factor_3',
                   'fields[24]'='factor_4',
                   'fields[25]'='factor_5',
                   'fields[26]'='factor_6',
                   'fields[27]'='factor_7',
                   'fields[28]'='factor_8',
                   'fields[29]'='form_2_complete',
                   'fields[30]'='drugs',
                   'fields[31]'='bdz_0',
                   'fields[32]'='bdz_1',
                   'fields[33]'='bdz_2',
                   'fields[34]'='bdz_3',
                   'fields[35]'='bdz_4',
                   'fields[36]'='bdz_e_1',
                   'fields[37]'='bdz_e_2',
                   'fields[38]'='bdz_e_3',
                   'fields[39]'='bdz_e_4',
                   'fields[40]'='bdz_table',
                   'fields[41]'='z_0',
                   'fields[42]'='z_1',
                   'fields[43]'='z_2',
                   'fields[44]'='z_e_1',
                   'fields[45]'='z_e_2',
                   'fields[46]'='z_table',
                   'fields[47]'='sleep_inducing_0',
                   'fields[48]'='sleep_inducing_1',
                   'fields[49]'='sleep_inducing_2',
                   'fields[50]'='sleep_inducing_3',
                   'fields[51]'='sleep_inducing_4',
                   'fields[52]'='sleep_inducing_5',
                   'fields[53]'='sleep_inducing_e_1',
                   'fields[54]'='sleep_inducing_e_2',
                   'fields[55]'='sleep_inducing_e_3',
                   'fields[56]'='sleep_inducing_e_4',
                   'fields[57]'='sleep_inducing_e_5',
                   'fields[58]'='sleep_inducing_table',
                   'fields[59]'='ssr_0',
                   'fields[60]'='ssr_1',
                   'fields[61]'='ssr_2',
                   'fields[62]'='ssr_3',
                   'fields[63]'='ssr_4',
                   'fields[64]'='ssr_5',
                   'fields[65]'='ssr_e_1',
                   'fields[66]'='ssr_e_2',
                   'fields[67]'='ssr_e_3',
                   'fields[68]'='ssr_e_4',
                   'fields[69]'='ssr_e_5',
                   'fields[70]'='ssri_table',
                   'fields[71]'='herbal_0',
                   'fields[72]'='herbal_1',
                   'fields[73]'='herbal_2',
                   'fields[74]'='herbal_3',
                   'fields[75]'='herbal_4',
                   'fields[76]'='herbal_e_1',
                   'fields[77]'='herbal_e_2',
                   'fields[78]'='herbal_e_3',
                   'fields[79]'='herbal_e_4',
                   'fields[80]'='herbal_table',
                   'fields[81]'='form_3_complete',
                   'fields[82]'='alcohol_0',
                   'fields[83]'='alcohol_1',
                   'fields[84]'='alcohol_2',
                   'fields[85]'='alcohol_3',
                   'fields[86]'='alcohol_e_1',
                   'fields[87]'='alcohol_e_2',
                   'fields[88]'='alcohol_e_3',
                   'fields[89]'='alcohol_table',
                   'fields[90]'='form_4_complete',
                   'fields[91]'='hepa_1',
                   'fields[92]'='hepa_2',
                   'fields[93]'='hepa_3',
                   'fields[94]'='hepa_4',
                   'fields[95]'='hepa_5',
                   'fields[96]'='hepa_6',
                   'fields[97]'='hepa_7',
                   'fields[98]'='hepa_8',
                   'fields[99]'='hepa_9',
                   'fields[100]'='hepa_10',
                   'fields[101]'='hepa_11',
                   'fields[102]'='base_2',
                   'fields[103]'='base_3',
                   'fields[104]'='base_4',
                   'fields[105]'='base_5',
                   'fields[106]'='base_6',
                   'fields[107]'='base_7',
                   'fields[108]'='descriptive_5',
                   'fields[109]'='base_8',
                   'fields[110]'='base_9',
                   'fields[111]'='base_10',
                   'fields[112]'='form_5_complete',
                   'fields[113]'='smart_1',
                   'fields[114]'='smart_2',
                   'fields[115]'='smart_3',
                   'fields[116]'='closing_complete',
                   'forms[0]'='consent',
                   'forms[1]'='form_1',
                   'forms[2]'='form_2',
                   'forms[3]'='form_3',
                   'forms[4]'='form_4',
                   'forms[5]'='form_5',
                   'forms[6]'='closing',
                   'events[0]'='baseline_arm_1',
                   'events[1]'='follow_up_arm_1',
                   rawOrLabel='label',
                   rawOrLabelHeaders='raw',
                   exportCheckboxLabel='true',
                   exportSurveyFields='false',
                   exportDataAccessGroups='false',
                   returnFormat='json'
  )

  response <- httr::POST(url, body = formData, encode = "form")
  
  # <<<<<<<<<<<<>>>>>>>>>>>>>>>>>
  
  httr::stop_for_status(response)
  
  raw_csv <- httr::content(response, as = "text", encoding = "UTF-8")
  read.csv(text = raw_csv, stringsAsFactors = FALSE)
}
