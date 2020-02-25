library(pacman)

p_load(tidyverse, vroom)

data("iris")
data("storms")

#### Generate multiple data frames split by a chosen group ####
# In this example, we are splitting by "Species"
iris %>% 
  mutate(group = Species) %>% 
  group_by(Species) %>% 
  group_walk(~ vroom_write(.x, delim = ",",paste0(.y$Species, ".csv")))

# In this example, we are splitting by "status" (storm type)
storms %>% 
  mutate(group = status) %>% 
  group_by(status) %>% 
  group_walk(~ vroom_write(.x, delim = ",",paste0(.y$status, ".csv")))


#### Split on variable that has large amount of unique values by reducing the factor first then creating data frames ####
# reduce the factor by setting a top(n) and then collapsing all other levels into an "Other" category
storms %>%
  mutate(storm_name = as.factor(name)) %>% 
  filter(!is.na(storm_name)) %>%
  mutate(storm_name = fct_lump(storm_name, 9)) %>% # this line creates the top(9)+"Other"
  count(storm_name) %>% 
  arrange(desc(n)) %>% 
  mutate(group = storm_name) %>% 
  group_by(storm_name) %>% 
  group_walk(~ vroom_write(.x, delim = ",",paste0(.y$storm_name, ".csv")))

# reduce the factor by setting a minimum number of occurences and then collapsing all other levels into an "Other" category
storms %>%
  mutate(storm_name = as.factor(name)) %>% 
  filter(!is.na(storm_name)) %>%
  mutate(storm_name = fct_lump_min(storm_name, 180)) %>% # this line sets the min occurences
  count(storm_name) %>% 
  arrange(desc(n)) %>% 
  mutate(group = storm_name) %>% 
  group_by(storm_name) %>% 
  group_walk(~ vroom_write(.x, delim = ",",paste0(.y$storm_name, ".csv")))
