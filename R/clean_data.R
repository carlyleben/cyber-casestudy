# This script cleans the raw cybersecurity data.

# load libraries
library(dplyr)
library(tidyverse)

# load in stacked dataframe
in_cyber_data <- readRDS("data/cve.with.desc.ref.conf.rds")

# unnest the metric columnh
current_df <- in_cyber_data %>% unnest(cols = metrics, names_sep = '.')

# get rid of the  columns we don't want
current_df <- current_df %>% select(id, sourceIdentifier, published, lastModified, vulnStatus, metrics.cvssMetricV31,
                                    evaluatorSolution, evaluatorImpact, evaluatorComment, vendorComments, weaknesses)

# unnest weaknesses
current_df <- current_df %>% unnest(cols = weaknesses, names_sep = '.')

# unnest weakness descriptions
current_df <- current_df %>% unnest(cols = weaknesses.description, names_sep = '.')

# unnest metric
current_df <- current_df %>% unnest_wider(col = metrics.cvssMetricV31, names_sep = '.')