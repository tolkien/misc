# ex 10-1) runif
set.seed(4395932)
par(mfrow=c(1,2))
hist(runif(100), xlab="", main="n=100", freq=F,
     ylim=c(0, 1.2), breaks=c(0,0.2,0.4,0.6,0.8,1.0), col="steelblue")
hist(runif(10000), xlab="", main="n=10,000", freq=F,
     ylim=c(0, 1.2), breaks=c(0,0.2,0.4,0.6,0.8,1.0), col="steelblue")

# ex 10-2) inverse transfer method
set.seed(123834)
e1 = -log(1 - runif(1000))
sq1 = sort(rexp(1000, 1))
tq1 = function(u) { -log(1-u) }
par(mfrow=c(1,2))
hist(e1, freq=F, ylim=c(0, 0.8), xlab="", main="", col="steelblue")
curve(dexp(x,1), xlim=c(0, 7), add=T, col=2, lwd=2)
plot(sq1, tq1(1:1000/1000), ylab="theorical", xlab="sampled")
abline(a=0, b=1, col=2, lwd=2)

# ex 10-3) random no. of chi distribution using exponential random no.
set.seed(135323)
u1 = runif(3*1000)
u2 = matrix(data=u1, nrow=3)
x1 = -log(1 - u2)         # random number of exponential dist.
x2 = 2 * apply(x1, 2, sum)# random number of chi dist. (?)
par(mfrow=c(1,1))
hist(x2, freq=F, xlim=c(0,25), ylim=c(0,0.15),
     xlab="", main="", col="steelblue", breaks=20)
curve(dchisq(x, df=6), add=T, col=2, lwd=2)

# ex 10-4) random of regular distribution by rejection method

# ex 10-5) rnorm by Box Muller method
set.seed(2343221)
u1 = runif(10000)
u2 = runif(10000)
x1 = sqrt(-2*log(u1)) * cos(2*pi*u2)
x2 = sqrt(-2*log(u1)) * sin(2*pi*u2)
par(mfrow=c(2,2))
hist(x1, freq=F, xlim=c(-4,4), breaks=20, ylim=c(0,0.4),
     xlab="", main="", col="steelblue")
curve(dnorm(x), add=T, col=2, lwd=2)
hist(x2, freq=F, xlim=c(-4,4), breaks=20, ylim=c(0,0.4),
     xlab="", main="", col="steelblue")
curve(dnorm(x), add=T, col=2, lwd=2)
qqnorm(x1, xlab="theorical", ylab="sampled", main="")
qqline(x1, col=2, lwd=2, col="red")
qqnorm(x2, xlab="theoreical", ylab="sampled", main="")
qqline(x2, col=2, lwd=2, col="green")

# ex 10-5) random number of bernullis
set.seed(234221)
par(mfrow=c(1,2))
# B(10, 0.25)
bn1 = rep(0,1000)
for(i in 1:1000) {
  bn1[i] = sum(runif(10) < 0.25)
}
hist(bn1, freq=F, xlab="", main="B(10, 0.25)", col="steelblue")
# B(100, 0.25)
bn2 = rep(0,1000)
for(i in 1:1000) {
  bn2[i] = sum(runif(100) < 0.25)
}
hist(bn2, freq=F, xlab="", main="B(100, 0.25)", col="steelblue")

# monte carlo
set.seed(135313)
pical = function(n) {
  u1 = runif(n, min=-10, max=10)
  u2 = runif(n, min=-10, max=10)
  x1 = rep(0, n)
  x1[u1^2 + u2^2 <= 100] = 1
  pi4 = mean(x1)*4
  return(pi4)
}
pical(100)
pical(10000)
pical(1000000)

# ex 10-8) integral of y=x^2 and y=x sqrt(1-x^2)
par(mfrow=c(1,2))
x1 = seq(from=0, to=1, by=0.01)
y1 = x1^3
y2 = x1 * sqrt(1-x1^2)  
plot(x1, y1, type="l", xlab="", ylab="", main="")
plot(x1, y2, type="l", xlab="", ylab="", main="")

set.seed(1234789)
rint = function(f, gg, n) {
  sam = matrix(runif(2*n), ncol=2)
  qq = gg(sam[,1], sam[,2])
  
  plot(sam[!qq,1], sam[!qq,2], col="steelblue", pch=1, xlab="", ylab="")
  points(sam[qq,1], sam[qq,2], col="gray", pch=1)
  curve(f, 0, 1, n=100, col="black", add=T, lwd=2)
  return(length(qq[qq])/n)
}
f1 = function(x) x^3
g1 = function(x,y) y <= x^3
integrate(f1, 0, 1)
rint(f1, g1, 100)
rint(f1, g1, 10000)

f2 = function(x) sqrt(1-x^2)*x
g2 = function(x,y) y <= sqrt(1-x^2)*x
integrate(f2, 0, 1)
rint(f2, g2, 100)
rint(f2, g2, 10000)

# ex 10-9) E(X), Var(X) of N(0,1) by random number
set.seed(234212)
x1 = rnorm(100)
x2 = rnorm(10000)

f1 = function(x) x*dnorm(x)
mu = integrate(f1, -Inf, Inf)
mu
mean(x1)
mean(x2)

f2 = function(x) (x-mu$value)^2*dnorm(x)
sigma2 = integrate(f2, -Inf, Inf)
sigma2
var(x1)
var(x2)

# ex 10-10) importance sampling
set.seed(123908)
imports = function(n) {
  x1 = rt(n, 1)
  w1 = dnorm(x1)/dt(x1,1)
  
  return(mean(x1*x1*w1))
}
imports(100)
imports(10000)

# Q 01 : random, histogram from logistic dist.
# F^-1(x) = log(x / (1-x))
u = runif(1000)
x = log(u/(1-u))
hist(x1, freq=F, breaks=20, ylim=c(0,0.4),
     xlab="", main="", col="steelblue")
curve(dlogis(x), add=T, col=2, lwd=2)

# Q 02 : using rejection method
rejsamp = function(cc) {
  while(1) {
    u = runif(1)
    x = rcauchy(1, 0, 2)
    if (u < dnorm(x)/(cc*dcauchy(x, 0, 2)))
      return (x)
  }
}

rsamp = replicate(10000, rejsamp(3))
hist(rsamp, freq=F, ylim=c(0, 0.5), breaks=50,
     col="steelblue", main="", xlab="")
lines(seq(-4, 4, 0.01), dnorm(seq(-4, 4, 0.01)), col=2, lwd=2)
lines(seq(-4, 4, 0.01), dcauchy(seq(-4, 4, 0.01), 0, 2)*3, col=3, lwd=2)

# Q 03 : E(X), Var(X) of Exp(1) by random
set.seed(234214)
e1 = rexp(10000)

g1 = function(x) x*dexp(x)
mu = integrate(g1, -Inf, Inf)
mu;mean(e1)

g2 = function(x) (x-mu$value)^2*dexp(x)
sigma2 = integrate(g2, -Inf, Inf)
sigma2;var(e1)
