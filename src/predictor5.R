# exampleCurate2 - Only keep data for new windows (avg,max,min,ect...)
#
# 
library(gdata)
library(ggplot2)
library(caret)
library(gridExtra)
library(plyr)

# Set multiple cores
doMC::registerDoMC(cores=2)


# Set working directory and load the data if needed
setwd("/Users/dagoodma/machinelearning/project/src")
mydata <- read.csv("../data/pml-training.csv")
Pml_raw <- data.frame(mydata)

# Keep column name patterns
keepPatterns <- c("X", "user_name", "^avg", "^total", "classe")

# Grab only new windows
inWinRow <- which(Pml_raw[,"new_window"] == "yes")

# Find deisired columns
inKeepCol <- unique(grep(paste(keepPatterns,collapse="|"), names(Pml_raw)), value=TRUE)

# Remove unneeded data
Pml <- Pml_raw[inWinRow,inKeepCol]

# Rename avg columns to play nice with test data
Pml <- rename(Pml, c("avg_roll_belt"="roll_belt", "avg_pitch_belt"="pitch_belt", "avg_yaw_belt"="yaw_belt",
    "avg_roll_arm"="roll_arm", "avg_pitch_arm"="pitch_arm", "avg_yaw_arm"="yaw_arm",
    "avg_roll_forearm"="roll_forearm", "avg_pitch_forearm"="pitch_forearm", "avg_yaw_forearm"="yaw_forearm",
    "avg_roll_dumbbell"="roll_dumbbell", "avg_pitch_dumbbell"="pitch_dumbbell", "avg_yaw_dumbbell"="yaw_dumbbell"))

summary(Pml)
names(Pml)


# Build traning and testing sets from training data
inTrain <- createDataPartition(y=Pml$classe, p=0.75, list=FALSE)
training <- Pml[inTrain,]
testing <- Pml[-inTrain,]

# Fit the data
modFit <- train(classe ~ ., method="rf", data=training)
print(modFit)

# Run on testing data
test1Pred <- predict(modFit, newdata=testing)
confusionMatrix(testing$classe, test1Pred)


# Generate answer with test data
testdata <- read.csv("../data/pml-testing.csv")
Pml_test <- data.frame(testdata)
test2Pred <- predict(modFit, newdata=Pml_test)
test2Pred

hist(test2Pred)
# # Write answers
# # pml_write_files = function(x){
# #   n = length(x)
# #   for(i in 1:n){
# #     filename = paste0("problem_id_",i,".txt")
# #     write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
# #   }
# # }

# # pml_write_files(testPred)
