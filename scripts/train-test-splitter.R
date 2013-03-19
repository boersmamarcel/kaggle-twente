# Assumes that getwd() returns git repository folder
# Use setwd() to change R working directory if this is not the case

sub     <- sample(nrow(titanic),floor(nrow(titanic)*0.8))
train   <- titanic[sub,]
test    <- titanic[-sub,]
write.csv(train, "data/internal_validation/internal_train.csv")
write.csv(test,  "data/internal_validation/internal_test.csv")