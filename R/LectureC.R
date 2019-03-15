# bar graph
c2=read.table("./story.txt", row.names='num', header=T)
c3=read.table("./iris4.txt", header=T)
c4=read.table("./example2-2.txt", header=T)
barplot.test = function() {
  par(mfrow=c(1,2))
  barplot(table(c4$Current))
  barplot(table(c4$Current, c4$Innov))
}
barplot.test()

barplot.test2 = function() {
  par(mfrow=c(1,2))
  a=c(10,20,30); b=c(10,10,20)
  barplot(cbind(a,b))
  barplot(cbind(a,b), beside=T)
}
barplot.test2()

# pie chart
pie.test = function() {
  par(mfrow=c(1,2))
  pie(rep(1,7), col=rainbow(7), radius=0.9)
  #pie(table(BMI$religion))
  pie(table(c3$Species))
}
pie.test()

# box plot
boxplot.test2 = function() {
  par(mfrow=c(1,2))
  #boxplot(BMI$height) 
  #boxplot(height~gender, data=BMI, col=rainbow(2))
  boxplot(c2$age) 
  boxplot(age~sex, data=c2, col=rainbow(2))
}
boxplot.test2()

# Stem and Leaf plot - 줄기-잎그래프
stem(c3$Sepal.Length)
stem(c3$Sepal.Length, scale=.4)

# stripChart - 점도표
stripchart.test = function() {
  par(mfrow=c(1,3))
  stripchart(c3$Petal.Length~c3$Species, method="stack")
  stripchart(c3$Petal.Length~c3$Species, method="jitter")
  stripchart(Petal.Length~Species, data=c3, method="stack",
             pch=24:25, col=c("red", "blue"))
}
stripchart.test()

# histogram
par(mfrow=c(1,2))
hist(c3$Petal.Length, labels=T, ylim=c(0,40))
hist(c3$Petal.Length, labels=T, freq=F, ylim=c(0, 0.6)) # 상대도수

# scatter plot - 산점도
plot.test = function() {
  par(mfrow=c(2,2))
  x=seq(1, 2*pi, length=10)
  y=sin(x)
  plot(x,y,type="l", main="type=\"l\"")
  plot(x,y,type="b", main="type=\"b\"")
  plot(x,y,type="h", main="type=\"h\"")
  plot(x,y,type="c", main="type=\"c\"")
}
plot.test()

plot.test2 = function() {
  par(mfrow=c(1,2))
  plot(c3$Petal.Length, c3$Petal.Width, main="iris", type="p",
       pch=".", sub="unit: cm")
  plot(c3$Petal.Length, c3$Petal.Width, main="iris", type="p",
       pch="0", sub="unit: cm", xlab="Length", ylab="Width")
}
plot.test2()

# plot all in c3 dataset.
plot(c3)

# abline, arrow, segment
sl = c3$Sepal.Length
sw = c3$Sepal.Width
abline.test = function() {
  par(mfrow=c(1,1))
  plot(sl, sw)
  abline(v=mean(sl), lty=2, col="blue")
  abline(h=mean(sw), lty=2, col="blue")
  abline(lsfit(sl, sw), lwd=2, col="red")
  abline(lsfit(sl, sw)$coef, lw=1, col="white")
}
abline.test()

arrow.segment.test = function() {
  par(mfrow=c(1,1))
  meansl=mean(sl); minsl=min(sl); maxsl=max(sl)
  meansw=mean(sw); minsw=min(sw); maxsw=max(sw)
  plot(sl, sw)
  arrows(minsl, meansw, maxsl, meansw, lty=2, col="blue")
  arrows(meansl, minsw, meansl, maxsw, lty=2, length=0.1, col="blue")
  segments(minsl, 3.4-0.06*minsl, maxsl, 3.4-0.06*maxsl,
           lwd=2, col="red")
}
arrow.segment.test()
