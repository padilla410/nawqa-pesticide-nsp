# targets
library(targets)
library(tarchetypes)

tar_option_set(packages = c(
  'dplyr', 'readr', 'stringr', 'purrr',                   # wrangle dbf and csv files
  'raster', 'foreign',                                    # work with rasters
  'forcats', 'ggplot2', 'ggspatial', 'maps', 'glue', 'sf' # plot
))

# setting options
options(tidyverse.quiet = TRUE)

source('1_fetch.R')
source('2_process.R')
# source('3_visualize.R')

# tar_option_set(debug = "p1_pest_bin_csv")


# define input file paths
path_dbfs <- c('1_fetch/in/maps/dbf19')
path_bins <- c('1_fetch/in/maps/bins')
path_labels <- c('1_fetch/in/maps/labels')

# define plot variables
year <- '2019'

c(p1_targets_list, p2_targets_list)

