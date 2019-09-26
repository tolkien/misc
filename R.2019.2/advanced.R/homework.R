# change working directory to R.2019.2/advanced.R
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/advanced.R'))
}

# p34 1-1
hw_p34_1.tab = read.table("./hw_p34_1-1.txt", header = T)
hw_p34_1.tab[c(9:10),]

# p34 1-2
#install.packages("xlsx")
library(xlsx)
hw_p34_1.xls = read.xlsx("./hw_p34_1-1.xlsx", 1)
head(hw_p34_1.xls, n=2)

# p34 1-3
#install.packages("dplyr")
library(dplyr)
mean(hw_p34_1.xls$DOSE[hw_p34_1.xls$SEX=='남']);
sd(hw_p34_1.xls$DOSE[hw_p34_1.xls$SEX=='남'])
hw_p34_1.m = filter(hw_p34_1.xls, SEX=='남')
mean(hw_p34_1.m$BP); sd(hw_p34_1.m$BP)
mean(hw_p34_1.m$AGE); sd(hw_p34_1.m$AGE)
hw_p34_1.f = filter(hw_p34_1.xls, SEX=='여')
mean(hw_p34_1.f$DOSE); sd(hw_p34_1.f$DOSE)
mean(hw_p34_1.f$BP); sd(hw_p34_1.f$BP)
mean(hw_p34_1.f$AGE); sd(hw_p34_1.f$AGE)

# p34 1-4
par(mfrow=c(2,2))
hist(hw_p34_1.m$DOSE, xlab="", main="m$DOSE")
hist(hw_p34_1.f$DOSE, xlab="", main="f$DOSE")
boxplot(hw_p34_1.m$DOSE)
boxplot(hw_p34_1.f$DOSE)

hist(hw_p34_1.m$BP, xlab="", main="m$BP")
hist(hw_p34_1.f$BP, xlab="", main="f$BP")
boxplot(hw_p34_1.m$BP)
boxplot(hw_p34_1.f$BP)

hist(hw_p34_1.m$AGE, xlab="", main="m$AGE")
hist(hw_p34_1.f$AGE, xlab="", main="f$AGE")
boxplot(hw_p34_1.m$AGE)
boxplot(hw_p34_1.f$AGE)

# p34 4-1
hw_p34_2.tab = read.table("./data/insurance.txt", header=T)
hw_p34_2.tab$sex = recode(hw_p34_2.tab$sex, m=1, f=2)
length(hw_p34_2.tab$sex[hw_p34_2.tab$sex == 1])
length(hw_p34_2.tab$sex[hw_p34_2.tab$sex == 2])

# p34 4-2
hw_p34_2.tab$religion
hw_p34_2.tab$religion2 = hw_p34_2.tab$religion
hw_p34_2.tab$religion2[hw_p34_2.tab$religion2 == 2] = 1
hw_p34_2.tab$religion2[hw_p34_2.tab$religion2 == 3] = 2
hw_p34_2.tab$religion2
hw_p34_2.tab$religion2 = recode(hw_p34_2.tab$religion2, `1`="A", `2`="B")
hw_p34_2.tab$religion2

# p34 4-3
hw_p34_2.tab$amount2 = log(hw_p34_2.tab$amount * 10000000)

# p34 4-4
par(mfrow=c(1,2))
plot(salary ~ amount, pch=16, data=hw_p34_2.tab)
plot(salary ~ amount2, pch=16, data=hw_p34_2.tab)

# p34 4-5
hw_p34_2.m = filter(hw_p34_2.tab, sex==1)
par(mfrow=c(1,2))
plot(salary ~ amount, pch=16, data=hw_p34_2.m)
plot(salary ~ amount2, pch=16, data=hw_p34_2.m)

# p34 4-6
hw_p34_2.f = filter(hw_p34_2.tab, sex==2)
par(mfrow=c(1,2))
plot(salary ~ amount, pch=16, data=hw_p34_2.f)
plot(salary ~ amount2, pch=16, data=hw_p34_2.f)

