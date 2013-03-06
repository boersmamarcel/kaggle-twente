library(ggplot2)

train <- read.csv("~/Documents/Studie/challenges/kaggle-twente/train.csv")

train.df <- data.frame(train)
train.clean = data.frame()
train.clean = train.df[,c(1,2,3,4,5,6,7,8,9,11)]

ggplot(train.clean, aes(x=sex, y=fare))+geom_point(aes(colour=factor(survived), alpha=0.5))

