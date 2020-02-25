library(tictoc)
library(readr)
library(data.table)
library(vroom)

#### Clear memory (this clears all data from env) ####
gc()
rm(list = ls(all.names = TRUE))


setwd("G:/AF-Surgeon General/AFMOA North/AFMOA_AFMS Analytics/ASGARD/Internal Capacity Improvement/data")

# View speed difference on single file upload
tic("readr_import")
cms_via_fread <- fread("double/Medicare_Provider_Utilization_and_Payment_Data__Physician_and_Other_Supplier_PUF_CY2015.csv")
toc()

tic("vroom_import")
cms_via_vroom <- vroom("double/Medicare_Provider_Utilization_and_Payment_Data__Physician_and_Other_Supplier_PUF_CY2015.csv")
toc()


### clear memory again for next phase ####
gc()
rm(list = ls(all.names = TRUE))


# View speed difference on multi-file upload
files <- dir("G:/AF-Surgeon General/AFMOA North/AFMOA_AFMS Analytics/ASGARD/Internal Capacity Improvement/data/double")
files
tic("20m row import")
cms_multi_vroom <- vroom(files, id = "path")
toc()

### clear memory again for next phase ####
gc()
rm(list = ls(all.names = TRUE))

# How to do column selection and typing using vroom
tic("2m rows phys compare")
phys_comp <- vroom("Physician_Compare_National_Downloadable_File.csv", 
                   delim = ",",
                   col_types = c(NPI= "c", `Medical school name`= "c", `Graduation year`= "c", `Primary specialty`= "c",
                                 `All secondary specialties`= "c",`Organization legal name`= "c", City= "c", State= "c", 
                                 `Hospital affiliation LBN 1`= "c", `Hospital affiliation LBN 2`= "c"),
                   col_select = c(NPI, `Medical school name`, `Graduation year`, `Primary specialty`,
                                  `All secondary specialties`,`Organization legal name`, City, State, 
                                  `Hospital affiliation LBN 1`, `Hospital affiliation LBN 2`))
toc()


# How to write files out using vroom
tic("write phys comp")
vroom_write(phys_comp, "phys_comp.tsv")
toc()



