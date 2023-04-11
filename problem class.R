library(caret)
library(randomForest)
library(tm)
library(readtext)
library(tidyverse)

path <- "C:/Users/rodri/Documents/Proyectos R/Problem-Clasification/Data/BECV_B2_Past_exams"
folder_path_temp <- "C:/Users/rodri/Documents/Proyectos R/Problem-Clasification/Classified-Data/B2_Student_Book _Workbook_combined_by_unit_36_files"
folder_list <- list.dirs(folder_path_temp, full.names = TRUE)
folder_list <- folder_list[-1] # El primer elemento es nombre del directorio
labels <- c("Type 1", "Type 2", "Type 3","Type 4", "Type 5", "Type 6","Type 7", "Type 8", "Type 9","Type 10", "Type 11", "Type 12") # Add or modify the labels according to your question types
data <- data.frame(text = character(), label = factor())
##

for (i in 1:length(folder_list)) {
  folder_path <- folder_list[i]
  file_list <- list.files(folder_path, full.names = TRUE)
  
  file_contents <- lapply(file_list, function(file) {
    if (file.exists(file)) {
      content <- paste(readLines(file, warn = FALSE), collapse = " ")
      content <- data.frame(text = content)
      return(content)
    }
  })
  
  for (j in 1:3){
    temp_data <- data.frame(text = file_contents[j], 
                            label = factor(rep(labels[i])))
    data <- rbind(data, temp_data)
  }
}

# Save data
#save(data, file = "question_data_frame.Rda")

# Preprocess the text

corpus <- VCorpus(VectorSource(data$text))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

dtm <- DocumentTermMatrix(corpus)
dtm_matrix <- as.matrix(dtm)

# Training and testing

set.seed(42)
train_indices <- createDataPartition(data$label, p = 0.8, list = FALSE)
train_data <- dtm_matrix[train_indices, ]
test_data <- dtm_matrix[-train_indices, ]
train_labels <- data$label[train_indices]
test_labels <- data$label[-train_indices]

model <- randomForest(train_data, train_labels)

predictions <- predict(model, test_data)
confusion_matrix <- confusionMatrix(predictions, test_labels)
print(confusion_matrix)



data$text

