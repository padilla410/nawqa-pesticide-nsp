#' Generate a vector of pesticide file names based on a subfolder
#' 
#' @param file_path chr, file path of the subfolder that contains the pesticide files
#' 
generate_pest_vector <- function(file_path) {
  dbf_files <- list.files(file_path, full.names = T)
  
  stringr::str_match(dbf_files, '(?<=\\_).*?(?=\\.)') %>%
    unique %>%
    as.vector
}

#' Read Pesticide `csv` Files
#' 
#' @param pesticides_of_interest chr, vector of pesticide names that will be used to select which files will be read in to memory.
#' @param file_path full file path where files of interest are located.
#' @param col_types vector of column types passed to `readr::read_csv()`.
#'
read_pest_files <- function(pesticides_of_interest, file_path, col_types) {
  out <- list.files(file_path, full.names = T) %>% 
    stringr::str_subset(pattern = 
                          paste("(\\.", pesticides_of_interest, "\\.)"
                                , sep = '')) %>% 
    readr::read_csv(., col_types = col_types)
  
  out$cmpnd <- pesticides_of_interest
  
  return(out)
}