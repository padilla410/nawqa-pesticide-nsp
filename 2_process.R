source('2_process/src/munge_pesticide_data.R')

# Munge pesticide data and
## combine each pesticides dbfs and USA raster
## US raster load the raster
## create a vector of pesticide names for late munging

p2_targets_list <- list(
  tar_target(
    # combine each pesticide dbf with the us raster
    # use percentile bins to assign factor values
    # save rasters to file
    p2_dummy_target_name,
    
  )
)