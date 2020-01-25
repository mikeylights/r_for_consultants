#### dtplyr allows for a data.table backend in parallel with dplyr front-end syntax ####
#' The value is that data.table is the fastest wrangling syntax, while dplyr is the most readable.
#' You typically sacrifice speed when using dplyr, but now, you can write dplyr syntax while leveraging
#' the speed of data.table via dtplyr

#### Setup environment ####
library(pacman)

#' pacman looks at the packages you need and does whatever is necessary to make them usable
#' whether you need it installed or just loaded as a library
p_load(vroom, dtplyr, dplyr, data.table) 

# vroom = for data import (much faster when not reading directly from web)
# dtplyr = data.table backend for dplyr
# dplyr = best wrangling syntax

# import data from cms website (~2.17m rows, takes about 2 minutes)
phys_comp <- vroom("https://data.medicare.gov/api/views/mj5m-pzi6/rows.csv?accessType=DOWNLOAD&bom=true&format=true&sorting=true")

# 1) load as lazy data frame (required first step for dtplyr)
phys_comp_lz <- lazy_dt(phys_comp)


# 2) Process data with dtyplyr
#' create df of total clinicians by hospital name and specialty across all hospitals
#' data. table is being used in the background on this run 
#' (check the console where it says "Call..." to see data.table eqquivalent code)
us_hosp_staffing_model <- phys_comp_lz %>% 
  filter(!is.na(`Hospital affiliation LBN 1`)) %>% 
  group_by(`Hospital affiliation LBN 1`, `Primary specialty`) %>% 
  summarise(doctors = n_distinct(NPI)) %>% 
  arrange(`Hospital affiliation LBN 1`,desc(doctors), `Primary specialty`) %>% 
  as_tibble()

