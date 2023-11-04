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
current_df <- in_cyber_data %>% unnest(cols = metrics, names_sep = '.')

# get rid of the  columns we don't want
current_df <- current_df %>% select(id, sourceIdentifier, published, lastModified, vulnStatus, metrics.cvssMetricV31,
                                    evaluatorSolution, evaluatorImpact, evaluatorComment, vendorComments, weaknesses)

# unnest weaknesses
current_df <- current_df %>% unnest(cols = weaknesses, names_sep = '.')

# unnest weakness descriptions
current_df <- current_df %>% unnest(cols = weaknesses.description, names_sep = '.')

# change col name to make this a little nicer
current_df <- rename(metrics.cvssMetricV31 = metricv31)

# unnest metric
current_df <- current_df %>% unnest_wider(col = metricv31, names_sep = '.')

#==============================#
#=== create exploits column ===#
#==============================#

# question -- are these linked by id column? 
# if so, we need to do some gsubbing on current_df id column to get it to match exploits data frame
