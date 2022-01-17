####################################
# Data Professor                   #
# http://youtube.com/dataprofessor #
# http://github.com/dataprofessor  #
####################################

# Importing libraries
library(RCurl) # for downloading the iris CSV file
library(randomForest)
library(caret)

# Importing the Iris data set
# iris <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/iris.csv")
                 
iris <- read.csv("C:/Users/skargutkar/Documents/GitHub/R-Projects/Data/App3-iris.csv")

# Performs stratified random split of the data set
TrainingIndex <- createDataPartition(iris$Species, p=0.8, list = FALSE)
TrainingSet <- iris[TrainingIndex,] # Training Set
TestingSet <- iris[-TrainingIndex,] # Test Set

write.csv(TrainingSet, "C:/Users/skargutkar/Documents/GitHub/R-Projects/App-3/training.csv")
write.csv(TestingSet, "C:/Users/skargutkar/Documents/GitHub/R-Projects/App-3/testing.csv")

TrainSet <- read.csv("C:/Users/skargutkar/Documents/GitHub/R-Projects/App-3/training.csv", header = TRUE)
TrainSet <- TrainSet[,-1]

# Building Random forest model

TrainSet$Species = factor(TrainSet$Species) 
model <- randomForest(Species ~ ., data = TrainSet, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
saveRDS(model, "C:/Users/skargutkar/Documents/GitHub/R-Projects/App-3/model.rds")