# p34 4-7
par(mfrow=c(1,2))
hw_p34_2.r.amount =  c(min(hw_p34_2.tab$amount), max(hw_p34_2.tab$amount))
hw_p34_2.r.amount2 = c(min(hw_p34_2.tab$amount2), max(hw_p34_2.tab$amount2))
hw_p34_2.r.salary =  c(min(hw_p34_2.tab$salary, na.rm = T), max(hw_p34_2.tab$salary, na.rm = T))
plot(salary ~ amount, pch=6, col="blue", data=hw_p34_2.m,
     xlim=hw_p34_2.r.amount, ylim=hw_p34_2.r.salary)
par(new=T)
plot(salary ~ amount, pch=8, col="red", data=hw_p34_2.f,
     xlim=hw_p34_2.r.amount, ylim=hw_p34_2.r.salary)
plot(salary ~ amount2, pch=6, col="blue", data=hw_p34_2.m,
     xlim=hw_p34_2.r.amount2, ylim=hw_p34_2.r.salary)
par(new=T)
plot(salary ~ amount2, pch=8, col="red", data=hw_p34_2.f,
     xlim=hw_p34_2.r.amount2, ylim=hw_p34_2.r.salary)

# p34 5
#install.packages("dplyr")
library(dplyr)
install.packages("hflights")
library(hflights)

# p34 5-1
dim(hflights)

# p34 5-2
flights <- tbl_df(hflights)
filter(flights, Month==1, DayofMonth==1)
filter(flights, UniqueCarrier=="AA" | UniqueCarrier=="UA")

# p34 5-3
select(flights, DepTime, ArrTime, FlightNum)

# p34 5-4
hflights2 = mutate(select(hflights, Distance, AirTime),
                   Speed=Distance/AirTime*60)
head(hflights2, n=3)

# p34 5-5
hflight3 = arrange(hflights, Dest)
hflight3_g = group_by(hflight3, Dest)
hflight3_m = summarize(hflight3_g, ArrDelayMean=mean(ArrDelay, na.rm=T))
hflight3_m

# p34 5-6
hflight2_2 = hflights %>%
  select(Distance, AirTime) %>%
  mutate(Speed=Distance/AirTime*60)
head(hflight2_2, n=3)

hflight3_2 = hflights %>%
  arrange(Dest) %>%
  group_by(Dest) %>%
  summarize(ArrDelayMean=mean(ArrDelay, na.rm=T))
hflight3_2

# p34 6-1
hw_p34_6_1 <- function() {
  tab = read.table("hw_p34_6.txt", header=T)
  par(mfrow=c(3,2))
  hist(tab$convenience, xlab="", ylab="", main="convenience")
  hist(tab$accuracy, xlab="", ylab="", main="accuracy")
  hist(tab$kindess, xlab="", ylab="", main="kindess")
  hist(tab$efficiency, xlab="", ylab="", main="efficiency")
  hist(tab$pleasant, xlab="", ylab="", main="pleasant")
  hist(tab$automatic, xlab="", ylab="", main="automatic")
}
hw_p34_6()

# p34 6-2
pairs(hw_p34_6.tab)
cor(hw_p34_6.tab)

# p34 6-3
#dimnames(hw_p34_6.tab)
par(mfrow=c(1,1))
stars(hw_p34_6.tab, key.loc=c(10,1.8))
#install.packages("aplpack")
library(aplpack)
faces(hw_p34_6.tab)

# p68 1
hw_p68_1 <- function(p_=0.4, size=1000) {
  r=c(); u=c(); s=c()
  for(i in 1:10) {
    r = c(r, rgeom(size, p_))
    l_ = (i-1)*size + 1
    u_ = i*size
    u = c(u, mean(r[l_:u_]))
    s = c(s, var(r[l_:u_]))
  }
  return (c(mean(u), (1-p_)/p_, mean(s), (1-p_)/p_^2))
}
hw_p68_1()

