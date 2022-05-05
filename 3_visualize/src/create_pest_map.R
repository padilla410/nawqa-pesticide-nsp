#' Create NAWQA Pesticide Map
#' 
#' @param pest_raster RasterLayer object for plotting
#' @param chemical_name name of the the pesticide
#' @param preliminary logical, are the results preliminary? Default is set to `FALSE`
#' @param estimate_type chr, does the raster represent the high estimate or the low estimate?
#' @param label_colors chr vector, vector of HEX colors used to generate map and legend
#' @param label_names chr vector, vector of break points used to generage legend labels. "No estimated use" is added internally.
#' 
create_map <- function(pest_raster, # may want to read in `file_path` instead of obj and chem name
                       chemical_name, label_names, plot_yr,
                       prelim = FALSE, estimate_type = c('High', 'Low'),
                       label_colors = c('#fff29e', '#ffb94f', '#d66000', '#873600', '#ffffff')
) {
  
  # prep state map
  state_map <- map('state')
  state_map <- sf::st_as_sf(map("state", plot = FALSE, fill = TRUE))
  
  # prep labels
  prelim_data <- ifelse(prelim == TRUE, '(Preliminary)', '')
  
  ttl <- stringr::str_glue("Estimated Agricultural Use for {chemical_name}, {plot_yr} {prelim_data} \n EPest-{estimate_type}")
  ttl_legend <- c('Estimated use on \n agricultural land, in \n pounds per square mile')
  label_legend <- c(label_names, 'No estimated use') %>% unlist() %>% as.vector() # need to remove names to make it work well with `scale_fill_manual`
  
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
  
  return(plt)
  # ggsave()
  
}