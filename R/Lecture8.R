# math fn
pi
sin(pi)
cos(10)
tan(pi)
asin(1) # inverse fn of sin()
acos(1)
atan(1)
log(2)
log10(10)
exp(2)
sqrt(2)
x1=c(1,-2,3,4,5)
x2=c(2,4,-6,7,3)
min(x1)
max(x1)
min(x1, x2)
range(x2) # c(min(x2), max(x2))
pmin(x1, x2) # pair-wise min
pmax(x1, x2)

# statistics
mean(x1)
sd(x1)          # 표준편차, std. deviation
var(x1)
median(x1)
quantile(x1, 0.75)
cor(x1, x2)     # 상관계수, correlation

# conditional statement
if (sum(x1) < sum(x2)) {
  print(mean(x1))
  print(var(x1))
} else {
  print("ouch")
}

ifelse(x1 < x2, x1, x2) # pmin(x1, x2)

type="var"
switch(type,
       mean=mean(x1),
       median=median(x1),
       sum=sum(x1),
       var=var(x1))
switch(2,
       mean(x1),
       median(x1),
       sum(x1))

for(i in 1:5) {
  print(rep(i,i))
}

i=1
while(i<=5) {
  print(rep(i,i))
  i=i+1
}

i=1
repeat {
  if (i>5) break
  print(rep(i,i))
  i=i+1
}

i=1
x=0
while(i<10) {
  i=i+1
  if(i<8) next
  print(i)
  x=x+i
}
