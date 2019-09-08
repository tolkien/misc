setwd("M:/2014-Ames/방통대교재-고급R 활용/Final/")

### <R 4.1> autompg 자료 요약

autompg<-read.csv("auto-mpg.csv",header=TRUE,na.string=".")
dim(autompg)
head(autompg)

### <R 4.2> tipping 자료 요약

tipping<-read.csv("tips.csv",header=TRUE)
dim(tipping)
head(tipping)

### <R 4.3> abalone 자료 요약

abalone<-read.csv("abalone.csv",header=TRUE)
dim(abalone)
head(abalone)

### <R 4.4> Pconsump 자료 요약

Pconsump<-read.csv("power_consumption.csv") 
dim(Pconsump)
head(Pconsump)

### <R 4.5> 수평 막대그래프 - 그림 4.1

library(lattice)
barchart(as.factor(autompg$cylinder))

### <R 4.6> 수직 막대그래프 - 그림 4.2

barchart(as.factor(autompg$year),horizontal=FALSE)

### <R 4.7> 히스토그램 - 그림 4.3

histogram(tipping$tip)

### <R 4.8> 다양한 breaks의 히스토그램들 - 그림 4.4

histogram(tipping$tip,breaks=seq(0,11,0.5),main="binwidth = 50 cent")
histogram(tipping$tip,breaks=seq(0,11,0.25),main="binwidth = 25 cent")
histogram(tipping$tip,breaks=seq(0,11,0.1),main="binwidth = 10 cent")
histogram(tipping$tip,breaks=seq(0,11,0.05),main="binwidth = 5 cent")

### <R 4.9> 밀도그림 - 그림 4.5

densityplot(autompg$mpg,xlab="mpg")

### <R 4.10> 산점도 - 그림 4.6

xyplot(tip~totbill,pch=16,data = tipping)

### <R 4.11> 산점도 - 그림 4.7

xyplot(tip~totbill|sex,pch=16,data = tipping)

### <R 4.12> 산점도 - 그림 4.8

xyplot(tip~totbill|sex,group=smoker,pch=c(16,1),data = tipping)

### <R 4.13> 산점도 - 그림 4.9

xyplot(tip~totbill|sex+smoker,data = tipping,
       panel = function(x, y) {
         panel.grid(h = 10, v = 2)
         panel.xyplot(x, y,pch=16)
         panel.lmline(x, y)
       })

### <R 4.14> 수평 평행 상자그림 - 그림 4.10

bwplot(cylinder~mpg,data=autompg)

### <R 4.15> 수직 평행 상자그림 - 그림 4.11

bwplot(weight~cylinder,data=autompg,horizontal=FALSE)

### <R 4.16> 점그림 - 그림 4.12

dotplot(cylinder~mpg,data=autompg)

### <R 4.17> sex 내의 size에 대한 mosaic 그림 - 그림 4.13

library(vcd)
mosaic(~sex+size,data = tipping)

### <R 4.18> size 내의 sex에 대한 mosaic 그림 - 그림 4.14

mosaic(~size+sex,data = tipping)

### <R 4.19> smoker 별 size 내의 sex에 대한 mosaic 그림 - 그림 4.15

cotabplot(~ size+sex | smoker, data = tipping, panel = cotab_mosaic)

### <R 4.20> 산점도 행렬 - 그림 4.16

splom(~autompg[,c(1,3:6)], data = autompg)

### <R 4.21> 여러 옵션을 이용한 산점도 행렬 - 그림 4.17

splom(~autompg[,c(1,3:6)], groups = cylinder, data = autompg,
      col=c("red","orange","blue","green","grey50"),
      pch=c(16,2,15,3,1),cex=0.7,
      key = list(title = "Various cylinders in autompg",
                 columns = 5, 
                 points = list(pch =c(16,2,15,3,1),
                 col = c("red","orange","blue","green","grey50")),
                 text = list(c("3","4","5","6","8"))))

### <R 4.22> 수평 평행좌표그림 - 그림 4.18

parallelplot(~ autompg[,c(1,3:6)] ,data = autompg,horizontal=FALSE) 

###<R 4.23> cylinder 별 수평 평행좌표그림 - 그림 4.19

parallelplot(~ autompg[,c(1,3:6)]|as.factor(cylinder) ,data = autompg) 

### <R 4.24> 3차원 산점도 그림 - 그림 4.20

cloud(mpg ~ horsepower*displacement, data = autompg,
             screen=list(x=-80,y=70))

### <R 4.25> cylinder 별 3차원 산점도 그림 - 그림 4.21

cloud(mpg ~ horsepower*displacement|as.factor(cylinder), data = autompg,
             screen=list(x=-80,y=70))

###<R 4.26> 등고선 그림 - 그림 4.22

contour (volcano)

### <R 4.27> 3차원 표면그림 - 그림 4.23

wireframe(volcano)

### <R 4.28> 옵션을 이용한 3차원 표면그림 - 그림 4.24

wireframe(volcano, shade = TRUE, light.source = c(10,0,10))

