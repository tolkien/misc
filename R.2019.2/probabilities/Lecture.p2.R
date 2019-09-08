#install.packages("prob")
library("prob")

# toss coin
tosscoin(1)
tosscoin(3)

# roll dice
rolldie(1)

# extraction
urnsamples(x=c("a","b","c"), size=2, replace=TRUE, ordered=TRUE)
urnsamples(x=c("a","b","c"), size=2, replace=FALSE, ordered=TRUE)
urnsamples(x=c("a","b","c"), size=2, replace=FALSE, ordered=FALSE)
nsamp(n=3, k=2, replace=TRUE, ordered=TRUE)
nsamp(n=3, k=2, replace=FALSE, ordered=TRUE)
nsamp(n=3, k=2, replace=FALSE, ordered=FALSE)

# probablities of roll dice
rolldie(1, makespace=T)
tosscoin(1, makespace = T)

# example 2-15
S=rolldie(1, makespace = T)
A=subset(S, X1%in%c(2,4,6))
B=subset(S, X1%in%c(3,6))
Prob(A)
Prob(B)
Prob(union(A,B))
Prob(intersect(A,B))
Prob(setdiff(A,B))
# program 3-1
Prob(intersect(A,B)/Prob(B))
