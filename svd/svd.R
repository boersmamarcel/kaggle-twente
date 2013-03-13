## SVD

# train.svd <- data.frame(class(train.clean$pclass), class(train.clean$sex), train.clean$sibsp, train.clean$parch, train.clean$fare, class(train.clean$embarked))
train.svd <- data.frame(train.clean$sex == "male", train.clean$sex == "female", train.clean$sibsp, train.clean$parch, train.clean$fare)
model = svd(train.svd, 700, 4)