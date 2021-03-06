
#Beginner Data Science Project in R
#Project : Election Outcome Prediction
#Machine Learning Algorithm used : Random Forest
#Author : Smitakshi Gupta

#getwd()

setwd("/Users/smitakshigupta/....../Election Outcome Prediction")

#Importing the data
mydata <- read.csv("election_campaign_data.csv", sep=",", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))
# Explore data:
nrow(mydata)
ncol(mydata)
summary(mydata)
#Data Wrangling

#Dropping variables in the data
mydata$cand_id <- NULL
mydata$last_name <- NULL
mydata$first_name <- NULL
mydata$twitterbirth <- NULL
mydata$facebookdate <- NULL
mydata$facebookjan <- NULL
mydata$youtubebirth <- NULL

ncol(mydata)

mydata$twitter <- as.factor(mydata$twitter)
mydata$gen_election <- ifelse(mydata$gen_election == "L", 0, 1)
mydata$facebook <- as.factor(mydata$facebook)
mydata$youtube <- as.factor(mydata$youtube)
mydata$cand_ici <- as.factor(mydata$cand_ici)
mydata$gen_election <- as.factor(mydata$gen_election)
summary(mydata)
#Keeping all the observation with no missing values

mydata <- mydata[complete.cases(mydata),]

#Creating the train and test set
n = nrow(mydata) # n will be ther number of obs. in data
# Creating an index for 70% of obs. by random

trainIndex = sample(1:n,size = round(0.7*n),replace=FALSE)

# Using the index to create train data
train_data = mydata[trainIndex,]
# Using the index to create test data
test_data = mydata[-trainIndex,]
# Install packages required for random forest:
install.packages("randomForest")
# Load packages required for random forest:
library(randomForest)
# 10 trees
rf <-randomForest(gen_election~., data=train_data, ntree=10,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
#20 trees
rf <-randomForest(gen_election~., data=train_data, ntree=20,
                  na.action=na.exclude, importance=T,proximity=F)

print(rf)
#30 trees
rf <-randomForest(gen_election~., data=train_data, ntree=30,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
#Trying with 40,50,60…110 trees to see the OOB
rf <-randomForest(gen_election~., data=train_data, ntree=40,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=50,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=60,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=70,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=80,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=90,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=100,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)
rf <-randomForest(gen_election~., data=train_data, ntree=110,
                  na.action=na.exclude, importance=T,proximity=F)
print(rf)

#Trying to find the best value of mtry
mtry <- tuneRF(train_data[-26], train_data$gen_election, ntreeTry=100,
               stepFactor=1.5, improve=0.01, trace=TRUE, plot=TRUE, ,
               na.action=na.exclude)
#Finding the value of best mtry
best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
print(mtry)
#Building the random forest model with the best mtry and ntreeTry
rf <-randomForest(gen_election~., data=train_data, mtry=15,
                  importance=TRUE, ntree=100)
print(rf)

#Using the caret package to create the Confusion Matrix
library(caret)
predicted_values <- predict(rf, test_data,type= "prob")
head(predicted_values)
threshold <- 0.5
pred <- factor( ifelse(predicted_values[,2] > threshold, 1, 0))
#R will use the threshold to convert the probabilities to class(0 and 1)
head(pred)
levels(test_data$gen_election)[2]
# Creating the confusion matrix
confusionMatrix(pred, test_data$gen_election,
                positive = levels(test_data$gen_election)[2])
#Calculating AUC and creating the ROC curve
install.packages("ROCR")
library(ROCR)
library(ggplot2)
predicted_values <- predict(rf, test_data,type= "prob")[,2]
pred <- prediction(predicted_values, test_data$gen_election)
perf <- performance(pred, measure = "tpr", x.measure = "fpr")
auc <- performance(pred, measure = "auc")
auc <- auc@y.values[[1]]
roc.data <- data.frame(fpr=unlist(perf@x.values),
                       tpr=unlist(perf@y.values),
                       model="RF")
ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr)) +
  geom_ribbon(alpha=0.2) +
  geom_line(aes(y=tpr)) +
  ggtitle(paste0("ROC Curve w/ AUC=", auc))
#Understanding importance of the variables
varImpPlot(rf)
#Evaluate variable importance
importance(rf)