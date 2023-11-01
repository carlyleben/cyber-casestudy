# This script cleans the raw cybersecurity data.

# load libraries
library(dplyr)
library(tidyverse)

# make a function to clean data file
# test
# in_file_path <- "cyber/rawdata/cve.1.rds"
clean_cyber_data <- function(in_file_path) {
  
  # load in data
  in_raw_file <- readRDS(in_file_path)
  
  # grab the data frame
  current_df <- as.data.frame(in_raw_file$vulnerabilities$cve)
  
  # unnest the metric columnh
  current_df <- current_df %>% unnest(cols = metrics, names_sep = '.')
  
  # get rid of the metrics columns we don't want
  
}