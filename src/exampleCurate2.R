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

# Keep statistical data in new window
keepPatterns <- c("X", "^kurtosis","^skewness","^max","^min","^amplitude",
    "^var", "^avg", "^stddev", "classe")

# Grab only new windows
inWinRow <- which(Pml_raw[,"new_window"] == "yes")

# Find deisired columns
inKeepCol <- unique(grep(paste(keepPatterns,collapse="|"), names(Pml_raw)), value=TRUE)

# Remove unneeded data
Pml <- Pml_raw[inWinRow,inKeepCol]

# Remove variables that are near zero or #DIV/0!
inDropRow <- nzv(Pml)
Pml <- Pml[,-inDropRow]

summaryn(Pml)
names(Pml)

