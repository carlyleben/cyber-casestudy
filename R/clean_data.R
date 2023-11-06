# This script cleans the raw cybersecurity data.

# load libraries
library(dplyr)
library(tidyverse)

# load in dataframes
in_exploit_data <- read.csv("rawdata/files_exploits from exploit-db.csv")
in_cyber_data <- readRDS("data/cve.with.desc.ref.conf.rds")

#=========================#
#=== format cyber data ===#
#=========================#

# unnest the metric columnh
cyber_df <- in_cyber_data %>% unnest(cols = metrics, names_sep = '.')

# get rid of the  columns we don't want
cyber_df <- cyber_df %>% select(id, sourceIdentifier, published, lastModified, vulnStatus, metrics.cvssMetricV31,
                                    evaluatorSolution, evaluatorImpact, evaluatorComment, vendorComments, weaknesses)

# unnest weaknesses
cyber_df <- cyber_df %>% unnest(cols = weaknesses, names_sep = '.', keep_empty = TRUE)

# pivot weaknesses wider so each vulnerability is a unique row
cyber_df <- cyber_df %>% select(-weaknesses.source) %>% 
                         pivot_wider(names_from = weaknesses.type,
                                     values_from = weaknesses.description)

# unnest weakness descriptions
cyber_df <- cyber_df %>% unnest(cols = Primary, names_sep = '.', keep_empty = T)
cyber_df <- cyber_df %>% unnest(cols = Secondary, names_sep = '.', keep_empty = T)

# change col name to make this a little nicer
cyber_df <- rename(cyber_df, metricv31 = metrics.cvssMetricV31)

# unnest metric
cyber_df <- cyber_df %>% unnest_wider(col = metricv31, names_sep = '.')

#============================#
#=== format exploits data ===#
#============================#

# get vector of exploited codes
exploited_codes <- as.character(unlist(strsplit(in_exploit_data$codes, ";")))

#===============================#
#=== create exploits column  ===#
#===============================#

cyber_exploits_df <- cyber_df %>% mutate(exploited = (id %in% exploited_codes))

#==============#
#=== export ===#
#==============#
saveRDS(cyber_exploits_df, file = "data/cyber_exploits_df.RDS")
