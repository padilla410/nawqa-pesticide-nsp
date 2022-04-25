source('1_fetch/src/fetch_pesticide_data.R')

# fetch pesticide data:
## fetch all pesticide dbfs in file
## fetch US raster in file
## fetch all descriptive data in file (bins and labels)
## fetch crosswalk of pesticide file names and 
## create a vector of pesticide names for late munging

p1_targets_list <- list(
  tar_target(
    #load files
    p1_pest_dbf
    
  ),
  
  tar_target(
    # load US raster
    p1_us_raster
  ),
  
  tar_target(
    # create vector of pesticide names (`pest_list`) from loaded files (previous target)
    # to filter the next 3 targets
    p1_pest_list
  ),
  
  tar_target(
    # load crosswalk of pesticide names (`pesticide_names.txt`)
    p1_pest_name_xwalk
  ),
  
  tar_target(
    # use pest_list to load pesticide percentile bins of interest
    p1_pest_bins
  ),
  
  tar_target(
    # use pest_list to load pesticide legend lables of interest
    p1_pest_labels
  )

)