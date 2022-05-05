# targets
library(targets)
library(tarchetypes)

# wrangling dbf and csv files
library(dplyr)
library(readr)
library(stringr)
library(purrr)

# working with rasters
library(raster)
library(foreign)

# plotting
library(forcats)
library(ggplot2)
library(ggspatial)
library(maps)
library(glue)
library(sf)

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

