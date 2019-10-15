# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# p50
market2 = read.table("./data/market-2.txt", header=T)
head(market2, 3)
X = market2[, c(2:3)]
X = cbind(1, X)
Y = market2[,4]
X = as.matrix(X)
Y = as.matrix(Y)
XTX = t(X) %*% X
XTXI = solve(XTX)
XTY = t(X) %*% Y
beta = XTXI %*% XTY
# therefore, Y = beta X

# p56
market2.lm = lm(Y ~ X1 + X2, data=market2)
summary(market2.lm)

# p58
anova(market2.lm)

# p61
#install.packages("lm.beta")
library(lm.beta)
market2.beta = lm.beta(market2.lm)
print(market2.beta)
coef(market2.beta)
summary(market2.beta)

# 추정과 검정
# 신뢰구간 구하기
pred.x = data.frame(X1 = 10, X2 = 10)
pc = predict(market2.lm, int="c", newdata=pred.x)
pc
pc99 = predict(market2.lm, int="c", level=0.99, newdata=pred.x)
pc99
summary(market2.lm)

# 추가제곱합, p71
health = read.table("./data/health.txt", header=T)
head(health, 3)
h1.lm = lm(Y ~ X1, data=health)
h2.lm = lm(Y ~ X1 + X4, data=health)
h3.lm = lm(Y ~ X1 + X3 + X4, data=health)
h4.lm = lm(Y ~ X1 + X2 + X3 + X4, data=health)
anova(h1.lm, h2.lm)
anova(h2.lm, h3.lm)
anova(h3.lm, h4.lm)

# 추가변수그림, p74
library(car)
avPlots(h4.lm)
summary(h4.lm)

# 잔차의 검토

# 분석 사례
library(xlsx)
# 1. read data
chemical = read.xlsx("./data/chemical.xlsx", 1)
head(chemical, 3)
# 2. see statistics and correlation
summary(chemical[,-1])
cor(chemical[,-1])
# 3. apply linear model
chemical.lm = lm(loss ~ speed + temp, data=chemical)
summary(chemical.lm)
avPlots(chemical.lm)
# 4. anova
anova(chemical.lm)
# 5. plot scatter plot of residual
par(mfrow=c(1,2), pty="s")
plot(chemical$speed, chemical.lm$residuals)
identify(chemical$speed, chemical.lm$residuals)
plot(chemical$temp, chemical.lm$residuals)
identify(chemical$temp, chemical.lm$residuals)

par(mfrow=c(1,1))
plot(chemical.lm$fitted.values, chemical.lm$residuals)
abline(h=0, lty=2)
identify(chemical.lm$fitted.values, chemical.lm$residuals)

# extra
lm(loss ~ speed + temp, data=chemical)
lm(loss ~ temp + speed, data=chemical)
