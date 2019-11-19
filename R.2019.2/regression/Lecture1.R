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

# ex 1
age = c(3, 1, 5, 8, 1, 4, 2, 6, 9, 3, 5, 7, 2, 6)
cost = c(39, 24, 115, 105, 50, 86, 67, 90, 140, 112, 70, 186, 43, 126)
e1.dat = data.frame(age, cost)
# (1) scatter plot
plot(e1.dat$age, e1.dat$cost, xlab="age of machine", ylab="maintenance cost", pch=1)
title("age of machine and maintenance cost")

# (2) least square method
e1.lm = lm(cost ~ age, data=e1.dat)
summary(e1.lm)
abline(e1.lm)

# (3) standard error of estimate (S_y.x)
# Residual standard error: 29.11 on 12 degrees of freedom

# (4) coefficient of determination
# Multiple R-squared:  0.6098
# (4) coefficient of correlation
#> sqrt(0.6098)
#[1] 0.7808969

# (5) anova
anova(e1.lm)
qf(0.95, 1, 12)

# (6) maintenance cost of 4 age
#> 29.107 + 13.637*4
#[1] 83.655

# (7) e_i = y_i - ^y_i
y = 29.107 + 13.637*age
resid = cost - y
sum(resid)

# (8) sum x_i*e_i
sum(resid * age)

# (9) sum ^y_i*e_i
sum(resid * y)

# (10) standardized
s_y = var(cost)
u_y = mean(cost)
s_x = var(age)
u_x = mean(age)
ys = (cost - u_y)/sqrt(s_y)
xs = (age - u_x)/sqrt(s_x)
e1.dat2 = data.frame(xs, ys)
e1.lm2 = lm(ys ~ xs, data=e1.dat2)
summary(e1.lm2)
summary(e1.lm)
# Estimate of xs  = sqrt(Multiple R-squared) of e1.lm

# ex 7
year = c(0:9)
sale = c(120, 135, 162, 181, 215, 234, 277, 313, 374, 422)
e7.dat = data.frame(year, sale)
e7.lm = lm(sale ~ year, data=e7.dat)
anova(e7.lm)
summary(e7.lm)
sale_h = 94.582 + 33.048*year
sale_h
resid = sale - sale_h
resid
plot(year+1983, e7.lm$residuals, pch=9)
abline(h=0, lty = 2)
