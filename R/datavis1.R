# 데이타->정보->시각화
# ex) 런던 콜레라 지도 by John Snow
#
#  데이타의 이해 -> 목표 설정 -> 그래프선정/구현 -> 스토리텔링

kings = read.table("vis5/chosun\ kings.txt", header=T)
str(kings)
attach(kings)
#windows(width=5.5, height=4.5)
hist(period)

# more
hist(period, xlim=c(0,70), ylim=c(0,10),
     nclass=14,
     right=F,
     main="조선 왕조",
     xlab="재위기간(년)",
     ylab="빈도")

# color
color = c("#FF0000", "#FFFF00", "#00FF00", "#00FFFF",
          "#0000FF", "#FF00FF")
pie(rep(1,5), col=color, labels=color)
par(new=T); pie(rep(1,1), col="white", radius=0.5, labels=color)
