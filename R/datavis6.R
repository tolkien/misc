# stats packages : ts function
# zoo packages
# xts packages
econ1 = read.csv("datavis/gdp.csv", header=T)
econ1.ts = ts(econ1, start=1970, freq=4)
plot(econ1.ts/1000, main="")

library(zoo)
year= seq(as.Date("1970-01-01"),
            as.Date("2013-12-01"), "quarter")
econ2 = zoo(econ1, year)
plot(econ2/1000, ylab="GPD(조원)", xlab="", col=1:2, screens=1)

library(ggplot2)
# qplot, ggplot + geom_xxx, ggplot + layer
small = diamonds[sample(nrow(diamonds),1000),]
head(small)
ggplot(small) +
  geom_point(aes(x=carat, y=price, colour=cut)) +
  scale_y_log10() +
  facet_wrap(~cut) + ggtitle("example")
gdp_kr = cbind(econ1, year)
ggplot(data=gdp_kr, aes(x=year)) +
  geom_line(aes(y = gdp/1000, colour="원계열")) +
  geom_line(aes(y = gdpsa/1000, colour="계절 조정계열")) +
  ylab("GDP(조원)") +
  scale_color_hue("GDP") +
  theme(legend.position="bottom")
library(scales)
ggplot(data=gdp_kr, aes(x=year)) +
  geom_line(aes(y = gdp/1000, colour="원계열")) +
  geom_line(aes(y = gdpsa/1000, colour="계절 조정계열")) +
  scale_x_date(breaks="5 years", labels=date_format("%Y")) +
  labs(x="연도", y="GDP(조원)") +
  scale_color_hue("GDP") + theme_bw()

# 시계열 = 신호+소음
# 중심화 이동평균 : cma(2k+1)_t = 1/(2k+1) sum(y_t-i, -k, k)
# 후방   이동평균 : bma(k)_t = 1/(2k+1) sum(y_t-i, 0, 2k)
#install.packages("quantmod")
library(quantmod)
kospi = getSymbols("^KS11", auto.assign = FALSE)[, 4]
kospi = na.omit(kospi)
kospi$ma = runMean(kospi, n = 200) # 200일 이동평균
colnames(kospi) = c("종합주가지수", "200일 이평선")
autoplot(kospi, facets = NULL) +
  xlab("연도") +
  theme(panel.background =
          element_rect(fill = "white", colour = "gray"),
        legend.position = "none")

# 경기동행지수 순환변동치
library(xts)
cycle1 = read.csv("datavis/data/cycle.csv", header=T)
year1= seq(as.Date("1970-01-01"),
          as.Date("2014-06-01"), "month")
cycle2 = xts(cycle1[,2], year1)
refdate = read.csv("datavis/data/refdate1.csv", header=T)
yrng = range(cycle2)
datebreaks = seq(as.Date("1970-01-01"),
                 as.Date("2014-06-01"), "2 year")
p = autoplot(cycle2, facets = NULL) +
  theme(panel.background =
          element_rect(fill = "white", colour = "gray"),
        legend.position = "bottom") +
  geom_rect(aes(NULL, NULL, xmin = as.Date(start),
                xmax = as.Date(end), fill = 경기순환),
            ymin = yrng[1], ymax = yrng[2], data = refdate) +
  scale_fill_manual(values = alpha(c("yellow", "darkblue"), 0.1)) +
  ylab("") + xlab("") +
  geom_hline(yintercept=100, colour="gray") +
  geom_text(aes(x = as.Date(start), y = yrng[2], label = name1),
            data = refdate, size = 4, hjust = 0.5, vjust = -0.5) +
  geom_text(aes(x = as.Date(end), y = yrng[2], label = name2),
            data = refdate, size = 4, hjust = 0.5, vjust = -0.5)
p + scale_x_date(breaks=datebreaks, labels=date_format("%Y"),
                 expand=c(0.01, 0.01))

# 제주시 강수량 추이
climate_kr1 = read.csv("datavis/data/climate.csv", header=T)
year3= seq(as.Date("2008-01-01"),
           as.Date("2013-12-01"), "month")
climate_kr = cbind(year3, climate_kr1)
ggplot(climate_kr, aes(x=year3, y=j강수량)) +
  geom_area(colour="black", fill="blue", alpha=0.2) +
  ylab("강수량(mm)")

# 강릉시, 서울시, 제주시 기온
climate_kr3 = read.csv("datavis/data/climate1.csv", header=T)
year4= rep(seq(as.Date("2008-01-01"),
               as.Date("2013-12-01"), "month"), 3)
climate_kr2 = cbind(year4, climate_kr3)
h = ggplot(climate_kr2, aes(x=year4)) +
  facet_grid(지역~.) +
  geom_ribbon(aes(ymin=최저, ymax=최고),
              fill="pink", alpha=0.7) +
  geom_line(aes(y=평균), colour="red") +
  theme_bw()
h + ylab("") + xlab("") + ylim(-12,33)

