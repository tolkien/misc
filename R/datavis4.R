#
# 이변량 분포
#
# scatter plot
exam = read.table("datavis/exam scores_2012.txt", header=T)
#attach(exam)
#windows(height=5.5, width=5)
plot(exam$mid, exam$final)

# refine "scatter plot"
summary(exam)
exam.xlab = "중간시험"
exam.ylab = "기말시험"
exam.title = "통계적 사고"
exam$mid[is.na(exam$mid)] <- 0
exam$final[is.na(exam$final)] <- 0
plot(exam$mid, exam$final, pch=20,
     xlim=c(-5,40), ylim=c(-5,40),
     col="blue",
     xlab=exam.xlab, ylab=exam.ylab, main=exam.title)

# refine more
n = length(exam$mid)
plot(exam$mid+runif(n,-0.5, 0.5),
     exam$final + runif(n, -0.5, 0.5),
     pch=20, col=rainbow(5),
     xlim=c(-5,40), ylim=c(-5,40),
     xlab=exam.xlab, ylab=exam.ylab, main=exam.title)

#
# 이변량 밀도
#
# density estimation
exam1 = exam[!is.na(exam$mid) & !is.na(exam$final),]
library(KernSmooth)
# bivariate kernel density estimate
density <- bkde2D(exam1, bandwidth = c(2.5, 2.5))
par(new=T)
# lwd : line width
contour(density$x1, density$x2, density$fhat,
        xlim=c(-5, 40), ylim=c(-5, 40),
        col=heat.colors(7)[7:1],
        nlevels = 7, lwd = 2)

#
# '큰' 자료의 산점도
#
# 그래프영역이 자료 점들로 포화 -> 먹칠
library(ggplot2)
data("diamonds")
plot(diamonds$carat, sqrt(diamonds$price), main="diamonds",
     xlim=c(-0.5, 5.5), ylim=c(0,160))
# hexagonal binning (육각형 칸에 넣기)
#install.packages("hexbin")
library(hexbin)
hexbinplot(sqrt(price)~carat, data=diamonds,
           main="diamonds",
           xlim=c(-0.5, 5.5), ylim=c(0,160),
           xbins=25, aspect = 1, colorkey = F)

#
# 회귀적 관계
#
# 선형회귀
plot(exam$mid, exam$final, pch=20,
     xlim=c(-5,40), ylim=c(-5,40),
     col="blue",
     xlab=exam.xlab, ylab=exam.ylab, main=exam.title)
abline(lm(exam$final~exam$mid), col="red")

# 비모수적 회귀
diamonds$sqrt.price <- sqrt(diamonds$price)
plot(diamonds$carat, sqrt(diamonds$price), main="diamonds",
     xlim=c(-0.5, 5.5), ylim=c(0,160), col="gray")
# lowess (locally weighted scatterplot smoothing)
lines(lowess(diamonds$sqrt.price~diamonds$carat, f=0.1),
      lwd=2, col="blue")

# see titanic.R for mosaic plot
data("Titanic")
barplot(apply(Titanic, 1, sum))
barplot(apply(Titanic, c(4,1), sum))
mosaicplot(~Class+Survived, data=Titanic, color=c("grey", "red"))
mosaicplot(~Sex+Survived, data=Titanic, color=c("grey", "red"))
apply(Titanic, c(2,4,1), sum)
mosaicplot(~Class+Sex+Survived, data=Titanic,
           color=c("grey", "red"),
           dir=c("v", "v", "h"), off=1)
mosaicplot(~ Class+Survived,
           data=as.table(Titanic[,"Male","Adult",]),
           color=c("grey", "red"), main="Male+Adult")
mosaicplot(~ Class+Survived,
           data=as.table(Titanic[,"Female","Adult",]),
           color=c("grey", "red"), main="Female+Adult")

# Simpson's paradox
data("UCBAdmissions")
apply(UCBAdmissions, c(1,2), sum)
mosaicplot(~Gender+Admit, data=UCBAdmissions,
           color=c("red", "grey"),
           main = "UC Berkeley Admissions")
mosaicplot(~Dept+Gender+Admit, data=UCBAdmissions,
           color=c("red", "grey"),
           dir=c("v", "v", "h"), off=1,
           main = "UC Berkeley Admissions")
par(mfrow=c(2,3))
mosaicplot(~Gender+Admit, data=as.table(UCBAdmissions[,,"A"]),
           color=c("red", "grey"),
           main = "Dept. A")
mosaicplot(~Gender+Admit, data=as.table(UCBAdmissions[,,"B"]),
           color=c("red", "grey"),
           main = "Dept. B")
mosaicplot(~Gender+Admit, data=as.table(UCBAdmissions[,,"C"]),
           color=c("red", "grey"),
           main = "Dept. C")
mosaicplot(~Gender+Admit, data=as.table(UCBAdmissions[,,"D"]),
           color=c("red", "grey"),
           main = "Dept. D")
mosaicplot(~Gender+Admit, data=as.table(UCBAdmissions[,,"E"]),
           color=c("red", "grey"),
           main = "Dept. E")
mosaicplot(~Gender+Admit, data=as.table(UCBAdmissions[,,"F"]),
           color=c("red", "grey"),
           main = "Dept. F")

#
# tree map
#
par(mfrow=c(1,1))
#install.packages("treemap")
library(treemap)
GNI.2010 = read.table("datavis/GNI-2010.txt", header=T)
treemap(GNI.2010, index=c("sector", "item"),
        vSize="principal", vColor="yield",
        type="value", bg.labels="yellow",
        title="Portpolio Evaluation GNI.2010 [1:104]")
GNI.2010$yield.total = GNI.2010$principal*as.numeric(GNI.2010$yield)
GNI.2010.a = aggregate(GNI.2010[,3:5], by=list(GNI.2010$sector), sum)
GNI.2010.a$yield.avg = GNI.2010.a$yield.total / GNI.2010.a$principal
treemap(GNI.2010.a, index=c("Group.1"),
        vSize="principal", vColor="yield.avg",
        type="value", bg.labels="yellow",
        title="Portpolio Evaluation GNI.2010 [1:104]")
