## 합의 확률분포 #####
nr = 100000
X1 = rnorm(nr, 1,1)
X2 = rnorm(nr, 1,1)
X3 = rnorm(nr, 1,1)
mr = (X1+X2+X3)
hist(mr, main="", xlab="", freq = FALSE, col="steelblue", ylim=c(0,0.5))
lines(density(mr), col=2, lwd=2)
lines(density(X1), col=5, lwd=2)
mean(mr)
var(mr)

## 중심극한정리 ######
par(mfrow=c(2,2))
for (nn in c(1,5,10, 50)) {
  XBar = rep(NA, 10000)
  for (i in 1:10000) XBar[i] = mean(rpois(nn, 2))
  hist(XBar, main=paste0("sample size:", nn), xlab=" ", freq = FALSE, col="steelblue")
  lines(density(XBar), col=2, lwd=2)
}
