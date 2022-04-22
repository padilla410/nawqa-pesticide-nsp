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
  ),
  
  tar_taget(
    # load US raster
  ),
  
  tar_target(
    # create vector of pesticide names (`pest_list`) from loaded files 
    # to filter the next 3 targets
  ),
  
  tar_target(
    # load crosswalk of pesticide names (`pesticide_names.txt`)
  ),
  
  tar_target(
    # use pest_list to load pesticide percentile bins of interest
  ),
  
  tar_target(
    # use pest_list to load pesticide legend lablels of interest
  )

)