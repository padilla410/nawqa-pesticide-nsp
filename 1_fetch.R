source('1_fetch/src/fetch_pesticide_data.R')

p1_targets_list <- list(
  # Track data -----------------------
  tar_target(
    p1_pest_of_interest,
    generate_pest_vector(file_path = path_dbfs)
  ),
  
  # Track changes in high estimate dbf files
  tar_files(
    p1_pest_hi_dbf,
    list.files(path_dbfs, full.names = T, pattern = 'H_')
  ),
  
  # Track changes in low estimate dbf files
  tar_files(
    p1_pest_lo_dbf,
    list.files(path_dbfs, full.names = T, pattern = 'L_')
  ),
  
  # Track changes in pesticide bins for pesticides of interest
  tar_files(
    p1_pest_bin_csv,
    list_pest_csv(file_path = path_bins, poi = p1_pest_of_interest)
  ),

  # Track changes in pesticide labels for pesticides of interest
  tar_files(
    p1_pest_label_csv,
    list_pest_csv(file_path = path_labels, poi = p1_pest_of_interest)
  ),
  
  # Track changes in human-readable pesticide names
  tar_files(
    p1_pest_map_names_txt,
    list.files(path = path_base, full.names = T,  pattern = '.txt')
  ),
  
  # Load data -----------------------
  # Load dbfs for pesticides of interest - high estimates
  tar_target(
    p1_pest_hi_data,
    foreign::read.dbf(file = p1_pest_hi_dbf),
    pattern = map(p1_pest_hi_dbf),
    iteration = 'list'
  ),
  
  # Load dbfs for pesticides of interest - low estimates
  tar_target(
    p1_pest_lo_data,
    foreign::read.dbf(file = p1_pest_lo_dbf),
    pattern = map(p1_pest_lo_dbf),
    iteration = 'list'
  ),
  
  # Load bins for pesticides of interest
  tar_target(
    p1_pest_bin_data,
    readr::read_csv(p1_pest_bin_csv, col_types = rep('d', 4), id = 'source'),
    pattern = map(p1_pest_bin_csv),
    iteration = 'list'
  ),
  
  # Load labels for pesticides of interest
  tar_target(
    p1_pest_label_data,
    readr::read_csv(p1_pest_label_csv, col_types = rep('c', 4), id = 'source'),
    pattern = map(p1_pest_label_csv),
    iteration = 'list'
  ),
  
  # Load human-readable pesticide names for plotting in 3_visualize
  tar_target(
    p1_pest_map_names,
    readr::read_delim(p1_pest_map_names_txt, delim = '\t') %>% 
      filter(cmpnd %in% p1_pest_of_interest) %>% 
      pull(Compound)
  )
)