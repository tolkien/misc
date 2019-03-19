# scatter plot of diamonds data

library(ggplot2)
data(diamonds)
str(diamonds)
attach(diamonds)

windows(height=7, width=6.4)
plot(carat,price,main="diamonds",xlim=c(-0.5,5.5),ylim=c(-1000,21000))

windows(height=7, width=6.4)
plot(carat,sqrt(price),main="diamonds",xlim=c(-0.5,5.5),ylim=c(0,160))

library(hexbin)
windows(height=7, width=6.4)
hexbinplot(sqrt(price)~carat,data=diamonds,main="diamonds",xlim=c(-0.5,5.5),ylim=c(0,160),
    xbins=25,aspect=1,colorkey=F) 

windows(height=7, width=6.4)
hexbinplot(sqrt(price)~carat,data=diamonds,main="diamonds",xlim=c(-0.5,5.5),ylim=c(0,160),
    xbins=100,aspect=1,colorkey=F,colramp=function(n) magent(n,225,25))

# end