# chapter 7 (시계열의 시각화)
# 막대그래프
library(ggplot2)
cb <- read.csv("datavis/data/cb.csv", header=T)
cb$경상수지 <- cb$경상수지 / 100
cb$pos <- cb$경상수지 >= 0
ggplot(cb, aes(x=연도, y=경상수지, fill=pos)) +
  geom_bar(stat="identity", position="identity",
           colour="black", size=0.25) +
  scale_fill_manual(values=c("red", "black"), guide=F) +
  ylab("경상수지 (억달러)") + theme_bw()

# 누적그래프
library(reshape2)
library(plyr)
pop_kr1 <- read.csv("datavis/data/krpop.csv", header=T)
pop_kr <- melt(pop_kr1, id="연령대")
pop_kr$연도 <- as.numeric(substr(pop_kr$variable, 2, 5))
ggplot(pop_kr, aes(x=연도, y=value/10000, fill=연령대)) +
  geom_area(colour="black", size=0.1, alpha=0.4) +
  scale_fill_brewer(palette = "Reds") +
  ylab("인구 (만명)") +
  scale_x_continuous(breaks=seq(1960, 2060, 5), expand=c(0,0)) +
  theme_bw()

pop_kr_p = ddply(pop_kr, "연도", transform, 비중
                  = value/sum(value) * 100)
ggplot(pop_kr_p, aes(x=연도, y=비중, fill=연령대)) +
  geom_area(colour="black", size=0.1, alpha=0.4) +
  scale_fill_brewer(palette = "Reds") +
  ylab("인구비중 (%)") +
  scale_x_continuous(breaks=seq(1960, 2060, 5), expand=c(0,0)) +
  theme_bw()

gdp_s1 = read.csv("datavis/data/gdp_sh.csv", header = T)
gdp_s = melt(gdp_s1, id="연도")
names(gdp_s) <- c("연도", "산업", "비중")
ggplot(gdp_s, aes(x=연도, y=비중, fill=산업)) +
  geom_bar(stat="identity") +
  scale_x_continuous(breaks=seq(1970, 2010, 5)) +
  theme(panel.background = element_rect(fill="white", colour="gray"),
        legend.position = "bottom") +
  ylab("비중 (%)") + xlab("")

# 경로그래프
library(scales)
library(zoo)
library(xts)
inven1 = read.csv("datavis/data/inven_cy.csv", header=T)
연도 = seq(as.Date("1980-01-01"), as.Date("2014-06-01"), "month")
inven = xts(inven1[,2:3], 연도)
inven$출하지수증감률 = (inven$출하지수 - lag(inven$출하지수,12))
                        / lag(inven$출하지수,12) * 100
inven$재고지수증감률 = (inven$재고지수 - lag(inven$재고지수,12))
                        / lag(inven$재고지수,12) * 100
inven_2 = inven[337:366]
ggplot(inven_2, aes(x=출하지수증감률, y=재고지수증감률)) +
  theme_bw() + geom_path() +
  geom_point() + ylim(-21,28) + xlim(-21,28) +
  geom_text(aes(label=substr(index(inven_2),3,7)), size=3,
            hjust=-0.2, vjust=-0.3, colour="blue") +
  geom_line(aes(x=inven_2$출하지수증감률, y=inven_2$출하지수증감률, colour="Reds")) +
  geom_hline(yintercept = 0, colour="gray") +
  geom_vline(xintercept = 0, colour="gray")

# 채색달력그래프
library(quantmod)
library(ggplot2)
library(reshape2)
library(plyr)
library(scales)
getSymbols("^KS11", src="yahoo")
KS11$주가변동 = abs((KS11$KS11.Close - lag(KS11$KS11.Close, 1))
                / lag(KS11$KS11.Close, 1))
dat <- data.frame(date=index(KS11),KS11)
dat$year <- as.numeric(as.POSIXlt(dat$date)$year + 1900)
dat$month <- as.numeric(as.POSIXlt(dat$date)$mon + 1)
dat$monthf <- factor(dat$month, levels = as.character(1:12),
  labels=c("1월","2월","3월","4월","5월","6월",
           "7월","8월","9월","10월","11월","12월"),
  ordered = T)
dat$weekday = as.POSIXlt(dat$date)$wday
dat$weekdayf = factor(dat$weekday, levels=rev(1:7),
                      labels=rev(c("월","화","수","목","금","토","일")),
                      ordered = T)
dat$yearmonth = as.yearmon(dat$date)
dat$yearmonthf = factor(dat$yearmonth)
dat$week = as.numeric(format(dat$date, "%W"))
dat <- ddply(dat,.(yearmonthf), transform,
             monthweek=1+week-min(week))
ggplot(dat, aes(monthweek, weekdayf, fill=주가변동)) +
  geom_tile(colour="white") +
  facet_grid(year~monthf) +
  scale_fill_gradient(limits=c(0,12), low="lightgray", high="darkred") +
  xlab("") + ylab("") +
  theme(panel.background = element_rect(fill="white", colour="gray"))
