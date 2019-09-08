# change working directory to R.2019.2/advanced.R
WD=getwd()
if (WD == '/Users/tolkien/work/misc/R') {
  setwd( paste0(dirname(WD), '/R.2019.2/advanced.R'))
}

# autompg (http://archive.ics.uci.edu/ml/datasets/)
autompg = read.csv("data/auto-mpg.csv", header=T)
dim(autompg);head(autompg)

# tips
tipping = read.csv("tips.csv", header=T)
tipping$tiprate = tipping$tip/tipping$total_bill * 100
dim(tipping);head(tipping)

# abalone
abalone = read.csv("data/abalone.csv", header=T)
dim(abalone);head(abalone)

# household power consumption
Pconsump = read.csv("data/power_consumption.csv", header=T)
dim(Pconsump);head(Pconsump)

# 4.2 lattice
library(lattice)

# barchart
barchart(as.factor(autompg$cylinder))
barchart(as.factor(autompg$year), horizontal=F)

# histgram
histogram(tipping$tip)
histogram(tipping$tip, breaks=seq(0,11,0.5), main="binwidth=50 cent")
histogram(tipping$tip, breaks=seq(0,11,0.25), main="binwidth=25 cent")
histogram(tipping$tip, breaks=seq(0,11,0.1), main="binwidth=10 cent")
histogram(tipping$tip, breaks=seq(0,11,0.05), main="binwidth=5 cent")

# densityplot
densityplot(autompg$mpg, xlab="mpg")

# scatter plot
xyplot(tip ~ total_bill, data=tipping)
xyplot(tip ~ total_bill | sex, pch=16, data=tipping)
xyplot(tip ~ total_bill | sex, group=smoker, pch=c(16,1), data=tipping)
xyplot(tip ~ total_bill | sex + smoker, data=tipping,
       panel = function(x, y) {
         panel.grid(h=-1, v=2)
         panel.xyplot(x, y, pch=16)
         panel.lmline(x, y)
       })

# one-way ANOVA
bwplot(cylinder ~ mpg, data=autompg)
bwplot(weight ~ cylinder, data=autompg, horizontal = F)
dotplot(cylinder ~ mpg, data=autompg)

# mosaic plot
#install.packages("vcd")
library(vcd)
mosaic(~ sex + size, data=tipping)
mosaic(~ size + sex, data=tipping)
cotabplot(~ size + sex | smoker, data=tipping, panel=cotab_mosaic())

# multi variable - array of scatter plot
splom(~autompg[, c(1, 3:6)], data=autompg)
splom(~autompg[, c(1, 3:6)], groups=cylinder, data=autompg,
      col=c("red", "orange", "blue", "green", "grey50"),
      pch=c(16,2,15,3,1), cex=0.7,
      key=list(title="Various cylinders in autompg",
               columns=5,
               points=list(pch=c(16,2,15,3,1),
                           col=c("red", "orange", "blue", "green", "grey50")),
               text=list(c("3","4","5","6","8"))))

# multi variable - parallel coordinate plot
parallelplot(~ autompg[,c(1, 3:6)], data=autompg, horizontal = F)
parallelplot(~ autompg[,c(1, 3:6)] | as.factor(cylinder), data=autompg)

# multi variable - 3D scatter plot
cloud(mpg ~ horsepower*displacement, data=autompg,
      screen=list(x=-80, y=70))
cloud(mpg ~ horsepower*displacement | as.factor(cylinder), data=autompg,
      screen=list(x=-80, y=70))

# multi variable - contour plot
contour(volcano)
wireframe(volcano)
wireframe(volcano, shade=T, light.source=c(10,0,10))

# ggplot
library(ggplot2)
# ggplot - qplot
qplot(length, wholeW, data=abalone)
qplot(length, wholeW, data=abalone, color=sex, shape=sex)
qplot(length, wholeW, data=abalone, alpha=I(1/10))

# ggplot - boxplot
qplot(sex, wholeW, data=abalone, geom="boxplot")
qplot(sex, wholeW, data=abalone, geom="jitter")
qplot(sex, wholeW, data=abalone, geom="jitter", alpha=I(1/3))
qplot(factor(rings), wholeW, data=abalone, geom="boxplot")
qplot(wholeW, data=abalone, geom="histogram",
      binwidth=0.05, fill=sex)
qplot(wholeW, data=abalone, geom="histogram",
      binwidth=0.05, facets=.~sex)

# ggplot - density plot
qplot(wholeW, data=abalone, geom="density",
      color=sex, linetype=sex)

# ggplot - time series plot
class(Pconsump$Date)
class(Pconsump$Time)
Pconsump$newDate = as.POSIXct(Pconsump$Date, format="%d/%m/%Y")
Pconsump$newTime = as.POSIXct(Pconsump$Time, format="%H:%M:%S")
Pconsump$year = format(Pconsump$newDate, "%Y")
Pconsump.2006.12.17 = Pconsump[Pconsump$Date == "17/12/2006", ]
qplot(newTime, X3, data=Pconsump.2006.12.17, geom="line")

Pconsump.12.17 = Pconsump[(Pconsump$Date == "17/12/2006" |
                             Pconsump$Date == "17/12/2007"),]
qplot(newTime, X3, data=Pconsump.12.17, color="year",
      geom="line", linetype=year)

qplot(newTime, X3, data=Pconsump, facets=Date~., geom="line")

