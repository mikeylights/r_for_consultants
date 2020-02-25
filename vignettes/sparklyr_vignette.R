#install sparklyr, only need to run this one time
# install.packages("sparklyr")
library(sparklyr)
library(dplyr)

#install spark, only need to run this one time
#spark_install()  

# launch connection with local server
sc <- spark_connect(master = "local")

# launch web GUI to view progress, duration, and event timeline (among other things)
spark_web(sc)


setwd("~/ASGARD/big_data")

cms_puf_columns <- c("npi",                              
                     "nppes_provider_last_org_name",     
                     "nppes_provider_first_name",
                     "nppes_provider_mi",
                     "nppes_credentials",
                     "nppes_provider_gender",
                     "nppes_entity_code",
                     "nppes_provider_street1",
                     "nppes_provider_street2",
                     "nppes_provider_city",
                     "nppes_provider_zip",
                     "nppes_provider_state",
                     "nppes_provider_country",
                     "provider_type",
                     "medicare_participation_indicator",
                     "place_of_service",
                     "hcpcs_code",
                     "hcpcs_description",
                     "hcpcs_drug_indicator",
                     "line_srvc_cnt",
                     "bene_unique_cnt",
                     "bene_day_srvc_cnt",
                     "average_Medicare_allowed_amt",
                     "average_submitted_chrg_amt",
                     "average_Medicare_payment_amt",
                     "average_Medicare_standard_amt")

# you can download the .txt files from here
# https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Physician-and-Other-Supplier

cms_2017 <- spark_read_csv(sc, "cms_2017", "Medicare_Provider_Util_Payment_PUF_CY2017.txt", 
                           columns = cms_puf_columns ,delimiter = "\t", memory = FALSE)
cms_2016 <- spark_read_csv(sc, "cms_2016","Medicare_Provider_Util_Payment_PUF_CY2016.txt", 
                           columns = cms_puf_columns, delimiter = "\t", memory = FALSE)
cms_2015 <- spark_read_csv(sc, "cms_2015", "Medicare_Provider_Util_Payment_PUF_CY2015.txt", 
                           columns = cms_puf_columns, delimiter = "\t", memory = FALSE)
phys_comp <- spark_read_csv(sc, "phys_comp", "Physician_Compare_National_Downloadable_File.csv", 
                            memory = FALSE)

cms_2015 <- cms_2015 %>% mutate(year = "2015")
cms_2016 <- cms_2016 %>% mutate(year = "2016")
cms_2017 <- cms_2017 %>% mutate(year = "2017")

phys_comp_3 <- phys_comp %>% 
  mutate(affiliations = paste(Hospital_affiliation_LBN_1, Hospital_affiliation_LBN_3, Hospital_affiliation_LBN_3)) %>% 
  select(NPI, affiliations) 

phys_comp_uniques <- phys_comp_3 %>% 
  distinct(NPI, affiliations) %>% 
  rename(npi = NPI) 

# union the three years of physician utilization datra (~ 30 million rows total)
# and join in the physician affiliation data set
cms_2015_2017 <- cms_2017 %>% union(cms_2016) %>% union(cms_2015) %>% 
  mutate(npi = as.character(npi)) %>% 
  left_join(phys_comp_uniques, by = "npi") 

# example of a dplyr group_by aggregation across 30 million rows
# takes ~ 3.5min to add to memory
sample_doc <- cms_2015_2017 %>% 
  filter(npi == "1962461012") %>% 
  group_by(npi,year, hcpcs_description, affiliations) %>% 
  summarise(procedures = sum(line_srvc_cnt, na.rm = TRUE)) %>% 
  compute("sample_doc")

# example of pivot_wider or spread in the sdf language (optional)
sample_doc_wide <- cms_2015_2017 %>% 
  filter(npi == "1962461012") %>% 
  sdf_pivot(npi+hcpcs_description+affiliations ~ year,
            fun.aggregate = list(procedures = "sum")) %>% 
  compute("sample_doc_wide")

# aggregate all docs
# takes 21min to add to memory
all_docs <- cms_2015_2017 %>% 
  group_by(npi,year, affiliations) %>% 
  summarise(procedures = sum(line_srvc_cnt, na.rm = TRUE)) %>% 
  compute("all_docs")



# export the 30 million row df to .csv
# takes ~ 24 min
# spark_write_csv(cms_2015_2017, "cms_2015_2017.csv")