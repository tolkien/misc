# EDA(탐색적 자료분석, Exploratory Data Analysis) by J.W.Tukey
#   Resistance, Residual,   Reexpression,  Graphic Representation
#   저항성,     잔차의 해석,자료의 재표현, 현시성

# 원그래프: 각 항목이 차지하는 비율
#     목표: 분포의 구성을 상대적으로 비교
# 막대그래프: 항목별 도수를 막대의 상대적인 길이
#       목표: 막대가 제일 긴지
# 혈액형
blood = read.csv("datavis/blood.csv", header=F)
blood.sort = sort(table(blood), decreasing=T)
par(mfrow=c(1,2))
slices=c("red", "blue", "yellow", "green")
pie(blood.sort, col=slices, radius=1, main="PieGraph")
barplot(blood.sort, col=slices, main="막대그래프")

# pie chart
pie.vote = c(152,5,3,13,127)
pie.rate = pie.num/sum(pie.num)
names(pie.rate) = c("새누리 152명", "선진 5명", " 무 3명",
                    "진보 13명", "민주 127명")
pie.color=c("red3","blue","green3","magenta","yellow")
pie.title="19대 국회의원 선거"
par(mfrow=c(1,2))
pie(pie.rate, col=pie.color, main=pie.title)

# add donut
par(new=T)
pie(pie.vote, radius=0.5, col="white", label=NA, border=NA)
text(0,0, "총 300석")

# add bar graph
barplot(pie.vote, col=pie.color, main=pie.title)

# https://www.r-graph-gallery.com/all-graphs/
# square.pie
set.seed(250)
#par(mar=c(0,0,0,0) , bg="white" )
plot(1,1,col="white", xlim=c(10,80), ylim=c(10,80),
     xaxt="n", yaxt="n", bty="n", xlab="", ylab="")
for(i in c(1:140)){
  col=rgb( sample(seq(0,1,0.01), 1),  sample(seq(0,1,0.01), 1),
           sample(seq(0,1,0.01), 1), 1)
  a=sample(1:80, 1)
  b=sample(1:80, 1)
  rect(a,b,a+sample(1:40, 1),b+sample(1:40, 1) , col=col,
       border="black", lwd=sample(1:6, 1) )
}
legend("topleft", legend = "© Yan Holtz", bty = "n", text.col = "gray70", cex=1.3, angle=90)

# histogram, boxplot, stem
# Histogram: 연속형 관찰값의 구간별 도수를 상대적인 막대의 길이
#      목표: 자료의 종심위치/산포, 봉우리의 갯수, 이상치의 점검
bile=read.table("./datavis/담즙과포화비율.txt", header=T)
#attach(bile)
#str(bile)
bile.len = length(bile)
bile.sort= bile[c(order(bile$담즙의과포화비율, decreasing=T)),]
bile.data= bile.sort$담즙의과포화비율
bile.brk = seq(30, max(bile.data)+10, 10)
bile.xlab= "담즙의과포화비율"
bile.jitt=jitter(bile.data)
par(mfrow=c(1,2))
hist(bile.data, breaks=bile.brk, main=NULL, xlab=bile.xlab)
rug(bile.jitt)
hist(bile.data, breaks=bile.brk, right=F, main=NULL, xlab=bile.xlab)
rug(bile.jitt)
#bile.m = matrix(c(1,3,2,3), ncol=2, byrow=T)
#layout(mat=bile.m)
hist(bile.data, prob=T, breaks=bile.brk, right=F,
     main=NULL, xlab=bile.xlab, ylab="상대도수")
lines(density(bile.data, bw=5), col="red")
rug(bile.jitt, col="blue")

# eruption lengths(in minutes) of 107 eruptions
#  of Old Faithful geyser
geyser.len=c(4.37,3.87,4.00,4.03,3.50,4.08,2.25,4.70,1.73,4.93,
             1.73,4.62,3.43,4.25,1.68,3.92,3.68,3.10,4.03,1.77,
             4.08,1.75,3.20,1.85,4.62,1.97,4.50,3.92,4.35,2.33,
             3.83,1.88,4.60,1.80,4.73,1.77,4.57,1.85,3.52,4.00,
             3.70,3.72,4.25,3.58,3.80,3.77,3.75,2.50,4.50,4.10,
             3.70,3.80,3.43,4.00,2.27,4.40,4.05,4.25,3.33,2.00,
             4.33,2.93,4.58,1.90,3.58,3.73,3.73,1.82,4.63,3.50,
             4.00,3.67,1.67,4.60,1.67,4.00,1.80,4.42,1.90,4.63,
             2.93,3.50,1.97,4.28,1.83,4.13,1.83,4.65,4.20,3.93,
             4.33,1.83,4.53,2.03,4.18,4.43,4.07,4.13,3.95,4.10,
             2.72,4.58,1.90,4.50,1.95,4.83,4.12)
# 계급의 폭을 0.5로 하고 제 1계급의 하한값(원점이라고도 함)을
#  1.35로 하는 도수분포표
geyser.xlab="간헐온천 지속시간"
w=c(1.35, 1.5)
par(mfrow=c(1,length(w)))
for(i in 1:length(w)) {
  geyser.brk=seq(w[i],max(geyser.len)+0.5,by=0.5)
  table(cut(geyser.len, breaks=geyser.brk))
  geyser.main = sprintf("origin %.2f", w[i])
  hist(geyser.len, breaks=geyser.brk, main=geyser.main, xlab=geyser.xlab)
}

par(mfrow=c(2,3))
w=c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
for(i in 1:length(w)) {
  geyser.brk=seq(1.35, 5.1+w[i], by=w[i])
  geyser.main = sprintf("break %.1f", w[i])
  hist(geyser.len, breaks=geyser.brk, main=geyser.main, xlab=geyser.xlab)
}

# draw graph by random number
par(mfrow=c(1,1))
r = runif(400, -1, 1)
hist(r)
r = rnorm(400, 0, 1)
hist(r)
r = rbinom(1000, 10, 0.5)
hist(r)
r = rpois(1000, 5)
hist(r)

# boxplot
boxplot(bile.data, col="yellow", horizontal = T, main = NULL)
rug(bile.data, col="blue")
par(mfrow=c(1,2))
boxplot(bile.sort$담즙의과포화비율~bile.sort$성별, notch=T,
        col="yellow", main=NULL)
# install.packages("vioplot")
require(vioplot)
#bile.m=subset(bile.sort, select=c(1,2), subset=(성별=="남자"))
bile.m=subset(bile.sort, subset=(성별=="남자"))
bile.f=subset(bile.sort, subset=(성별=="여자"))
vioplot(bile.m$담즙의과포화비율, bile.f$담즙의과포화비율, col="violet")

# stem plot
exam1 = read.table("datavis/exam1.txt", header=T)
stem(exam1$score, scale=2)
