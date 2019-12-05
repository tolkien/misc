# change working directory to R.2019.2/data.mining
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/data.mining'))
}

e2.dat = read.csv("./titanic.csv", header = T)
head(e2.dat)
e2.lm = glm(Survived ~ Class + Age + Sex, family=binomial(link="logit"), data=e2.dat)
e2.step = step(e2.lm, direction="both")
e2.step$anova
summary(e2.step)

p = predict(e2.lm, newdata=e2.dat, type="response")
threshold = 0.5
yhat = ifelse(p > threshold, 1, 0)
e2.tab = table(e2.dat$Survived, yhat, dnn=c("Actual", "Predicted"))
e2.tab

#install.packages("ROCR")
library(ROCR)
pred = prediction(p, e2.dat$y)
perf = performance(pred, "tpr", "fpr")
plot(perf, lty=1, col=2, xlib=c(0,1), ylim=c(0,1),
     xlab="", ylab="Survived", main="ROC Curve")
lines(x=c(0,1), y=c(0,1), col="grey")

library(car)
Anova(e2.lm)
e2.lm2 = glm(Survived ~ Class + Age + Sex + Class:Sex + Age:Sex + Class:Age:Sex,
             family=binomial(link="logit"), data=e2.dat)
Anova(e2.lm2)

library(rpart)
e2.control = rpart.control(xval=10, cp=-0.01, minsplit = 1)
e2.tree = rpart(Survived ~ ., data=e2.dat, method="class", control=e2.control)
print(e2.tree)
printcp(e2.tree)
e2.prun.tree = prune(e2.tree, cp=0.0)
print(e2.prun.tree)
plot(e2.prun.tree, uniform=T, compress=T, margin=0.1)
text(e2.prun.tree, use.n=T, col="blue")
summary(e2.prun.tree)

# e4
e4.x1 = c(1,1,1,0,0,1,0,0,1,0)
e4.x2 = c(0,1,0,0,0,1,1,1,0,0)
e4.x3 = c(1,1,0,0,1,0,1,0,0,0)
e4.y = c(1,1,0,0,1,1,1,0,0,0)
e4.bagging = 1/3*e4.x1 + 1/3*e4.x2 + 1/3*e4.x3
e4.bag_y = ifelse(e4.bagging > 0.5, 1, 0)
e4.bag_y
e4.y
sum(ifelse(e4.bag_y != e4.y, 1, 0))/length(e4.y)
#e4.bag_tab = table(e4.y, e4.bag_y, dnn=c("Actual", "Predicted"))
#e4.bag_tab
#(e4.bag_tab[1,2]+e4.bag_tab[2,1])/sum(e4.bag_tab)

e4.boost = 0.2*e4.x1 + 0.6*e4.x2 + 0.2*e4.x3
e4.boo_y = ifelse(e4.boost > 0.5, 1, 0)
e4.boo_y
e4.y
sum(ifelse(e4.boo_y != e4.y, 1, 0))/length(e4.y)

#it's not
e4.w = 1/length(e4.y)
e4.x1_w = 0.2
e4.x2_w = 0.6
e4.x3_w = 0.2
e4.x1_e = e4.x1_w*sum(ifelse(e4.x1 != e4.y, e4.w, 0))
e4.x2_e = e4.x2_w*sum(ifelse(e4.x2 != e4.y, e4.w, 0))
e4.x3_e = e4.x3_w*sum(ifelse(e4.x3 != e4.y, e4.w, 0))
c(e4.x1_e, e4.x2_e, e4.x3_e)
e4.x1_a = (1/2)*log10((1-e4.x1_e)/e4.x1_e)
e4.x2_a = (1/2)*log10((1-e4.x2_e)/e4.x2_e)
e4.x3_a = (1/2)*log10((1-e4.x3_e)/e4.x3_e)
c(e4.x1_a, e4.x2_a, e4.x3_a)
e4.sum_a = sum(c(e4.x1_a, e4.x2_a, e4.x3_a))
e4.x1_a = e4.x1_a / e4.sum_a
e4.x2_a = e4.x2_a / e4.sum_a
e4.x3_a = e4.x3_a / e4.sum_a
c(e4.x1_a, e4.x2_a, e4.x3_a)

