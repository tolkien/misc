# scatter plot of diamonds data
# 4Àý

windows(height=7, width=6.4)
diamonds$sqrt.price <- sqrt(price)
plot(sqrt(price) ~ carat,col="gray",main="diamonds",xlim=c(-0.5,5.5),ylim=c(0,160))
lines(lowess(diamonds$sqrt.price~diamonds$carat, f=0.1),lwd=2,col="blue")
lines(lowess(diamonds$sqrt.price~diamonds$carat, f=0.25),lwd=2,col="red",lty="dotted")

windows(height=7, width=6.4)
plot(price ~ carat,col="gray",main="diamonds",xlim=c(-0.5,5.5),ylim=c(-1000,21000))
lines(lowess(diamonds$price~diamonds$carat, f=0.1),lwd=2,col="blue")
lines(lowess(diamonds$price~diamonds$carat, f=0.25),lwd=2,col="red",lty="dotted")

# end