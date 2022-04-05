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

year <- '2019'



# create rasters
list(
  tar_target(
    pesticides_of_interest,
    generate_pest_vector(file_path = 'in/maps/dbf19')
  ),
  
  # read dbfs
  tar_target(
    pesticides_of_interest,
    read_pest_dbf(file_path = 'in/maps/dbf19')
  ),
)

# load plot variables
list(
  tar_target(
    pesticides_of_interest,
    generate_pesticides_vector(file_path = 'in/maps/dbf19')
    ), 
  
  tar_target(
    pesticide_labels,
    read_pest_files(pesticides_of_interest, 
                    file_path = 'in/maps/labels', col_types = rep('c', 4)),
    pattern = map(pesticides_of_interest)
  ),
  
  tar_target(
    pesticide_bins,
    read_pest_files(pesticides_of_interest, 
                    file_path = 'in/maps/bins', col_types = rep('d', 5)),
    pattern = map(pesticides_of_interest)
  )
)