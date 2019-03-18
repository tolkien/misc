# Regression
c2=read.table("./story.txt", row.names='num', header=T)
c3=read.table("./iris4.txt", header=T)
c4=read.table("./example2-2.txt", header=T)

# 선형관계 (Linear Relationship)
#  반응변수(목표변수,종속변수,출력변수) Y
#  설명변수(입력변수,독립변수) X
age = 5:14
height = c(104,108,119,124,137,138,149,150,156,165)
plot(age, height, main="age vs height")

#
# Simple Linear Regression
#
# y_i = b_0 + b_1*x_i + err_i    i=1,...,n
# 잔차 = 관측치 - 예측치
#  sum(r_i^2, 1, n) = sum((y_i - y_i^hat)^2, 1, n)
#lm(Y ~ X)
lm1 = lm(height~age)
names(lm1)
summary(lm1)

# 회귀직선은 다음과 같다.
# Height = 70.7455 + 6.7636*age
# i.e. b_0 = 70.7455, b_1 = 6.7636
sum((height-mean(height))^2) # 반응변수 height의 총 변동량
sum((lm1$residuals)^2)       # 잔차제곱합
rss=sum((lm1$residuals)^2)
sst=sum((height-mean(height))^2)
1-rss/sst    # Multiple R-squared

# 단순선형회귀모형에서 Multi R^2 == correlation(X,Y)^2
cor(age,height)^2 # 

# Example 15-4
age2=c(6.3,7.2,10.5,13.6)
age.new=data.frame(age2)
colnames(age.new)="age"
predict(lm1, age.new)

#
# Multiple Regression Model
#
dim(mtcars)
head(mtcars)
plot(mtcars)
lm.cars=lm(mpg~., data=mtcars)
summary(lm.cars)

# 회귀진단 (Regression Diagnosis)
# 가정 1. X와 Y는 선형관계 
# 가정 2. 오차항(err_i)의 평균은 0, 등분산을 가짐
# Example 15-6
x = c(1, 4, 17, 30, 40, 49, 54, 60, 63, 70)
y = c(3, -52, -1116, -3535, -6316, -9500, -11551, -14274, -15745, -24173)
cor(x,y)
lm2=lm(y~x)
summary(lm2)
# 산점도를 봐서 확인 필요.
par(mfrow=c(1,2))
plot(x, y, main="설명변수 vs 반응변수")
abline(lm2, col=2)
plot(x,lm2$residuals, ylab="잔차", main="residual plot")
abline(h=0, col=2)
# residual plot을 보면 잔차가 크게 휘어진 곡선이므
# X와 Y의 관계가 선형이 아님
# 실제 이 data는 Y=a X^2 + b X + c 인 비선형관계

#
# Variable selection
#
# 좋은 회귀모형이란
# 1. 예측오차가 작아야 한다.
# 2. 모형은 간단해야 한다.
# AIC(Akaike Information Criterion)
#  AIC = nlog(RSS/n) + 2P
# use stepwise regression
# Example 15-7
lm.cars.step=step(lm.cars, direction = "both")
summary(lm.cars.step)
# step() 함수가 권장하는 모형의 변수는 wt,qsec,am (AIC가 최소인)

# 다시 한번 회귀진단
par(mfrow=c(1,2))
plot(lm.cars.step$fitted.values, lm.cars.step$residuals,
     main="잔차산점도", xlab="예측치", ylab="잔차")
abline(h=0, col=2)
plot(mtcars$mpg, lm.cars.step$fitted.values,
     main="관측치vs예측치", xlab="관측치", ylab="예측치")
abline(a=0, b=1, col=2)
