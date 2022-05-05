source('2_process/src/create_pest_raster.R')

# Munge pesticide data and
## combine each pesticides dbfs and USA raster
## US raster load the raster
## create a vector of pesticide names for late munging

p2_targets_list <- list(
  # load US raster
  tar_target(
    p2_us_raster,
    raster::raster('1_fetch/in/maps/nlcd11pctagco/', values = TRUE)
  ),
  
  # combine each pesticide dbf with the us raster
  # use percentile bins to assign factor values
  # use labels to label factors appropriately
  # save rasters to file
  tar_target(
    p2_pest_lo_raster,
    create_pest_raster(
      dbf_data = p1_pest_lo_data, us_raster = p2_us_raster, 
      bin_df = p1_pest_bin_data, label_df = p1_pest_label_data, 
      pest_name = p1_pest_of_interest, est_type = 'Low',
      cellkg_column = 'cellkg2019'),
    format = 'file',
    pattern = map(p1_pest_lo_data, p1_pest_bin_data, 
                  p1_pest_label_data, p1_pest_of_interest)
  ),
  
  tar_target(
    p2_pest_hi_raster,
    create_pest_raster(
      dbf_data = p1_pest_hi_data, us_raster = p2_us_raster, 
      bin_df = p1_pest_bin_data, label_df = p1_pest_label_data, 
      pest_name = p1_pest_of_interest, est_type = 'High',
      cellkg_column = 'cellkg2019'),
    format = 'file',
    pattern = map(p1_pest_hi_data, p1_pest_bin_data, 
                  p1_pest_label_data, p1_pest_of_interest)
  )
)