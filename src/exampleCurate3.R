# exampleCurate2 - Only keep data for new windows (avg,max,min,ect...)
#
# 
library(gdata)
library(ggplot2)
library(caret)
library(gridExtra)

# Set multiple cores
doMC::registerDoMC(cores=2)


# Set working directory and load the data if needed
setwd("/Users/dagoodma/machinelearning/project/src")
mydata <- read.csv("../data/pml-training.csv")
Pml_raw <- data.frame(mydata)

# Keep column name patterns
keepPatterns <- c("X", "^avg", "^total", "classe")

# Grab only new windows
inWinRow <- which(Pml_raw[,"new_window"] == "yes")

# Find deisired columns
inKeepCol <- unique(grep(paste(keepPatterns,collapse="|"), names(Pml_raw)), value=TRUE)

# Remove unneeded data
Pml <- Pml_raw[inWinRow,inKeepCol]

summary(Pml)
names(Pml)



# # Build traning and testing sets from training data
# inTrain <- createDataPartition(y=Pml$classe, p=0.75, list=FALSE)
# training <- Pml[inTrain,]
# testing <- Pml[-inTrain,]

# # Fit the data
# modFit <- train(classe ~ ., method="rf", data=training)
# print(modFit)

# # Run on testing data
# testPred <- predict(modFit, newdata=testing)
# summary(testPred)
# confusionMatrix(testing$classe, testPred)


# # Generate answer with test data
# testdata <- read.csv("../data/pml-testing.csv")
# Pml_test <- data.frame(testdata)
# testPred <- predict(modFit, newdata=Pml_test)
# testPred

# # # Write answers
# # # pml_write_files = function(x){
# # #   n = length(x)
# # #   for(i in 1:n){
# # #     filename = paste0("problem_id_",i,".txt")
# # #     write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
# # #   }
# # # }

# # # pml_write_files(testPred)
