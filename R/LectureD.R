# graph #2
c2=read.table("./story.txt", row.names='num', header=T)
c3=read.table("./iris4.txt", header=T)
c4=read.table("./example2-2.txt", header=T)

# matplot
matplot.test = function() {
  par(mfrow=c(1,2))
  x = seq(-pi,pi,length=100)
  y = cbind(sin(x), cos(x))
  matplot(x, y, type="l")
  abline(h=0, lty=5, col="lightgray")
  matplot(y, type="p", pch=16, main="one vectory only")
  # if no x, x = c(0,100)
}
matplot.test()

# 산점도 행렬
pairs.test = function() {
  pairs(~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,
        data=c3, subset=Species == "setosa",
        labels=c("Sepal.len", "Sepal.width",
                 "Petal.len", "Petal.width"), row1attop=F)
#  pairs(~height+weight+year, data=BMI, subset=gender == "F",
#        labels=c("heght(cm)", "weight(kg)", "year"), row1attop=F)
}
pairs.test()

# curve
curve.test = function() {
  par(mfrow=c(1,2))
  curve(sin(x), xlim=c(-pi,pi), main="Sin Curve")
  abline(h=0)
  hist(rnorm(100), freq=F)
  curve(dnorm(y), from=-3, to=3, add=T, col="red", xnam="y")
}
curve.test()

# star plot (or star diagram)
X = matrix( c(90, 80, 90, 90, 80,  90, 70, 80, 80, 80,
              70, 70, 70, 80, 50,  50, 60, 90, 60, 40),
            ncol=5, byrow=T) / 100
dimnames(X) = list(c("john", "bill", "mike", "jerry"),
                   c("stat", "pc", "mgmt", "eng", "sport"))
stars.test2 = function() {
  par(mfrow=c(1,2))
  stars(X, scale=F, main="scale=F")
  stars(X, radius=F, main="radius=F")
}
stars.test2()

stars.test3 = function() {
  par(mfrow=c(1,2))
  stars(X, locations=c(0,0), scale=F, radius=T,
        col.stars=1:10, xlim=c(-1.2, 1.2), main="score",
        key.loc=c(0,0), key.xpd=T)
  stars(X, locations=c(0,0), scale=F, radius=T,
        col.stars=1:10, xlim=c(-1.2, 1.2), main="score")
}
stars.test3()

stars.test4 = function() {
  par(mfrow=c(1,2))
  myloc = rbind(c(1,1), c(3,1), c(1,3), c(3,3))
  stars(X, draw.segments = T, location = myloc,
        key.loc = c(2, 5.5), scale = F, main="draw.segment=T",
        ylim = c(0,6))
  abline(h=4)
  stars(X, axes = T, location = myloc,
        key.loc = c(2, 5.5), scale = F, main="axes=T",
        ylim = c(0,6))
  abline(h=4)
}
stars.test4()

# 3D plot, persp
binormalpdf = function(r=0) {
  x = seq(-3, 3, length = 30)
  y = x
  z = matrix(0, ncol=length(x), nrow=length(y))
  for (i in 1:length(x)) {
    for (j in 1:length(y)) {
      z[i,j] = exp(-(x[i]^2 - 2*r*x[i]*y[j] + y[j]^2)/(2*(1-r^2)))
    }
  }
  z = z/(2*pi*sqrt(1-r^2))
  list(x=x, y=y, z=z)
}
persp.test = function() {
  par(mfrow=c(1,2))
  persp(binormalpdf(0.6)$z)
  persp(binormalpdf(0.9)$z)
}
persp.test()

# contour map
contour.test = function() {
  x = binormalpdf(0.7)$x
  y = x
  z = binormalpdf(0.7)$z
  par(mfrow=c(1,3))
  contour(x, y, z, drawlabels = F)
  contour(x, y, z, nlevel=5, main="nlevel=5", col=2, labcex=.8)
  contour(x, y, z, level=seq(0.05, 0.25, by=0.04),
          labels=as.character(seq(0.05, 0.25, by=0.04)),
          main="level, labels used", col=4)
}
contour.test()

filled.contour.test = function() {
  x = seq(-3, 3, length=30)
  y = x
  par(mfrow=c(1,1))
  filled.contour(x, y, binormalpdf(0.7)$z,
                 col=rainbow(20))
}
filled.contour.test()
