# change working directory to R.2019.2/data.mining
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/data.mining'))
}

# estimate a cosine function
#install.packages("neuralnet")
library(neuralnet)
set.seed(1234)
ind1 = 1:100
ind2 = ind1/length(ind1)
cos2 = cos(ind2*4*pi)
cdat = data.frame(cbind(ind2, cos2))
cos2.nn = neuralnet(cos2 ~ ind2, data=cdat, hidden=5, linear.output = T)
plot(cos2.nn)
#cos2.pred = predict(cos2.nn, newdata=cdat)
cos2.pred = compute(cos2.nn, cdat)
plot(ind1, cos2.pred$net.result)
lines(cos2)

# Boston housing
library(MASS)
bdat = Boston
i = sample(1:nrow(bdat), round(0.5 * nrow(bdat)))
max1 = apply(bdat, 2, max)
min1 = apply(bdat, 2, min)
sdat = scale(bdat, center=min1, scale=max1 - min1)
sdat = as.data.frame(sdat)
train = sdat[i,]
test  = sdat[-i,]
n = names(train)
form = as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse=" + ")))
nn1 = neuralnet(form, data=train, hidden=c(5,3), linear.output = T)
plot(nn1)
pred.nn1 = compute(nn1, test[,1:13])
pred1 = pred.nn1$net.result * (max(bdat$medv) - min(bdat$medv)) + min(bdat$medv)
PMSE = sum((bdat[-i, 14] - pred1)^2)/nrow(test)
PMSE
