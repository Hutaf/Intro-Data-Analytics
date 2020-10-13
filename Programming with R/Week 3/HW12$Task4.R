## DT classifier on diabetes dataset ##
library("party") 
library("dplyr") 
library("rpart")
library("rpart.plot")
library("scorecard")


diabetes <- read.csv("C:/Users/hotaf/Downloads/diabetes.csv")
View(diabetes)

# Split the dataset into train and test set
data <- split_df(diabetes, ratio = c(0.7, 0.3), name_dfs = c("train", "test"))
train <- data$train
test <- data$test

dim(train)
dim(test)

?rpart

# Create DT, train and plot the model
clf <- rpart(Outcome~., data = train, method = "class")
rpart.plot(clf)

# Testing the trained model on test set
predict <-predict(clf, test, type = 'class')

# creates a confusion matrix 
CM <- table(test$Outcome, predict) 
CM

# Evaluating the model using Accuracy as evaluation metric
Acc <- sum(diag(CM)) / sum(CM) 
cat('Accuracy: ', (Acc*100), sep = " ") 



