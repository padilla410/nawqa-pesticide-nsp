# targets
library(targets)
library(tarchetypes)

tar_option_set(packages = c(
  'dplyr', 'readr', 'stringr', 'purrr',                   # wrangling dbf and csv files
  'raster', 'foreign',                                    # working with rasters
  'forcats', 'ggplot2', 'ggspatial', 'maps', 'glue', 'sf' # plotting
))

# setting options
options(tidyverse.quiet = TRUE)

source('1_fetch.R')
source('2_process.R')
# source('3_visualize.R')

# tar_option_set(debug = "p1_pest_bin_csv")
# year <- '2019'

# define input file paths
path_dbfs <- c('1_fetch/in/maps/dbf19')
path_bins <- c('1_fetch/in/maps/bins')
path_labels <- c('1_fetch/in/maps/labels')

c(p1_targets_list, p2_targets_list)

