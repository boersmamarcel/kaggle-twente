t_clean <- data.frame(titanic$survived, titanic$age, titanic$sibsp, titanic$parch, titanic$fare)
t_clean <- rename(t_clean, c("titanic.survived"="survived","titanic.sibsp"="sibsp","titanic.parch"="parch","titanic.fare"="fare"))))
sub     <- sample(nrow(t_clean),floor(nrow(t_clean)*0.8))
train   <- t_clean[sub,]
test    <- t_clean[-sub,]
train_0 <- train[train$survived==0,]
train_1 <- train[train$survived==1,]
test_0  <- test[test$survived==0,]
test_1  <- test[test$survived==1,]
prior_0 <- nrow(train_0)/nrow(train)
prior_1 <- nrow(train_1)/nrow(train)
train_no_survived <- train[2:ncol(train)]
pca     <- princomp(na.omit(train_no_survived))