# p68 2
hw_p68_2 <- function(p_=0.2, n_=1000) {
  r = rgeom(n_, p_)
  u = mean(r)
  s = var(r)

  nr = rnbinom(n_, size = 1, mu=u)
  return (c(u, mean(nr), s, var(nr)))
}
hw_p68_2()

# p68 3
hw_p68_3 <- function(df_ = 10, n_ = 500) {
  r = rchisq(n_, df_)
  return (c(mean(r), var(r)))
}
hw_p68_3()

# p68 4
hw_p68_4 <- function(n_ = 20, p_ = 0.5, size = 1000) {
  r = rbinom(size, n_, p_)
  par(mfrow=c(1,1))
  hist(r, freq=F, xlab = "rbinom(1000)", main = "B(20, 0.5)")
  x <- seq(4,16, length=200)
  y <- dnorm(x, mean=n_*p_, sd=sqrt(n_*p_*(1-p_)))
  lines(x, y)
}
hw_p68_4()

# p68 6
hw_p68_6 <- function(rho=0.5, size=1000) {
  x <- rnorm(size)
  y <- rep(0, size)
  for (i in 1:size)
    y[i] = rnorm(1, mean=rho*x[i], sd=sqrt(1-rho^2))
  hist(y, prob=T)
  xa = seq(-3, 3, length=size)
  lines(xa, dnorm(xa), col="blue")
}
hw_p68_6()

# p120 3
hw_p120_Levene <- function(
  x = c(69, 74, 66, 66, 78, 68, 62, 63, 69, 69),
  y = c(55, 54, 56, 58, 48, 52, 58, 51, 53, 56),
  sig = 0.025
) {
  # H0 : mx - my = d0
  d0 = 0
  m = length(x);  n = length(y)
  mx = mean(x);   my = mean(y)
  z1 = abs(x-mx); z2 = abs(y-my)
  mz1 = mean(z1); mz2 = mean(z2)
  sdz1 = sd(z1);  sdz2 = sd(z2)
  sp = sqrt( ((m-1)*sdz1^2 + (n-1)*sdz2^2)/(m+n-2) )
  t0 = (mz1 - mz2 - d0)/(sp * sqrt(1/m + 1/n))
  F0 = t0^2
  print(F0)
  r = 1 - pf(F0, 1, m+n-2)
  print(r)
  if (r < sig)
    print(paste0('reject H0: mx - my = ', d0))
  else
    print(paste0("accept H0: mx - my = ", d0))
}
hw_p120_Levene()

# ex 3.2
hw_p120_Levene( x=c(21.6, 20.8, 17.6, 20.1, 20.1, 21.9, 20.6, 19.4, 21.5, 26.1),
                y=c(20.6, 20.4, 20.2, 20.2, 18.0, 19.8, 20.9, 19.7, 20.3, 19.7, 22.7))
x=c(21.6, 20.8, 17.6, 20.1, 20.1, 21.9, 20.6, 19.4, 21.5, 26.1)
y=c(20.6, 20.4, 20.2, 20.2, 18.0, 19.8, 20.9, 19.7, 20.3, 19.7, 22.7)
merged = c(x, y)
group = c(rep(1,10), rep(2,11))
dat = data.frame(group, merged)
levene.test(merged, group, location="mean")
#bartlett.test(merged~group, dat)

#install.packages("lawstat")
library(lawstat)
x = c(69, 74, 66, 66, 78, 68, 62, 63, 69, 69)
y = c(55, 54, 56, 58, 48, 52, 58, 51, 53, 56)
merged = c(x, y)
group = c(rep(1,10), rep(2,10))
dat = data.frame(group, merged)
levene.test(merged, group, location="mean")

