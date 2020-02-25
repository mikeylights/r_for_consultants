# Introduction 
This vignette will help anyone get up and running with sparklyr on a non-GFE device. Sparklyr is an R package that enables distributed computing, removing the limitations of Rstudio in-memory capacity problems. This vignette highlights how an analyst is able to perform dplyr manipulations on a data set with ~ 30 million observations. Dplyr functions performed on the data include:
- mutate(), select(), distinct(), left_join(), filter(), and group_by / summarise()
- sdf_pivot() << this is the equivalent to a dplyr spread()
#
Note: Certain pieces of script are commented out if they are one-time runs, or if they take a significant amount of time to run.

# Getting Started
1.	Install sparklyr
2.	Run spark_install() to install spark
3.	Generate a connection to local spark instance
4.  Use dplyr commands to wrangle
5.	Save dfs to spark memory and write out csv files

# Data
Physician Utilization Data for 2015, 2016, and 2017 can be downloaded here:
- https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Physician-and-Other-Supplier
- Download each of the zip files, and the ".txt" will be in each. Move the ".txt" to your project folder

Physician Compare Data for these physicians can be downloaded here:
- https://data.medicare.gov/Physician-Compare/Physician-Compare-National-Downloadable-File/mj5m-pzi6
- Click export, then click "CSV for Excel", then move the file to your project folder

# Helpful Resources
- https://spark.rstudio.com/
- https://rstudio.github.io/bigdataclass/intro-to-sparklyr.html
- https://therinspark.com/index.html
#
Contact misanchez@deloitte.com for any questions! :)