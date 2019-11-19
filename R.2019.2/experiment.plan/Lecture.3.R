# change working directory to R.2019.2/experiment.plan
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/experiment.plan'))
}

# example 3-1, 3-2, 3-3
a1 = c(1.93, 2.38, 2.20, 2.25)
a2 = c(2.55, 2.72, 2.75, 2.70)
a3 = c(2.40, 2.68, 2.32, 2.28)
a4 = c(2.33, 2.38, 2.28, 2.25)
wear = c(a1, a2, a3, a4)
group = c("a1", "a2", "a3", "a4")
group = rep(group, c(4, 4, 4, 4))
wear.dat = data.frame(group, wear)

tapply(wear.dat$wear, wear.dat$group, sum)
tapply(wear.dat$wear, wear.dat$group, mean)
sum(wear.dat$wear)
mean(wear.dat$wear)
boxplot(wear ~ group, data=wear.dat)

# is equal variance?
bartlett.test(wear ~ group, data=wear.dat)
# if p-value of bartlett.test > 0.05, accept H0: equal variance

# 분산분석
aov.out = aov(wear ~ group, data=wear.dat)
summary(aov.out)
# CT = T/ar,  T = sum(x_ij)
# A dfA = a-1    SSA = sum(T_i^2)/r - CT MSA=SSA/dfA F0=MSA/MSE F(0.01, dfA, dfE)
# E dfE = a(r-1) SSE = SST - SSA         MSE=SSE/dfE
# T dfA = ar-1   SST = sum(x_ij^2) - CT
qf(.99, df1=3, df2=12) # F(0.01)
pf(8.785, df1=3, df2=12, lower.tail = F)

# or 일원배치
oneway.test(wear ~ group, data=wear.dat, var.equal = T)

# if p-value of oneway.test (or aov) < 0,
# reject H0: a1 = a2 = a3 = a4 = 0

# follow-up analysis
# no adjustment, Tukey, Bonferroni
TukeyHSD(aov.out)
plot(TukeyHSD(aov(wear ~ group)))

pairwise.t.test(wear, group, p.adj="none")
pairwise.t.test(wear, group, p.adj="bonferroni")

# example 3-4
d1 = c(62, 60, 63, 59, 61)
d2 = c(63, 67, 71, 64, 65, 66)
d3 = c(68, 66, 71, 67, 68, 68)
d4 = c(56, 62, 60, 61, 63, 64)
y = c(d1, d2, d3, d4)
x = c("d1", "d2", "d3", "d4")
x = rep(x, c(5, 6, 6, 6))
# is equal variance?
bartlett.test(y ~ x)
# accept H0: equal variance since p-value > 0.05
anova = aov(y ~ x)
summary(anova)
# reject H0: d1 = d2 = d3 = d4 = 0 because p-value < 0.05
qf(p = 0.01, df1=3, df2=19, lower.tail = F)
tapply(y, x, mean)
tapply(y, x, sum)
boxplot(y~x)

pairwise.t.test(y, x, p.adj="none")
plot(anova, 1)
plot(anova, 2)

# q5
q5.a1 = c(19, 20, 23, 20, 26, 18, 18, 35)
q5.a2 = c(20, 20, 32, 27, 40, 24, 22, 18)
q5.a3 = c(16, 15, 18, 26, 19, 17, 19, 18)
q5.a = c(q5.a1, q5.a2, q5.a3)
a5.len = length(q5.a1)
q5.grp = c("a1", "a2", "a3")
q5.grp = rep(q5.grp, c(8, 8, 8))
q5.dat = data.frame(q5.grp, q5.a)
q5.aov = aov(q5.a ~ q5.grp, data=q5.dat)
# q5 (1)
summary(q5.aov)
qf(p=1-0.05, df1=2, df2=21)
# q5 (2), follow-up analysis
q5.t = qt(p=0.05/2, df=21, lower.tail = F)
q5.m1 = mean(q5.a1)
q5.m2 = mean(q5.a2)
q5.m3 = mean(q5.a3)
c(q5.m1 - q5.t*sqrt(33.23/8),  q5.m1 + q5.t*sqrt(33.23/8))
c(q5.m2 - q5.t*sqrt(33.23/8),  q5.m2 + q5.t*sqrt(33.23/8))
c(q5.m3 - q5.t*sqrt(33.23/8),  q5.m3 + q5.t*sqrt(33.23/8))
# q5 (3), LSD(least significant difference)
q5.t*sqrt(2*33.23/8)
q5.m1 - q5.m2

# q7
q7.a1 = c(19, 18, 21, 18)
q7.a2 = c(16, 11, 13, 14, 11)
q7.a3 = c(13, 16, 28, 11, 15, 11)
q7.a = c(q7.a1, q7.a2, q7.a3)
q7.N = length(q7.a)
q7.grp = c("a1", "a2", "a3")
q7.grp = rep(q7.grp, c(4, 5, 6))
q7.dat = data.frame(q7.grp, q7.a)
q7.aov = aov(q7.a ~ q7.grp, data=q7.dat)
pf(2.111, df1=2, df2=12, lower.tail = F)
qf(p=0.05, df1=2, df2=12, lower.tail = F)

# pnorm(z, lower.tail=TRUE) (the R default) gives the probability of a 
# normal variate being at or below z. This is the value commonly called 
# the cumulative distribution function at the point z, or the integral 
# from -Inf to z of the gaussian density.
#
# pnorm(z, lower.tail=FALSE) gives the complement of the above, or 1 - 
#  cdf(z), and is the integral from z to Inf of the gaussian density.
#
#E.g.,
#
#> pnorm(1.96, lower.tail=TRUE)
#[1] 0.9750021
#> pnorm(1.96, lower.tail=FALSE)
#[1] 0.02499790
#>
#
# Use lower.tail=TRUE if you are, e.g., finding the probability at the 
# lower tail of a confidence interval or if you want to the probability 
# of values no larger than z.
#
# Use lower.tail=FALSE if you are, e.g., trying to calculate test value 
# significance or at the upper confidence limit, or you want the 
# probability of values z or larger.
#
# You should use pnorm(z, lower.tail=FALSE) instead of 1-pnorm(z) 
# because the former returns a more accurate answer for large z.
#
# This is really simple issue, and has no inherent complexity 
# associated with it.

# q8 (1)
q8.a1 = c(98, 97, 99, 96)
q8.a2 = c(91, 90, 93, 92)
q8.a3 = c(96, 95, 97, 95)
q8.a4 = c(95, 96, 99, 98)
q8.a = c(q8.a1, q8.a2, q8.a3, q8.a4)
q8.grp = c("a1", "a2", "a3", "a4")
q8.grp = rep(q8.grp, c(4, 4, 4, 4))
q8.dat = data.frame(q8.grp, q8.a)
q8.aov = aov(q8.a ~ q8.grp, data=q8.dat)
summary(q8.aov)
# q8 (2) 기여율
q8.var_e = 1.896
q8.var_a = 1/4 * (29.729 - 1.896)
q8.roh = q8.var_a / (q8.var_e + q8.var_a)
