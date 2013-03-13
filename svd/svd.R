## SVD

train.svd <- data.frame(class(train.clean$pclass), class(train.clean$sex), train.clean$sibsp, train.clean$parch, train.clean$fare, class(train.clean$embarked))
model = svd(train.svd, 700, 4)