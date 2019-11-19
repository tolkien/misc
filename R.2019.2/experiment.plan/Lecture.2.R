# change working directory to R.2019.2/experiment.plan
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/experiment.plan'))
}

# q4 - t-test
ins1 = c(1.35, 1.16, 1.23, 1.20, 1.32, 1.28, 1.21, 1.25, 1.17, 1.19)
ins2 = c(1.01, 0.98, 0.95, 1.05, 1.02, 0.96, 0.99, 0.98, 1.01, 1.02)
t.test(ins1, ins2, var.equal = T, alternative = "greater", conf.level=0.99)
ins.1.m = mean(ins1)
ins.1.v = var(ins1)
ins.1.n = length(ins1)
ins.2.m = mean(ins2)
ins.2.v = var(ins2)
ins.2.n = length(ins2)
ins.sp = ((ins.1.n - 1)*ins.1.v + (ins.2.n - 1)*ins.2.v)/(ins.1.n + ins.2.n - 2)
ins.t0 = (ins.1.m - ins.2.m)/(sqrt(ins.sp) * sqrt(1/ins.1.n + 1/ins.2.n))
ins.t = qt(1-0.01, df=ins.1.n + ins.2.n - 2, lower.tail = T)
# reject H0 : ins.1.u == ins.2.u because ins.t0 > ins.t

# q5 - paired t-test
deer1 = c(142, 140, 144, 144, 142, 146, 149, 150, 142, 148)
deer2 = c(138, 136, 147, 139, 143, 141, 143, 145, 136, 146)
t.test(deer1 - deer2, mu=0)
diff = deer1 - deer2
diff.m = mean(diff)
diff.v = var(diff)
diff.n = length(diff)
diff.t0 = diff.m/(sqrt(diff.v/diff.n))
diff.t = qt(1-0.05/2, df=diff.n-1, lower.tail = T)
# reject H0 : diff = 0 because diff.t0 > diff.t

# q6 - var.test
q6.v1 = 1.2
q6.n1 = 14
q6.v2 = 4.8
q6.n2 = 5
q6.level = 0.1
q6.F0 = (q6.v2/q6.v1)
q6.F = qf(p=q6.level/2, df1=q6.n2-1, df2=q6.n1-1, lower.tail = F)
# reject H0: q6.s1 = q6.s2 because q6.F0 > q6.F
