# curate - curate the data
# Belt Euler angle data looks the most useful. I think the xyz information
# can be removed, since the Euler angles have already been derived from those.
# Also, all columns that are blank have been removed.
# 
library(gdata)
library(ggplot2)
library(caret)
library(gridExtra)

# Set multiple cores
doMC::registerDoMC(cores=2)

# Columns to drop for model
dropNames <- c("user_name","raw_timestamp_part_1","raw_timestamp_part_2",
    "cvtd_timestamp", "new_window", "num_window")
# Drop columns that start with: kurtosis, skewness,max,min,amplitude,
# var, avg, stdddev.
dropPatterns <- c("^kurtosis","^skewness","^max","^min","^amplitude",
    "^var", "^avg", "^stddev")


# Drops that showed low importance (varImp)
moreDrops <- c("magnet_dumbbell_x",
    "pitch_belt",
    "accel_belt_x",
    "gyros_arm_y",
    "gyros_arm_x",
    "pitch_arm",
    "gyros_forearm_x",
    "magnet_belt_x",
    "magnet_dumbbell_z",
    "accel_belt_y",
    "magnet_forearm_z",
    "total_accel_arm",
    "accel_dumbbell_y",
    "gyros_belt_x");

# Set working directory and load the data if needed
setwd("/Users/dagoodma/machinelearning/project/src")
if (!exists("mydata") || !exists("Pml")) {
    mydata <- read.csv("../data/pml-training.csv")
    Pml_raw <- data.frame(mydata)

    # Remove useless data columns
    Pml <- Pml_raw[,!(names(Pml_raw) %in% dropNames)]
    Pml <- Pml[,-unique(grep(paste(dropPatterns,collapse="|"),
        names(Pml)), value=TRUE)]
    Pml <- Pml[,!(names(Pml) %in% moreDrops)]
}
summary(Pml)
names(Pml)

# Partition training data for cross-validation
inTrain <- createDataPartition(y=Pml$classe, p=0.7, list=FALSE)
training <- Pml[inTrain,]
testing <- Pml[-inTrain,]

# try a simple stupid fit
modFit <- train(classe ~ ., method="rpart", data=training)
print(modFit)


# Predict with model
pred <- predict(modFit, testing)

qplot(classe,pred,data=testing)

confusionMatrix(testing$classe, pred)
