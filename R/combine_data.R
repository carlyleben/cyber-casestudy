## clean.cyber.data.r
## extract contents of the json objects and 
## compile in data frames
library(jsonlite)

tot = read_json('https://services.nvd.nist.gov/rest/json/cves/2.0/')
head(tot)

n = tot$totalResults
max.per.query = 2000
J = ceiling(n/max.per.query)
n/max.per.query
J
dd = NULL

for (j in 1:J){
  cat(j, '')
  
  filename = paste0('rawdata/cve.', j, '.rds')
  d = readRDS(filename)
  df = d$vulnerabilities$cve
  
  # df = df %>%
  #   select(-descriptions, 
  #          -references, 
  #          -configurations, 
  #          -metrics)
  # head(df)
  
  ## join 
  dd = bind_rows(dd, df)
  
}


saveRDS(dd , file='data/cve.with.desc.ref.conf.rds')
