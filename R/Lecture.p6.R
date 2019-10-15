library(distrEx)
# Covarience, 공분산
# Var(X) = E(X-u)^2 = E(X^2) - u^2 if E(X) = u
# Cov(X,Y) = E(XY) - E(X)E(Y)
#        ( = E([X-E(X)][Y-E(Y)]) )
# 1. Cov(X,a) = 0
# 2. Cov(aX,bY) = ab Cov(X,Y)
# 3. if X, Y is independent, Cov(X,Y) = 0
#   P(X and Y) = P(X) P(Y) if and only if X, Y is independent
# 4. Var(aX+bY) = a^2 Var(X) + b^2 Var(Y) + 2ab Cov(X,Y)

# Correlation, 상관계수
# roh = Corr(X,Y) = Cov(X,Y)/(s_X s_Y)
# 1. -1 <= roh <= 1
# 2. roh > 0, X,Y간 양의 상관관계
# 3. roh < 0, negative relation between X and Y
# 4. roh = 0, no relation between X and Y

# conditional
# f_x|y(x|y) = f(x, y)/f_y(y)
# P(X=x|Y=2), E(X|Y=2)

# bivariate normal distribution
# (X  ~ N_2((u_x , (s_x^2       roh*s_x*s_y
#  Y)        u_y)   roh*s_x*s_y       s_y^2))
#     where roh = Corr(X,Y) = Cov(X,Y)/(s_x s_y)

# conditional normal distribution
# Y|X=x ~ N(u_y + roh(s_y/s_x)(x-u_x), (1-roh^2)s_y^2)
# X|Y=y ~ N(u_x + roh(s_x/s_y)(y_u_y), (1-roh^2)s_x^2)

# multivariate normal distribution
# X1,...,Xn ~ Multi(n,p1,...,pn)
# P(X1=x1,...,Xn=xn) = n!/(x1!...xn!) p1^x1...pn^xn

#install.packages("mvtnorm")
library(mvtnorm)
# program 7-1
x = seq(0, 6, length=51)
y = seq(-1, 11, length=51)
f = matrix(0, nrow=length(x), ncol=length(y))
m = c(3,5)
S = matrix(c(1,-1,-1,4), nrow=2, ncol=2)
for(i in 1:length(x))
  for(j in 1:length(y))
    f[i,j] = dmvnorm(c(x[i],y[j]), mean=m, sigma=S)
persp(x,y,f)
# program 7-2
dmultinom(c(3,5,2), size = 10, prob = c(0.25,0.5,0.25))
rmultinom(n=5, size = 10, prob = c(0.25,0.5,0.25))

