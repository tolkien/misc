# change working directory to R.2019.2/experiment.plan
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/experiment.plan'))
}

# q3
q3.A1 = c(78.3, 77.1, 78.1, 78.1, 77.7)
q3.A2 = c(79.3, 78.2, 80.1, 79.7, 79.3)
q3.A3 = c(77.0, 78.0, 77.4, 78.4, 77.1)
q3.a = 3
q3.b = 5
q3.A = c(q3.A1, q3.A2, q3.A3)
q3.l.a = c("A1", "A2", "A3")
q3.l.a = rep(q3.l.a, c(5, 5, 5))
q3.l.b = c("B1", "B2", "B3", "B4", "B5")
q3.l.b = rep(q3.l.b, c(3))
q3.dat = data.frame(q3.A, q3.l.a, q3.l.b)
names(q3.dat)[1] = "y"
names(q3.dat)[2] = "A"
names(q3.dat)[3] = "B"
boxplot(y ~ A, data=q3.dat)
boxplot(y ~ B, data=q3.dat)
q3.aov = aov(y ~ A + B, data=q3.dat)
summary(q3.aov)
q3.T = sum(q3.A)
q3.Ti = tapply(q3.A, q3.l.a, sum)
q3.Tj = tapply(q3.A, q3.l.b, sum)
q3.CT = q3.T^2 / (q3.a * q3.b)
q3.SST = sum(q3.A^2) - q3.CT
q3.SSA = sum(q3.Ti^2)/q3.b - q3.CT
q3.SSB = sum(q3.Tj^2)/q3.a - q3.CT
q3.SSE = q3.SST - q3.SSA - q3.SSB
q3.dfA = q3.a - 1
q3.dfB = q3.b - 1
q3.dfT = q3.a * q3.b - 1
q3.dfE = q3.dfT - q3.dfA - q3.dfB
q3.MSA = q3.SSA / q3.dfA
q3.MSB = q3.SSB / q3.dfB
q3.MSE = q3.SSE / q3.dfE
q3.F0_A = q3.MSA/q3.MSE
q3.F0_B = q3.MSB/q3.MSE
pf(q3.F0_A, df1=q3.dfA, df2=q3.dfE, lower.tail = F)
pf(q3.F0_B, df1=q3.dfB, df2=q3.dfE, lower.tail = F)
qf(p=0.05, df1=q3.dfA, df2=q3.dfE, lower.tail = F)
qf(p=0.05, df1=q3.dfB, df2=q3.dfE, lower.tail = F)

# q4
q4.R1 = c(21, 47, 31, 49)
q4.R2 = c(35, 49, 29, 44)
q4.R3 = c(42, 38, 51, 27)
q4.R4 = c(53, 25, 40, 32)
q4.y = c(q4.R1, q4.R2, q4.R3, q4.R4)
q4.p = 4
q4.row = factor(rep(c(1,2,3,4), c(4, 4, 4, 4)))
q4.col = factor(rep(c(1,2,3,4), 4))
q4.trt = c("C", "B", "A", "D",
           "A", "D", "C", "B",
           "B", "A", "D", "C",
           "D", "C", "B", "A")
q4.dat = data.frame(q4.y, q4.row, q4.col, q4.trt)
q4.aov = aov(q4.y ~ q4.row + q4.col + q4.trt, data=q4.dat)
summary(q4.aov)
q4.dfT = q4.p^2 - 1
q4.dfR = q4.dfC = q4.dft = q4.p - 1
q4.dfE = q4.dfT - q4.dfR - q4.dfC - q4.dft
q4.T = sum(q4.y)
q4.CT = q4.T^2/q4.p^2
q4.Tr = tapply(q4.y, q4.row, sum)
q4.Tc = tapply(q4.y, q4.col, sum)
q4.Tt = tapply(q4.y, q4.trt, sum)
q4.SST = sum(q4.y^2) - q4.CT
q4.SSR = sum(q4.Tr^2)/q4.p - q4.CT
q4.SSC = sum(q4.Tc^2)/q4.p - q4.CT
q4.SSt = sum(q4.Tt^2)/q4.p - q4.CT
q4.SSE = q4.SST - q4.SSR - q4.SSC - q4.SSt
q4.MSR = q4.SSR / q4.dfR
q4.MSC = q4.SSC / q4.dfC
q4.MSt = q4.SSt / q4.dft
q4.MSE = q4.SSE / q4.dfE
q4.F0_t = q4.MSt / q4.MSE
qf(p=0.05, df1=q4.dft, df2=q4.dfE, lower.tail = F)
pf(q4.F0_t, df1=q4.dft, df2=q4.dfE, lower.tail = F)
save.image("Lecture.4.RData")
