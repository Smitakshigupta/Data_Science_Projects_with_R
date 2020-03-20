#Project : Customer Churn Rate Prediction
# Algorithms used :  Logistic Regression
#Author : Smitakshi Gupta
#Kaggle Link to the data : https://www.kaggle.com/blastchar/telco-customer-churn


#Installing packages

library(plyr)
library(corrplot)
library(ggplot2)
library(gridExtra)
install.packages("ggthemes")
library(ggthemes)
install.packages("caret")
library(caret)
library(MASS)
library(randomForest)
install.packages("party")
library(party)

setwd("/Users/smitakshigupta/......../Customer_Churn_Prediction")

#Importing the  dataset

train_churn <- read.csv("Telco-Customer-Churn.csv",sep=",", header=T, strip.white = T, na.strings = c("NA","NaN","","?"))

#Check the column names in R
colnames(train_churn)

#See the attributes of the different columns in R
str(train_churn)

#Check the missing values for each column
sapply(train_churn, function(x) sum(is.na(x)))

#Since there are 11 missing values in TotalCharges, I am removing them.

churn_data <- train_churn[complete.cases(train_churn), ]
churn_data$Churn <- ifelse(churn_data$Churn == "Yes", 0, 1)
churn_data$Churn <- as.factor(churn_data$Churn)

#Data Wrangling 
#Data Preprocessing 

#Changing the "No Phone Service" to "No" for "Multiple Lines

churn_data$MultipleLines <- as.factor(mapvalues(churn_data$MultipleLines, 
                                           from=c("No phone service"),
                                           to=c("No")))

#Changing "No Internet Service" to "No" for “OnlineSecurity”, “OnlineBackup”, “DeviceProtection”, “TechSupport”, “streamingTV”, “streamingMovies”

cols_recode1 <- c(10:15)
for(i in 1:ncol(churn_data[,cols_recode1])) {
  churn_data[,cols_recode1][,i] <- as.factor(mapvalues
                                        (churn_data[,cols_recode1][,i], from =c("No internet service"),to=c("No")))
}

#Checking the maximum and minimum tenure for the customers

min(churn_data$tenure); max(churn_data$tenure)

#Grouping the tenure into 5 major groups : "Upto 12 Months","12-24 Months","24-48 Months","48-60 Months", ">60 Months"

group_tenure <- function(tenure){
  if (tenure >= 0 & tenure <= 12){
    return('Upto 12 Months')
  }else if(tenure > 12 & tenure <= 24){
    return('12-24 Months')
  }else if (tenure > 24 & tenure <= 48){
    return('24-48 Months')
  }else if (tenure > 48 & tenure <=60){
    return('48-60 Months')
  }else if (tenure > 60){
    return('> 60 Months')
  }
}

#Adding the tenure_group to the churn_data
churn_data$tenure_group <- sapply(churn_data$tenure,group_tenure)
churn_data$tenure_group <- as.factor(churn_data$tenure_group)

#Senior Citizen values from 0 or 1 to "No" or "Yes"

churn_data$SeniorCitizen <- as.factor(mapvalues(churn_data$SeniorCitizen,
                                           from=c("0","1"),
                                           to=c("No", "Yes")))

#Removing the variables not required for Analysis

churn_data$customerID <- NULL
churn_data$tenure <- NULL

#Exploratory Data Analysis
#Correlation between the numerical variables

numeric.var <- sapply(churn_data, is.numeric)
corr.matrix <- cor(churn_data[,numeric.var])
corrplot(corr.matrix, main="\n\nCorrelation Plot for Numerical Variables", method="number")

#Since Monthly Charges and Total Charges are correlated, one of them needs to be removed for Analysis
#Removing Total Charges
churn_data$TotalCharges <- NULL

#Categorical Variables Data Exploration

p1 <- ggplot(churn_data, aes(x=gender)) + ggtitle("Gender") + xlab("Gender") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p2 <- ggplot(churn_data, aes(x=SeniorCitizen)) + ggtitle("Senior Citizen") + xlab("Senior Citizen") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p3 <- ggplot(churn_data, aes(x=Partner)) + ggtitle("Partner") + xlab("Partner") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p4 <- ggplot(churn_data, aes(x=Dependents)) + ggtitle("Dependents") + xlab("Dependents") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p1, p2, p3, p4, ncol=2)
p5 <- ggplot(churn_data, aes(x=PhoneService)) + ggtitle("Phone Service") + xlab("Phone Service") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p6 <- ggplot(churn_data, aes(x=MultipleLines)) + ggtitle("Multiple Lines") + xlab("Multiple Lines") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p7 <- ggplot(churn_data, aes(x=InternetService)) + ggtitle("Internet Service") + xlab("Internet Service") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p8 <- ggplot(churn_data, aes(x=OnlineSecurity)) + ggtitle("Online Security") + xlab("Online Security") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p5, p6, p7, p8, ncol=2)
p9 <- ggplot(churn_data, aes(x=OnlineBackup)) + ggtitle("Online Backup") + xlab("Online Backup") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p10 <- ggplot(churn_data, aes(x=DeviceProtection)) + ggtitle("Device Protection") + xlab("Device Protection") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p11 <- ggplot(churn_data, aes(x=TechSupport)) + ggtitle("Tech Support") + xlab("Tech Support") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p12 <- ggplot(churn_data, aes(x=StreamingTV)) + ggtitle("Streaming TV") + xlab("Streaming TV") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p9, p10, p11, p12, ncol=2)
p13 <- ggplot(churn_data, aes(x=StreamingMovies)) + ggtitle("Streaming Movies") + xlab("Streaming Movies") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p14 <- ggplot(churn_data, aes(x=Contract)) + ggtitle("Contract") + xlab("Contract") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p15 <- ggplot(churn_data, aes(x=PaperlessBilling)) + ggtitle("Paperless Billing") + xlab("Paperless Billing") + 
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p16 <- ggplot(churn_data, aes(x=PaymentMethod)) + ggtitle("Payment Method") + xlab("Payment Method") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
p17 <- ggplot(churn_data, aes(x=tenure_group)) + ggtitle("Tenure Group") + xlab("Tenure Group") +
  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
grid.arrange(p13, p14, p15, p16, p17, ncol=2)

#Data Analysis
#Logistic Regression

#Splitting the data into test and train
intrain<- createDataPartition(churn_data$Churn,p=0.7,list=FALSE)
set.seed(2017)
train<- churn_data[intrain,]
test<- churn_data[-intrain,]

#Fitting the Logit Model

Logit <- glm(Churn ~ .,family=binomial(link="logit"),data=train)
print(summary(Logit))

#Predicting and Fitting the Model 

fitted.results <- predict(Logit,newdata=test,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != test$Churn)
print(paste('Accuracy of the Logistic Regression Model',1-misClasificError))

##Accuracy of the Logistic Regression Model 0.797912713472486

print("Confusion Matrix for Logistic Regression"); 
table(test$Churn, fitted.results > 0.5)

#Odds Ratio 
library(MASS)
exp(cbind(OR=coef(Logit), confint(Logit)))


