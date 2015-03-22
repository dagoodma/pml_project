# exampleCurate2 - Only keep data for new windows (avg,max,min,ect...)
#
# 
library(gdata)
library(caret)

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

# Rename avg columns to play nice with test data
Pml <- rename(Pml, c("avg_roll_belt"="roll_belt", "avg_pitch_belt"="pitch_belt", "avg_yaw_belt"="yaw_belt",
    "avg_roll_arm"="roll_arm", "avg_pitch_arm"="pitch_arm", "avg_yaw_arm"="yaw_arm",
    "avg_roll_forearm"="roll_forearm", "avg_pitch_forearm"="pitch_forearm", "avg_yaw_forearm"="yaw_forearm",
    "avg_roll_dumbbell"="roll_dumbbell", "avg_pitch_dumbbell"="pitch_dumbbell", "avg_yaw_dumbbell"="yaw_dumbbell"))

summary(Pml)
names(Pml)

# Partition data for cross-validation
inTrain <- createDataPartition(y=Pml$classe, p=0.75, list=FALSE)
training <- Pml[inTrain,]
testing <- Pml[-inTrain,]

# Build model from training data
modFit <- train(classe ~ ., method="rf", data=training, prox=TRUE)
print(modFit)

# # Look at model using cluster centers
# pmlP <- classCenter(training[,c(3,5)], training$classe, modFit$finalModel$prox)
# pmlP <- as.data.frame(pmlP); pmlP$classe <-rownames(pmlP);
# p <- qplot(roll_belt, yaw_belt, col=classe, data=training)
# p + geom_point(aes(x=roll_belt,y=yaw_belt,col=classe), size=5, shape=4, data=pmlP)


# Run on sub-training testing data
test1Pred <- predict(modFit, newdata=testing)
summary(test1Pred)
confusionMatrix(testing$classe, test1Pred)


# Run on testing data to predict answers
testdata <- read.csv("../data/pml-testing.csv")
Pml_test <- data.frame(testdata)
predict(modFit, newdata=Pml_test,type="prob") # print probabilities
test2Pred <- predict(modFit, newdata=Pml_test)
test2Pred

# # Write answers
# # pml_write_files = function(x){
# #   n = length(x)
# #   for(i in 1:n){
# #     filename = paste0("problem_id_",i,".txt")
# #     write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
# #   }
# # }

# # pml_write_files(testPred)
