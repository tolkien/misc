# arithmatic operator
1+1
x=3
y<-2
x+y
v1=c(1,3)
v2=c(2,4)
m1=matrix(c(5,10,2,1), ncol=2)
m2=matrix(c(3,4,5,6), ncol=2)
v1+v2
m1+m2
v2-v1
m1-m2
v1*v2
m1*m2
m1/m2
m1^m2
x %/% y   # return integer value only
m1 %/% m2 # return integer value only

# matrix op.
m1 %*% m2 # matrix multiple, not scalar op.

# logical op.
1 == 2
1 != 2
1 <= 2
T && F
2 == 2 && c(2==2, 3>4)
2 == 2 &  c(2==2, 3>4)
2 == 2 || c(2==2, 3>4)
2 == 2 |  c(2==2, 3>4)

# set op.
s1 = c(1,2,5)
s2 = c(5,1,8,9)
union(s1, s2)
intersect(s1, s2)
setdiff(s1, s2)
setdiff(s2, s1)
setequal(s1, s2)
2 %in% s1
choose(5, 2)  # number of subset with size 2 from set with size 5
