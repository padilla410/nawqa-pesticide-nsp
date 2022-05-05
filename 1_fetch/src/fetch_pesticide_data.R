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

#' #' Generate a vector of pesticide dbf file names based on a subfolder
#' #' 
#' #' @param file_path chr, file path of the subfolder that contains the pesticide files
#' #' @param est_type chr, a filter to select `High` or `Low` pesticide estimates
#' #'
#' list_pest_dbf <-function(file_path, est_type = c('High', 'Low')) {
#'   
#'   # Check
#'   if(!(est_type %in% c('High', 'Low'))) stop('`est_type` is not specified correctly')
#'   
#'   # build regex expression based on estimate type
#'   regex_filter <- ifelse(est_type == 'High', '(?:/H_)', '(?:/L_)')
#'   
#'   # select files that match estimate type
#'   dbf_files <- list.files(file_path, full.names = T) %>% 
#'     stringr::str_subset(regex_filter)
#'   
#'   return(dbf_files)
#' }

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

#' THESE FUNCTIONS WILL LIKELY BE DEPRECATED IN THE FINAL PIPELINE
#' NOT READY TO GET RID OF THEM JUST YET
#' #' Generate a vector of pesticide file names based on a subfolder
#' #' 
#' #' @param file_path chr, file path of the subfolder that contains the pesticide files
#' #' 
#' read_pest_dbf <- function(file_path, est_type = c('High', 'Low')) {
#'   
#'   # build regex expression based on estimate type
#'   regex_filter <- ifelse(est_type == 'High', '(?:/H_)', '(?:/L_)')
#'   
#'   # select files that match estimate type
#'   dbf_files <- list.files(file_path, full.names = T) %>% 
#'     .[str_detect(., regex_filter)] # this returns the 
#'   
#'   # read in DBF files as a list of data.frames
#'   out_dbf <- dbf_files %>% 
#'     map(~ foreign::read.dbf(file = .x))
#' 
#' }
#' 
#' #' Read Pesticide `csv` Files
#' #' 
#' #' @param pesticides_of_interest chr, vector of pesticide names that will be used to select which files will be read in to memory.
#' #' @param file_path full file path where files of interest are located.
#' #' @param col_types vector of column types passed to `readr::read_csv()`.
#' #'
#' read_pest_files <- function(pesticides_of_interest, file_path, col_types) {
#'   out <- list.files(file_path, full.names = T) %>% 
#'     stringr::str_subset(., pattern = 
#'                           paste("(\\.", pesticides_of_interest, "\\.)"
#'                                 , sep = '')) %>% 
#'     readr::read_csv(., col_types = col_types)
#'   
#'   out$cmpnd <- pesticides_of_interest
#'   
#'   return(out)
#' }