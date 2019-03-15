### 제0장 패키지의 인스톨 ####

install = function(packages){
  new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(new.packages)) 
    install.packages(new.packages, dependencies = TRUE)
  sapply(packages, require, character.only = TRUE)
}

required.packages = c("mosaic", "mosaicCalc", "distrEx", "distrTeach", "TeachingDemos", "stats4", "tkrplot")
install(required.packages)

## 1. 동전 던지기의 분포 ####
 
 n_num =10000
 r_rflip = do(n_num) * rflip(2) 
 
# 앞면의 수의 분포 근삿값
 taa = tally(~heads, data=r_rflip)
  taa/n_num
 histogram(~ heads, data=r_rflip, width=1) 

### 2. 기댓값 구하기 ####

f  = makeFun(2*exp(-2*x) ~ x)  
F  = antiD(x*f(x) ~ x)
Ex = F(Inf) - F(0)

r_exp = rexp(10000,2)
mean(r_exp)

### 3. 이항분포의 포아송분포 근사 ####
 
 Poisson_2 = Pois(2)
 Binom_21  = Binom(10, 0.2)
 Binom_22  = Binom(100, 0.02)
 
 par(mfrow=c(3,1))
 plot(Poisson_2, mfColRow = FALSE, to.draw.arg="d", ylab="")
 plot(Binom_21, mfColRow = FALSE, to.draw.arg="d", ylab="", xlim=c(0, 12))
 plot(Binom_22, mfColRow = FALSE, to.draw.arg="d", ylab="", xlim=c(0, 12))

 par(mfrow=c(1,1))
 
### 4. 이항분포의 정규분포 근사 ####
 
 plotDist("binom", size=100, prob=.30, col=2, lwd=2) +
  plotDist("norm", mean=30, sd=sqrt(100 * .3 * .7), add=TRUE)

### 5. 합의 분포 #####
 n=100000
 X1 = rnorm(n,1,1)
 X2 = rnorm(n,2,1) 
 SX = X1+X2
 plot(density(SX, bw=0.8), xlim=c(-4,9),ylim=c(0,0.35), main="", xlab="")
  lines(density(X1, bw=0.8),lty=2, col=4)
  lines(density(X2, bw=0.8),lty=2, col=2)
  legend("topright", c(expression(X[1]+X[2]), 
    expression(X[1]), expression(X[2])), lty=c(1,2,2), col=c(1,4,2))

### 6. 대수의 법칙 ####
 
 illustrateLLN(Distr = Pois(2), main="Posssion(2)")
 
### 7. 중심극한정리 ####
 
  clt.examp(1)
  clt.examp(5)
  clt.examp(10)
  clt.examp(30)	
  par(mfrow=c(1,1))
  
### 8. 검정력의 비교 ####
run.power.examp()

### 9. 신뢰구간의 비교 ####
run.ci.examp()

