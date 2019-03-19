# scatter plot of the exam scores data
# 4절

windows(height=5.5,width=5)
plot(exam$mid,exam$final,pch=20,xlim=c(-5,40),ylim=c(-5,40),col="blue",
   xlab="중간시험",ylab="기말시험",main="통계적 사고")
abline(lm(exam$final~exam$mid),col="red")
diff <- mean(exam$final,na.rm=T)-mean(exam$mid,na.rm=T)

windows(height=5.5,width=5)
plot(exam$mid,exam$final,pch=21,xlim=c(-5,40),ylim=c(-5,40),col="blue",
   xlab="중간시험",ylab="기말시험",main="통계적 사고")
lines(lowess(exam[!is.na(exam$mid)&!is.na(exam$final),],f=0.5),lwd=2)
abline(c(0,1), lty="dotted")

# end