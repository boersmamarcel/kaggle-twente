# Assumes that getwd() returns git repository folder
# Use setwd() to change R working directory if this is not the case
library("plyr")

# Load training and test set
titanic_train <- read.csv("data/internal_validation/internal_train.csv")
titanic_test  <- read.csv("data/internal_validation/internal_test.csv")
train <- data.frame(titanic_train$survived, titanic_train$sex, titanic_train$age, titanic_train$sibsp, titanic_train$parch, titanic_train$fare)
train <- rename(train, c("titanic_train.survived"="survived","titanic_train.sex"="sex","titanic_train.age"="age","titanic_train.sibsp"="sibsp","titanic_train.parch"="parch","titanic_train.fare"="fare"))
test  <- data.frame(titanic_test$survived, titanic_test$sex, titanic_test$age, titanic_test$sibsp, titanic_test$parch, titanic_test$fare)
test  <- rename(test, c("titanic_test.survived"="survived","titanic_test.sex"="sex","titanic_test.age"="age","titanic_test.sibsp"="sibsp","titanic_test.parch"="parch","titanic_test.fare"="fare"))

# Transform 'male/female' into '1/0'
train$sex <- as.numeric(train$sex)
test$sex <- as.numeric(test$sex)

# Omit NA's from training and test set
train <- na.omit(train)
test  <- na.omit(test)

# Calculate PCA
pca        <- princomp(na.omit(train[2:ncol(train)]))
pca_weight <- pca$loadings[,1]
pca_score  <- pca$scores

# Get indices for survived=0 and survived=1
train_0 <- rownames(train[train$survived==0,])
train_1 <- rownames(train[train$survived==1,])

# Calculate priors
prior_0 <- length(train_0)/nrow(train)
prior_1 <- length(train_1)/nrow(train)

# Do some conversion stuff, because R is retarded
train_0_vec <- vector()
train_1_vec <- vector()
for(i in 1:nrow(pca_score)) {
	for(j in 1:length(train_0)){
		if(rownames(pca_score)[i]==train_0[j]){
			train_0_vec <- union(train_0_vec, pca_score[i])
		}
	}
	for(j in 1:length(train_1)){
		if(rownames(pca_score)[i]==train_1[j]){
			train_1_vec <- union(train_1_vec, pca_score[i])
		}
	}
}

# Calculate new pca feature scores
test$pca_value <- test$sex*pca_weight[1] + test$age*pca_weight[2] + test$sibsp*pca_weight[3] + test$parch*pca_weight[4] + test$fare*pca_weight[5] 

# Calculate likelihoods
test$likelihood_0 <- dnorm(test$pca_value, mean = mean(train_0_vec) , sd = sd(train_0_vec), log = FALSE)
test$likelihood_1 <- dnorm(test$pca_value, mean = mean(train_1_vec) , sd = sd(train_1_vec), log = FALSE)

# Calculate posteriors
test$posterior_0 <- test$likelihood_0 * prior_0
test$posterior_1 <- test$likelihood_1 * prior_1

# Calculate classification
test$classification <- (test$posterior_1>=test$posterior_0)

# Classification counts
good = 0;
bad = 0;
print("survived -> survived")
good = good + nrow(test[test$survived==1 & test$classification=='TRUE',])
good
print("survived -> died")
bad = bad + nrow(test[test$survived==1 & test$classification=='FALSE',])
bad
print("died -> survived")
bad = bad + nrow(test[test$survived==0 & test$classification=='TRUE',])
nrow(test[test$survived==0 & test$classification=='TRUE',])
print("died -> died")
good = good + nrow(test[test$survived==0 & test$classification=='FALSE',])
nrow(test[test$survived==0 & test$classification=='FALSE',])
print("Accuracy:")
good/(good+bad)
