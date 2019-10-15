# change working directory to R.2019.2/regression
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/regression'))
}

# d-th order polynomial regression
# p123
tcrime = read.table("./data/tcrime.txt", header=T)
head(tcrime, 3)
#attach(tcrime)
plot(tcrime$motor, tcrime$tcratio, pch=19)
tcrime.lm = lm(tcratio ~ motor + I(motor^2), data=tcrime)
summary(tcrime.lm)

# p125
marathon = read.table("./data/maraton.txt", header=T)
summary(marathon, 2)
plot(marathon$sect, marathon$m1990, pch=19)
marathon.lm = lm(m1990 ~ sect + I(sect^2) + I(sect^3), data=marathon)
summary(marathon.lm)

# dummy variable
soup = read.table("./data/soup.txt", header=T)
soup[c(1,15,16,27),]
soup$D = factor(soup$D, levels = c(0, 1), label=c("Line0", "Line1"))
soup[c(1,15,16,27),]
#
plot(soup$X, soup$Y, type="n")
points(soup$X[soup$D == "Line1"], soup$Y[soup$D=="Line1"], pch=17, col="BLUE")
points(soup$X[soup$D == "Line0"], soup$Y[soup$D=="Line0"], pch=19, col="RED")
legend("bottomright", legend=levels(soup$D), pch=c(19,17), col=c("RED", "BLUE"))
#
soup.lm = lm(Y ~ X + D, data=soup)
summary(soup.lm)
abline(27.28179, 1.23074, lty=2, col="RED")
abline(27.28179 + 53.1292, 1.23074, lty=2, col="BLUE")

# 교호작용 확인 (interaction effect)
soup.lm2 = lm(Y ~ X + D + X:D, data=soup)
summary(soup.lm2)
# X:D의 p-value > 0.05이므로 교호작용은 없다.(reject H0: b3 = 0)

# EXTRA: multilevel factor
#install.packages("faraway")
library(faraway)
data(fruitfly)
fruitfly[c(1,25,51,75,101),]
#
attach(fruitfly)
plot(thorax, longevity, type="n")
points(thorax[activity=="many"], longevity[activity=="many"], pch="a", col=1)
points(thorax[activity=="isolated"], longevity[activity=="isolated"], pch="i", col=2)
points(thorax[activity=="one"], longevity[activity=="one"], pch="o", col=3)
points(thorax[activity=="low"], longevity[activity=="low"], pch="n", col=4)
points(thorax[activity=="high"], longevity[activity=="high"], pch="h", col=5)

g = lm(longevity ~ thorax * activity, data=fruitfly)
summary(g)
anova(g)

# refit model withou interaction term (?)
gb = lm(longevity ~ thorax + activity, data=fruitfly)
summary(gb)
