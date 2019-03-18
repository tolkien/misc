# Simulation

# Terminology
# pdf (probability density function) -> 확률밀도함수
# iid (independent identical distribution)
#  -> 독립적이고 동일한 분포를 따르는 
# d : density     -> 확률밀도함수(pdf)의 prefix
# p : probability -> 분포함수(cdf)의 prefix
# q : quantile    -> 백분위수 함수, 분포함수의 역함수의 prefix
# r : random      -> 랜덤변수의 prefix

# if random variable X has pdf f(x),
# the mean of h(X) is...
# E(h(X)) = integral(-inf, inf, h(x)f(x), dx)
# MC(Monte-Carlo) simulation
# if we generated iid random variables X1,...,Xn with pdf f(x),
# mean(MC) = 1/n sum(1, n, h(X_i))

# 14-1
x = rnorm(10000, mean=0, sd=1)
summary(x)
sd(x)
hist(x)

# 14-2
sim.n = 1000
myhx = rep(0, sim.n)
for(i in 1:sim.n) {
  x = rnorm(10000, mean=10, sd=5)
  hx = (x^2+2*x+log(x^2+3))/sqrt(5*abs(x) + exp(x))
  myhx[i] = mean(hx)
}
mean(myhx)
var(myhx)

# Central Limit Theorem
# 1. data is from random followed by Chi Distribution
x = seq(0.15, by=0.1, length=100)
plot(x, dchisq(x,3), type="l", main="pdf of chisq(3)")

# 2. run MC simul.
#   it shows a sample distribution goes regular distribution
sim.n=1000
sam.n=c(5,10,20,50)
x.mean=matrix(0, sim.n, 4)
for(j in 1:4) {
  for(i in 1:sim.n) {
    x=rchisq(sam.n[j], 3)
    x.mean[i,j]=mean(x)
  }
}
par(mfrow=c(2,2))
hist(x.mean[,1], main="n=5")
hist(x.mean[,2], main="n=10")
hist(x.mean[,3], main="n=20")
hist(x.mean[,4], main="n=50")

# Numerical Integration
integrate(dnorm, -1.96, 1.96)
integrate(dnorm, -Inf, Inf)

# E(h(x))
testfn1 = function(x) {
  # E(h(x)) = integral(h(x)pi(x), -inf, inf)
  hx = (x^2+2*x+log(x^2+3))/sqrt(5*abs(x) + exp(x))
  res = hx*dnorm(x, 10, 5)
  return(res)
}
integrate(testfn1, -Inf, Inf)

# Var(h(x))
testfn2 = function(x) {
  # Var(h(x)) = integral((h(x) - u)^2 pi(x), -inf, inf)
  hx = (x^2+2*x+log(x^2+3))/sqrt(5*abs(x) + exp(x))
  res = (hx - 1.129548)^2*dnorm(x, 10, 5)
  return(res)
}
integrate(testfn2, -Inf, Inf)

# Optimization Technique
myfn1 = function(x) {
  res =(x-2)^2+3
  return (res)
}
#myfn1($objective) has a minimum value $minimum
optimize(myfn1, c(-10, 10))

myfn2 = function(x) {
  res=log(x)/(1+x)
  return(res)
}
optimize(myfn2, c(0,20), maximum = T)
