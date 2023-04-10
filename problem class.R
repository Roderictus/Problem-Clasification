library(caret)
library(randomForest)
library(tm)
library(readtext)

path <- "C:/Users/rodri/Documents/Proyectos R/Problem-Clasification/Data/BECV_B2_Past_exams"
file_list <- list.files(path, full.names = TRUE)

output_folder <- "C:/Users/rodri/Documents/Proyectos R/Problem-Clasification/Output"



lapply(file_list, function(file){
  if(file.exists(file)) {
    content <- readtext(file, warn = FALSE)
    content <- content$text
    file_name <- basename(file)
    new_file_path <- file.path(output_folder, paste0("new_", file_name))
    writeLines(content,new_file_path)
  }
})


file_contents <- lapply(file_list, function(file) {
  content <- NULL
  if(file.exists(file)) {
    content <- readtext(file, warn = FALSE)
  }
  return(content)
})

temp <- readtext(path)
temp$text






