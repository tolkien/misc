# Data #1

# Simulation (모의실험)
x=c("A", "B", "C", "D")
p=c(0.1,0.2,0.3,0.4)
sample(x,size=10, replace=T, prob=p)
sample.int(1000, size=10) # get 10 random no. between 1 and 1000
t=sample(c(0,1), 1000, replace=T, prob=c(0.5,0.5)) # toss a coin
sum(t)

# percentile (백분위수)
# 0<a<1인a에 대해 확률변수 X의 a분위수 e_a는 P(X<e_a) = a가 되는점
# z_0.05는 95% 백분위수

# R에서 함수이름은
#  난수발생 r, 확률밀도함수 d, 누적분포함수 p, 분위수는 q 로 시작

# uniform distribution
# runif(), dunif(), punif(), qunif()
dunif(1)
punif(0.5)
mean(runif(100))

# regular distribution
# rnorm(), dnorm(), pnorm(), qnorm()
qnorm(0.025)
dnorm(c(-1,0,1))
pnorm(c(-2.54,-1.96,0,1.96,2.54))

z.ci = function(alpha=0.05, nrep=1000) {
  ndata=10
  qz = qnorm(1-alpha/2)
  se = 1/sqrt(ndata)
  ncover = 0
  for(i in 1:nrep) {
    x = rnorm(ndata)
    meanx = mean(x)
    ubound = meanx + qz*se
    lbound = meanx - qz*se
    if ( ubound > 0 & lbound < 0) ncover = ncover + 1
  }
  list(ncover=ncover)
}
z.ci()

# binary distribution
# 공을 k번뽑아서 흰공이 x개가 될 확률은?
# rbinom(), dbinom(), pbinom(), qbinom()
dbinom(2,10,0.2)
pbinom(2,10,0.2)   # P_r[X <= 2]
dbinom(0,10,0.2) + dbinom(1,10,0.2) + dbinom(2,10,0.2)
1-pbinom(2,10,0.2) # P_r[X > 2]
pbinom(2,10,0.2,lower=F)
qbinom(0.5,10,0.2) # P[X<=a] = 0.5인 a

binom.par=function(nrep=100, n=5, p=1/6) {
  x = rbinom(nrep, n, p)
  meanx = mean(x)
  varx = var(x)
  
  list(mean=meanx, var=varx)
}
binom.par()

# hypergeometric distribution
# 주머니에서 m개의 횐색공과 n개의 검은공이 있을때,
#  임의로 k개를 비복원추출로 꺼내는 경우,
#  흰색공이 x개가 될 확률은?
# rhyper(), dhyper(), phyper(), qhyper()
dhyper(2,5,6,3)
choose(5,2)*choose(6,1)/choose(11,3)
1-phyper(1,5,6,3)  # P_r[X > 2]

# quantile
q1=1:100
quantile(q1)
quantile(q1, prob=c(0.05, 0.1, 0.9, 0.95))

# mean, trimmed mean, median
m1=c(1:100, 1000)
mean(m1)
mean(m1, trim=0.05)
median(m1)
m2=c(m1, NA)
median(m2)
median(m2, na.rm=T)

# sd, var, range, min, max, IQR
sd(m1)
var(m1)
range(m1)
c(min(m1), max(m1))
IQR(m1)  # Inter Quatitle Range : Q_3 - Q_1
quantile(m1)
c1=c(1,2,3,4,5,6,7,8)
c2=c(6,7,8,9,0,1,2,3)

# cor, cov; it needs data.frame or matrix
cor(iris$Sepal.Width, iris$Petal.Width) # correlation
cov(iris$Sepal.Width, iris$Petal.Width) # covariance
c3 = cbind(rnorm(100), rnorm(100), rnorm(100))
cor(c1)

# 도수분포표
c4=read.table("./story.txt", row.names='num', header=T)
#table(BMI$gender)
#table(BMI$gender, BMI$religion)
#table(BMI$gender, BMI$religion, BMI$marr)
#table(BMI$gender, BMI$religion, exclude="No", dnn=c("GEN", "REL"))
table(c4$sex)
table(c4$sex, c4$age)
#ftable(religion~gender, data=BMI)
#ftable(BMI[,4:6], row.vars=2) # gender
#ftable(BMI[,4:6], row.vars="marr")
ftable(sex~age, data=c4)
ftable(c4[,2:3], row.vars="sex")
ftable(c4[,2:3], row.vars=2)
ftable(c4[,2:3], row.vars=1)
#t2=table(BMI$gender, BMI$religion)
#prop.table(t2)
#prop.table(t2, margin=1)
t1=table(c4$sex, c4$age)
prop.table(t1)
prop.table(t1, margin=1)
#addmargins(prop.table(t2))
addmargins(prop.table(t1))
