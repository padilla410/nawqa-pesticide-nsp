#' Generate a vector of pesticide file names based on a subfolder
#' 
#' @param file_path chr, file path of the subfolder that contains the pesticide files
#' 
generate_pest_vector <- function(file_path) {
  dbf_files <- list.files(file_path, full.names = F)
  
  stringr::str_match(dbf_files, '(?<=\\_).*?(?=\\.)') %>%
    unique %>%
    as.vector
}

#' Generate a vector of pesticide csv file names based on a subfolder
#' 
#' @param file_path chr, file path of the subfolder that contains the pesticide files
#' @param poi chr, a vector of pesticides of interest (poi)
#'
list_pest_csv <-function(file_path, poi) {

  # list csv files in `file_path`
  csv_files <- list.files(file_path, full.names = T) 
  
  # track csv files for pesticides of interest
  out <- poi %>%
    purrr::map_chr(~ grep(paste("(\\.", .x, "\\.)", sep = ""),
               csv_files, value = TRUE))

  return(out)
}
