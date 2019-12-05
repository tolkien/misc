# change working directory to R.2019.2/data.mining
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/data.mining'))
}

# p201
library(MASS)
Boston$chas = factor(Boston$chas)
Boston$rad  = factor(Boston$rad)
# split Boston into train, test
set.seed(1234)
i = sample(1:nrow(Boston), round(nrow(Boston)*0.7))
Boston.train = Boston[i,]
Boston.test  = Boston[-i,]
# Regression
fit.reg = lm(medv ~ ., data=Boston.train)
fit.step.reg = step(fit.reg, direction="both", trace=F)
yhat.reg = predict(fit.step.reg, newdata = Boston.test, type="response")
mean((Boston.test$medv - yhat.reg)^2) # PMSE
# Decision Tree
library(rpart)
Boston.ctrl = rpart.control(xval=10, cp=0, minsplit = nrow(Boston.train)*0.05)
fit.tree = rpart(medv ~ ., data=Boston.train, method="anova", control=Boston.ctrl)
ii = which.min(fit.tree$cp[,4]) # find min xerror
fit.prun.tree = prune(fit.tree, cp=fit.tree$cp[ii,1])
yhat.tree = predict(fit.prun.tree, newdata = Boston.test, type="vector")
mean((Boston.test$medv - yhat.tree)^2) # PMSE
# Neural Network
library(neuralnet)
Boston2 = Boston  # standardize data
for(i in 1:ncol(Boston2))
  if (!is.numeric(Boston2[,i]))
    Boston2[,i] = as.numeric(Boston2[,i])
max1 = apply(Boston2, 2, max)
min1 = apply(Boston2, 2, min)
sdat = scale(Boston2, center=min1, scale=max1 - min1)
sdat = as.data.frame(sdat)

set.seed(1234)
i2 = sample(1:nrow(Boston2), round(nrow(Boston2)*0.7))
Boston2.train = sdat[i2,]
Boston2.test  = sdat[-i2,]
vname = names(Boston2.train)
Boston2.f = as.formula(paste("medv ~ ", paste(vname[!vname %in% "medv"], collapse = " + ")))
fit.nn = neuralnet(Boston2.f, data=Boston2.train, hidden=c(3,2), linear.output = T)
pred = compute(fit.nn, Boston2.test[,1:13])
yhat.nn = pred$net.result*(max(Boston2$medv)-min(Boston2$medv)) + min(Boston2$medv)
Boston2.test$medv2 = Boston2.test$medv*(max(Boston2$medv)-min(Boston2$medv)) + min(Boston2$medv)
mean((Boston2.test$medv2 - yhat.nn)^2) # PMSE

# Random Forest
library(randomForest)
fit.rf = randomForest(medv ~ ., data=Boston.train, ntree=100, mtry=5,
                      importance=T, na.action=na.omit)
yhat.rf = predict(fit.rf, newdata=Boston.test, type="response")
mean((Boston.test$medv - yhat.rf)^2) # PMSE

# p204
german = read.table("germandata.txt", head=T)
german$numcredits = factor(german$numcredits)
german$residence = factor(german$residence)
german$residpeople = factor(german$residpeople)
threshold = 0.5
# split german into train, test
set.seed(1234)
i = sample(1:nrow(german), round(nrow(german)*0.7))
german.train = german[i,]
german.test  = german[-i,]

# Regression
fit.reg = glm(y ~ ., family=binomial(link="logit"), data=german.train)
fit.step.reg = step(fit.reg, direction="both", trace=F)
p.test.reg = predict(fit.step.reg, newdata = german.test, type="response")
yhat.test.reg = ifelse(p.test.reg > threshold,
                       levels(german$y)[2], levels(german$y)[1])
tab.reg = table(german.test$y, yhat.test.reg, dnn=c("Observed", "Predicted"))
print(tab.reg)
1-sum(diag(tab.reg))/sum(tab.reg)   # misclassification rate
tab.reg[,2]/apply(tab.reg, 1, sum)  # specificity/sensitivity

# Decision Tree
german.ctrl = rpart.control(xval=10, cp=0, minsplit = 5)
fit.tree = rpart(y ~ ., data=german.train, method="class", control=german.ctrl)
ii = which.min(fit.tree$cp[,4])   # find min xerror
fit.prun.tree = prune(fit.tree, cp=fit.tree$cp[ii,1])
p.test.tree = predict(fit.prun.tree, newdata = german.test, type="prob")[,2]
yhat.test.tree = ifelse(p.test.tree > threshold,
                        levels(german$y)[2], levels(german$y)[1])
tab.tree = table(german.test$y, yhat.test.tree, dnn=c("Observed", "Predicted"))
print(tab.tree)
1-sum(diag(tab.tree))/sum(tab.tree)   # misclassification rate
tab.tree[,2]/apply(tab.tree, 1, sum)  # specificity/sensitivity

# Random Forest
fit.rf = randomForest(y ~ ., data=german.train, ntree=100, mtry=5, importance=T, na.action=na.omit)
p.test.rf = predict(fit.rf, newdata = german.test, type="prob")[,2]
yhat.test.rf = ifelse(p.test.rf > threshold,
                      levels(german$y)[2], levels(german$y)[1])
