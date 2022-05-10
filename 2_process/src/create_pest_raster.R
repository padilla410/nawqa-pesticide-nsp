#' Create NAWQA Pesticide Raster
#' 
#' @param dbf_data data.table, gridded pesticide data derived from an ArcGIS dBASE (.dbf) table 
#' @param us_raster RasterObject, a raster of the US
#' @param bin_df data.table, table of binning values used to group pesticide estimates (units of kg/cell)
#' @param label_df data.table, table of label values used to label grouped pesticide estimates (units of lb/mi^2)
#' @param cellkg_column chr, name of the column in the pesticide dbf file that contains the cell data.
#'
create_pest_raster <- function(dbf_data, us_raster, bin_df, label_df, pest_name,
                               cellkg_column, est_type){
  
  # unlist bin and label data.frames
  bin <- unlist(bin_df[1, c(2:6)])
  label <- unlist(label_df[1, c(2:5)])
  
  # build regex expression based on estimate type
  out_file_name_builder <- ifelse(est_type == 'High', 'H_', 'L_')
  
  # check that the dbf data.frame has `ID` in the first column
  names(dbf_data)[1] <- 'ID'
  
  cellkg <- raster::as.data.frame(us_raster)
  names(cellkg) <- 'ID' # rename field for left join with data
  
  cellkg <- dplyr::left_join(cellkg, dbf_data) %>% dplyr::pull({{ cellkg_column }})
  
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
  
  # save output
  file_out <- paste('2_process/out/', out_file_name_builder
                    , pest_name, '.tif', sep = '')
  
  raster::writeRaster(pest_raster, file = file_out, 
                      format = 'GTiff', overwrite = T)
  
  return(file_out)
}
