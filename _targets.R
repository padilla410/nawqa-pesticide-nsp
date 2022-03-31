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

list(
  tar_target(
    pesticides_of_interest,
    generate_pesticides_vector(file_path = 'in/maps/dbf19')
    ), 
  
  tar_target(
    pesticide_labels,
    read_pest_files(pesticides_of_interest, file_path = 'in/maps/labels'),
    pattern = map(pesticides_of_interest)
  ),
  
  tar_target(
    pesticide_bins,
    read_pest_files(pesticides_of_interest, file_path = 'in/maps/bins'),
    pattern = map(pesticides_of_interest)
  )#,
  # 
  # tar_combine(
  #   all_pesticide_bins,
  #   pesticide_bins,
  #   command =
  # )
  # 
  
)