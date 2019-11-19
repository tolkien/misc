# change working directory to R.2019.2/experiment.plan
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/experiment.plan'))
}

# ex 6.1
e6.x = c(20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42)
e6.y = c(8.4, 9.5, 11.8, 10.4, 13.3, 14.8, 13.2, 14.7, 16.4, 16.5, 18.9, 18.5)
e6.lm = lm(e6.y ~ e6.x)
plot(e6.x, e6.y)
abline(e6.lm)
cor.test(e6.y, e6.x)
e6.n = length(e6.x)
e6.EX = mean(e6.x)
e6.EY = mean(e6.y)
e6.Sxx = sum((e6.x - e6.EX)^2)
e6.Sxy = sum((e6.x - e6.EX)*(e6.y - e6.EY))
e6.b1 = e6.Sxy/e6.Sxx
e6.b0 = e6.EY - e6.b1*e6.EX
# ex6.2
e6.Syy = sum((e6.y - e6.EY)^2)
e6.SST = e6.Syy
e6.SSR = e6.b1*e6.Sxy
e6.SSE = e6.SST - e6.SSR
e6.dfT = e6.n - 1
e6.dfR = 1
e6.dfE = e6.dfT - e6.dfR
e6.MSR = e6.SSR / 1
e6.MSE = e6.SSE / e6.dfE
e6.F0 = e6.MSR / e6.MSE
qf(p=0.05, df1=e6.dfR, df2=e6.dfE, lower.tail = F)
pf(e6.F0, df1=e6.dfR, df2=e6.dfE, lower.tail = F)
anova(e6.lm)
(length(e6.x) - 1)*var(e6.y)
# ex6.3
confint(e6.lm, level=0.95)
e6.t = qt(p=0.05/2, df=e6.n-2, lower.tail=F)
e6.b1 - e6.t*sqrt(e6.MSE/e6.Sxx)
e6.b1 + e6.t*sqrt(e6.MSE/e6.Sxx)
#predict(e6.lm, newdata, interval = "confidence")
x1 = 30
(e6.b0 + e6.b1*x1) - e6.t*sqrt(e6.MSE*(1/e6.n + ((x1 - e6.EX)^2)/e6.Sxx))
(e6.b0 + e6.b1*x1) + e6.t*sqrt(e6.MSE*(1/e6.n + ((x1 - e6.EX)^2)/e6.Sxx))

save.image("Lecture.6.RData")
