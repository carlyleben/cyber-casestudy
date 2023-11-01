## get.cyber.data.r
library(jsonlite)
library(tidyverse)

# https://nvd.nist.gov/ 
# https://nvd.nist.gov/developers/vulnerabilities 
# https://www.exploit-db.com/
  
tot = read_json('https://services.nvd.nist.gov/rest/json/cves/2.0/')
head(tot)
n = tot$totalResults
max.per.query = 2000
J = ceiling(n/max.per.query)
n/max.per.query
J

for (j in 3:J){
  cat(j, '')
  
  # Use startindex to pull all records API
  # &resultsPerPage=2000 is the default and max allowed 
  startIndex = format((j-1)*max.per.query, scientific = F)
  
  url = paste0('https://services.nvd.nist.gov/rest/json/cves/2.0/?startIndex=',
               startIndex) 
  
  d = read_json(url, 
                simplifyVector = TRUE)
  
  filename = paste0('rawdata/cve.', j, '.rds')
  saveRDS(d, file=filename)
  
  ## From https://nvd.nist.gov/developers/start-here#
  
  ## "The public rate limit (without an API key) is 
  ## 5 requests in a rolling 30 second window; 
  ## the rate limit with an API key is 
  ##  50 requests in a rolling 30 second window."
  
  ## "It is recommended that users "sleep" their scripts 
  ## for six seconds between requests."
  Sys.sleep(6) 
  
}


#d2 = readLines('https://services.nvd.nist.gov/rest/json/cves/2.0/?pubStartDate=2021-08-01T00:00:00.000&pubEndDate=2021-08-31T00:00:00.000')
# head(d)
# dim(d$vulnerabilities)
# df = d$vulnerabilities
# head(df[[1]]$cve)
# names(df)
# df = df %>%
#   select(-descriptions, 
#          -references)
# head(df)
