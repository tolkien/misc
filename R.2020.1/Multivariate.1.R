# change working directory to R.2019.2/
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2020.1'))
}

x = matrix(c(1:12), nco=4, byrow=T)
x
x[,c(1:3)]
x[c(1:3),]
x[,c(-1,-2)]
x[,-2] %*% x
diag(x)
t(x)
svd(x)
qr(x)
eigen(x[,-2])
apply(x,1,sum)
apply(x,2,sum)

library(xlsx)
survey.data = read.xlsx("./mva/survey.xlsx", 1)
attach(survey.data)
mean(age)
sd(age)
summary(age)


tapply(age, sex, mean)
tapply(age, sex, sd)
tapply(age,marriage, mean)
tapply(age,marriage, sd)
sex.marriage = list(sex, marriage)
tapply(age, sex.marriage, mean)
tapply(age, sex.marriage, sd)

# 빈도표, 분할표
table(sex)
table(edu)
SexEdu = table(sex, edu)
SexEdu
# 독립성 검정, H_0 = 독립
summary(SexEdu)

# plot
sex.edu = list(sex, edu)
sex.edu.tb = table(sex.edu)
sex.edu.tb
colnames(sex.edu.tb) = c("무학", "초졸", "중졸", "고졸", "대졸")
rownames(sex.edu.tb) = c("남성", "여성")
barplot(sex.edu.tb)
title("성별 교육정도 막대그래프")

# plot using lines, co2 is builtin data
plot(co2)
lines(smooth(co2), col="BLUE")

# plot of math. function
x = seq(0, 20, 0.1)
y = exp(-x/10)*cos(2*x)
plot(x, y, type="l")

# Bivariate boxplot
#install.packages("HSAUR2")
#install.packages("MVA")
library(HSAUR2)
library(MVA)
data("USairpollution")
head(USairpollution)
x = USairpollution[,c(3,4)]
bvbox(x, xlab="manu", ylab="popul")
identify(x)
rownames(x)[c(7,9,14,30)]

# bubble plot
plot(wind~temp, data=USairpollution, pch=9)
with(USairpollution, symbols(temp, wind, circles = SO2, inches = 0.5, add = T))

# 산점도 행렬
social.data = read.table("./mva/social_data.txt", header = T)
pairs(social.data)
round(cor(social.data), 3)

# star plot
social = social.data[,-1]
year = social.data[,1]
rownames(social) = year
head(social)
stars(social)

# face graph
#install.packages("aplpack")
library(aplpack)
faces(social, face.type=4)
