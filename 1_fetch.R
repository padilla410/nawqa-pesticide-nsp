source('1_fetch/src/fetch_pesticide_data.R')

p1_targets_list <- list(
  tar_target(
    p1_pest_of_interest,
    generate_pest_vector(file_path = '1_fetch/in/maps/dbf19')
  ),
  
  # Track changes in high estimate dbf files
  tar_target(
    p1_pest_hi_dbf,
    list_pest_dbf(file_path = '1_fetch/in/maps/dbf19', 
                  est_type = 'High'),
    format = 'file'
  ),
  
  # Track changes in low estimate dbf files
  tar_target(
    p1_pest_lo_dbf,
    list_pest_dbf(file_path = '1_fetch/in/maps/dbf19', 
                  est_type = 'Low'),
    format = 'file'
  ),
  
  # Track changes in pesticide bins for pesticides of interest
  tar_target(
    p1_pest_bin_csv,
    list_pest_csv(file_path = '1_fetch/in/maps/bins', 
                  poi = p1_pest_of_interest),
    format = 'file'
  ),
  
  # Track changes in pesticide labels for pesticides of interest
  tar_target(
    p1_pest_label_csv,
    list_pest_csv(file_path = '1_fetch/in/maps/labels', 
                  poi = p1_pest_of_interest),
    format = 'file'
  )
)