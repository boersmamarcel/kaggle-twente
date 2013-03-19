library("plyr")
sub     <- sample(nrow(titanic),floor(nrow(titanic)*0.8))
train   <- titanic[sub,]
test    <- titanic[-sub,]
write.csv(train, "data/internal validation/internal_train.csv")
write.csv(test,  "data/internal validation/internal_test.csv")