### <R 4.29> ggplot2 패키지 설치

#install.packages("ggplot2")

### <R 4.30> qplot을 이용한 산점도 - 그림 4.25

library(ggplot2)
qplot(length,wholeW,data = abalone)

### <R 4.31> color, shape 옵션을 이용한 이용한 산점도 - 그림 4.26

qplot(length,wholeW,data = abalone,colour=sex,shape=sex)

### <R 4.32> alpha 옵션을 이용한 이용한 산점도 - 그림 4.27

qplot(length,wholeW,data = abalone,alpha=I(1/10))

### <R 4.33> qplot을 이용한 수직 상자그림 - 그림 4.28

qplot(sex,wholeW,data = abalone,geom="boxplot")

### <R 4.34> jitter를 이용한 그림 - 그림 4.29

qplot(sex,wholeW,data = abalone,geom="jitter")

### <R 4.35> alpha 옵션을 이용한 jitter 그림 - 그림 4.30

qplot(sex,wholeW,data = abalone,geom="jitter",alpha=I(1/3))

### <R 4.36> rings별 wholeW의 평행상자그림 - 그림 4.31

qplot(factor(rings),wholeW,data = abalone,geom="boxplot")

### <R 4.37> qplot을 이용한 히스토그램 - 그림 4.32

qplot(wholeW, data = abalone, geom = "histogram" , 
                    binwidth = 0.05, fill = sex)

### <R 4.38> facets을 이용한 히스토그램 - 그림 4.33

qplot(wholeW,data = abalone, geom="histogram",
           binwidth=0.05,facets=.~sex)

### <R 4.39> color와 linetype 옵션을 이용한 밀도그림 - 그림 4.34

qplot(wholeW,data = abalone, geom="density",color=sex, linetype=sex)

### <R 4.40> 날짜, 시간 나타내기

class(Pconsump$Date)
class(Pconsump$Time)
Pconsump$newDate <- as.POSIXlt(Pconsump$Date, format="%d/%m/%Y")
Pconsump$newTime <- as.POSIXlt(Pconsump$Time,format="%H:%M:%S") 
Pconsump$year <-  format(Pconsump$newDate,"%Y")

### <R 4.41> qplot을 이용한 시계열 그림 - 그림 4.35

Pconsump.2006.12.17<-Pconsump[Pconsump$Date=="17/12/2006",]
qplot(newTime,X3,data = Pconsump.2006.12.17,geom="line")

### <R 4.42> color과 linetype 옵션을 이용한 시계열 그림 - 그림 4.36

Pconsump.12.17<-Pconsump[(Pconsump$Date=="17/12/2006" |
                              Pconsump$Date=="17/12/2007") ,]
qplot(newTime,X3,data = Pconsump.12.17,color=year,
                             geom="line",linetype=year)

### <R 4.43> facets옵션을 이용한 시계열 그림 - 그림 4.37

qplot(newTime,X3,data = Pconsump,facets=Date~.,geom="line")

### <R 4.44> ggplot 선언

plot.basic<-ggplot(tipping,
       aes(x=totbill,y=tip,color=sex,shape=sex,size=tiprate))

### <R 4.45> ggplot으로 산점도 그리기 - 그림 4.38

plot.basic + layer(geom="point")

### <R 4.46> summary 함수로 살펴보는 ggplot내의 선언 내용들

plot.scatter<- plot.basic + geom_point()
summary(plot.scatter)

### <R 4.47> 산점도에 group 별 smooth line 그리기 - 그림 4.39

plot.basic+geom_point()+
           geom_smooth(aes(group=sex))

### <R 4.48> 산점도에 통계량을 이용한 점찍기 - 그림 4.40

plot.stat<-ggplot(abalone,aes(x=rings,y=log(wholeW)))
plot.stat + geom_point(shape=1) + 
            stat_summary(size=3,shape=15,color="red",
                         fun.y = "mean", geom = "point") 

### <R 4.49> 통계량을 이용한 그림 그리기 - 그림 4.41         

plot.stat + stat_summary(fun.data = "mean_cl_normal", geom = "errorbar")

### <R 4.50> 통계량을 이용한 그림 그리기 - 그림 4.42

q1<-function(x) quantile(x,p=0.25)
q3<-function(x) quantile(x,p=0.75)
plot.stat + stat_summary(aes(color="Q1",shape="Q1"),fun.y=q1,geom="point") +
   stat_summary(aes(color="median",shape="median"),fun.y=median,geom="point") +
   stat_summary(aes(color="Q3",shape="Q3"),fun.y=q3,geom="point") +
   stat_summary(aes(color="min",shape="min"),fun.y=min,geom="point") +
   stat_summary(aes(color="max",shape="max"),fun.y=max,geom="point") +
   scale_color_hue("Quartile")+scale_shape("Quartile")

### <R 4.51> 히스토그램과 stat_bin을 이용한 다양한 그림 그리기 - 그림 4.43

