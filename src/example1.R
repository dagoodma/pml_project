# example1 - exporatory analysis with belt Euler
# Looking at a small time slice for user, carlitos, and plotting
# lines of Euler angel drived from belt accellerometer data.
#
library(gdata)
library(ggplot2)
library(caret)

# Set working directory and load the data if needed
setwd("/Users/dagoodma/machinelearning/project/src")
if (!exists("mydata")) {
    mydata <- read.csv("../data/pml-training.csv")
}
colNames <- colnames(mydata)

# Some sample data
user <- "carlitos"
x <- 1:165
cols <- c("roll_belt", "pitch_belt", "yaw_belt")


#miny <- min(mydata[x,"roll_belt"],mydata[x,"pitch_belt"],mydata[x,"yaw_belt"])
#maxy <- max(mydata[x,"roll_belt"],mydata[x,"pitch_belt"],mydata[x,"yaw_belt"])

#qplot(,x=roll_belt,data=mydata[slice,],type="l")
#featurePlot(x=mydata[x,cols],y=mydata[x,"classe"], plot="pairs")
par(mfrow=c(1,3))
plot(x,mydata[x,"roll_belt"],type="l") #,ylim=c(miny, maxy))
plot(x,mydata[x,"pitch_belt"],type="l")
plot(x,mydata[x,"yaw_belt"],type="l")