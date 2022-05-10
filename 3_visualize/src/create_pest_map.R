#' Create NAWQA Pesticide Map
#' 
#' @param pest_raster_path chr, full path to a RasterLayer object for plotting
#' @param chemical_name name of the the pesticide
#' @param prelim logical, are the results preliminary? Default is set to `FALSE`
#' @param label_df chr data.frame, `data.frame`` of break points used to generate legend labels. "No estimated use" is added internally.
#' @param plot_yr chr, year associated with data
#' @param label_colors chr vector, vector of HEX colors used to generate map and legend
#' @param dpi int, dots per inch, used to scale final map resolution
#' @param out_path chr, path for output files. Do not include file name. Must include trailing `/`
#' 
create_pest_map <- function(pest_raster_path, # may want to read in `file_path` instead of obj and chem name
                       chemical_name, prelim = FALSE, label_df, plot_yr,
                       label_colors = c('#fff29e', '#ffb94f', '#d66000', '#873600', '#ffffff'),
                       dpi = 300, out_path = '3_visualize/out/'
                       ) {
  
  # prep raster
  pest_raster <- raster::raster(pest_raster_path)
  
  # prep state map
  state_map <- sf::st_as_sf(maps::map('state', plot = FALSE, fill = TRUE))
  
  # prep labels
  prelim_data <- ifelse(prelim == TRUE, '(Preliminary)', '')
  est_type <- ifelse(stringr::str_detect(pest_raster_path, 'H_'), 'High', 'Low')
  
  ttl <- stringr::str_glue("Estimated Agricultural Use for {chemical_name}, {plot_yr} {prelim_data} \n EPest-{est_type}")
  ttl_legend <- c('Estimated use on \n agricultural land, in \n pounds per square mile')
  label_legend <- c(label_df[1, c(2:5)], 'No estimated use') %>% 
    unlist() %>% 
    as.vector() # need to remove names to make it work well with `scale_fill_manual`

  #make pesticide map
  plt <- 
    ggplot() +
    ggspatial::layer_spatial(pest_raster, aes(fill = as.factor(stat(band1)))) +
    geom_sf(data = state_map, fill = NA, color = '#6e6e6e', lwd = 0.5) +
    scale_fill_manual(name = ttl_legend, 
                      labels = label_legend,
                      values = label_colors
    ) +
    labs(title = ttl) +
    theme_void() +
    theme(plot.title = element_text(hjust = 0.5, vjust = -10, face = 'bold')) +
    theme(legend.position = c(0.20, 0.10),
          legend.key = element_rect(colour = 'black')) 
  
  # save output
  chem_label <- stringr::str_extract(pest_raster_path, 
                                     '(?<=t\\/)(.*?)(?=\\.)') # grab everything after the `t/` and before `.`
  out_file <- paste(out_path, chem_label, '_', plot_yr, '.png', sep = '')
  ggsave(filename = out_file, plot = plt,
         width = 10 * dpi, height = 7.5 * dpi, units = 'px', dpi = dpi)
  
  return(out_file)
  
}