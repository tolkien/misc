# change working directory to R.2019.2/data.mining
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/data.mining'))
}

# p130
library(MASS)
Boston$chas = factor(Boston$chas)
Boston$rad  = factor(Boston$rad)
summary(Boston)
#install.packages("randomForest")
library(randomForest)
rf.Boston = randomForest(medv ~ ., data = Boston, ntree=100, mtry=5, importance=T, na.action=na.omit)
summary(rf.Boston)
head(rf.Boston$predicted, 10)
importance(rf.Boston, type=1)
Boston$medv.hat =predict(rf.Boston, newdata = Boston)
mean((Boston$medv - Boston$medv.hat)^2) # MSE
plot(Boston$medv, Boston$medv.hat, xlab="Observed", ylab = "Fitted")
abline(0,1)
# split Boston into train, test
set.seed(1234)
Boston.idx = sample(1:nrow(Boston), round(nrow(Boston)*0.7))
Boston.train = Boston[Boston.idx,]
Boston.test  = Boston[-Boston.idx,]
rf2.Boston = randomForest(medv ~ ., data = Boston.train, ntree=100, mtry=5, importance=T, na.action=na.omit)
medv.hat.test = predict(rf2.Boston, newdata = Boston.test)
mean((Boston.test$medv - medv.hat.test)^2) # MSE

# ensemble - bagging, p136
#install.packages("adabag")
german = read.table("germandata.txt", head=T)
german$numcredits = factor(german$numcredits)
german$residence = factor(german$residence)
german$residpeople = factor(german$residpeople)
summary(german)
library(adabag)
german.ctrl = rpart.control(xval=0, cp=0, minsplit = 5, maxdepth = 10)
bag.german = bagging(y ~ ., data=german, mfinal=50, control=german.ctrl)
summary(bag.german)
print(bag.german$importance)
importanceplot(bag.german)
pred.bag.german = predict(bag.german, newdata = german)
head(pred.bag.german$prob, 5)
print(pred.bag.german$confusion)
1-sum(diag(pred.bag.german$confusion))/sum(pred.bag.german$confusion) # 오분류율
evol.german = errorevol(bag.german, newdata = german)
plot.errorevol(evol.german)
# split german into train, test
set.seed(1234)
german.i = sample(1:nrow(german), round(nrow(german)*0.7))
german.train = german[german.i,]
german.test  = german[-german.i,]
bag2.german = bagging(y ~ ., data=german, mfinal=50, control=german.ctrl)
pred.bag2.german = predict.bagging(bag2.german, newdata=german.test)
print(pred.bag2.german$confusion)
1-sum(diag(pred.bag2.german$confusion))/sum(pred.bag2.german$confusion)

# ensemble - boosting
library(adabag)
german.ctrl2 = rpart.control(xval=0, cp=0, maxdepth=1)
boo.german = boosting(y ~ ., data=german, boos = T, mfinal=100, control=german.ctrl2)
summary(boo.german)
#boo.german$trees
print(boo.german$importance)
importanceplot(boo.german)
pred.boo.german = predict.boosting(boo.german, newdata = german)
head(pred.boo.german$prob, 5)
print(pred.boo.german$confusion)
1-sum(diag(pred.boo.german$confusion))/sum(pred.boo.german$confusion)
evol2.german = errorevol(boo.german, newdata = german)
plot.errorevol(evol2.german)
# split german into train, test
boo2.german = boosting(y ~ ., data=german.train, boos = T, mfinal=100, control=german.ctrl2)
pred.boo2.german = predict.boosting(boo2.german, newdata=german.test)
print(pred.boo2.german$confusion)
1-sum(diag(pred.boo2.german$confusion))/sum(pred.boo2.german$confusion)

# ensemble - randomForest
library(randomForest)
rf.german = randomForest(y ~ ., data = german, ntree=100, mtry=5, importance=T, na.action=na.omit)
summary(rf.german)
head(rf.german$predicted, 10)
importance(rf.german, type=1)
pred.rf.german = predict(rf.german, newdata = german)
head(pred.rf.german, 10)
tab.german = table(german$y, pred.rf.german, dnn=c("Actual", "Predicted"))
print(tab.german)
1-sum(diag(tab.german))/sum(tab.german)
plot(rf.german)
# split german into train, test
rf2.german = randomForest(y ~ ., data = german.train, ntree=100, mtry=5,
                          importance=T, na.action=na.omit)
pred.rf2.german = predict(rf2.german, newdata = german.test)
tab2.german = table(german.test$y, pred.rf2.german, dnn=c("Actual", "Predicted"))
print(tab2.german)
1-sum(diag(tab2.german))/sum(tab2.german)
