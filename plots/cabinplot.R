library(ggplot2)

train <- read.csv("~/Documents/Studie/challenges/kaggle-twente/train.csv")

train.df <- data.frame(train)
train.clean = data.frame()
train.clean = train.df[,c(1,2,3,4,5,6,7,8,9,10,11)]

ggplot(train.clean, aes(x=substr(cabin,0,1), y=age))+geom_point(aes(colour=factor(survived)),alpha=0.5)