# ggplot - layered grpahics - aesthetic mapping
plot.basic = ggplot(tipping,
                    aes(x=total_bill, y=tip, color=sex, shape=sex,
                        size=tiprate))
#plot.basic + layer(geom="point") is not working

# ggplot - geom_...
plot.scatter = plot.basic + geom_point()
summary(plot.scatter)
plot.scatter
plot.scatter + geom_smooth(aes(group=sex))

# ggplot - stat_...
plot.stat = ggplot(abalone, aes(x=rings, y=log(wholeW)))
plot.stat + geom_point(shape=1) +
  stat_summary(size=3, shape=15, color="red",
               fun.y="mean", geom="point")
plot.stat + stat_summary(fun.data="mean_cl_normal", geom="errorbar")

q1 = function(x) quantile(x, p=0.25)
q3 = function(x) quantile(x, p=0.75)
plot.stat +
  stat_summary(aes(color="Q1", shape="Q1"), fun.y=q1, geom="point") +
  stat_summary(aes(color="median", shape="median"), fun.y=median, geom="point") +
  stat_summary(aes(color="Q3", shape="Q3"), fun.y=q3, geom="point") +
  stat_summary(aes(color="min", shape="min"), fun.y=min, geom="point") +
  stat_summary(aes(color="max", shape="max"), fun.y=max, geom="point") +
  scale_color_hue("Quantile") + scale_shape("Quantile")

plot.1d = ggplot(tipping, aes(x=tip))
plot.1d + geom_histogram() + ggtitle("geom_histogram")
plot.1d + stat_bin(geom="area") + ggtitle("stat_bin, geom_area")
plot.1d + stat_bin(geom="point") + ggtitle("stat_bin, geom_point")
plot.1d + stat_bin(geom="line") + ggtitle("stat_bin, geom_line")
plot.1d + geom_histogram(aes(fill=sex)) + ggtitle("geom_histogram by sex")
plot.1d + geom_histogram(aes(y=..density.., fill=sex)) +
  ggtitle("geom_histogram with density")

# ggplot - position adjustment
plot.pos = ggplot(tipping, aes(x=day, fill=sex, shape=sex)) +
  theme(legend.position = "none")
plot.pos + geom_bar(position="stack") + ggtitle("stack")
plot.pos + geom_bar(position="dodge") + ggtitle("dodge")
plot.pos + geom_bar(position="fill") + ggtitle("fill")
plot.pos + geom_point(aes(y=total_bill, color=sex, shape=sex),
                      position="jitter") + ggtitle("jitter")
plot.pos + geom_bar(position="identity") + ggtitle("identity")
plot.pos + geom_bar(position="identity", alpha=I(0.5)) +
  ggtitle("identity with alpha")

# ggplot - scale
plot.scale1 = ggplot(tipping, aes(x=total_bill, y=tip,
                                  color=sex, shape=sex,
                                  size=size)) + geom_point()
plot.scale1 + scale_color_hue("Gender", labels=c("Female", "Male"))
plot.scale1 + scale_color_brewer(palette = "Set1")
plot.scale2 = ggplot(tipping, aes(x=total_bill, y=tip)) +
  geom_point()
plot.scale2 + scale_x_continuous(breaks=c(20,40)) +
  scale_y_continuous(breaks=1:10)
plot.scale2 + coord_trans(x="log10", y="sqrt")

# ggplot - faceting
plot.facet = ggplot(tipping, aes(x=total_bill, y=tip)) + geom_point()
plot.facet + facet_grid(sex ~ smoker, margins=T)
#plot.facet + facet_grid(sex ~ smoker)
plot.facet + facet_wrap(~ size, ncol=6)
#plot.facet + facet_wrap(~ size)
tipping$tipgroup1 = cut_interval(tipping$tiprate, n=3)
tipping$tipgroup2 = cut_number(tipping$tiprate, n=3)
plot.newfacet = ggplot(tipping, aes(x=total_bill, y=tip)) + geom_point()
plot.newfacet + facet_wrap(~tipgroup1)
plot.newfacet + facet_wrap(~tipgroup2)

# ggplot - theme
plot.theme = ggplot(tipping, aes(x=total_bill, y=tip))
plot.theme + geom_point(color="blue") + xlab("Total Bill") +
  ylab("Tip") + ggtitle("Total Bill and Tip")
plot.theme + geom_point(color="blue") + xlab("Total Bill") +
  ylab("Tip") + ggtitle("Total Bill and Tip") +
  theme(plot.title = element_text(size=10, color="blue",
                                  face="bold", hjust=0))
last_plot() + geom_point(color="blue") + xlab("Total Bill") +
  theme_bw() + theme(panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.border = element_blank(),
                     axis.line = element_line())
plot.theme + geom_point(aes(color=sex, shape=sex)) +
  theme(legend.position = "none")

lm.result = lm(tip~total_bill, data=tipping)
ab = round(coef(lm.result),2)
ggplot(tipping, aes(x=total_bill, y=tip)) +
  geom_point() +
  geom_smooth(method="lm") +
  geom_text(data=NULL, x=10, y=8.5,
            label=paste("y =", ab[1], "+", ab[2], "x"),
            hjust=0) +
  ggtitle(expression(paste(hat(beta)[0],"+",hat(beta)[1],"x")))

# save to file
ggsave("sample-plot.png")
