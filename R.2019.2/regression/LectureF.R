# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# simple regression model
market = read.table("data/market-1.txt", header = T)
head(market, 3)

market.lm = lm(Y ~ X, data=market)   # Y^ = beta0 + beta1 X
summary(market.lm)                   # Y^ = 0.3282 + 2.1497 X

plot(market$X, market$Y, xlab="commercial", ylab="sales total", pch=19)
title("scatterplot between commercial and sales total")
abline(market.lm)
identify(market$X, market$Y)

anova(market.lm)
# since p-value is small, reject H0: beta1 = 0

# 결정계수 R^2 = SSR/SST from anova()
485.57/(485.57 + 32.72)
# 추정값 표준오차        from anova()
sqrt(2.52)
# beta1 95% 신뢰구간     from market.lm
q.val = qt(0.975, 13)
2.1497 - q.val * 0.1548
2.1497 + q.val * 0.1548
# beta0 95% 신뢰구간     from market.lm
q.val0 = qt(0.975, 13)
0.3282 - q.val0 * 1.4302
0.3282 + q.val0 * 1.4302
# beta1 검정             from market.lm
# t0 = 2.1497/0.1548 = 13.889
qt(0.973, 13)           # 기각역 (유의수준 5%)
2*(1-pt(13.889, 13))    # p-value 유의확률
# 신뢰대 그리기
pred.frame = data.frame(X=seq(3.5, 14.5, 0.2))
pc = predict(market.lm, int="c", newdata=pred.frame)   # 기댓값 신뢰구간
pp = predict(market.lm, int="p", newdata=pred.frame)   # 새로운 값 신뢰구간
head(pc, 3)
head(pp, 3)
pred.X = pred.frame$X
pred.X
plot(market$X, market$Y, ylim=range(market$Y, pp))
matlines(pred.X, pc, lty=c(1,2,2), col="BLUE")
matlines(pred.X, pp, lty=c(1,2,3), col="RED")

# 중회귀 모형
# 모형적합
market2 = read.table("./data/market-2.txt", header=T)
head(market2, 2)
market2.lm = lm(Y ~ X1 + X2, data=market2)
summary(market2.lm)
# Y^ = 0.85041 + 1.55811 X1 + 0.42736 X2
# 결정계수 : 0.9799, reject H0: beta1 = beta2 = 0
anova(market2.lm)

# 표준화 회귀모형
library(lm.beta)
market2.beta = lm.beta(market2.lm)
print(market2.beta)
summary(market2.beta)
# X1의 표준화계수가 X2의 표준화계수보다 크므로 X1의 영향이 더 크다

# 신뢰구간
# 1. x1=10, x2=10에서 E(y)를 95% 신뢰구간으로 추정
pred.x = data.frame(X1=10, X2=10)
pc = predict(market2.lm, int="c", newdata=pred.x)
pp = predict(market2.lm, int="c", level=0.99, newdata=pred.x)
pc
pp
# 2. H0: beta1 = 0, H0 : beta2 = 0에 대해서 유의수준 0.005로 가설검정

# 다항회귀 적합
maraton = read.table("./data/maraton.txt", header=T)
maraton.lm = lm(m1990 ~ sect + I(sect^2) + I(sect^3), data=maraton)
summary(maraton.lm)
# m1990^ = 917.593 + 13.785 sect - 0.683 sect^2 + 0.0.12 sect^3

# 가변수를 이용한 회귀모형
soup = read.table("./data/soup.txt", header=T)
soup[c(1,15,16,27),]
# 두 그룹별 산점도
soup$D = factor(soup$D, level=c(0,1), label=c("Line0", "Line1"))
plot(soup$X, soup$Y, type="n")
points(soup$X[soup$D=="Line1"], soup$Y[soup$D=="Line1"], pch=17, col="BLUE")
points(soup$X[soup$D=="Line0"], soup$Y[soup$D=="Line0"], pch=19, col="RED")
legend("bottomright", legend = levels(soup$D), pch=c(19,17), col=c("RED", "BLUE"))
# 교호작용을 고려한 경우
soup2.lm = lm(Y ~ X + D + X:D, data=soup)   # or Y ~ X * D
summary(soup2.lm)
# p-value 0.18355 > 0.05, 교호작용을 고려하지 않은 모형이 적합

# 교호작용을 고려하지 않은 경우
soup.lm = lm(Y ~ X + D, data=soup)
summary(soup.lm)

abline(27.28179, 1.23074, lty=2, col="RED")
abline(27.28179+53.12920, 1.23074, lty=2, col="BLUE")
# 적합된 회귀모형 Y^ = 27.282 + 1.231 X + 53.129 D

# 특이값 검정
forbes = read.table("./data/forbes.txt", header = T)
forbes$Lpress = 100 * log10(forbes$press)
forbes.lm = lm(Lpress ~ temp, data=forbes)

forbes.res = ls.diag(forbes.lm)
names(forbes.res)
resid.result = cbind(forbes.res$std.res, forbes.res$stud.res, forbes.res$hat)
colnames(resid.result) = c("standaized resid", "studentized resid", "Hat")
resid.result = round(resid.result, 3)
print(resid.result)

rstudent(forbes.lm)    # studentized residual
# Bonferroni 유의수준 0.01에서의 기각치
qt(0.01/(2*17), 14)
# Bonferroni p-value for obs. 12
2*17*(1-pt(12.374, 14))

library(car)
outlierTest(forbes.lm)

# 잔차분석 및 cook 통계량
soil = read.table("./data/soil.txt", header=T)
soil.lm = lm(SL ~ SG + LOBS + PGC, data=soil)
soil.diag = ls.diag(soil.lm)
names(soil.diag)
diag.st = cbind(soil.diag$hat, soil.diag$std.res, soil.diag$stud.res, soil.diag$cooks)
colnames(soil.st) = c("Hii", "ri", "ti", "Di")
round(diag.st, 3)

Di = cooks.distance(soil.lm)
round(Di, 3)
library(car)
outlierTest(soil.lm)

# 오차의 등분산 - 스코어 검정
goose = read.table("./data/goose.txt", header=T)
goose.lm = lm(photo ~ obsA, data=goose)
library(car)
ncvTest(goose.lm)
# p-value < 0.05, reject 등분산 가정

# 선형성 진단
tree = read.table("./data/tree.txt", header=T)
tree.lm = lm(V ~ D + H, data=tree)
# 잔차-설명변수 산점도
plot(tree$D, tree.lm$residuals, pch=19)
plot(tree$H, tree.lm$residuals, pch=19)
# reject 모형 선형성 가정

# 오차의 정규성
qqPlot(goose.lm)
# Shapiro-Wilk's test
library(mvnormtest)
goose.rstudent = rstudent(goose.lm)
shapiro.test(goose.rstudent)
# p-value < 0.05, reject 정규성 가정

# Box-Cox transformation

# logistic regression model : binomial
# log( pi`(x) / (1 - pi`(x)) ) = -2.528 + 0.022 x