tab.rf = table(german.test$y, yhat.test.rf, dnn=c("Observed", "Predicted"))
print(tab.rf)
1-sum(diag(tab.rf))/sum(tab.rf)   # misclassification rate
tab.rf[,2]/apply(tab.rf, 1, sum)  # specificity/sensitivity

# Neural Network
#install.packages("dummy")
library(dummy)
dvar = c(4, 9, 10, 15, 17) # find nominal variables
german2 = dummy(x=german[,dvar])
german2 = german2[,-c(10,14,17,20,24)] # delete redundant dummy variables
german2 = cbind(german[,-dvar], german2)
for(i in 1:ncol(german2))
  if (!is.numeric(german2[,i]))
    german2[,i] = as.numeric(german2[,i])
german2$y = ifelse(german$y=="good", 1, 0)
max1 = apply(german2, 2, max)
min1 = apply(german2, 2, min)
gdat = scale(german2, center=min1, scale=max1 - min1)
gdat = as.data.frame(gdat)
i2 = sample(1:nrow(german2), round(nrow(german2)*0.7))
german2.train = gdat[i2,]
german2.test = gdat[-i2,]
gn = names(german2.train)
german2.f = as.formula(paste("y ~ ", paste(gn[!gn %in% "y"], collapse = " + ")))
fit.nn = neuralnet(german2.f, data=german2.train, hidden=c(3,2), linear.output = F)
p.test.nn = compute(fit.nn, german2.test[,-16])$net.result
yhat.test.nn = ifelse(p.test.nn > threshold, 1, 0)
tab.nn = table(german2.test$y, yhat.test.nn, dnn=c("Observed", "Predicted"))
print(tab.nn)
1-sum(diag(tab.nn))/sum(tab.nn)   # misclassification rate
tab.nn[,2]/apply(tab.nn, 1, sum)  # specificity/sensitivity

# Bagging
library(adabag)
german.ctrl2 = rpart.control(xval=0, cp=0, minsplit = 5, maxdepth = 10)
fit.bag = bagging(y ~ ., data=german.train, mfinal=50, control=german.ctrl2)
p.test.bag = predict.bagging(fit.bag, newdata = german.test)$prob[,2]
yhat.test.bag = ifelse(p.test.bag > threshold,
                       levels(german$y)[2], levels(german$y)[1])
tab.bag = table(german.test$y, yhat.test.bag, dnn=c("Observed", "Predicted"))
print(tab.bag)
1-sum(diag(tab.bag))/sum(tab.bag)   # misclassification rate
tab.bag[,2]/apply(tab.bag, 1, sum)  # specificity/sensitivity

# Boosting
german.ctrl3 = rpart.control(xval=0, cp=0, maxdepth = 1)
fit.boo = boosting(y ~ ., data=german.train, boos=T, mfinal=100, control=german.ctrl3)
p.test.boo = predict.boosting(fit.boo, newdata = german.test)$prob[,2]
yhat.test.boo = ifelse(p.test.boo > threshold,
                       levels(german$y)[2], levels(german$y)[1])
tab.boo = table(german.test$y, yhat.test.boo, dnn=c("Observed", "Predicted"))
print(tab.boo)
1-sum(diag(tab.boo))/sum(tab.boo)   # misclassification rate
tab.boo[,2]/apply(tab.boo, 1, sum)  # specificity/sensitivity

# ROC and AUC
library(ROCR)
pred.reg = prediction(p.test.reg, german.test$y);
  perf.reg = performance(pred.reg, "tpr", "fpr")
pred.tree = prediction(p.test.tree, german.test$y);
  perf.tree = performance(pred.tree, "tpr", "fpr")
pred.nn = prediction(p.test.nn, german2.test$y);
  perf.nn = performance(pred.nn, "tpr", "fpr")
pred.bag = prediction(p.test.bag, german.test$y);
  perf.bag = performance(pred.bag, "tpr", "fpr")
pred.boo = prediction(p.test.boo, german.test$y);
  perf.boo = performance(pred.boo, "tpr", "fpr")
pred.rf = prediction(p.test.rf, german.test$y);
  perf.rf = performance(pred.rf, "tpr", "fpr")

plot(perf.reg, lty=1, col=1, xlim=c(0,1), ylim=c(0,1),
     xlab="1-Specificity", ylab="Sensitivity", main="ROC Curve")
plot(perf.tree, lty=2, col=2, add=T)
plot(perf.nn, lty=3, col=3, add=T)
plot(perf.bag, lty=4, col=4, add=T)
plot(perf.boo, lty=5, col=5, add=T)
plot(perf.rf, lty=6, col=6, add=T)
lines(x=c(0,1), y=c(0,1), col="grey")
legend(0.6, 0.3, c("Regression", "Decision Tree", "Neural Network",
                   "Bagging", "Boosting", "Random Forest"), lty=1:6, col=1:6)

performance(pred.reg, "auc")@y.values
performance(pred.tree, "auc")@y.values
performance(pred.nn, "auc")@y.values
performance(pred.bag, "auc")@y.values
performance(pred.boo, "auc")@y.values
performance(pred.rf, "auc")@y.values

