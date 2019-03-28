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
