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
library(car)
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
with(chemical.lm, text(fitted.values, residuals, labels = names(fitted.values), pos = 4))
#identify(chemical.lm$fitted.values, chemical.lm$residuals)

# extra
lm(loss ~ speed + temp, data=chemical)
lm(loss ~ temp + speed, data=chemical)

# ex 2
y = c(81.4, 122.0, 101.7, 175.6, 150.3, 64.8, 92.1, 113.8)
x1 = c(195, 179, 205, 204, 201, 184, 210, 209)
x2 = c(57, 61, 60, 62, 61, 54, 58, 61)
e2.dat = data.frame(y, x1, x2)
# (1) estimate regression model
e2.lm = lm(y ~ x1 + x2, data=e2.dat)
summary(e2.lm)
# Y = -554.5267 - 0.1743*X1 + 11.8449*X2
# (2) if Var(e) == MSE, estimate Var(b0), Var(b1), Var(b2)
anova(e2.lm)
X = e2.dat[, c(2:3)]
X = cbind(1, X)
X = as.matrix(X)
XTX = t(X) %*% X
XTXI = solve(XTX)
MSE = 469.4 * diag(3)
Var_b = XTXI * MSE
Var_b
# (3) X1=200, X2=59, Y=?, Var(Y)
Y = e2.dat[,1]
Y = as.matrix(Y)
XTY = t(X) %*% Y
beta = XTXI %*% XTY
Xi = c(1, 200, 59)
Xi = as.matrix(Xi)
XiT = t(Xi)
# Y=
XiT %*% beta
# Var(Y)
(XiT %*% XTXI %*% Xi) * 469.4
# (4) b1 is invalid, b2 is valid. see p81
# (5) anova, see p58
anova(e2.lm)
qf(0.95, 2, 5)
# (6) coefficient of determination
summary(e2.lm)
# Multiple R-squared:  0.747
# (7) standardize, estimate a regression model
mean(Y)
Yi = (Y - mean(Y))/sqrt(var(Y)[1,1])
Zi1 = (X[,2] - mean(X[,2]))/sqrt(var(X[,2]))
Zi2 = (X[,3] - mean(X[,3]))/sqrt(var(X[,3]))
Z = cbind(1, Zi1, Zi2)
e2.lm2 = lm(Yi ~ Z)
summary(e2.lm2)
# or
library(lm.beta)
e2.beta = lm.beta(e2.lm)
print(e2.beta)

# ex 3
y = c(2.8, 3.9, 3.9, 4.4, 3.1, 3.1, 3.5, 3.6, 3.0, 3.3)
x1 = c(10, 24, 25, 28, 15, 18, 22, 22, 12, 15)
x2 = c(27, 26, 28, 26, 30, 24, 27, 25, 27, 25)
x3 = c(64, 72, 80, 88, 81, 45, 46, 69, 54, 39)
e3.dat = data.frame(y, x1, x2, x3)
# (1) regression model
e3.lm = lm(y ~ x1 + x2 + x3, data=e3.dat)
summary(e3.lm)
# (2) b1 is valid, b2, b3 is invalid. see p81
# (3) anova
anova(e3.lm)
qf(0.95, 3, 6)
# Multiple R-squared:  0.9202
# (4) X1 = 20, X2 = 27, X3 = 60, Y=?
2.409213 + 0.069788*20 - 0.024767*27 + 0.005864*60