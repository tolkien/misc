# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# scatter plot
market = read.table("data/market-1.txt", header = T)
head(market)
plot(market$X, market$Y, xlab="commercial", ylab="sales total", pch=19)
title("scatterplot between commercial and sales total")

# least square method
market.lm = lm(Y ~ X, data=market)
summary(market.lm)
abline(market.lm)
identify(market$X, market$Y)

# residual
names(market.lm)
resid = market.lm$residuals
fitted = market.lm$fitted.values
# (3)
sum(fitted)
sum(market$Y)
# (4)
sum(market$X*resid)
# (5)
sum(fitted*resid)
# (6)
xbar=mean(market$X)
ybar=mean(market$Y)
points(xbar, ybar, pch=17, cex=2.0, col="RED")
text(xbar, ybar, "(8.85, 19.36)")
fx = "Y-hat = 0.328*2.14*X"
text(locator(1), fx)

# anova
anova(market.lm)
qf(0.95, 1, 13)
1 - pf(192.9, 1, 13)
# coefficient of determination
# standard error of estimate
# coefficient of correlation
