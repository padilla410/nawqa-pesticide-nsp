generate_pest_vector <- function(file_path) {
  dbf_files <- list.files(file_path, full.names = T)
  
  stringr::str_match(dbf_files, '(?<=\\_).*?(?=\\.)') %>%
    unique %>%
    as.vector
}

read_pest_files <- function(pesticides_of_interest, file_path, col_types) {
  out <- list.files(file_path, full.names = T) %>% 
    stringr::str_subset(pattern = paste("(\\.", pesticides_of_interest, "\\.)", sep = '')) %>% 
    readr::read_csv(., col_types = col_types)
  
  out$cmpnd <- pesticides_of_interest
  
  return(out)
}