# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# 다중공선성, p95
hospital = read.table("./data/hospital.txt", header=T)
head(hospital, 3)
hospital.lm = lm(Y ~ X1 + X2 + X3 + X4 + X5, data=hospital)
summary(hospital.lm)
anova(hospital.lm)

#install.packages("fmsb")
library(fmsb)
VIF(lm(X1 ~ X2 + X3 + X4 + X5, data=hospital))
VIF(lm(X2 ~ X1 + X3 + X4 + X5, data=hospital))
VIF(lm(X3 ~ X1 + X2 + X4 + X5, data=hospital))
VIF(lm(X4 ~ X1 + X2 + X3 + X5, data=hospital))
VIF(lm(X5 ~ X1 + X2 + X3 + X4, data=hospital))
cor(hospital[,-6])
summary(lm(Y ~ X2 + X3 + X4 + X5, data=hospital))
VIF(lm(X2 ~ X3 + X4 + X5, data=hospital))
VIF(lm(X3 ~ X2 + X4 + X5, data=hospital))
VIF(lm(X4 ~ X2 + X3 + X5, data=hospital))
VIF(lm(X5 ~ X2 + X3 + X4, data=hospital))

# 3.5 변수선택의 방법
# 1) all possible regression
hald = read.table("./data/hald.txt", header=T)
head(hald, 3)
#install.packages("leaps")
library(leaps)
hald.all_lm = regsubsets(Y ~ ., data=hald)
(rs = summary(hald.all_lm))
names(rs)
rs$rsq
rs$adjr2
rs$cp

# 2) forward selection
hald.fw_lm = lm(Y ~ 1, data=hald)
hald.all_lm = lm(Y ~ ., data=hald)
step(hald.fw_lm, scope = list(lower=hald.fw_lm, upper=hald.all_lm), direction="forward")

# 3) backward elimination
step(hald.all_lm, data=hald, direction="backward")

# 4) stepwise regression
step(hald.fw_lm, scope = list(upper=hald.all_lm), data=hald, direction="both")
