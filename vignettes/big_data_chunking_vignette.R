#### This script shows how to apply a custom set of dplyr transformations to multiple data frames via iteration ####


# Load pacman for library loads and installations of required packages
library(pacman)

# Install and load required packages
p_load(fs, tidyverse, vroom)

# Cleanup memory
gc(verbose = TRUE, reset = TRUE)
format(memory.size(), units = "MB")
rm(list = ls(all.names = TRUE))

# View a 100-row sample of the file to see the column names
spec <- vroom("G:/AF-Surgeon General/AFMOA North/AFMOA_AFMS Analytics/ASGARD/Internal Capacity Improvement/data/double/Medicare_Provider_Utilization_and_Payment_Data__Physician_and_Other_Supplier_PUF_CY2017.csv",
              id = "file_name", n_max=100)

# Build a vector of the column names to use for later
spec <- spec(spec)

# Point to the directory where your files exist (all files must have same columns)
files <- dir_ls("G:/AF-Surgeon General/AFMOA North/AFMOA_AFMS Analytics/ASGARD/Internal Capacity Improvement/data/double",
                glob = "*.csv")

# Create an empty data frame to hold the final output (replace "doc_summary" name with your own name)
doc_summary <- NULL


#### #### #### #### #### #### #### #### #### #### #### ####
## THIS SCRIPT HAS TWO OPTIONS AFTER LINE 27 IS EXECUTED ##
#### #### #### #### #### #### #### #### #### #### #### ####


#### Option 1 -- Iterate through data frames with vroom import + dplyr syntax wrangling to build an in-memory df ####
#' "doc_summary" is the final output df
#' "workload" is the name of the import that is continuously imported then removed
#' replace both dfs with your own to leverage the for loop for your situation
for(i in seq_along(files)) {
  workload <- vroom(files[i], col_types = spec, id = "file_name")
  doc_summary <- workload %>%
    mutate(year = str_sub(file_name,-8,-5)) %>% 
    group_by(`Provider Type`, year, `HCPCS Description`) %>%
    summarise(total_procedures = sum(`Number of Services`)) %>% 
    bind_rows(doc_summary) 
  rm(workload)
}



#### Option 2 - Iterate through data frames with vroom import + dplyr syntax wrangling  ####
#' and write a singular out-of-memory file to your computer, then continuously appending to the flat file 
#' export method can be changed to ".csv" as well
#' replace names for your own use similar to Option 1
for(i in seq_along(files)) {
  workload <- vroom(files[i], col_types = spec, id = "file_name")
  doc_summary <- workload %>%
    mutate(year = str_sub(file_name,-8,-5)) %>% 
    group_by(`Provider Type`, year, `HCPCS Description`) %>%
    summarise(total_procedures = sum(`Number of Services`)) %>% 
    vroom_write("doc_summary.tsv", append = TRUE)
  rm(workload, doc_summary)
}

