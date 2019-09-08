#install.packages("distrEx")
library("distrEx")

# program 4-1
X = DiscreteDistribution(supp = c(1:6), prob=rep(1/6,6))
plot(X)
E(X)
var(X)
sd(X)
E(2*X+5)
var(2*X+5)
sd(2*X+5)

# discrete uniform
# X ~ DU(n), P(X=x) = 1/n
# E(X) = (n+1)/2, Var(X) = (n^2-1)/12

# hyper
# X ~ HYP(n,D,N)
# P(X=x) = Combi(D,x)Combi(N-D,n-x)/Combi(N,n)
# E(X) = nD/N, Var(X) = E(X)*(N-D)/N*(N-n)/(N-1)
# example 5-14
X1 = Hyper(2,2,2)
d(X1)(0)
d(X1)(1)
d(X1)(2)
E(X1)
var(X1)

# binary
# X ~ B(n,p), P(X=x) = Combi(n,x) p^x (1-p)^(n-x)
# E(X) = np, Var(X) = np(1-p)
# example 5-15
X2 = Binom(4, 0.8)
d(X2)(2)
E(X2)
var(X2)

# Poisson
# X ~ POI(lambda), P(X=x) = lambda^x/x! e^(-lambda)
# E(X) = lambda, Var(X) = lambda
X3 = Pois(1)
1-p(X3)(2)
X3_1 = Binom(10000, 0.0001)
1-p(X3_1)(2)
E(X3)
var(X3)
