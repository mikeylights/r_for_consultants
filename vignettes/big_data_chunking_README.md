# Introduction 
When dealing with large data, you may want to split the original data into smaller subsets, then apply the same transformation to each of the subset data frames. If you'd like to see an easy way to split a data frame, check out the **"group_walk_vignette"**. This particular vignette will show the steps involved in taking multiple files from one folder, then importing, wrangling, combining, and exporting a single aggregated data frame or flat file. Each data frame in the folder must have the same columns, and preferrably the same column types, which can be controlled for.

# Getting Started
- Install "pacman" if you haven't already, then just follow the script
- Replace the example data frame names with your own to customize

# Contribute
I've included two scenarios:
1.  Iterate through multiple files to create in-memory data frame
2.  Iterate through multiple files to create an out-of-memory flat file (minimizes the reliance on Rstudio memory)

# Resources
- https://vroom.r-lib.org/reference/vroom_write.html
- https://dplyr.tidyverse.org/reference/index.html

# Questions
- Contact misanchez@deloitte.com
