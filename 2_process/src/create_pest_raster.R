#' Create NAWQA Pesticide Raster
#' 
#' @param dbf_data data.table, gridded pesticide data derived from an ArcGIS dBASE (.dbf) table 
#' @param us_raster RasterObject, a raster of the US
#' @param bin_df data.table, table of binning values used to group pesticide estimates (units of kg/cell)
#' @param label_df data.table, table of label values used to label grouped pesticide estimates (units of lb/mi^2)
#' @param cellkg_column chr, name of the column in the pesticide dbf file that contains the cell data.
#'
create_pest_raster <- function(dbf_data, us_raster, bin_df, label_df, cellkg_column){
  
  # unlist bin and label data.frames
  bin <- unlist(bin_df)
  label <- unlist(label_df)
  
  # check that the dbf data.frame has `ID` in the first column
  names(dbf_data)[1] <- 'ID'
  
  # replace the default raster data.frame with the pesticide-specific data.frame
  us_raster@data@attributes[[1]] <- dbf_data
  
  cellkg <- as.data.frame(us_raster) %>% dplyr::pull({{cellkg_column}})
  
  ## Assign levels
  lab_cell_lb_mi2 <- dplyr::case_when(
    is.na(cellkg) ~ "No estimated use",
    cellkg < bin[2] ~ label[1],
    cellkg >= bin[2] & cellkg < bin[3] ~ label[2],
    cellkg >= bin[3] & cellkg < bin[4] ~ label[3],
    cellkg >= bin[4] & cellkg < bin[5] ~ label[4]
  ) %>% 
    as.factor %>% 
    forcats::fct_relevel(., label)
  
  pest_raster <- raster::setValues(us_raster, lab_cell_lb_mi2)
  
  return(pest_raster)
}
