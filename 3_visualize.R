source('3_process/src/plot_pesticide_data.R')

# Plot pesticide rasters
## create a table to map over
## make plots

p3_targets_list <- list(
  # combine each pesticide dbf with the us raster
  # use percentile bins to assign factor values
  # use labels to label factors appropriately
  # save rasters to file
  tar_target(
    p2_pest_lo_map,
    create_pest_map(
      pest_raster_path = p2_pest_lo_raster,
      chemical_name = 'tmp',
      preliminary = T,
      est_type = 'Low',
      label_names = p1_pest_label_data
      ),
    format = 'file',
    pattern = map(p2_pest_lo_raster, p1_pest_label_data)
  )#,
  # 
  # tar_target(
  #   p2_pest_hi_map,
  #   create_pest_raster(
  #     dbf_data = p1_pest_hi_data, us_raster = p2_us_raster, 
  #     bin_df = p1_pest_bin_data, label_df = p1_pest_label_data, 
  #     pest_name = p1_pest_of_interest, est_type = 'High',
  #     cellkg_column = 'cellkg2019'),
  #   format = 'file',
  #   pattern = map(p1_pest_hi_data, p1_pest_bin_data, 
  #                 p1_pest_label_data, p1_pest_of_interest)
  # )
)