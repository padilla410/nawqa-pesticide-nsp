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
path_base <- c('1_fetch/in/maps/')
path_dbfs <- paste0(path_base, 'dbf19')
path_bins <- paste0(path_base, 'bins')
path_labels <- paste0(path_base, 'labels')

# define plot variables
year <- '2019'

c(p1_targets_list, p2_targets_list)