# e3_2
library(rpart)
e3.dat = iris
e3.N = length(e3.dat[,5])
e3.cnt_1 = sum(ifelse(e3.dat$Species=="setosa", 1, 0))
e3.cnt_2 = sum(ifelse(e3.dat$Species=="versicolor", 1, 0))
e3.cnt_3 = sum(ifelse(e3.dat$Species=="virginica", 1, 0))
e3.control = rpart.control(minbucket=10, xval=10)
e3.tree = rpart(Species ~ ., data=e3.dat, method="class", control=e3.control,
                parms=list(prior = c(e3.cnt_1/e3.N, e3.cnt_2/e3.N, e3.cnt_3/e3.N),
                           split = "gini"))
printcp(e3.tree)
e3.prun.tree = prune(e3.tree, cp = 0.0)
printcp(e3.prun.tree)
print(e3.tree)
print(e3.prun.tree)
plot(e3.tree, uniform=T, compress=T, margin=0.1)
text(e3.tree, use.n=T, col="blue")

e3.control2 = rpart.control(minbucket = 5, xval=10)
e3.tree2 = rpart(Species ~ ., data=e3.dat, method="class", control=e3.control2,
                parms=list(prior = c(e3.cnt_1/e3.N, e3.cnt_2/e3.N, e3.cnt_3/e3.N),
                           split = "gini"))
e3.prun.tree2 = prune(e3.tree2, cp = 0.0)
print(e3.prun.tree2)
printcp(e3.prun.tree2)

# ex3_3
# 분류표를 보고, data 생성
X1=c(1,1,1, 1,1, 1,1,1,1, 2,2,2,2,2,2, 2, 3,3, 
     1,1, 2,2, 2,2,2,2,2, 3,3,3,3, 3,3,3,3,3,3,3, 3)
X2=c(1,1,1, 2,2, 3,3,3,3, 2,2,2,2,2,2, 3, 3,3,
     3,3, 1,1, 2,2,2,2,2, 1,1,1,1, 2,2,2,2,2,2,2, 3)
grp=c(1,1,1, 1,1, 1,1,1,1, 1,1,1,1,1,1, 1, 1,1,
      2,2, 2,2, 2,2,2,2,2, 2,2,2,2, 2,2,2,2,2,2,2, 2)
e5.dat = data.frame(grp, X1, X2)
head(e5.dat)
library(rpart)
# 전체관측치가 39이고, 1번 분할되는 나무를 만들기 위해서 minisplit를 19로
e5.ctrl = rpart.control(xval=10, cp=-0.01, minisplit=19)
e5.tree = rpart(grp ~ ., data=e5.dat, method="class", control=e5.ctrl,
                parms=list(split = "gini"))
print(e5.tree)
printcp(e5.tree)
# 1번 분할시 cp == 0이므로, 이 값을 기준으로 가지치기
e5.prun.tree = prune(e5.tree, cp=0.0)
print(e5.prun.tree)
plot(e5.prun.tree, uniform=T, compress=T, margin=0.1)
text(e5.prun.tree, use.n=T, col="blue")
summary(e5.prun.tree)

# regression tree model, p96
library(MASS)
Boston$chas = factor(Boston$chas)
Boston$rad  = factor(Boston$rad)
summary(Boston)
library(rpart)
Boston.ctrl = rpart.control(xval=10, cp=0, minsplit = nrow(Boston)*0.05)
Boston.fit = rpart(medv ~ ., data=Boston, method="anova", control=Boston.ctrl)
print(Boston.fit)
printcp(Boston.fit)
0.24125+0.035312
Boston.prun = prune(Boston.fit, cp=0.0061)
print(Boston.prun)
plot(Boston.prun, uniform = T, compress = T, margin = 0.1)
text(Boston.prun, use.n = T, col="blue")
summary(Boston.prun)
Boston$medv.hat = predict(Boston.prun, newdata = Boston, type="vector")
mean((Boston$medv - Boston$medv.hat)^2) # MSE
plot(Boston$medv, Boston$medv.hat, xlab="Observed", ylab="Fitted")
abline(0,1)
# split Boston into train, test
set.seed(1234)
Boston.idx = sample(1:nrow(Boston), round(nrow(Boston)*0.7))
Boston.train = Boston[Boston.idx,]
Boston.test  = Boston[-Boston.idx,]
Boston.fit = rpart(medv ~ ., data = Boston.train, method="anova", control = Boston.ctrl)
printcp(Boston.fit)
0.16719+0.018040
Boston.prun = prune(Boston.fit, cp = 0.00604221)
print(Boston.prun)
Boston.hat.test = predict(Boston.prun, newdata = Boston.test, type="vector")
mean((Boston.test$medv - Boston.hat.test)^2)