plot.1D<-ggplot(tipping,aes(x=tip))
plot.1D+geom_histogram()+ggtitle("geom histogram")
plot.1D+stat_bin(geom="area")+ggtitle("stat_bin, geom_area")
plot.1D+stat_bin(geom="point")+ggtitle("stat_bin, geom_point")
plot.1D+stat_bin(geom="line")+ggtitle("stat_bin, geom_line")
plot.1D+geom_histogram(aes(fill=sex))+ggtitle("geom_histogram by sex")
plot.1D+geom_histogram(aes(y=..density..,fill=sex))+
        ggtitle("geom_histogram with density")

### <R 4.52> position adjust를 이용한 다양한 그림 그리기 - 그림 4.44

plot.pos <- ggplot(tipping,aes(x = day, fill = sex, shape = sex))
plot.pos + geom_bar(position = "stack") + ggtitle("stack") +            
           theme(legend.position="none")
plot.pos + geom_bar(position = "dodge") + ggtitle("dodge")+ 
           theme(legend.position="none")
plot.pos + geom_bar(position = "fill") + ggtitle("fill") + 
           theme(legend.position="none")
plot.pos+geom_point(aes(y=totbill,color=sex,shape=sex),position="jitter")+
           ggtitle("jitter") + theme(legend.position="none")
plot.pos + geom_bar(position = "identity") + ggtitle("identity") + 
           theme(legend.position="none")
plot.pos + geom_bar(position = "identity", alpha = I(0.5)) + 
           ggtitle("identity with alpha") + 
           theme(legend.position="none")

### <R 4.53> scale_color_hue를 이용한 범례 - 그림 4.45

plot.scale1 <- ggplot(tipping,aes(x=totbill,y=tip,
                  color=sex,shape=sex,size=size))+
               geom_point()
plot.scale1+scale_color_hue("Gender",labels=c("여자","남자"))

### <R 4.54> scale_color_brewer를 이용한 palette 바꾸기 - 그림 4.46

plot.scale1+scale_color_brewer(palette="Set1")

### <R 4.55> scale_*_continous를 이용한 x축, y축 눈금바꾸기 - 그림 4.47
 
plot.scale2 <- ggplot(tipping,aes(x=totbill,y=tip))+geom_point()
plot.scale2 + scale_x_continuous(breaks=c(20,40)) +
              scale_y_continuous(breaks=1:10) 

### <R 4.56> coord_trans를 이용한 x축, y축 함수변환 - 그림 4.48

plot.scale2 + coord_trans(xtrans="log10",ytrans="sqrt") 
          
### <R 4.57> facet_grid를 이용한 그림 - 그림 4.49

plot.facet<-ggplot(tipping,aes(x=totbill,y=tip))+geom_point()
plot.facet + facet_grid(sex~smoker,margins=T)

### <R 4.58> facet_wrap을 이용한 그림 - 그림 4.50

plot.facet + facet_wrap(~size,ncol=6)

### <R 4.59> cut_interval, cut_number로 연속변수를 범주형변수로 바꾸기 - 그림 4.51

tipping$tipgroup1 <- cut_interval(tipping$tiprate,n=3)
tipping$tipgroup2 <- cut_number(tipping$tiprate,n=3)
plot.newfacet<-ggplot(tipping,aes(x=totbill,y=tip))+geom_point()
plot.newfacet + facet_wrap(~tipgroup1)

### <R 4.60> cut_interval, cut_number로 연속변수를 범주형변수로 바꾸기 - 그림 4.52

plot.newfacet + facet_wrap(~tipgroup2)

### <R 4.61> xlab, ylab, ggtitle 이용한 그림그리기 - 그림 4.53

plot.theme<-ggplot(tipping,aes(x=totbill,y=tip))
plot.theme+geom_point()+xlab("Total Bill")+
           ylab("팁")+ggtitle("전제 금액과 팁")

### <R 4.62> theme 이용한 title 조정하기 - 그림 4.54

plot.theme+geom_point()+
      labs(xlab="Total Bill",ylab="팁",title="전제 금액과 팁")+
      theme(plot.title=element_text(size=10,
            color="red",face="bold",hjust=0))

### <R 4.63> theme 이용한 그림의 격자선, 테두리 조정하기 - 그림 4.55

last_plot()+theme_bw()+
      theme(panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            panel.border=element_blank(),
            axis.line = element_line())

### <R 4.64> theme 이용한 범례 조정하기 - 그림 4.56

plot.theme+geom_point(aes(color=sex,shape=sex))+
           theme(legend.position="none")

### <R 4.65> expression을 이용하여 수식넣기- 그림 4.57

lm.result<-lm(tip~totbill,data = tipping)
ab <- round(coef(lm.result),2)
ggplot(tipping,aes(x=totbill,y=tip))+
     geom_point()+
     geom_smooth(method="lm")+
     geom_text(data = NULL,x=10,y=8.5,
         label=paste("y =",ab[1],"+",ab[2],"x"),hjust=0) +
     ggtitle(expression(paste(hat(beta)[0],"+",hat(beta)[1],"x")))

### <R 4.66> 그림을 파일로 저장하기

ggsave("sample-plot.png")



