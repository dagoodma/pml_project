# predcitor4 - second attempt at a predictor
# Keeping only 38 useful variables, using some different prediction
# models with cross-validation.
# In sample: 100%
# Out of sample: ??
# 
library(gdata)
library(ggplot2)
library(caret)
library(gridExtra)

# Set multiple cores
doMC::registerDoMC(cores=2)

# Columns to keep
keep <- c("X", "roll_belt", "yaw_belt", "total_accel_belt", "gyros_belt_y",
    "gyros_belt_z", "accel_belt_z", "magnet_belt_y", "magnet_belt_z",
    "roll_arm", "yaw_arm", "gyros_arm_z", "accel_arm_x", "accel_arm_y",
    "accel_arm_z", "magnet_arm_x", "magnet_arm_y", "magnet_arm_z",
    "roll_dumbbell", "pitch_dumbbell", "yaw_dumbbell",
    "total_accel_dumbbell", "gyros_dumbbell_x", "gyros_dumbbell_y",
    "gyros_dumbbell_z", "accel_dumbbell_x", "accel_dumbbell_z",
    "magnet_dumbbell_y", "roll_forearm", "pitch_forearm", "yaw_forearm",
    "total_accel_forearm", "gyros_forearm_y", "gyros_forearm_z",
    "accel_forearm_x", "accel_forearm_y", "accel_forearm_z", "magnet_forearm_x",
    "magnet_forearm_y", "classe")

keep2 <- c("X", "pitch_forearm", "roll_dumbbell", "accel_forearm_x", "magnet_arm_x", 
    "magnet_arm_y", "accel_arm_x", "magnet_forearm_x", "pitch_dumbbell",
    "magnet_belt_y", "magnet_dumbbell_y", "classe")

# Set working directory and load the data if needed
setwd("/Users/dagoodma/machinelearning/project/src")
if (!exists("mydata") || !exists("Pml")) {
    mydata <- read.csv("../data/pml-training.csv")
    Pml_raw <- data.frame(mydata)

    # Remove useless data columns
    Pml <- Pml_raw[,(names(Pml_raw) %in% keep2)]
}
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
testPred <- predict(modFit, newdata=testing)
summary(testPred)
confusionMatrix(testing$classe, testPred)


# Generate answer with test data
testdata <- read.csv("../data/pml-testing.csv")
Pml_test <- data.frame(testdata)
testPred <- predict(modFit, newdata=Pml_test)
testPred

# Write answers
# pml_write_files = function(x){
#   n = length(x)
#   for(i in 1:n){
#     filename = paste0("problem_id_",i,".txt")
#     write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
#   }
# }

# pml_write_files(testPred)
