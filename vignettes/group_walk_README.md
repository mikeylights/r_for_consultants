# Introduction 
Large data frames sometimes require that we split the original data into smaller data frames that R can digest in-memory. Using a combination of "group_by" and "group_walk", it is possible to generate new data frames based on a variable that exists in your data set.

# Getting Started
- Just follow the script to execute the data frame split.

# Contribute
I've included two scenarios:
1.  Original data frame has a low volume factor (3 levels or less)
2.  Original data frame has high-volume factor (10 levels or more). This approach leverages the forcats package!

# Resources
- https://dplyr.tidyverse.org/reference/group_map.html
- https://forcats.tidyverse.org/

# Questions
- Contact misanchez@deloitte.com
