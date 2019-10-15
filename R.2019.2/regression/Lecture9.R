# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# aggregate analysis - fitted model
# 회귀진단(regresssion diagnostics): 2. model diag, 1. data diag.
# 잔차분석 : standardized residual, studentized residual
# 특이점 (outlier)
forbes = read.table("./data/forbes.txt", header = T)
forbes$Lpress = 100 * log10(forbes$press)
head(forbes, 3)
plot(forbes$temp, forbes$Lpress, pch=10)
identify(forbes$temp, forbes$Lpress)
# we could see that 12nd element is outlier
forbes.lm = lm(Lpress ~ temp, data=forbes)
summary(forbes.lm)
# therefore, Lpress^ = -42.16 + 0.8956 * temp
anova(forbes.lm)
# residual analysis
forbes.res = ls.diag(forbes.lm)
names(forbes.res)
resid.result = cbind(forbes.res$std.res, forbes.res$stud.res, forbes.res$hat)
colnames(resid.result) = c("standaized resid", "studentized resid", "Hat")
resid.result = round(resid.result, 3)
print(resid.result)
# 또는 R 함수를 이용
rstudent(forbes.lm)
# Bonferroni p-value
2*17*(1-pt(12.374, 14))
# car(companion to applied regression) 특이점 검정할수 있는 packages
#install.packages("car")
library(car)
outlierTest(forbes.lm)

# 영향력 관측값 : influential observation
soil = read.table("./data/soil.txt", header=T)
head(soil, 3)
soil.lm = lm(SL ~ SG + LOBS + PGC, data=soil)
summary(soil.lm)
# SL = -1.88 + 77.33*SG + 1.56*LOBS + -23.9*PGC
anova(soil.lm)
# residual analysis
plot(soil.lm$fitted.values, soil.lm$residuals, pch=19)
identify(soil.lm$fitted.values, soil.lm$residuals)
# 7th, 10th element may be outliers
soil.diag = ls.diag(soil.lm)
names(soil.diag)
soil.st = cbind(soil.diag$hat, soil.diag$std.res, soil.diag$stud.res, soil.diag$cooks)
colnames(soil.st) = c("Hii", "ri", "ti", "Di")
round(soil.st, 3)
# notice that 10th's ti, 7th's Di
# Cook Distance
Di = cooks.distance(soil.lm)
round(Di, 3)
# outlierTest
outlierTest(soil.lm)

# 2. model diag
# check if 오차 등분산성, 모형 선형성, 오차 정규성
# how? scatter plot of residual

# 오차 등분산성 : Var(res_i) = sigma^2
goose = read.table("./data/goose.txt", header=T)
head(goose, 3)
goose.lm = lm(photo ~ obsA, data=goose)
plot(goose.lm$fitted.values, goose.lm$residuals, pch=19)
# score test
library(car)
ncvTest(goose.lm)
# reject 오차 등분산 가정

# 모형 선형성
tree = read.table("./data/tree.txt", header=T)
head(tree, 3)
tree.lm = lm(V ~ D + H, data=tree)
# 잔차-설명변수 산점도
plot(tree$D, tree.lm$residuals, pch=19)
plot(tree$H, tree.lm$residuals, pch=19)
# reject 모형 선형성 가정

# 오차의 정규성
# normal probability plot
qqPlot(goose.lm)
# Shapiro-Wilk's test
#install.packages("mvnormtest")
library(mvnormtest)
goose.rstudent = rstudent(goose.lm)
shapiro.test(goose.rstudent)
# reject 오차 정규성 가정

# 치료 1. 분산안정을 위한 변환
# a. 가중최소제곱, b. 등분산변환방법
# 치료 2. 선형으로 변환
# 치료 3. 반응변수의 변환
# Box Cox transformation
energy = read.table("./data/energy.txt", header=T)
head(energy, 3)
energy.lm = lm(Y ~ X, data=energy)
plot(energy.lm$fitted.values, energy.lm$residuals, pch=19)
#qqPlot(energy.lm)
#install.packages("MASS")
library(MASS)
boxcox(Y~X, data=energy, lambda=seq(-2,2,1/2), plotit=T)
# lamba = 0.5 is maximum, therefore, use Y^(1/2)