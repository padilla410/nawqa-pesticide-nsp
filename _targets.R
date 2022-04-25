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

source('src/web_map_functions.R')
# source('1_fetch/src/fetch_pesticide_data.R')
# source('2_process.R')
# source('3_visualize.R')

# source('draft_docs/fetch_pesticide_data.R')

year <- '2019'



# tar_target(
#   pest_vector,
#   generate_pest_vector(file_path = '1_fetch/in/maps/dbf19')
# )
# # Return the complete list of targets
# # c(p1_targets_list, p2_targets_list, p3_targets_list)



year <- '2019'

# load plot variables
list(
  tar_target(
    pesticides_of_interest,
    generate_pest_vector(file_path = '1_fetch/in/maps/dbf19')
    ),

  tar_target(
    pesticide_labels,
    read_pest_files(pesticides_of_interest,
                    file_path = '1_fetch/in/maps/labels', col_types = rep('c', 4)),
    pattern = map(pesticides_of_interest)
  ),

  tar_target(
    pesticide_bins,
    read_pest_files(pesticides_of_interest,
                    file_path = '1_fetch/in/maps/bins', col_types = rep('d', 5)),
    pattern = map(pesticides_of_interest)
  )
)

# # make plots