hw_p120_eq_var <- function(
  x = c(69, 74, 66, 66, 78, 68, 62, 63, 69, 69),
  y = c(55, 54, 56, 58, 48, 52, 58, 51, 53, 56),
  d0 = 10,
  sig = 0.05) {
  # H1 : mx - my > d0
  m = length(x);  n = length(y)
  mx = mean(x);   my = mean(y)
  sdx = sd(x);    sdy = sd(y)

  sp = sqrt(((m-1)*sdx^2+(n-1)*sdy^2) / (m+n-2))
  t0 = (mx - my - d0)/(sp*sqrt(1/m + 1/n))
  print(t0)

  r = 1-pt(t0, m+n-2)
  print(r)
  lbd = (mx-my) - qt(1-sig/2, m+n+2)*sp*sqrt(1/m+1/n)
  ubd = (mx-my) + qt(1-sig/2, m+n+2)*sp*sqrt(1/m+1/n)
  print(paste('[', lbd, ', ', ubd, ']'))
  if (r < sig)
    print(paste0('H1: mx - my > ', d0))
  else
    print(paste0("H0: mx - my = ", d0))
}
hw_p120_eq_var( x=c(21.6, 20.8, 17.6, 20.1, 20.1, 21.9, 20.6, 19.4, 21.5, 26.1),
                y=c(20.6, 20.4, 20.2, 20.2, 18.0, 19.8, 20.9, 19.7, 20.3, 19.7, 22.7),
                d0 = 0)
hw_p120_eq_var()

# p120 5
hw_p120_5 <- function(n_=6, size=100) {
  x = sample.int(6, size=size, replace=T)
  print(1/n_)
  for(i in 1:n_) {
    print(paste("probability of ", i, " is ", sum(x == i)/size))
  }
}
hw_p120_5()

# p120 8
hw_p120_8 <- function() {
  x1 = c(11, 10, 8, 11, 10, 10, 11, 11, 10, 9)
  x2 = c(11, 11, 9, 11, 12, 13, 9, 10, 11, 10)
  x3 = c(12, 14, 10, 12, 10, 12, 12, 12, 11, 12)
  x4 = c(11, 10, 8, 11, 11, 9, 10, 11, 11, 10)
  x = c(x1, x2, x3, x4)
  group = rep(1:4, rep(10, 4))
  dat = data.frame(x, group)
  oneway.test(x ~ group, data=dat, var.equal = T)
}
hw_p120_8()

library(ggplot2)
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

head(diamonds)
dim(diamonds)
# p178 Q1
hw_p178_1 <- function() {
  p.carat = ggplot(diamonds, aes(x=carat)) + geom_density()
  p.cut = ggplot(diamonds, aes(x=cut))     + geom_bar()
  p.color = ggplot(diamonds, aes(x=color)) + stat_count()
  p.clarity = ggplot(diamonds, aes(x=clarity)) + stat_count()
  p.depth = ggplot(diamonds, aes(x=depth)) + geom_density()
  p.table = ggplot(diamonds, aes(x=table)) + geom_histogram(bins=40)
  p.price = ggplot(diamonds, aes(x=price)) + geom_density()
  multiplot(p.carat, p.cut, p.color, p.clarity,
            p.depth, p.table, p.price, cols=2)
}
hw_p178_1()

hw_p178_1e <- function() {
  library(lattice)
  cloud(z~x*y, data=diamonds)
}
hw_p178_1e()

# p178 Q2
hw_p178_2 <- function() {
  plot.price = ggplot(diamonds, aes(y=price))
  #p01 = plot.price + geom_density_2d(aes(x=carat))
  p02 = plot.price + geom_point(aes(x=carat, alpha=I(1/8)))
  p40 = plot.price + geom_point(aes(x=cut, alpha=I(1/8)))
  p10 = plot.price + geom_point(aes(x=color, alpha=I(1/8)))
  p20 = plot.price + geom_point(aes(x=clarity, alpha=I(1/8)))
  #p30 = plot.price + geom_jitter(aes(x=clarity, alpha=I(1/8), color=cut))
  multiplot(p02, p40, p10, p20, cols=2)
}
hw_p178_2()
