# scatter plot of the exam scores data
# 2절

exam <- exam[!is.na(exam$mid) & !is.na(exam$final),]
windows(height=5.5,width=5)
plot(exam$mid,exam$final,pch=20,xlim=c(-5,40),ylim=c(-5,40),col="blue",
   xlab="중간시험",ylab="기말시험",main="통계적 사고")

library(KernSmooth)
density <- bkde2D(exam,bandwidth=c(2.5,2.5))
par(new=T); contour(density$x1,density$x2,density$fhat,xlim=c(-5,40),ylim=c(-5,40), col=heat.colors(7)[7:1], nlevels=7, lwd=2)

# end


