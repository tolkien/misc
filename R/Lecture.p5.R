library(distrEx)
# uniform
# X ~ U(a, b)
# pdf: f(x) = 0 : 1/(b-a)
# cdf: F(x) = 0 : (x-a)/(b-a) : 1
X4 = Unif(1,5)
1-p(X4)(2)
p(X4)(4) - p(X4)(2)
E(X4)
var(X4)

# exponential
# X ~ Exp(r)
# pdf: f(x) = r e^(-r x), x >= 0 : 0
# cdf: F(x) = 1 - e^(-r x), x >= 0
X5 = Exp(3)
p(X5)(1)
plot(X5)
E(X5)
var(X5)

# normal
# X ~ N(u, s^2)
# pdf: f(x) = 1/sqrt(2 pi s^2) e^-((x-u)^2/(2 s^2))
# E(X) = u, Var(X) = s^2
# standard normal
# Z ~ N(0, 1), Z = (x-u)/s
# pdf: f(z) = 1/sqrt(2 pi) e^-((z^2)/2)
X6=Norm(15,5)
p(X6)(25)
plot(X6)
E(X6)
var(X6)
