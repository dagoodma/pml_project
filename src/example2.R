# example2 - exporatory analysis
# Plots sensor data vs. class. Plots sensor data in feature plot.
#
library(gdata)
library(ggplot2)
library(caret)
library(gridExtra)

# Set working directory and load the data if needed
setwd("/Users/dagoodma/machinelearning/project/src")
if (!exists("mydata") || !exists("Pml")) {
    mydata <- read.csv("../data/pml-training.csv")
    Pml <- data.frame(mydata)
}
colNames <- colnames(Pml)
#colNames

# Partition training data for cross-validation
#inTrain <- createTimeSlices(y=Pml$classe, p=0.7, list=FALSE)
training <- Pml[,]
#testing <- Pml[-inTrain,]
dim(training)
#dim(testing)

# Plot belt Euler
br <- qplot(y=roll_belt,data=training,colour=classe)
bp <- qplot(y=pitch_belt,data=training,colour=classe)
by <- qplot(y=yaw_belt,data=training,colour=classe)
grid.arrange(br,bp,by,nrow=3)

# Plot forearm Euler
dev.new()
fr <- qplot(y=roll_forearm,data=training,colour=classe)
fp <- qplot(y=pitch_forearm,data=training,colour=classe)
fy <- qplot(y=yaw_forearm,data=training,colour=classe)
grid.arrange(fr,fp,fy,ncol=3)

# Plot arms Euler
dev.new()
ar <- qplot(y=roll_arm,data=training,colour=classe)
ap <- qplot(y=pitch_arm,data=training,colour=classe)
ay <- qplot(y=yaw_arm,data=training,colour=classe)
grid.arrange(ar,ap,ay,ncol=3)

# Plot dumbbell Euler
dev.new()
dr <- qplot(y=roll_dumbbell,data=training,colour=classe)
dp <- qplot(y=pitch_dumbbell,data=training,colour=classe)
dy <- qplot(y=yaw_dumbbell,data=training,colour=classe)
grid.arrange(dr,dp,dy,ncol=3)

# Feature pot against classe (as numbers: A=1, B=2, ect...)
#trainClasseAsNum <- match(training$classe,LETTERS)
#featurePlot(x=training[,c("roll_belt","pitch_belt","yaw_belt")],
#    y=trainClasseAsNum, plot="pairs")