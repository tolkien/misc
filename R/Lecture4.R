# vector
scan(sep='.')
seq(from=1, to=6, by=1) # sequence
seq(from=1, to=10, length=3)
seq(from=1, by=0.05, along=1:10)
seq(from=1, to=5, along=1:9) # along == between 1 and 10
rep(c(1,2), times=2)  # repeat
rep(1:2, times=2)
rep(c(2,4), times=c(2,1))
rep(c(2,4), times=c(2,3))
rep(c(2,4), each=2)
rep(c(2,4,8), length=5) # length == number of elements of vector
c(2,1,2)
c(1:6)

# "char" vector
c("1", "KNOU", "univ")

# logical vector
c(T,F,T)

# edit a vector
v1=c(1:10)
v1[2:3]
v1[v1>5]
v2=replace(v1, 3, 6)
v2[c(3,5)]
v3=append(v1, c(11:12), after=5)
v4=c(rep(1, times=3), seq(1, 5, by=2),
     rev(seq(1,5,length=3)), rep(2, times=3))
v4
sort(v4)
rank(v4, na.last=TRUE)  # rank of element in a vector
order(v4, na.last=TRUE) # position(index) of element in a vetor
