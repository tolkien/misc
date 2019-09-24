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
# p34 6-2
# p34 6-3

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
p.carat = ggplot(diamonds, aes(x=carat)) + geom_density()
p.cut = ggplot(diamonds, aes(x=cut))     + geom_bar()
p.color = ggplot(diamonds, aes(x=color)) + stat_count()
p.clarity = ggplot(diamonds, aes(x=clarity)) + stat_count()
p.depth = ggplot(diamonds, aes(x=depth)) + geom_density()
p.table = ggplot(diamonds, aes(x=table)) + geom_histogram(bins=40)
p.price = ggplot(diamonds, aes(x=price)) + geom_density()
multiplot(p.carat, p.cut, p.color, p.clarity,
          p.depth, p.table, p.price, cols=2)
library(lattice)
p.xyz = cloud(z~x*y, data=diamonds)
p.xyz

# p178 Q2
plot.price = ggplot(diamonds, aes(y=price))
#p01 = plot.price + geom_density_2d(aes(x=carat))
p02 = plot.price + geom_point(aes(x=carat, alpha=I(1/8)))
p40 = plot.price + geom_point(aes(x=cut, alpha=I(1/8)))
p10 = plot.price + geom_point(aes(x=color, alpha=I(1/8)))
p20 = plot.price + geom_point(aes(x=clarity, alpha=I(1/8)))
#p30 = plot.price + geom_jitter(aes(x=clarity, alpha=I(1/8), color=cut))
multiplot(p02, p40,
          p10, p20, cols=2)

