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



# Load raster & convert to df -------------------
r_w001001 <- raster::raster('data/raw/nlcd11pctagco/w001001.adf')

# # convert raster to data.frame for remapping the "Value" variable for mapping
# df_w001001 <- as.data.frame(r_w001001)

# load DBF data, bins, and labels ---------------

# read in dbf tables - this determines which maps are made
dbf_files <- list.files('data/raw/dbf19', full.names = T)
ls_dbf_data <- lapply(dbf_files, foreign::read.dbf) # slow-ish 1.56 min for all files
names(ls_dbf_data) <- basename(dbf_files)

# create master list of chemicals - used to read in needed data only
master_list <- stringr::str_match(dbf_files, '(?<=\\_).*?(?=\\.)') %>%
  unique %>%
  as.vector

# read in pesticide names
p_list <- readr::read_delim('data/raw/pesticide_names.txt') %>%
  filter(cmpnd %in% master_list)

# read in labels
label_files <- list.files('data/raw/labels', full.names = T)
ls_label_data <- lapply(label_files, readr::read_csv, col_types = cols())
names(ls_label_data) <- stringr::str_match(basename(label_files), '(?<=\\.).*?(?=\\.)') %>%
  as.vector

# read bins
bin_files <- list.files('data/raw/bins', full.names = T)
ls_bin_data <- lapply(bin_files, readr::read_csv, col_types = cols())
names(ls_bin_data) <- stringr::str_match(basename(bin_files), '(?<=\\.).*?(?=\\.)') %>%
  as.vector

# filter for parameters in the master list
ls_label_data <- ls_label_data %>% 
  .[names(.) %in% master_list]

ls_bin_data <- ls_bin_data %>% 
  .[names(.) %in% master_list]

# assign bins to values --------------------------------

## dummy var
i <- 2

## assign levels based on assigned bins
label <- ls_label_data[[i]] %>% unlist
bin <- ls_bin_data[[i]] %>% unlist
dat <- ls_dbf_data[[i]]

## this is a check to make sure things line up
names(ls_label_data)[i]
names(ls_bin_data)[i]
names(ls_dbf_data)[i]


## join dbf data to raster, convert raster to data.frame, extract values
# An interesting surprise, when not using arcpy, it looks like the 
# VALUE field is called "ID", not "VALUE" in the raster
r_w001001@data@attributes[[1]] <- dplyr::left_join(r_w001001@data@attributes[[1]],
                                                   #H_ACEPHATE
                                                   ls_dbf_data[[i]],
                                                   by = c('ID' = 'VALUE'))
# an alternate way?
r_w001001_alt <- r_w001001
r_w001001_alt@data@attributes[[1]] <- ls_dbf_data[[i]]
r_w001001 <- r_w001001_alt
names(r_w001001@data@attributes[[1]])[1] <- 'ID'
raster::writeRaster(r_w001001, filename = 'data/out/tif_H_ACEPHATE_alt.tif', format = 'GTiff')

cellkg2019 <- as.data.frame(r_w001001) %>% 
  dplyr::pull(cellkg2019)

## Assign levels
lab_cell_lb_mi2 <- dplyr::case_when(
  is.na(cellkg2019) ~ "No estimated use",
  cellkg2019 < bin[2] ~ label[1],
  cellkg2019 >= bin[2] & cellkg2019 < bin[3] ~ label[2],
  cellkg2019 >= bin[3] & cellkg2019 < bin[4] ~ label[3],
  cellkg2019 >= bin[4] & cellkg2019 < bin[5] ~ label[4]
) %>% 
  as.factor %>% 
  fct_relevel(., label)

r_w001001 <- raster::setValues(r_w001001, lab_cell_lb_mi2)
raster::writeRaster(r_w001001, filename = 'data/out/tif_H_ACEPHATE.tif', format = 'GTiff')

tmp <- raster::setValues(r_w001001, r_w001001@data@attributes[[1]])


# Plot preparation --------------------------------------------

## prepare map of states for outline
state_map <- map('state')
state_map <- sf::st_as_sf(map("state", plot = FALSE, fill = TRUE))

## prepare labels and label colors
chemical_nm <- p_list$Compound[[2]]
conc <- 'High'
yr <- '2019'
prelim <- '(Preliminary)'
ttl <- stringr::str_glue("Estimated Agricultural Use for {chemical_nm}, {yr} {prelim} \n EPest-{conc}")
ttl_legend <- c('Esimated use on \n agricultural land, in \n pounds per square mile')
label_legend <- c(label, 'No estimated use') %>% as.vector() # need to remove names to make it work well with `scale_fill_manual`

label_col <- c(
  '#fff29e', # yellow
  '#ffb94f', # orange-brown
  '#d66000', # light brown
  '#873600', # brown
  '#ffffff'  # white
)


# Plotting ------------------------------------------------------

#' Create NAWQA Pesticide Map
#' 
#' @param raster_object RasterLayer object for plotting
#' @param chemical_name name of the the pesticide
#' @param preliminary logical, are the results preliminary? Default is set to `FALSE`
#' @param estimate_type chr, does the raster represent the high estimate or the low estimate?
#' @param label_colors chr vector, vector of HEX colors used to generate map and legend
#' @param label_names chr vector, vector of break points used to generage legend labels
#' 
create_map <- function(raster_object, # may want to read in `file_path` instead of obj and chem name
                       chemical_name, 
                       preliminary = FALSE, estimate_type = c('high', 'low'),
                       label_colors = c('#fff29e', '#ffb94f', '#d66000', '#873600', '#ffffff'),
                       label_names) {
  plt <- 
    ggplot() +
    ggspatial::layer_spatial(raster_object, aes(fill = as.factor(stat(band1)))) +
    geom_sf(data = state_map, fill = NA, color = '#6e6e6e', lwd = 0.5) +
    scale_fill_manual(name = ttl_legend, 
                      labels = label_names,
                      values = label_colors
    ) +
    labs(title = ttl) +
    theme_void() +
    theme(plot.title = element_text(hjust = 0.5, vjust = -10, face = 'bold')) +
    theme(legend.position = c(0.20, 0.10),
          legend.key = element_rect(colour = 'black')) 
  
  ggsave()
  
}





# NEXT STEPS - 
# Assign factor levels to `df_w001001` that match the bins 
# create geoTIFFs

# using world map US bounding box - (-124.848974, 24.396308) - (-66.885444, 49.384358)

x <- 
  ggplot() +
  ggspatial::layer_spatial(r_w001001, aes(fill = as.factor(stat(band1)))) +
  geom_sf(data = state_map, fill = NA, color = '#6e6e6e', lwd = 0.5) +
  scale_fill_manual(name = ttl_legend, 
                    labels = label_legend,
                    values = label_col
  ) +
  labs(title = ttl) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, vjust = -10, face = 'bold')) +
  theme(legend.position = c(0.20, 0.10),
        legend.key = element_rect(colour = 'black')) 

x


# GOALS -------------------------------------

# (1) static maps
# (2) GeoTIFFS (I need domain expertise to review)
