library(pacman)
p_load(tidyverse, plyr, vroom, fs, ggpubr, rstatix)

### Load data ####
data(iris)
attach(iris)

#### Create vector of numeric variables within your data frame ####
spec <- iris %>% 
  select_if(is.numeric) %>% 
  colnames(.)


#### Create functions for outlier detection ####
iqr_1.5 <- function(x, k = 1.5, na.rm = TRUE) {
  quar <- quantile(x, probs = c(0.25, 0.75), na.rm = na.rm)
  iqr <- diff(quar)
  
  (quar[1] - k * iqr > x) | (x > quar[2] + k * iqr)
}

iqr_3 <- function(x, k = 3, na.rm = TRUE) {
  quar <- quantile(x, probs = c(0.25, 0.75), na.rm = na.rm)
  iqr <- diff(quar)
  
  (quar[1] - k * iqr > x) | (x > quar[2] + k * iqr)
}

z <- function(x, thres = 3, na.rm = TRUE) {
  abs(x - mean(x, na.rm = na.rm)) > thres * sd(x, na.rm = na.rm)
}

z_mad <- function(x, thres = 3, na.rm = TRUE) {
  abs(x - median(x, na.rm = na.rm)) > thres * mad(x, na.rm = na.rm)
}




#### Identify outliers across full data set (value of "TRUE" == outlier) ####
outliers_identified <- iris %>% 
  mutate_at(spec, list("iqr_1.5" = ~iqr_1.5(.),
                       "iqr_3" = ~iqr_3(.),
                       "z" = ~z(., na.rm = TRUE),
                       "z_mad" = ~z_mad(., na.rm = TRUE)))

#### Identify outliers by group (value of "TRUE" == outlier) ####
outliers_by_group <- iris %>% 
  group_by(Species) %>% 
  mutate_at(spec, list("iqr_1.5" = ~iqr_1.5(.),
                       "iqr_3" = ~iqr_3(.),
                       "z" = ~z(., na.rm = TRUE),
                       "z_mad" = ~z_mad(., na.rm = TRUE)))


#### identify outliers by hand ####
ol_byhand <- iris %>% 
  group_by(Species) %>% 
  summarise(iqr = IQR(Petal.Width),
            q1 = quantile(Petal.Width, probs = 0.25),
            q3 = quantile(Petal.Width, probs = 0.75))

obh <- iris %>% 
  left_join(ol_byhand, by = "Species") %>% 
  mutate(outlier = ifelse(Petal.Width < q1 - (1.5*iqr)  | Petal.Width > (1.5*iqr) + q3, "TRUE", "FALSE"))


#### test z by hand ####
zol_byhand <- iris %>% 
  group_by(Species) %>% 
  summarise(sd = sd(Petal.Width),
            mean = mean(Petal.Width),
            median = median(Petal.Width),
            mad = mad(Petal.Width))

zobh <- iris %>% 
  left_join(zol_byhand, by = "Species") %>% 
  mutate(outlier_mean = ifelse(abs(Petal.Width - mean) > 3 * sd, "TRUE", "FALSE"),
         outlier_mad = ifelse(abs(Petal.Width - median) > 3 * mad, "TRUE", "FALSE"))


####  ttest ####
iris %>% 
  group_by(Species) %>% 
  get_summary_stats(type = "full")

stat.test <- iris %>% 
  anova_test(Petal.Width ~ Species)

plot(stat.test)
ggplot(stat.test)
stat.test
print(stat.test)

md_out <- iris %>% 
  group_by(Species) %>%
  doo(~mahalanobis_distance(.))

iris %>% 
  shapiro_test(Sepal.Length)

iris %>% 
  group_by(Species) %>% 
  shapiro_test(Sepal.Length, Sepal.Width, Petal.Width, Petal.Length)

iris_gather <- iris %>% 
  gather(metric, n, Sepal.Width, Sepal.Length, Petal.Width, Petal.Length)

ggboxplot(iris_gather, x = "Species", y = "n", facet.by = "metric",
          fill = "Species", palette = c("#00AFBB", "#E7B800", "#FC4E07"))
