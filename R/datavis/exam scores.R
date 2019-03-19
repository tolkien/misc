# scatter plot of the exam scores data

exam <- read.table("exam scores_2012.txt", header=T)
str(exam)
attach(exam)
windows(height=5.5,width=5)
plot(mid,final)

summary(exam)
mid[is.na(mid)] <- 0
final[is.na(final)] <- 0

windows(height=5.5,width=5)
plot(mid,final,pch=20,xlim=c(-5,40),ylim=c(-5,40),col="blue",
   xlab="중간시험",ylab="기말시험",main="통계적 사고")

windows(height=5.5,width=5)
set.seed(12); n <- length(mid)
plot(mid+runif(n,-0.5,0.5),final+runif(n,-0.5,0.5),pch=20,col=rainbow(5),method="square",xlim=c(-5,40),ylim=c(-5,40),
     xlab="중간시험",ylab="기말시험",main="통계적 사고")

# end