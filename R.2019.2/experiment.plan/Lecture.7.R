# change working directory to R.2019.2/experiment.plan
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/experiment.plan'))
}
# save.image("Lecture.7.RData")

# ex7.1
e7.y1 = c(11, 18, 25)
e7.y2 = c(1, 6, 14)
e7.y3 = c(6, 15, 18)
e7.y = c(e7.y1, e7.y2, e7.y3)
e7.B = c("B1", "B2", "B3")
e7.B = rep(e7.B, c(3))
e7.A = c("A1", "A2", "A3")
e7.A = rep(e7.A, c(3, 3, 3))
e7.dat = data.frame(e7.y, e7.A, e7.B)
names(e7.dat)[1] = "y"
names(e7.dat)[2] = "A"
names(e7.dat)[3] = "B"
names(e7.dat)
# 7.1 (1)
e7.Ti = tapply(e7.y, e7.A, sum)
e7.Tj = tapply(e7.y, e7.B, sum)
e7.T  = sum(e7.y)
e7.a = 3
e7.b = 3
e7.CT = e7.T^2/(e7.a * e7.b)
e7.SST = sum(e7.y^2) - e7.CT
e7.SSA = sum(e7.Ti^2)/e7.b - e7.CT
e7.SSB = sum(e7.Tj^2)/e7.a - e7.CT
e7.SSE = e7.SST - e7.SSA - e7.SSB
e7.dfT = e7.a * e7.b - 1
e7.dfA = e7.a - 1
e7.dfB = e7.b - 1
e7.dfE = e7.dfT - e7.dfA - e7.dfB
e7.MSA = e7.SSA/e7.dfA
e7.MSB = e7.SSB/e7.dfB
e7.MSE = e7.SSE/e7.dfE
e7.F0_A = e7.MSA/e7.MSE
e7.F0_B = e7.MSB/e7.MSE
qf(p=0.05, df1=e7.dfA, df2=e7.dfE, lower.tail = F)
qf(p=0.05, df1=e7.dfB, df2=e7.dfE, lower.tail = F)
pf(e7.F0_A, df1=e7.dfA, df2=e7.dfE, lower.tail = F)
pf(e7.F0_B, df1=e7.dfB, df2=e7.dfE, lower.tail = F)
e7.anova = aov(y ~ A + B, data=e7.dat)
summary(e7.anova)
# 7.1 (2)
e7.c1 = c(1/6, 1/6, -1/3)
e7.d1 = c(1/3, -1/3, 0)
e7.mat.A = cbind(e7.c1, e7.d1)
contrasts(e7.dat$A) = e7.mat.A
e7.c2 = c(-1, 0, 1)
e7.d2 = c(1, -2, 1)
e7.mat.B = cbind(e7.c2, e7.d2)
contrasts(e7.dat$B) = e7.mat.B
e7.contrast = aov(y ~ A + B, data=e7.dat)
summary(e7.contrast, split=list(A=list("domestic vs foreign"=1,
                                       "child co. vs other co."=2),
                                B=list("linear"=1, "quadratic"=2)
                                ))

# ex7.2
e2.y = c(4, 6, 3, 7, -2, 2, -4, -6)
e2.a = c("A0", "A1")
e2.a = rep(e2.a, c(4, 4))
e2.b = c(rep("B0", 2), rep("B1", 2))
e2.b = rep(e2.b, c(2))
e2.dat = data.frame(e2.y, e2.a, e2.b)
names(e2.dat)[1] = "y"
names(e2.dat)[2] = "A"
names(e2.dat)[3] = "B"
e2.Ti = tapply(e2.y, e2.a, sum)
e2.Tj = tapply(e2.y, e2.b, sum)
e2.r  = 2
# 1)
e2.A = (e2.Ti[1] - e2.Ti[2])/(2*e2.r)
e2.B = (e2.Tj[1] - e2.Tj[2])/(2*e2.r)
e2.AB = (e2.Tj[2] + e2.Ti[1] - e2.Tj[1] - e2.Ti[1])/(2*e2.r)
# 2)
e2.SSA = e2.r*(e2.A)^2
e2.SSB = e2.r*(e2.B)^2
e2.SSAB = e2.r*(e2.AB)^2
e2.T = sum(e2.y)
e2.CT = e2.T^2/e2.r^3
e2.SST = sum(e2.y^2)-e2.CT
e2.SSE = e2.SST - e2.SSA - e2.SSB - e2.SSAB
# 3) yates

# homework 2
y = c(22, 15, 35, 33, 8, 3, 18, 13)
a = c(0, 1, 0, 1, 0, 1, 0, 1)
b = c(0, 0, 1, 1, 0, 0, 1, 1)
c = c(0, 0, 0, 0, 1, 1, 1, 1)
blk = rep(c(1,2), c(4, 4))
data = data.frame(y, a, b, c, blk)
data$a = factor(data$a, levels=c(0, 1), labels=c("A0", "A1"))
data$b = factor(data$b, levels=c(0, 1), labels=c("B0", "B1"))
data$c = factor(data$c, levels=c(0, 1), labels=c("C0", "C1"))
data$blk = factor(data$blk, levels=c(1, 2), labels=c("blk1", "blk2"))
upto2 = aov(y ~ (a+b+c)^3, data=data)
summary(upto2)
