# change working directory to R.2019.2/medical.info
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/medical.info'))
}

# Q5 - p244
#install.packages("survival")
library(survival)
data = read.table("./data/흑색종환자자료.txt", header=T)

fit2 = survfit(Surv(time, status)~x, data=data)
summary(fit2)
plot(fit2, xlab="time", ylab="survival", lty=c(1,2), mark.time = T)
legend(5, 0.2, c("CP treated", "BCG treated"), lty=c(1,2))

survdiff(Surv(time, status)~x, data=data)
# Gehan-Wilconxon test
#install.packages("npsm")
library(npsm)
gehan.test(data$time, data$status, data$x)

# Q6 - p94
x = c(90, 56, 49, 64, 65, 88, 62, 91, 74, 93, 55, 71, 54, 64, 54)
y = c(72, 55, 56, 57, 62, 79, 55, 72, 73, 74, 58, 59, 58, 71, 61)
diff = x - y
length(diff)
qqnorm(diff)
qqline(diff, lty=2)
shapiro.test(diff)
mean(diff);sd(diff)
t.test(x, y, paired = T, alternative = "greater")
