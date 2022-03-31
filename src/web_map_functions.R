generate_pesticides_vector <- function(file_path) {
  dbf_files <- list.files(file_path, full.names = T)
  
  stringr::str_match(dbf_files, '(?<=\\_).*?(?=\\.)') %>%
    unique %>%
    as.vector
}


read_pest_files <- function(pesticides_of_interest, file_path) {
  out <- list.files(file_path, full.names = T) %>% 
    read_csv
  
  out$cmpnd <- pesticides_of_interest
  
  return(out)
}