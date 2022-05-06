source('3_visualize/src/create_pest_map.R')

# Plot pesticide rasters
## create a table to map over
## make plots

p3_targets_list <- list(
  # takes ~30 min to build
  tar_target(
    p2_pest_lo_map,
    create_pest_map(
      pest_raster_path = p2_pest_lo_raster,
      chemical_name = p1_pest_map_names,
      prelim = T,
      label_df = p1_pest_label_data,
      plot_yr = year
      ),
    pattern = map(p2_pest_lo_raster, p1_pest_map_names, p1_pest_label_data),
    format = 'file'
  ),
  
  # takes ~30 min to build
  tar_target(
    p2_pest_hi_map,
    create_pest_map(
      pest_raster_path = p2_pest_hi_raster,
      chemical_name = p1_pest_map_names,
      prelim = T,
      label_df = p1_pest_label_data,
      plot_yr = year
    ),
    pattern = map(p2_pest_hi_raster, p1_pest_map_names, p1_pest_label_data),
    format = 'file'
  )
)